#!/usr/bin/env python3
"""
Scrape quiz questions/answers out of the PubQuizQuestionsHQ HTML export.

Source of truth: pubquizquestionshq.com/quiz/*.html  (1230 human-readable-slug
files). Their content is byte-identical to the numeric node/*.html aliases and
to the 4 duplicate loose HTML files in the project root, so only quiz/ is parsed
to avoid duplicating questions.

Each quiz page stores its Q&A inside a
<!-- google_ad_section_start --> ... <!-- google_ad_section_end --> region as a
flat run of <p>/<div> blocks. Several layouts occur across the corpus and are
each handled (see the per-format parsers below):
  * split      - "Questions:"/"Answers:" (or "Clues:"/"The Answers:") sections,
                 or an unlabeled numbered list repeated with answers
  * inline     - <strong>Question</strong> then plain <p>Answer</p>, or the two
                 combined in one block via <br/>; multi-line lyric clues; and
                 the reverse convention (plain numbered question, bold answer)
  * picture    - image questions with a <ul> list of numbered answers
  * alternating- no bold markup at all; plain question/answer paragraphs alternate

Output: quiz_questions.json - a flat list of question objects:
    {
        "question_text": str,
        "options": [str, ...] | [],   # multiple choice options, else empty list
        "answer_text": str,           # "" only where the source omits the answer
        "category": str,               # inferred from filename
        "source_file": str,            # relative path, for traceability
        "quiz_title": str               # <title> of the page, for grouping
    }
"""
import glob
import html
import json
import os
import re
from html.parser import HTMLParser

ROOT = "/Users/ifor/Downloads/tmp/quiz-temp"
QUIZ_DIR = os.path.join(ROOT, "pubquizquestionshq.com", "quiz")

AD_START = "<!-- google_ad_section_start -->"
AD_END = "<!-- google_ad_section_end -->"

# Files in quiz/ that are not actual quizzes (promos / book offers /
# how-to articles) - they contain no question/answer pairs.
SKIP_BASENAMES = {
    "brand-new-quiz-book-special-offer.html",
    "free-quiz-book-members-community.html",
    "how-host-your-own-quiz-home-2020.html",
}


# --------------------------------------------------------------------------
# Minimal HTML -> block-text extraction.
# We convert the ad-section body into a flat list of "blocks", each being
# (tag, text, bold) for <p> content, plus explicit list items for <li>.
# This keeps enough structure (bold vs not, block boundaries, <br/> splits)
# to distinguish question / options / answer without needing a full DOM.
# --------------------------------------------------------------------------

class BlockExtractor(HTMLParser):
    """Parses a fragment into a list of paragraph-like blocks.

    Each block is a dict: {"tag": "p"|"li", "parts": [(text, is_bold), ...]}
    <br/> inside a block starts a new "part group" boundary marked by a
    special ("<BR>", False) sentinel so callers can split on it.
    """

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.blocks = []
        self._cur = None
        self._bold_depth = 0
        self._skip_depth = 0  # inside <script>/<style>/<img>/<a class=print-*>

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag in ("p", "li", "div"):
            # Starting a new block-level element discards any still-open
            # block (this only happens with malformed/unclosed markup,
            # e.g. stray wrapping <div>s around groups of <p>s - in that
            # case the discarded block is empty/whitespace-only anyway).
            self._cur = {"tag": tag, "parts": []}
        elif tag in ("strong", "b"):
            self._bold_depth += 1
        elif tag == "br":
            if self._cur is not None:
                self._cur["parts"].append(("<BR>", False))
        elif tag in ("script", "style"):
            self._skip_depth += 1
        elif tag == "img":
            alt = attrs.get("alt", "")
            if alt and self._cur is not None:
                self._cur["parts"].append((f"[image: {alt}]", False))

    def handle_startendtag(self, tag, attrs):
        if tag == "br" and self._cur is not None:
            self._cur["parts"].append(("<BR>", False))

    def handle_endtag(self, tag):
        if tag in ("p", "li", "div"):
            if self._cur is not None:
                self.blocks.append(self._cur)
                self._cur = None
        elif tag in ("strong", "b"):
            self._bold_depth = max(0, self._bold_depth - 1)
        elif tag in ("script", "style"):
            self._skip_depth = max(0, self._skip_depth - 1)

    def handle_data(self, data):
        if self._skip_depth:
            return
        if self._cur is None:
            return
        if not data:
            return
        self._cur["parts"].append((data, self._bold_depth > 0))


def extract_ad_body(raw_html):
    start = raw_html.find(AD_START)
    end = raw_html.find(AD_END)
    if start == -1 or end == -1 or end < start:
        return None
    return raw_html[start + len(AD_START): end]


def get_title(raw_html):
    m = re.search(r"<title>(.*?)</title>", raw_html, re.S)
    if not m:
        return ""
    t = html.unescape(m.group(1)).strip()
    t = re.sub(r"\s*\|\s*Pub Quiz Questions HQ\s*$", "", t)
    return t


def block_plaintext(block):
    """Join a block's parts into plain text, collapsing <BR> to newline."""
    out = []
    for text, bold in block["parts"]:
        if text == "<BR>":
            out.append("\n")
        else:
            out.append(text)
    s = "".join(out)
    s = re.sub(r"[ \t]+", " ", s)
    s = re.sub(r"\n[ \t]*", "\n", s)
    return s.strip()


def block_bold_runs(block):
    """Return list of (segment_text, is_bold) merged across BR-less parts,
    split into lines on <BR>, each line a list of (text,bold) runs."""
    lines = [[]]
    for text, bold in block["parts"]:
        if text == "<BR>":
            lines.append([])
        else:
            if text.strip() == "" and not lines[-1]:
                # leading whitespace-only text; keep for now
                pass
            lines[-1].append((text, bold))
    return lines


# Multiple choice options line: starts "a)" and has at least a "b)" - two
# options ("a) town b) city") is enough; three+ ("...c) ...") also match.
OPTION_RE = re.compile(
    r"^\s*a\)\s*.+?\bb\)\s*.+", re.I | re.S
)
NUM_PREFIX_RE = re.compile(r"^\s*\(?\d{1,3}[\).]\s*")
# Numbered *question* start: number + delimiter + actual trailing content.
# Requiring the trailing "\S" stops a bare numeric answer like "12." from
# being mistaken for the start of question 12.
NUM_QSTART_RE = re.compile(r"^\s*\(?\d{1,3}[\).]\s+\S")
QLABEL_RE = re.compile(r"^\s*(the\s+)?(questions?|clues?)\s*:?\s*$", re.I)
ALABEL_RE = re.compile(r"^\s*(the\s+)?answers?\s*:?\s*$", re.I)

# Punctuation/whitespace stripped out when judging how "bold" a line is,
# so that quote marks or a trailing "- (explanation)" sitting outside a
# <strong> span don't make an otherwise-bold line look unbold.
_PUNCT_RE = re.compile(r"[\s\"'‘’“”.,;:()\-]+")


def _core_len(text):
    return len(_PUNCT_RE.sub("", text))


def is_bold_line(line_parts, threshold=0.6):
    """Ratio-based bold test for a full line/block: True if the majority
    (by non-punctuation character count) of the text is bold. Used where
    we need to classify a whole line as "the question" vs "the answer"."""
    non_empty = [(t, b) for t, b in line_parts if t.strip() and t != "<BR>"]
    if not non_empty:
        return False
    total = sum(_core_len(t) for t, _ in non_empty)
    if total == 0:
        return False
    bold = sum(_core_len(t) for t, b in non_empty if b)
    return (bold / total) >= threshold


def has_any_bold(line_parts):
    """True if a line contains any bold run at all. Used only to detect
    the "<strong>Question</strong> - clue<br/>Answer" pattern, where the
    bold span may cover just part of the first line."""
    return any(b for t, b in line_parts if t.strip() and t != "<BR>")


def is_bold_block(block):
    parts = [(t, b) for t, b in block["parts"] if t != "<BR>"]
    return is_bold_line(parts)


def starts_with_bold_clue(line_parts):
    """Narrow pattern: '<strong>Term</strong> (explanation)' or
    '<strong>Term</strong> - explanation' on a single line/block, where the
    bold ratio-based test fails because the parenthetical/dash explanation
    outweighs the bold term. Only fires when the bold run leads the line
    AND is immediately followed by '(', '-' or ':' - narrow enough not to
    misfire on ordinary answer text that happens to contain a bold word."""
    real = [(t, b) for t, b in line_parts if t != "<BR>" and t.strip()]
    if not real or not real[0][1]:
        return False
    j = 0
    while j < len(real) and real[j][1]:
        j += 1
    trailing = "".join(t for t, b in real[j:]).strip()
    return bool(re.match(r"^[-(:]", trailing))


def strip_num_prefix(s):
    return NUM_PREFIX_RE.sub("", s).strip()


def looks_like_options(s):
    """Detect 'a) ... b) ... c) ...' style multiple choice text."""
    return bool(OPTION_RE.match(s.strip()))


def split_options(s):
    """Split 'a) foo b) bar c) baz' into ['a) foo', 'b) bar', 'c) baz']."""
    # Split right before each lettered marker (a-e), keep the marker.
    parts = re.split(r"(?=(?:^|\s)[a-e]\)\s)", s.strip())
    opts = [p.strip() for p in parts if p.strip()]
    return opts


def clean_answer_prefix(s):
    """Strip a leading 'Answer:' label if present."""
    return re.sub(r"^\s*answers?\s*:\s*", "", s, flags=re.I).strip()


# --------------------------------------------------------------------------
# Format A: "inline" — each Q/A pair is one or two <p> blocks:
#   <p><strong>Question text</strong></p>
#   optional <p><strong>a) .. b) .. c) ..</strong></p>
#   <p>Answer text</p>
# Sometimes the question and answer are combined in ONE block separated by
# <br/>:
#   <p><strong>Question text</strong><br/>Answer text</p>
# --------------------------------------------------------------------------

SINGLE_OPTION_RE = re.compile(r"^\s*[a-e]\)\s+\S")


def parse_inline_format(blocks):
    questions = []
    pending_q = None
    pending_opts = []
    # True when the current pending question came from an explicitly
    # numbered line ("7) ..."). Most rounds bold the question and leave
    # the answer plain, but a handful do the reverse (plain numbered
    # question, bold answer). Numbering is a stronger, unambiguous signal
    # than boldness, so once we see it we trust it over bold/non-bold for
    # deciding whether the next line is a new question or this one's answer.
    pending_numbered = False

    def flush(answer_text):
        nonlocal pending_q, pending_opts, pending_numbered
        if pending_q:
            questions.append({
                "question_text": pending_q,
                "options": pending_opts,
                "answer_text": answer_text,
            })
        pending_q = None
        pending_opts = []
        pending_numbered = False

    def handle_single_line(txt, bold):
        nonlocal pending_q, pending_opts, pending_numbered
        if QLABEL_RE.match(txt) or ALABEL_RE.match(txt):
            return
        if looks_like_options(txt):
            if pending_q and not pending_opts:
                pending_opts = split_options(txt)
            return
        if NUM_QSTART_RE.match(txt):
            # Numbered lines always start a fresh question, regardless of
            # bold/non-bold.
            if pending_q:
                flush("")  # previous numbered question never resolved
            pending_q = strip_num_prefix(txt)
            pending_opts = []
            pending_numbered = True
            return
        if pending_q is not None and pending_numbered:
            # We're waiting for the answer to a numbered question - the
            # next line (bold or not) is that answer.
            flush(clean_answer_prefix(txt))
            return
        if bold:
            if pending_q and SINGLE_OPTION_RE.match(txt) and not OPTION_RE.match(txt):
                # A single "b) some answer" line right after a multi-choice
                # question is the marked correct answer, even if the site
                # happened to bold it too - not a new question.
                flush(clean_answer_prefix(txt))
                return
            if pending_q:
                # A previous question is still waiting for its answer
                # (e.g. a multi-choice question's options arrived on their
                # own block and its answer hasn't shown up yet, or this is
                # a "sequence" round with several bold clue lines before
                # one answer). Merge rather than discard, so nothing is
                # silently dropped with a blank answer.
                pending_q = pending_q + "\n" + txt
            else:
                pending_q = txt
                pending_opts = []
                pending_numbered = False
        else:
            # Answer text
            if pending_q:
                flush(clean_answer_prefix(txt))
            # else: stray non-bold paragraph (intro text) -> ignore

    for block in blocks:
        if block["tag"] not in ("p", "div"):
            continue
        text = block_plaintext(block)
        if not text:
            continue
        # Skip obvious non-content paragraphs (nav links, PDF links, blurbs)
        if re.match(r"^(print pdf|pdf version)", text, re.I):
            continue

        raw_lines = block_bold_runs(block)
        # Rebuild lines as (text, is_bold, any_bold) with per-line detection
        line_infos = []
        for line_parts in raw_lines:
            txt = "".join(t for t, b in line_parts if t != "<BR>")
            txt = re.sub(r"[ \t]+", " ", txt).strip()
            if not txt:
                continue
            is_bold = is_bold_line(line_parts) or starts_with_bold_clue(line_parts)
            line_infos.append((txt, is_bold, has_any_bold(line_parts)))

        if not line_infos:
            continue

        if len(line_infos) >= 2:
            # First line(s) bold = question (+options), remaining = answer
            first_txt, first_is_bold, first_any_bold = line_infos[0]
            if looks_like_options(first_txt) and pending_q and not pending_opts:
                pending_opts = split_options(first_txt)
                # remaining lines are the answer
                ans = " ".join(t for t, b, ab in line_infos[1:])
                flush(clean_answer_prefix(ans))
                continue
            # question + answer combined in same block via <br/> - the
            # question line need only CONTAIN bold (e.g. "<strong>Clue</strong>
            # - explanation<br/>Answer"), not be bold throughout.
            if first_any_bold:
                # The question can span several leading bold lines (e.g. a
                # "complete the lyric" clue: two bold lyric lines then the
                # non-bold answer). Consume consecutive bold lines into the
                # question, stopping at an options line or the first
                # non-bold line (which begins the answer).
                q_parts = [strip_num_prefix(first_txt)]
                j = 1
                while j < len(line_infos):
                    txt_j, is_b_j, any_b_j = line_infos[j]
                    if is_b_j and not looks_like_options(txt_j):
                        q_parts.append(txt_j)
                        j += 1
                    else:
                        break
                q_text = " ".join(q_parts).strip()
                rest = line_infos[j:]
                opts = []
                if rest and looks_like_options(rest[0][0]):
                    opts = split_options(rest[0][0])
                    rest = rest[1:]
                ans = " ".join(t for t, b, ab in rest).strip()
                if pending_q:
                    pending_q = pending_q + "\n" + q_text
                    if opts and not pending_opts:
                        pending_opts = opts
                else:
                    pending_q = q_text
                    pending_opts = opts
                    pending_numbered = bool(NUM_QSTART_RE.match(first_txt))
                if ans:
                    # This block carries its own answer (e.g. "Clue<br/>Answer").
                    flush(clean_answer_prefix(ans))
                # else: this block is question(+options) only - e.g. a
                # multi-choice question whose answer arrives as a later,
                # separate block. Leave pending_q set for that block to
                # resolve via handle_single_line.
                continue
            # else fall through to generic single-line handling per line
            for txt, bold, ab in line_infos:
                handle_single_line(txt, bold)
            continue

        txt, bold, ab = line_infos[0]
        handle_single_line(txt, bold)

    if pending_q:
        flush("")

    return [q for q in questions if q["question_text"]]


def any_bold_present(blocks):
    for block in blocks:
        if block["tag"] not in ("p", "div"):
            continue
        for t, b in block["parts"]:
            if b and t.strip() and t != "<BR>":
                return True
    return False


# --------------------------------------------------------------------------
# Format D: "alternating" — a small number of quizzes use no bold markup
# at all: plain paragraphs alternate question, [optional a)/b)/c) options],
# answer, question, answer, ... with only blank paragraphs as separators.
# Only tried when a file has produced nothing AND contains no bold text
# anywhere, so it can't misfire on the far more common bold-marked formats.
# --------------------------------------------------------------------------

def parse_alternating_format(blocks):
    texts = []
    for block in blocks:
        if block["tag"] not in ("p", "div"):
            continue
        t = block_plaintext(block)
        if not t:
            continue
        if QLABEL_RE.match(t) or ALABEL_RE.match(t):
            continue
        if re.match(r"^(print pdf|pdf version)", t, re.I):
            continue
        texts.append(t)

    questions = []
    pending_q = None
    pending_opts = []
    for t in texts:
        if pending_q is None:
            pending_q = strip_num_prefix(t)
            pending_opts = []
        elif not pending_opts and looks_like_options(t):
            pending_opts = split_options(t)
        else:
            questions.append({
                "question_text": pending_q,
                "options": pending_opts,
                "answer_text": clean_answer_prefix(t),
            })
            pending_q = None
            pending_opts = []
    return questions if questions else None


# --------------------------------------------------------------------------
# Format B: "split" — a "Questions:" <p> label, then numbered question
# paragraphs, then an "Answers:" <p> label, then numbered (repeated
# question + bold answer) paragraphs.
# --------------------------------------------------------------------------

NUM_LEAD_RE = re.compile(r"^\s*(\d{1,3})[\).]\s*(.*)$", re.S)


def group_by_blank(items):
    """Split a list of (block, text) into groups, using blocks with empty
    text (blank paragraphs) as separators between groups."""
    groups = []
    cur = []
    for block, t in items:
        if not t:
            if cur:
                groups.append(cur)
                cur = []
            continue
        cur.append((block, t))
    if cur:
        groups.append(cur)
    return groups


def group_by_number(items):
    """Group a list of (block, text) by leading question number: a new
    group begins at each line starting "N)"/"N.", and following
    unnumbered lines attach to it. Blank lines are dropped. Used when a
    section is numbered but has no blank-line separators between items
    (a very common layout: one <p> per numbered item, back to back)."""
    groups = []
    cur = []
    for block, t in items:
        if not t:
            continue
        if NUM_LEAD_RE.match(t):
            if cur:
                groups.append(cur)
            cur = [(block, t)]
        else:
            if cur:
                cur.append((block, t))
            else:
                cur = [(block, t)]
    if cur:
        groups.append(cur)
    return groups


def group_section(items):
    """Group one Q or A section into per-item groups. Prefer grouping by
    leading number (robust whether or not blank separators exist); fall
    back to blank-line grouping for unnumbered sections."""
    numbered = sum(1 for block, t in items if t and NUM_LEAD_RE.match(t))
    if numbered >= 2:
        return group_by_number(items)
    return group_by_blank(items)


def _split_group(group):
    """Pull a leading number (from the first line only), any a)/b)/c)
    options line, and the remaining content lines out of one group."""
    num = None
    options = []
    lines = []
    for i, (block, t) in enumerate(group):
        rest = t
        if i == 0:
            m = NUM_LEAD_RE.match(t)
            if m:
                num = int(m.group(1))
                rest = m.group(2).strip()
        if not rest:
            continue
        if looks_like_options(rest):
            if not options:
                options = split_options(rest)
            continue
        lines.append(rest)
    return num, lines, options


def split_trailing_bold(block):
    """For a block whose content is 'leading text <strong>trailing bold
    text</strong>' (a restated clue immediately followed by a bold answer,
    both inside the same <p>, e.g. "1) Some clue: **Answer**"), return
    (leading_text, trailing_bold_text). None if the block doesn't end in
    a meaningful bold run, or has no leading text before it."""
    parts = [(t, b) for t, b in block["parts"] if t != "<BR>"]
    while parts and not parts[-1][0].strip():
        parts.pop()
    if not parts or not parts[-1][1]:
        return None
    j = len(parts)
    while j > 0 and parts[j - 1][1]:
        j -= 1
    leading = re.sub(r"[ \t]+", " ", "".join(t for t, b in parts[:j])).strip()
    leading = re.sub(r"[:\-]\s*$", "", leading).strip()
    trailing = re.sub(r"[ \t]+", " ", "".join(t for t, b in parts[j:])).strip()
    if not leading or not trailing:
        return None
    return leading, trailing


def find_implicit_qa_split(texts):
    """Detect an unlabeled split format: a numbered question list (1..N)
    followed by the SAME numbered list restated with answers - no
    "Questions:"/"Answers:" text markers at all, just the numbering
    restarting from (about) 1. Returns the index in `texts` where the
    second (question+answer) list begins, or None. Deliberately strict
    (matching max numbers in both halves) since this runs before
    parse_inline_format and a false positive would misparse a file that
    inline-format would have handled correctly.
    """
    numbered = [(i, int(NUM_LEAD_RE.match(t).group(1)))
                for i, (block, t) in enumerate(texts) if NUM_LEAD_RE.match(t)]
    if len(numbered) < 4:
        return None
    for k in range(1, len(numbered)):
        prev_i, prev_n = numbered[k - 1]
        cur_i, cur_n = numbered[k]
        if cur_n <= prev_n and cur_n <= 2 and prev_n >= 3:
            before = [n for i, n in numbered if i < cur_i]
            after = [n for i, n in numbered if i >= cur_i]
            if before and after and max(after) >= max(before):
                return cur_i
    return None


def _norm(s):
    return re.sub(r"[^a-z0-9]+", "", s.lower())


def _norm_match(a, b):
    """True if normalized a and b are equal, or the shorter is a prefix of
    the longer covering >=85% of it (tolerates minor trailing edits in a
    restated question)."""
    na, nb = _norm(a), _norm(b)
    if not na or not nb:
        return False
    if na == nb:
        return True
    short, long = (na, nb) if len(na) <= len(nb) else (nb, na)
    return long.startswith(short) and len(short) >= 0.85 * len(long)


def strip_norm_prefix(full, prefix):
    """Remove `prefix` from the start of `full` by normalized-character
    alignment (ignoring punctuation/whitespace/tags), returning the
    remaining original substring. None if `full` doesn't start with
    `prefix`."""
    fmap = []
    norm_full = []
    for i, ch in enumerate(full):
        # Keep exactly the chars _norm() keeps ([a-z0-9]) so both sides
        # normalize identically - note accented letters (e.g. the "æ" in
        # "Solskjær") are alnum but not ASCII, and _norm drops them.
        if ch.isascii() and ch.isalnum():
            norm_full.append(ch.lower())
            fmap.append(i)
    norm_full = "".join(norm_full)
    np = _norm(prefix)
    if not np or not norm_full.startswith(np):
        return None
    end_full_idx = fmap[len(np) - 1]
    return full[end_full_idx + 1:]


def _group_lines(group):
    """Split a group's blocks into per-<br/> lines, each (text, is_bold)."""
    out = []
    for block, _ in group:
        for line_parts in block_bold_runs(block):
            txt = "".join(t for t, b in line_parts if t != "<BR>")
            txt = re.sub(r"\s+", " ", txt).strip()
            if not txt:
                continue
            out.append((txt, is_bold_line(line_parts)))
    return out


def _extract_answer(alines, group, q_text):
    """Given the (numbered-stripped, option-stripped) lines of an answer
    group, the raw group, and the known question text for it, return the
    answer string. Works whether the answer is the bold or the non-bold
    part, and whether question and answer are separated by <br/>, a
    colon, or sit in separate blocks."""
    # 1. Multi-line: drop the line that restates the known question.
    if q_text and len(alines) >= 2:
        kept = []
        removed = False
        for txt, bold in alines:
            if not removed and _norm_match(txt, q_text):
                removed = True
                continue
            kept.append((txt, bold))
        if removed and kept:
            return " ".join(t for t, b in kept).strip()
    # 2. Single line that embeds the question as a prefix ("Q: answer").
    if q_text and len(alines) == 1:
        rem = strip_norm_prefix(alines[0][0], q_text)
        if rem is not None and rem.strip(" :-\t"):
            return rem.strip(" :-\t")
    # 3. Mixed bold within a single block ("clue: **answer**").
    if len(group) == 1:
        sp = split_trailing_bold(group[0][0])
        if sp and (not q_text or _norm_match(sp[0], q_text)
                   or _norm(sp[0]).startswith(_norm(q_text)[:20])):
            return sp[1]
    # 4. Default: the last line is the answer.
    if alines:
        return alines[-1][0]
    return ""


def parse_split_format(blocks):
    # Locate the Questions:/Clues: and Answers: label blocks (<p> or <div>).
    texts = []
    for block in blocks:
        if block["tag"] not in ("p", "div"):
            continue
        t = block_plaintext(block)
        texts.append((block, t))

    q_start = None
    a_start = None
    for i, (block, t) in enumerate(texts):
        if q_start is None and QLABEL_RE.match(t):
            q_start = i
        if a_start is None and ALABEL_RE.match(t):
            a_start = i
    if a_start is None:
        restart = find_implicit_qa_split(texts)
        if restart is None:
            return None  # not actually split format
        a_start = restart - 1
        q_start = None

    q_section = texts[(q_start + 1 if q_start is not None else 0):a_start]
    a_section = texts[a_start + 1:]

    # Drop themed-quiz section sub-headers (bold, short, ends with ":",
    # no number, no "?"), e.g. "Television:" / "Gone but not Forgotten:".
    # They appear in both the Questions and Answers sections and would
    # otherwise become junk entries or leak into an adjacent answer.
    # Numbered fill-in prompts ("Osiris is the Egyptian god of:") are
    # exempt because they carry a leading number.
    def is_subheader(block, t):
        t = t.strip()
        if not t.endswith(":") or "?" in t or len(t) > 40:
            return False
        if NUM_LEAD_RE.match(t) or looks_like_options(t):
            return False
        return is_bold_block(block)

    q_section = [(b, t) for b, t in q_section if not is_subheader(b, t)]
    a_section = [(b, t) for b, t in a_section if not is_subheader(b, t)]

    # Build question lookup: by number (preferred) and by position.
    q_by_num = {}
    q_by_pos = []
    for g in group_section(q_section):
        num, lines, options = _split_group(g)
        qtext = " ".join(lines).strip()
        q_by_pos.append((qtext, options))
        if num is not None and num not in q_by_num:
            q_by_num[num] = (qtext, options)

    questions = []
    for idx, group in enumerate(group_section(a_section)):
        alines = _group_lines(group)
        num = None
        if alines and NUM_LEAD_RE.match(alines[0][0]):
            m = NUM_LEAD_RE.match(alines[0][0])
            num = int(m.group(1))
            alines[0] = (m.group(2).strip(), alines[0][1])
        alines = [(t, b) for t, b in alines if t]

        options = []
        for t, b in alines:
            if looks_like_options(t):
                options = split_options(t)
                break
        alines = [(t, b) for t, b in alines if not looks_like_options(t)]
        if not alines:
            continue

        known = None
        if num is not None and num in q_by_num:
            known = q_by_num[num]
        elif idx < len(q_by_pos):
            known = q_by_pos[idx]
        q_text = known[0] if known else ""
        q_opts = options or (known[1] if known else [])

        answer_text = _extract_answer(alines, group, q_text)

        if not q_text:
            # Answer-only group with no matching question section entry -
            # treat all but the last line as the question.
            if len(alines) >= 2:
                q_text = " ".join(t for t, b in alines[:-1]).strip()
                answer_text = alines[-1][0]

        if not q_text:
            continue
        questions.append({
            "question_text": q_text,
            "options": q_opts,
            "answer_text": clean_answer_prefix(answer_text),
        })
    return questions


# --------------------------------------------------------------------------
# Format C: picture rounds — "Answers:" as an <li> list, question is a
# single generic prompt (often with an <img>). We treat this specially:
# one question overall ("Can you name..."), image noted, and each <li>
# becomes an individual numbered sub-answer. Given the required schema
# (one question_text per object), we emit one object per li using the
# generic prompt as question_text with the item number appended.
# --------------------------------------------------------------------------

def parse_picture_round(blocks):
    prompt = None
    answers = []
    for block in blocks:
        t = block_plaintext(block)
        if not t:
            continue
        if block["tag"] == "p":
            if ALABEL_RE.match(t):
                continue
            if prompt is None and not t.lower().startswith("[image"):
                # first substantive bold prompt paragraph
                if is_bold_block(block) and "?" in t:
                    prompt = t
        elif block["tag"] == "li":
            m = NUM_LEAD_RE.match(t)
            if m:
                answers.append((int(m.group(1)), m.group(2).strip()))
            else:
                answers.append((len(answers) + 1, t))
    if not prompt or not answers:
        return None
    questions = []
    for num, ans in answers:
        questions.append({
            "question_text": f"{prompt} ({num})",
            "options": [],
            "answer_text": ans,
        })
    return questions


# --------------------------------------------------------------------------
# Category inference from filename
# --------------------------------------------------------------------------

YEAR_TOKEN_RE = re.compile(r"^(\d{4}|\d{1,4}s)$")   # 2022, 90s, 1970s, 2000s
STOP_TOKENS = {"quiz", "round", "rounds", "part", "pt", "special", "edition"}


def infer_category(basename):
    """Infer a category from the filename slug, e.g.
    "2022-music-round-1"           -> "music"
    "90s-football-quiz-round-1"    -> "football"
    "anagrams-quiz-round-1-actors" -> "anagrams"
    "general-knowledge-quiz-round-291" -> "general knowledge"
    Rule: drop a leading year/decade, then keep tokens up to the first
    structural marker (quiz / round / a bare number / round letter)."""
    stem = re.sub(r"\.html?$", "", basename, flags=re.I).lower()
    tokens = [t for t in re.split(r"[-_]", stem) if t]

    while tokens and YEAR_TOKEN_RE.match(tokens[0]):
        tokens.pop(0)

    cat = []
    for tok in tokens:
        if tok in STOP_TOKENS:
            break
        if re.fullmatch(r"\d+[a-z]?", tok):        # "1", "12", "2b"
            break
        if re.fullmatch(r"[a-f]", tok) and cat:    # trailing round letter
            break
        cat.append(tok)

    if not cat:
        # The slug led with a structural token (e.g. "quiz-year-2022",
        # i.e. the "Quiz of the Year" series). Keep the meaningful tokens
        # ("quiz", "year", topic words) but drop numbers and round markers.
        drop = {"round", "rounds", "part", "pt", "special", "edition"}
        cat = [t for t in tokens
               if not re.fullmatch(r"\d+[a-z]?", t) and t not in drop]

    return " ".join(cat).strip()


def parse_file(path, rel_label):
    raw = open(path, encoding="utf-8", errors="replace").read()
    body = extract_ad_body(raw)
    if body is None:
        return None, "no-ad-markers"
    parser = BlockExtractor()
    try:
        parser.feed(body)
    except Exception as e:
        return None, f"parse-error: {e}"
    blocks = parser.blocks

    result = parse_split_format(blocks)
    fmt = "split"
    if not result:
        result = parse_picture_round(blocks)
        fmt = "picture"
    if not result:
        result = parse_inline_format(blocks)
        fmt = "inline"
    if not result and not any_bold_present(blocks):
        result = parse_alternating_format(blocks)
        fmt = "alternating"
    if not result:
        return None, f"empty (tried split/picture/inline/alternating)"
    return result, fmt


def main():
    files = sorted(glob.glob(os.path.join(QUIZ_DIR, "*.html")))
    all_questions = []
    stats = {"split": 0, "inline": 0, "picture": 0, "alternating": 0}
    failures = []

    for path in files:
        base = os.path.basename(path)
        if base in SKIP_BASENAMES:
            continue
        title = get_title(open(path, encoding="utf-8", errors="replace").read())
        category = infer_category(base)
        result, fmt = parse_file(path, base)
        if result is None:
            failures.append((base, fmt))
            continue
        stats[fmt] = stats.get(fmt, 0) + 1
        for q in result:
            question_text = html.unescape(q["question_text"]).strip()
            answer_text = html.unescape(q["answer_text"]).strip()
            # Drop degenerate pairs where the "answer" is identical to the
            # question (a stray section header captured as a Q&A).
            if answer_text and _norm(question_text) == _norm(answer_text):
                continue
            q_obj = {
                "question_text": question_text,
                "options": [html.unescape(o).strip() for o in q.get("options", [])],
                "answer_text": answer_text,
                "category": category,
                "source_file": os.path.relpath(path, ROOT),
                "quiz_title": title,
            }
            all_questions.append(q_obj)

    out_path = os.path.join(ROOT, "quiz_questions.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(all_questions, f, ensure_ascii=False, indent=2)

    print(f"Total files processed: {len(files) - len(SKIP_BASENAMES & set(os.path.basename(p) for p in files))}")
    print(f"Format stats: {stats}")
    print(f"Failures ({len(failures)}):")
    for b, r in failures[:40]:
        print(f"   {b}: {r}")
    print(f"Total questions extracted: {len(all_questions)}")
    print(f"Written to {out_path}")


if __name__ == "__main__":
    main()
