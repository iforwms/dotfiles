"--------General Preferences--------"
set encoding=utf-8                                  "Set encoding to utf-8.
set fileencoding=utf-8                              "Set file encoding to utf-8.
syntax enable                                       "Enable syntax and plugins (for netrw).
filetype plugin on                                  "Enable filetype plugin.
set nocompatible                                    "Disable checks for staying compatible with VI.
set noswapfile                                      "Disable swapfile creation.
set hidden                                          "Allow switching buffers without writing to disk.
set autowriteall                                    "Enable save on buffer change.
"set spell                                          "Enable spell-checking.
"set relativenumber                                 "Show line numbers relative to cursor position.
let g:tmux_navigator_disable_when_zoomed = 1        "Disable tmux navigator when zooming the Vim pane
"Clear terminal on exit.
au VimLeave * !clear

"--------Spaces and Tabs--------"
set shiftwidth=4                                    "Set indenting to 4 spaces not 8.
set tabstop=8                                       "Set tab width to 8.
set softtabstop=4                                   "Number of spaces for a tab.
set expandtab                                       "Use spaces instead of tabs.


"--------UI Config--------"
let mapleader=','                                   "Overwrite default leader (\) to comma.
set backspace=indent,eol,start                      "Fix backspace actions.
set number                                          "Add line numbering.
set showcmd                                         "Show (partial) command in status line.
set showmatch                                       "Highlight matching [{()}]
set matchpairs+=<:>                                 "Highlight matching pairs of brackets. Use the '%' character to jump between them.
augroup CursorLine                                  "Only highlight cursor line for active buffer.
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
augroup END


"--------Lilypond--------"
" \v for version
inoremap <Leader>\v \version "2.18.2"

"--------Search--------"
set path+=**                                        "Turn on recursive search.
set hlsearch                                        "Highlight all search results.
set incsearch                                       "Enable incremental searching.
set ignorecase                                      "Enable case-insensitive searching.
set smartcase                                       "Enable case-sensitive searching if mixed-case.
set tags=./tags;,tags,                              "Set ctags index location.
set wildmenu                                        "Display all matching files when tab complete.
set wildignore+=**/node_modules/**                  "Ignore node_modules in autocomplete.
set wildignore+=*.pyc,*.pyo,__pycache__             "Ignore compiled pythong files in autocomplete.
set complete=.,w,b,u,t

"Shortcut to turn off search highlighting.
nnoremap <Leader><space> :nohlsearch<CR>


"--------Shortcuts--------"
"Create horizontal split.
nmap ss :split<Return>

"Create vertical split.
nmap sv :vsplit<Return>

"Create new tab
nmap te :tabedit<Return>

"Switch between tabs
nmap <Tab> :tabnext<Return>
nmap <S-Tab> :tabprev<Return>

"--------Visuals--------ete horizontal split.
if !has("gui_running")                              "Enable 256 colors and turn on theme.
    set term=pcansi
    set t_CO=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    colorscheme Benokai
endif

set fillchars=""                                    "Characters used in split window divider.
set list                                            "Display whitespaces.
set listchars=tab:>-                                "Set whitespace tab characters.
"set listchars+=eol:$                               "Set whitespace eol characters.
set listchars+=trail:.                              "Set trailing whitespace characters.
set listchars+=extends:>                            "Set character denoting a line overflowing off the screen when wrapping is off.
set listchars+=precedes:<                           "Set character denoting a line overflowing off the screen when wrapping is off.
set listchars+=nbsp:.                               "Set character for non-breaking spaces.


"--------Color Scheme Overrides--------"
hi CursorLine ctermbg=0                             "Set color of current line.
hi CursorColumn ctermbg=0                           "Set color of current column.
hi CursorLineNr ctermbg=red ctermfg=white           "Current line number formatting.
hi NonText ctermbg=235 ctermfg=red cterm=none       "EOL etc text formatting.
hi LineNr ctermbg=bg                                "Set line number formatting.
hi VertSplit ctermbg=blue                           "Set vertical split separator color.
hi TabLineFill ctermfg=red ctermbg=DarkBlue         "Set main tab bg (right).
hi TabLine ctermfg=White ctermbg=DarkBlue           "Set unselected tabs formatting.
hi TabLineSel ctermfg=White ctermbg=red             "Set active tab formatting.
hi Title ctermfg=White                              "Set window count per tab formatting.

hi User1 ctermbg=grey ctermfg=0                     "Set user-defined scheme 1.
hi User2 ctermbg=red ctermfg=white                  "Set user-defined scheme 2.
hi User3 ctermbg=blue ctermfg=white                 "Set user-defined scheme 3.
hi User4 ctermbg=yellow ctermfg=black               "Set user-defined scheme 4.
hi User5 ctermbg=black ctermfg=white                "Set user-defined scheme 5.


"--------Split Management--------"
set splitbelow                                      "Open new splits below.
set splitright                                      "Open new splits to the right.

"Map ctrl+direction to move between windows.
"nnoremap <C-h> <C-w><C-h>
"nnoremap <C-j> <C-w><C-j>
"nnoremap <C-k> <C-w><C-k>
"nnoremap <C-l> <C-w><C-l>


"--------Directory browser settings--------"
let g:netrw_banner=0                                "Remove header from directory browser.
let g:netrw_browse_split=4                          "Open files in a new vertical split. (1: hsplit, 2: vsplit, 3: tab, 4: prev window)
let g:netrw_altv=1                                  "Open files to the right.
let g:netrw_liststyle=3                             "Set display mode to be Tree.
let g:netrw_list_hide=netrw_gitignore#Hide()        "Hide files hidden by .gitignore.
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S+'        "Hide additional files.
"autocmd FileType netrw setl bufhidden=Delete        "By default, netrw leaves unmodified buffers open. This autocommand deletes netrw's buffer once it's hidden.
autocmd BufRead * call s:set_hidden()
function s:set_hidden()
    if empty(&buftype) "most explorer plugins have buftype=nofile
        setlocal bufhidden=delete
    endif
endfunction

"--------Snippets--------"
nnoremap <Leader>html :-1read $HOME/.vim/.skeleton.html<CR>4jf>a
"inoremap <SPACE><SPACE> <ESC>/<++><Enter>"_c4l
nnoremap <Leader>ev :tabe $MYVIMRC<CR>
inoremap <Leader>i Ifor Waldo Williams
inoremap <Leader>em ifor@cors.tech
inoremap <Leader>n iforwms


"--------AutoCommands--------"
autocmd bufwritepre * :%s/\s\+$//e                  "Delete trailing whitespace on save.
augroup autosourcing                                "Auto-source the vimrc file on save.
        autocmd!
        autocmd BufWritePost .vimrc source %
augroup END


"--------Statusline--------"
function! ActiveStatus()
    "1: grey, 2: red, 3: blue, 4: green"

    let statusline=""
    let statusline.="%1*\ %{BufferNumber()}\ "      "Show current buffer number.
    let statusline.="%0*\ %{StatuslineGit()}\ "         "Show current GIT branch.
    let statusline.="%0*\%-.30f\  "                 "Show filename.
    let statusline.="%0*%="                         "Add divider.
    let statusline.="%0*\ %{FileSize()}\ [%l:%v] |"             "Show filesize.
    let statusline.="%0* %y\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ "   "Show file encoding.
    let statusline.="%0*\| %{strftime('%a %d %h %R')}\ "      "Show current time.
    return statusline
endfunction

function! InactiveStatus()
    let statusline=""
    let statusline.="%1*\ %{BufferNumber()}\ "      "Show current buffer number.
    let statusline.="\ %-.30f\ "                    "Show filename.
    return statusline
endfunction

set laststatus=2                                    "Always show status line.
set statusline=%!ActiveStatus()                     "Set statusline to active statusline.

augroup status
  autocmd!
  autocmd WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END


"--------Helper Functions--------"
"Get current GIT branch - WIP
function! GitBranch()
    "return "WIP"
    let l:string = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")

    return l:string
endfun

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"Get current buffer number
function! BufferNumber()
    return 'help'!=&filetype?'b:'.bufnr('%'):''
endfun

"Get current buffer's size
function! FileSize()
    let bytes = getfsize(expand('%:p'))

    if (bytes >= 1024)
        let kbytes = bytes / 1024
    endif

    if (exists('kbytes') && kbytes >= 1000)
        let mbytes = kbytes / 1000
    endif

    if bytes <= 0
        return '0 B'
    endif

    if (exists('mbytes'))
        return mbytes . 'MB'
    elseif (exists('kbytes'))
        return kbytes . 'KB'
    else
        return bytes . 'B'
    endif
endfunction


"--------Reference Guide--------"
" [count] [operator] [text object / motion]
"
"
" Operators
" ========
" c - change
" d - delete
" y - yank
" ~ swap case
" gU - uppercase
" gu - lowercase
" ! - filter to external program
" > - shift right
" < - shift left
" = - indent
"
"
" Text objects
" =========
" aw - a word
" iw - inner word
" aW - a WORD
" iW - inner WORD
" ap - a paragraph
" ip - inner paragraph
" ab - a bracket
" ib - inner bracket
" at - a tag block
" it - inner tag block
"
"
" Motions (act with operators or on their own)
" ==========================
" % - go to matching parens/bracket
" [count]+ - go to first non-blank char of line
" [count]$ - end of line
" [count]f/F{char} - to next occurrence of {char}
" [count]t/T{char} - to before next occurrence of {char}
" [count]h/j/k/l - left, down, up, right
" [count]]m - beginning of next method
" [count]w/W - go a word/WORD to right
" [count]b/B - go a word/WORD to left
" [count]e/E - go to end of word/WORD right
"
"
" Splits
" ====
" Ctrl+w s - split window
" Ctrl+w v - vert split
" Ctrl+w q - close window
" Ctrl+w w - alternate window
" Ctrl+w o - only window
" Ctrl+w r - rotate windows
" Ctrl+w x - switch viewport
" Ctrl+w H - change horz to vert
" Ctrl+w K - change verto to horz
" :windo {cmd} - execute command on all windows
" :sp - split current file
" :vs - vert split current file
" :sf - split find
" :sall - split all windows
" :vert {cmd} - make any split command vertical, e.g. :vert sf - vert split find
"
"
" Tabs
" ===
" gt - go to next tab
" gT - go to prev tab
" :tabc - close tab
" :tabe - open tab
" :tabo - close other tabs
"
"
" Searching
" ========
" /{patt}[/]<CR> - go to next {patt}
" /<CR> - go to net of last {patt}
" ? for backwards search
" [count]n - repeat last search [count] times
" [count]N - backwards
" * - search forward for word under cursor
" # - backwards under cursor
" gd - go to local declaration
" Ctrl+] - go to tag
" Ctrl+t - go back tag
" Ctrl+O/I - cycle through :jumps
" g; / g, - cycle through :changes
"
"
" Insert mode
" =========
" Ctrl+r - insert from register
" Ctrl+a - insert last edit, e.g. 3cwCtrl+a
"
"
" Buffers
" ======
" :bn - go to next buffer
" : b {filename} go to buffer {filename}
" :bd - delete current buffer
" :buffers - list all buffers
" :bufdo {cmd} - execute {cmd} on all buffers
" :n - go to next file (based on args list)
" :arga {filename} - add {filename} to arg list
" :arg1 {files} - make a local arg copy via {files}
" :args - print all args
"
"
" NETRW
" ======
" - - up a directory
" D - delete file
" R - rename
" d - create directory
" p - preview file
" Ctrl+w z - close preview
" s - change sort type
" x - show in finder
"
"
" Other actions
" ===========
" z= - spell suggestion
" Ctrl+N  - autocomplete
" :difft[his] - diff current window, use with :windo to diff all arg files
" :diffo[ff] - turn off diff
" :vim[grep] /{pattern}/ {file} - grep file(s) (% for current file, ## for all args)
" :cn[ext] / :cp[rev] = scroll through quicklists
" :cdo {cmd} - do a command for every result, e.g. :cdo s/TODO/DONE/g
" @: - repeat last command
" :so $VIMRUNTIME/syntax/hitest.vim - view all colors
" :retab - replace tabs with spaces
" :{int},{int}s/{term}/{replacement} - search and replace only certain lines
" (use ^ for start of line, i.e. to insert something to start of line -
"       :2,5s/^/#
