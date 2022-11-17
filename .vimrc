"--------Useful tips --------------"
"Replace all px with rem
" :%s#\(\d\+\)px#\=printf("%f", (submatch(1) / 16.0))."rem"#g

"--------General Preferences--------"
filetype off
set runtimepath+=$HOME/.dotfiles/lilypond/vim/
set runtimepath+=$HOME/.fzf/bin/fzf
filetype plugin on                                  "Enable filetype plugin.
filetype indent on                                  "Enable indent plugin.
filetype on

set encoding=utf-8                                  "Set encoding to utf-8.
set fileencoding=utf-8                              "Set file encoding to utf-8.
set termencoding=utf-8
setglobal fileencoding=utf-8

syntax enable                                       "Enable syntax and plugins (for netrw).
set nocompatible                                    "Disable checks for staying compatible with VI.
set noswapfile                                      "Disable swapfile creation.
set hidden                                          "Allow switching buffers without writing to disk.
set history=200 "Increase command line history
set autowriteall                                    "Enable save on buffer change.
set dictionary+=/usr/share/dict/words               "Add dictionary.
set cmdheight=2

set viewoptions=folds,cursor
set sessionoptions=folds

"Enable auto format on rust files on save
let g:rustfmt_autosave = 1

runtime macros/matchit.vim " improve brace matching

"---------COC Config-------"
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

nnoremap coc#float#has_scroll() ? coc#float#scroll(1, 1) : "<C-j>"
nnoremap coc#float#has_scroll() ? coc#float#scroll(0, 1) : "<C-k>"

" Always show the sign column, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge sign column and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Add buffer shortcuts
nnoremap <silent> [b : bprevious <CR>
nnoremap <silent> ]b : bnext <CR>
nnoremap <silent> [B :b first <CR>
nnoremap <silent> ]B :b last <CR>

" Keep page centered during searches
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep join string in same cursor position
" nnoremap J mzJ`z

" Add additional undo points
" inoremap , ,<c-g>u

" Edit current pane in new tab
nmap <c-w><c-t> :tabedit %<cr>

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location
" list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Fix & (repeat last substitution) by preserving options
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" GoTo code navigation.
function! JumpToDefinition()
   let s =  execute("normal \<Plug>(coc-definition)")
   if strtrans(s)=="^@[coc.nvim]Definition provider not found for current document^@[coc.nvim]Definition provider not found for current document"
    execute "AnyJump"
   endif
endfunction
nmap <silent>gd :call JumpToDefinition()<CR>

nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
if (exists("CocActionAsync"))
    autocmd CursorHold * silent call CocActionAsync('highlight')
endif

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Update ctags on save
autocmd BufWritePost * call system("ctags-R")

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language
" server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"Project rename word
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

"-------End COC Config--------

"-------Vim Fugitive------
"Shortcut for committing changes
nnoremap <leader>ep :Git push<CR>

"Shortcut for showing git diff
nnoremap <leader>ed :Gvdiffsplit!<CR>

"Shortcut for committing changes
nnoremap <leader>ec :Git commit<CR>

"Shortcut for checking out branches
nnoremap <leader>eo :GBranches<CR>

"Git status
nmap <leader>es :G<CR>

"set spell                                          "Enable spell-checking.
let g:tmux_navigator_disable_when_zoomed = 1        "Disable tmux navigator when zooming the Vim pane
"set clipboard+=unnamedplus                          "By default, yank to system clipboard
set foldcolumn=2                                    "Display folds beside line numbers.

"--------Spaces and Tabs--------"
set shiftwidth=4                                    "Set indenting to  space.
set tabstop=4                                       "Set tab width to 4.
set softtabstop=0                                   "Number of spaces for a tab - force using spaces.
set expandtab                                       "Use spaces instead of tabs.


"--------UI Config--------"
let mapleader=','                                   "Overwrite default leader (\) to comma.
set timeoutlen=1000                                 "Disable delay in switching from insert to normal mode
set colorcolumn="80,".join(range(120,999),",")      "Set visual markers at cols 80 and 120
autocmd FileType markdown let &colorcolumn=""       "Disable column colouring in markdown files
set ttimeoutlen=0                                  "Disable delay in switching from insert to normal mode
set backspace=indent,eol,start                      "Fix backspace actions.
set number                                          "Add line numbering.
"set relative number                                  "Show line numbers relative to cursor position.
set showmatch                                       "Highlight matching [{()}]
set nrformats=                                      "Always treat numbers as decimal
set matchpairs+=<:>                                 "Highlight matching pairs of brackets. Use the '%' character to jump between them.
augroup CursorLine                                  "Only highlight cursor line for active buffer.
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
augroup END

function! GenerateSpellcheckFiles()
    for d in glob('~/.vim/spell/*.add', 1, 1)
        if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
            exec 'mkspell! ' . fnameescape(d)
        endif
    endfor
endfunction

augroup Startup
    au!
    au VimEnter * :call GenerateSpellcheckFiles()
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
set tags=./tags,tags;$HOME                          "Set ctags index location.
set wildmenu                                        "Display all matching files when tab complete.
set wildmode=full                                   "Make wildcard matching match ZSH behaviour
set wildignore+=**/node_modules/**                  "Ignore node_modules in autocomplete.
set wildignore+=**/vendor/**                  "Ignore vendor in autocomplete.
set wildignore+=*.pyc,*.pyo,__pycache__             "Ignore compiled pythong files in autocomplete.
set wildignorecase
"file, window, buffer, inactive buffers, tags, includes, spell check (when enabled)"
set complete=.,w,b,u,t,i

" Turn on spellcheck
set spell

"Shortcut to turn off search highlighting.
nnoremap <leader>t :!ctags -R .<CR>

"Alias :W to :w
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

"Shortcut to turn off search highlighting.
nnoremap <leader><space> :nohlsearch<CR>

"Set shellcheck as default compiler for bash scripts
augroup Linting
    autocmd!
    set errorformat+=%f:%l:%c\ %m
    autocmd FileType sh compiler shellcheck
    autocmd BufWritePost *.sh silent make! <afile> | silent redraw!
    autocmd QuickFixCmdPost [^l]* cwindow
augroup END

"Prettify current file
function! Prettify()
    let curPos = getcurpos()
    let cmd = "%!prettier --stdin-filepath %"
    if (&ft=='sh')
        let cmd = ":silent make! %"
        set local errorformat+=%f:%l:%c\ %m
    endif
    if (&ft=='python')
        let cmd = "!black %"
    endif
    exe cmd
    exe ":silent redraw!"
    call setpos('.', curPos)
endfunction
nnoremap <leader>p :call Prettify()<cr>

function! PdfLatex()
    let curPos = getcurpos()
    exe ":silent !~/.dotfiles/scripts/latex_preview % %:r >/dev/null 2>&1"
    exe ":silent redraw!"
    call setpos('.', curPos)
endfunction
nnoremap <silent> <leader>l :call PdfLatex()<cr>

"Invoke FZF for current directory
nnoremap <silent> <leader>f :GFiles<cr>

"Toggle soft line wrap using F9
nnoremap <leader>[ :set wrap!<cr>

"Invoke FZF respecting .gitignore
nnoremap <silent> <leader>gf :Files<cr>

"Invoke FZF buffer search
nnoremap <silent> <leader>b :Buffers<cr>

"Invoke FZF tag search
nnoremap <silent> <leader>c :Tags<cr>

"Invoke FZF for home directory
nnoremap <silent> <leader>F :Files ~<cr>

"Set fzf window to center
" if v:version > 819
if has("patch-8.2.191")
    let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
endif
let $FZF_DEFAULT_OPTS='--reverse --color="bg+:#2d323b,hl:#3786d1,hl+:#3786d1"'

"Order lines by length
vmap <leader>su !awk '{ print length(), $0 \| "sort -n \| cut -d\\  -f2-" }'<CR>


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
nmap <leader>s :tag<space>


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
    " set term=pcansi
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
"hi TabLineFill ctermfg=red ctermbg=0         "Set main tab bg (right).
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

"--------Args List--------"
nnoremap <silent> [a :previous<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> ]A :last<CR>

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
nnoremap <leader>html :-1read $HOME/.vim/.skeleton.html<CR>4jf>a
nnoremap <leader>pgn :-1read $HOME/.vim/templates/pgn<CR>:3<CR>ci"<C-r>=strftime('%F')<CR><ESC>:12<CR>ci"<C-r>=strftime('%H:%M')<CR><ESC>
"inoremap <SPACE><SPACE> <ESC>/<++><Enter>"_c4l
nnoremap <leader>ev :tabe $MYVIMRC<CR>
inoremap <leader>iww Ifor Waldo Williams
" inoremap <leader>em ifor@cors.tech
" inoremap <leader>nn iforwms


"--------AutoCommands--------"
autocmd bufwritepre * :%s/\s\+$//e                  "Delete trailing whitespace on save.
augroup autosourcing                                "Auto-source the vimrc file on save.
        autocmd!
        autocmd BufWritePost .vimrc source %
augroup END

"Clear terminal on exit.
au VimLeave * !clear

"Auto save folds
augroup AutoSaveFolds
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  if !&diff
      autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
      autocmd BufWinEnter ?* silent! loadview
  else
      "Merge from left pane (merge conflict)
      nmap dg :diffget //3<CR>

      "Merge from right pane (merge conflict)
      nmap dh :diffget //2<CR>
  endif
augroup END

"--------Function for PHP namespace import -------"
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <leader>n <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <leader>n :call PhpInsertUse()<CR>

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
