"--------Userful tips --------------"
"Replace all px with rem
" :%s#\(\d\+\)px#\=printf("%f", (submatch(1) / 16.0))."rem"#g

"--------General Preferences--------"
filetype off
set runtimepath+=$HOME/.dotfiles/lilypond/vim/
filetype plugin on                                  "Enable filetype plugin.
filetype on

set encoding=utf-8                                  "Set encoding to utf-8.
set fileencoding=utf-8                              "Set file encoding to utf-8.
set termencoding=utf-8
setglobal fileencoding=utf-8

syntax enable                                       "Enable syntax and plugins (for netrw).
set nocompatible                                    "Disable checks for staying compatible with VI.
set noswapfile                                      "Disable swapfile creation.
set hidden                                          "Allow switching buffers without writing to disk.
set autowriteall                                    "Enable save on buffer change.
"set spell                                          "Enable spell-checking.
let g:tmux_navigator_disable_when_zoomed = 1        "Disable tmux navigator when zooming the Vim pane
"set clipboard+=unnamedplus                          "By default, yank to system clipboard

"--------Spaces and Tabs--------"
set shiftwidth=4                                    "Set indenting to 4 spaces not 8.
set tabstop=8                                       "Set tab width to 8.
set softtabstop=4                                   "Number of spaces for a tab.
set expandtab                                       "Use spaces instead of tabs.


"--------UI Config--------"
let mapleader=','                                   "Overwrite default leader (\) to comma.
set timeoutlen=1000                                 "Disable delay in switching from insert to normal mode
set colorcolumn="80,".join(range(120,999),",")      "Set visual markers at cols 80 and 120
autocmd FileType markdown let &colorcolumn=""       "Disable column colouring in markdown files
set ttimeoutlen=0                                  "Disable delay in switching from insert to normal mode
set backspace=indent,eol,start                      "Fix backspace actions.
set number                                          "Add line numbering.
"set relativenumber                                  "Show line numbers relative to cursor position.
set showmatch                                       "Highlight matching [{()}]
set nrformats=                                      "Always treat numbers as decimal
set matchpairs+=<:>                                 "Highlight matching pairs of brackets. Use the '%' character to jump between them.
augroup CursorLine                                  "Only highlight cursor line for active buffer.
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
augroup END

"Show absolute line numbering when in insert mode.
"augroup numbertoggle
  "autocmd!
  "autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  "autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END


"--------Fix common typos--------"
iabbrev teh the


"--------Search--------"
set path+=**                                        "Turn on recursive search.
set hlsearch                                        "Highlight all search results.
set incsearch                                       "Enable incremental searching.
set ignorecase                                      "Enable case-insensitive searching.
set smartcase                                       "Enable case-sensitive searching if mixed-case.
set tags=./tags;,tags,                              "Set ctags index location.
set wildmenu                                        "Display all matching files when tab complete.
set wildmode=full                                   "Make wildcard matching match ZSH behaviour
set wildignore+=**/node_modules/**                  "Ignore node_modules in autocomplete.
set wildignore+=**/vendor/**                  "Ignore vendor in autocomplete.
set wildignore+=*.pyc,*.pyo,__pycache__             "Ignore compiled pythong files in autocomplete.
"file, window, buffer, inactive buffers, tags, includes, spell check (when enabled)"
set complete=.,w,b,u,t,i,kspell

"Shortcut to turn off search highlighting.
nnoremap <Leader><space> :nohlsearch<CR>
"
"Prettify current file
function! Prettify()
    let curPos = getcurpos()
    exe "%!prettier --stdin --stdin-filepath %"
    call setpos('.', curPos)
endfunction
nnoremap <Leader>p :call Prettify()<cr>


"--------Shortcuts--------"
"Force saving file as sudo
cmap w!! w !sudo tee > /dev/null %

"Create horizontal split.
nmap ss :split<Return>

"Create vertical split.
nmap sv :vsplit<Return>

"Create new tab
nmap te :tabedit<Return>

"Switch between tabs
"nmap <Tab> :tabnext<Return>
"nmap <S-Tab> :tabprev<Return>

"Search tags
nmap <Leader>s :tag<space>


"--------Visuals--------ete horizontal split.
if !has('gui')
    " ^[ is a single character: Ctrl+V,<ESC>
    let &t_8f = "[38;2;%lu;%lu;%lum"
    let &t_8b = "[48;2;%lu;%lu;%lum"

    set termguicolors

    if !has('mac')
        set t_ut=
    endif
endif

if !has("gui_running")                              "Enable 256 colors and turn on theme.
    set term=pcansi
    set t_CO=256

    "Add italic support
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
    highlight Comment cterm=italic

    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    let g:onedark_terminal_italics=1
    let g:onedark_termcolors=256
    colorscheme onedark
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
hi CursorLine ctermbg=234                             "Set color of current line.
hi CursorColumn ctermbg=0                           "Set color of current column.
hi CursorLineNr ctermbg=235 ctermfg=39           "Current line number formatting.
hi NonText ctermbg=235 ctermfg=red cterm=none       "EOL etc text formatting.
hi LineNr ctermbg=234                                "Set line number formatting.
hi VertSplit ctermbg=238                           "Set vertical split separator color.
hi TabLineFill ctermfg=red ctermbg=236         "Set main tab bg (right).
hi TabLine ctermfg=244 ctermbg=236           "Set unselected tabs formatting.
hi TabLineSel ctermfg=120 ctermbg=236             "Set active tab formatting.
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


"--------Buffers--------"
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> ]B :blast<CR>

"--------Quickfix--------"
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> ]Q :clast<CR>

" Add similar to above but for [l - location
" and [t for tag lists


"--------Directory browser settings--------"
let g:netrw_banner=0                                "Remove header from directory browser.
let g:netrw_browse_split=4                          "Open files in a new vertical split. (1: hsplit, 2: vsplit, 3: tab, 4: prev window)
let g:netrw_altv=1                                  "Open files to the right.
let g:netrw_liststyle=3                             "Set display mode to be Tree.
let g:netrw_list_hide=netrw_gitignore#Hide()        "Hide files hidden by .gitignore.
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S+'        "Hide additional files.
"autocmd FileType netrw setl bufhidden=Delete        "By default, netrw leaves unmodified buffers open. This autocommand deletes netrw's buffer once it's hidden.
"autocmd BufRead * call s:set_hidden()
"function s:set_hidden()
"    if empty(&buftype) "most explorer plugins have buftype=nofile
"        setlocal bufhidden=delete
""    endif
"endfunction


"--------Snippets--------"
nnoremap <Leader>html :-1read $HOME/.vim/.skeleton.html<CR>4jf>a
"inoremap <SPACE><SPACE> <ESC>/<++><Enter>"_c4l
nnoremap <Leader>ev :tabe $MYVIMRC<CR>
inoremap <Leader>iww Ifor Waldo Williams
inoremap <Leader>em ifor@cors.tech
inoremap <Leader>nn iforwms


"--------AutoCommands--------"
autocmd bufwritepre * :%s/\s\+$//e                  "Delete trailing whitespace on save.
augroup autosourcing                                "Auto-source the vimrc file on save.
        autocmd!
        autocmd BufWritePost .vimrc source %
augroup END

"Clear terminal on exit.
au VimLeave * !clear

"--------Helper Functions--------"
function! PhpSyntaxOverride()
  " Put snippet overrides in this function.
  hi! link phpDocTags phpDefine
  hi! link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

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
