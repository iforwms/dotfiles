#!/usr/bin/env python3
"""File picker for phone-backup and phone-restore: tick which phone folders and files
to back up (or restore).

usage: phone-backup-select.py [--name PRESET] [--restore] <listing> <rules> <out> <presets dir> [scope]
  --name       preset being edited; w starts with this name filled in
  --restore    say "restore" instead of "back up" (phone-restore lists the backup)
  listing     "<size> <mtime> /sdcard/<path>" lines, as phone-backup lists the phone
  rules        selection to start from (a preset file; missing or empty = everything)
  out          where the chosen rules are written when you press enter
  presets dir  where w saves the selection as a named preset
  scope        folder under /sdcard the listing covers ("" for all of it)

Rules (the preset format), one per line, "#" starts a comment:
  + <dir>/    back up the folder and everything in it    - <dir>/    leave it out
  + <dir>/*   the files directly in the folder            - <dir>/*
  + <file>    one file                                    - <file>
"/" is the whole phone and "*" the files directly in /sdcard. The most specific rule
wins: a file rule, then "<dir>/*" for its folder, then the deepest "<dir>/" above it.
A file no rule matches is backed up. Paths a phone does not have are ignored, so a
preset works on any phone.

Keys: arrows or hjkl to move/open/close, ctrl+d/ctrl+u (or ctrl+down/ctrl+up, page
down/up) to scroll a page, space to tick, a for all, w to save as a preset, enter to go
on with this selection, q to cancel. Exits 0 after enter, 1 on q.
"""

import curses
import locale
import os
import re
import sys
import unicodedata

HEADER = """\
# phone-backup preset{name}
# + backs up, - leaves out. "<dir>/" is a folder and everything in it, "<dir>/*" the
# files directly in it, anything else one file; "/" is the whole phone. The most
# specific rule wins.
"""


def name_key(name):
    """Alphabetical, case-insensitive, hidden (dot) names first."""
    return (not name.startswith("."), name.casefold())


class File:
    __slots__ = ("name", "size", "on")

    def __init__(self, name, size):
        self.name, self.size, self.on = name, size, True


class Node:
    __slots__ = ("name", "path", "parent", "children", "files", "expanded",
                 "total_size", "total_files", "sel_size", "sel_files")

    def __init__(self, name, path, parent):
        self.name = name
        self.path = path
        self.parent = parent
        self.children = {}
        self.files = []
        self.expanded = False
        self.total_size = self.total_files = self.sel_size = self.sel_files = 0

    def state(self):
        if self.sel_files == self.total_files:
            return "all"
        return "none" if self.sel_files == 0 else "some"

    def walk(self):
        yield self
        for c in self.children.values():
            yield from c.walk()

    def sort(self):
        self.children = dict(sorted(self.children.items(), key=lambda kv: name_key(kv[0])))
        self.files.sort(key=lambda f: name_key(f.name))
        for c in self.children.values():
            c.sort()


def join(d, name):
    return f"{d}/{name}" if d else name


def load_tree(listing):
    root = Node("sdcard", "", None)
    with open(listing, "rb") as f:
        for raw in f:
            parts = raw.rstrip(b"\n").decode("utf-8", "surrogateescape").split(" ", 2)
            if len(parts) != 3 or not parts[0].isdigit() or not parts[2].startswith("/sdcard/"):
                continue
            *dirs, name = parts[2][len("/sdcard/"):].split("/")
            node = root
            for d in dirs:
                child = node.children.get(d)
                if child is None:
                    child = Node(d, join(node.path, d), node)
                    node.children[d] = child
                node = child
            node.files.append(File(name, int(parts[0])))
    root.sort()
    update(root, totals=True)
    return root


def update(node, totals=False):
    """Recount the selected (and with totals=True, the total) size and files below node."""
    s = n = ts = tn = 0
    for f in node.files:
        ts += f.size
        tn += 1
        if f.on:
            s += f.size
            n += 1
    for c in node.children.values():
        update(c, totals)
        s += c.sel_size
        n += c.sel_files
        ts += c.total_size
        tn += c.total_files
    node.sel_size, node.sel_files = s, n
    if totals:
        node.total_size, node.total_files = ts, tn


def set_all(node, on):
    for n in node.walk():
        for f in n.files:
            f.on = on


def find(root, path):
    node = root
    for d in path.split("/") if path else []:
        node = node.children.get(d)
        if node is None:
            return None
    return node


# A rule is (on, path, kind): kind "tree" for "<dir>/", "files" for "<dir>/*",
# "file" for a single file.

def parse_rules(path):
    rules = []
    if not path or not os.path.exists(path):
        return rules
    with open(path, encoding="utf-8", errors="surrogateescape") as f:
        for line in (l.rstrip("\n") for l in f):
            sign, _, target = line.partition(" ")
            if sign not in ("+", "-") or not target:
                continue
            on = sign == "+"
            if target == "/":
                rules.append((on, "", "tree"))
            elif target == "*":
                rules.append((on, "", "files"))
            elif target.endswith("/*"):
                rules.append((on, target[:-2], "files"))
            elif target.endswith("/"):
                rules.append((on, target.rstrip("/"), "tree"))
            else:
                rules.append((on, target, "file"))
    return rules


def format_rule(rule):
    on, path, kind = rule
    if kind == "tree":
        target = path + "/" if path else "/"
    elif kind == "files":
        target = path + "/*" if path else "*"
    else:
        target = path
    return ("+ " if on else "- ") + target


class Rules:
    def __init__(self, rules):
        self.tree = {p: on for on, p, k in rules if k == "tree"}
        self.files = {p: on for on, p, k in rules if k == "files"}
        self.file = {p: on for on, p, k in rules if k == "file"}

    def subtree_on(self, d):
        """Whether folder d is backed up by the nearest folder rule at or above it."""
        while True:
            if d in self.tree:
                return self.tree[d]
            if not d:
                return True
            d = d.rpartition("/")[0]

    def file_on(self, d, name):
        path = join(d, name)
        if path in self.file:
            return self.file[path]
        return self.files[d] if d in self.files else self.subtree_on(d)


def in_scope(path, scope):
    return not scope or path == scope or path.startswith(scope + "/")


def apply_rules(root, rules):
    r = Rules(rules)
    for n in root.walk():
        for f in n.files:
            f.on = r.file_on(n.path, f.name)
    update(root)


def majority(on_n, off_n, fallback):
    return fallback if on_n == off_n else on_n > off_n


def collect(node, inherited, out):
    """The fewest rules that give node's subtree its ticks, given the inherited default.
    A partly ticked folder takes on whichever its items mostly are, so new folders and
    files on another phone follow the majority (tick only DCIM: "- /" and "+ DCIM/")."""
    st = node.state()
    if st != "some":
        on = st == "all"
        if on != inherited:
            out.append((on, node.path, "tree"))
        return
    states = [c.state() for c in node.children.values()] + ["all" if f.on else "none" for f in node.files]
    default = majority(states.count("all"), states.count("none"), inherited)
    if default != inherited:
        out.append((default, node.path, "tree"))
    if node.files:
        on_n = sum(f.on for f in node.files)
        files_default = majority(on_n, len(node.files) - on_n, default)
        if files_default != default:
            out.append((files_default, node.path, "files"))
        out.extend((f.on, join(node.path, f.name), "file") for f in node.files if f.on != files_default)
    for c in node.children.values():
        collect(c, default, out)


def rules_for(root, scope, outside):
    """Rules for the whole selection: those outside scope as they were, plus new ones inside."""
    node = find(root, scope) or root
    inherited = Rules(outside).subtree_on(scope.rpartition("/")[0]) if scope else True
    new = []
    collect(node, inherited, new)
    return sorted(outside + new, key=lambda r: (r[1] != "", r[1].casefold(), r[2] != "tree"))


def write_rules(path, rules, name=""):
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8", errors="surrogateescape") as f:
        f.write(HEADER.format(name=f": {name}" if name else ""))
        f.writelines(format_rule(r) + "\n" for r in rules)
    os.replace(tmp, path)


def human(b):
    for unit in ("B", "KB", "MB", "GB"):
        if b < 1024:
            return f"{b:.0f} {unit}" if unit == "B" else f"{b:.1f} {unit}"
        b /= 1024
    return f"{b:.1f} TB"


def char_width(ch):
    return 2 if unicodedata.east_asian_width(ch) in "WF" else 1


def width(s):
    return sum(char_width(ch) for ch in s)


def fit(s, w):
    """Cut s to w terminal columns (CJK characters take two), padding with spaces."""
    out, used = [], 0
    for ch in s:
        cw = char_width(ch)
        if used + cw > w:
            if w >= 1 and out:
                while used > w - 1:
                    used -= char_width(out.pop())
                out.append("…")
                used += 1
            break
        out.append(ch)
        used += cw
    return "".join(out) + " " * max(0, w - used)


def printable(s):
    return s.encode("utf-8", "surrogateescape").decode("utf-8", "replace")


CHECK = {"all": "[x]", "none": "[ ]", "some": "[~]"}


def rows(root):
    """Visible rows: (node, file, depth); file is None for a folder row."""
    out = []

    def walk(node, depth):
        out.append((node, None, depth))
        if node.expanded:
            for c in node.children.values():
                walk(c, depth + 1)
            out.extend((node, f, depth + 1) for f in node.files)

    walk(root, 0)
    return out


def row_text(node, file, depth, cols):
    indent = "  " * depth
    if file is not None:
        st = "all" if file.on else "none"
        name = f"{indent}{CHECK[st]}   {printable(file.name)}"
        info = f"{human(file.size):>10}"
    else:
        st = node.state()
        arrow = "▾" if node.expanded else "▸"
        name = f"{indent}{CHECK[st]} {arrow} {printable(node.name)}/"
        info = f"{human(node.total_size):>10} {node.total_files:>7} files"
        if st == "some":
            info = f"{human(node.sel_size)} of " + info.lstrip()
    return st, fit(name, max(10, cols - width(info) - 2)) + "  " + info


def put(scr, y, text, attr=0):
    try:
        scr.addstr(y, 0, text, attr)
    except curses.error:
        pass  # a line that runs past the edge of a tiny window


def ask(scr, question, text=""):
    """One-line input on the bottom row, starting with text already typed. Backspace
    deletes, ctrl+u clears, enter answers, esc skips (returns "")."""
    curses.curs_set(1)
    try:
        while True:
            lines, cols = scr.getmaxyx()
            put(scr, lines - 1, fit(question + text, cols - 1), curses.A_BOLD)
            scr.move(lines - 1, min(width(question + text), cols - 2))
            ch = scr.get_wch()
            if ch in ("\n", "\r", curses.KEY_ENTER):
                return text.strip()
            if ch == "\x1b":
                scr.nodelay(True)
                rest = scr.getch()
                while scr.getch() != -1:
                    pass  # swallow the rest of an arrow key's escape sequence
                scr.nodelay(False)
                if rest == -1:
                    return ""
            elif ch in (curses.KEY_BACKSPACE, "\x7f", "\b"):
                text = text[:-1]
            elif ch == "\x15":
                text = ""
            elif isinstance(ch, str) and ch.isprintable() and len(text) < 60:
                text += ch
    finally:
        curses.curs_set(0)


ESCAPES = {"A": curses.KEY_UP, "B": curses.KEY_DOWN, "C": curses.KEY_RIGHT, "D": curses.KEY_LEFT,
           "H": curses.KEY_HOME, "F": curses.KEY_END, "5~": curses.KEY_PPAGE, "6~": curses.KEY_NPAGE,
           "1;5A": curses.KEY_PPAGE, "1;5B": curses.KEY_NPAGE}  # ctrl+up / ctrl+down
PAGE_KEYS = {4: curses.KEY_NPAGE, 21: curses.KEY_PPAGE,  # ctrl+d / ctrl+u
             b"kDN5": curses.KEY_NPAGE, b"kUP5": curses.KEY_PPAGE}  # ctrl+down / ctrl+up


def read_key(scr):
    """getch, with ctrl+d/ctrl+u and ctrl+down/ctrl+up turned into page down/up, and
    arrow keys that arrive as raw ESC [ x / ESC O x sequences (some terminals and tmux
    send those even in keypad mode) decoded. A lone ESC stays 27."""
    key = scr.getch()
    if key in PAGE_KEYS:
        return PAGE_KEYS[key]
    if key > 255:
        try:
            return PAGE_KEYS.get(curses.keyname(key), key)
        except ValueError:
            return key
    if key != 27:
        return key
    scr.nodelay(True)
    seq = ""
    ch = scr.getch()
    while ch != -1:
        seq += chr(ch)
        ch = scr.getch()
    scr.nodelay(False)
    if len(seq) >= 2 and seq[0] in "[O":
        return ESCAPES.get(seq[1:], ESCAPES.get(seq[-1], -1))
    return 27 if not seq else -1


def picker(scr, root, scope, outside, presets_dir, preset_name="", tool="phone-backup", verb="back up"):
    curses.curs_set(0)
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_GREEN, -1)
    curses.init_pair(2, curses.COLOR_YELLOW, -1)
    curses.init_pair(3, curses.COLOR_CYAN, -1)
    color = {"all": curses.color_pair(1), "some": curses.color_pair(2), "none": curses.A_DIM}
    keys_help = (" ↑↓ move  ^d/^u page  → open  ← close  space tick  a all  w save preset"
                 "  enter go on  q cancel")

    root.expanded = True
    node = root
    for d in scope.split("/") if scope else []:
        node = node.children.get(d)
        if node is None:
            break
        node.expanded = True

    cur = top = 0
    status = ""
    while True:
        visible = rows(root)
        lines, cols = scr.getmaxyx()
        body = max(1, lines - 3)
        cur = max(0, min(cur, len(visible) - 1))
        top = min(max(top, cur - body + 1), cur)

        scr.erase()
        head = (f" {tool}: tick what to {verb}   Selected {human(root.sel_size)} of "
                f"{human(root.total_size)} ({root.sel_files} of {root.total_files} files)")
        put(scr, 0, fit(head, cols - 1), curses.color_pair(3) | curses.A_BOLD)
        for i, (n, f, depth) in enumerate(visible[top:top + body]):
            st, text = row_text(n, f, depth, cols - 1)
            put(scr, 1 + i, text, color[st] | (curses.A_REVERSE if top + i == cur else 0))
        put(scr, lines - 1, fit(status or keys_help, cols - 1),
            curses.color_pair(1) if status else curses.A_DIM)
        status = ""
        scr.refresh()

        key = read_key(scr)
        n, f, _ = visible[cur]
        if key in (curses.KEY_UP, ord("k")):
            cur -= 1
        elif key in (curses.KEY_DOWN, ord("j")):
            cur += 1
        elif key == curses.KEY_PPAGE:
            cur -= body
        elif key == curses.KEY_NPAGE:
            cur += body
        elif key in (curses.KEY_HOME, ord("g")):
            cur = 0
        elif key in (curses.KEY_END, ord("G")):
            cur = len(visible) - 1
        elif key in (curses.KEY_RIGHT, ord("l")):
            if f is None:
                if n.expanded:
                    cur += 1
                n.expanded = True
        elif key in (curses.KEY_LEFT, ord("h")):
            if f is None and n.expanded:
                n.expanded = False
            else:
                parent = n if f is not None else n.parent
                if parent is not None:
                    cur = next(i for i, r in enumerate(visible) if r[0] is parent and r[1] is None)
        elif key == ord(" "):
            if f is not None:
                f.on = not f.on
            else:
                set_all(n, n.state() != "all")
            update(root)
        elif key == ord("a"):
            set_all(root, root.state() != "all")
            update(root)
        elif key == ord("w"):
            name = ask(scr, " Save as preset (letters, digits, . _ -; esc to skip): ", preset_name)
            if not name:
                continue
            if not re.fullmatch(r"[A-Za-z0-9._-]+", name):
                status = f" Not saved: '{name}' has characters other than letters, digits, . _ -"
                continue
            os.makedirs(presets_dir, exist_ok=True)
            path = os.path.join(presets_dir, name + ".preset")
            replaced = os.path.exists(path)
            write_rules(path, rules_for(root, scope, outside), name)
            preset_name = name
            status = f" {'Replaced' if replaced else 'Saved'} preset '{name}' ({path})"
        elif key in (10, 13, curses.KEY_ENTER):
            return True
        elif key in (ord("q"), 27):
            return False


def main():
    args = sys.argv[1:]
    preset_name = ""
    tool, verb = "phone-backup", "back up"
    while args and args[0] in ("--name", "--restore"):
        if args[0] == "--restore":
            tool, verb, args = "phone-restore", "restore", args[1:]
        elif len(args) >= 2:
            preset_name, args = args[1], args[2:]
        else:
            sys.exit(__doc__)
    if len(args) not in (4, 5):
        sys.exit(__doc__)
    listing, rules_path, out_path, presets_dir = args[:4]
    scope = args[4].strip("/") if len(args) == 5 else ""

    root = load_tree(listing)
    rules = parse_rules(rules_path)
    apply_rules(root, rules)
    outside = [r for r in rules if not in_scope(r[1], scope)]

    locale.setlocale(locale.LC_ALL, "")
    os.environ.setdefault("ESCDELAY", "25")
    if not curses.wrapper(picker, root, scope, outside, presets_dir, preset_name, tool, verb):
        sys.exit(1)
    write_rules(out_path, rules_for(root, scope, outside))


if __name__ == "__main__":
    main()
