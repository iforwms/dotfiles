"--------Statusline--------"
set showcmd                                         "Show (partial) command in status line.
hi StatusLineNC ctermbg=237
hi vertsplit ctermfg=fg ctermbg=bg

function! ActiveStatus()
    let statusline=""

    "Show input mode
    let statusline.="%#Function#\ %{toupper(g:currentmode[mode()][0])} "

    "Show current GIT branch.
    let statusline.="%0*\%{StatuslineGit()}\ "

    "Show filename.
    let statusline.="%#String#\ %-.30f%{getbufvar(bufnr('%'),'&mod')?'*':''}\ "

    "help file flag
    let statusline.="%h"

    "read-only flag
    let statusline.="%r"

    "Add divider.
    let statusline.="%0*%="

    "Show current line ancd column"
    let statusline.="%0*\ %l/%L:%v\ "

    "Show current buffer number
    let statusline.="%#Function#\ %{BufferNumber()}\ "

    "Show filesize and current line/col
    "let statusline.="%0*\ "
    "let statusline.="%{FileSize()}"
    "let statusline.="\ "
    "let statusline.="%l:%v "
    "let statusline.="[%b][0x%B]"

    "Show file type, encoding and format.
    "let statusline.="%0* %y\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ "

    "Show current time.
    "let statusline.="%0*\| %{strftime('%a %d %h %R')}\ "

    return statusline
endfunction

function! InactiveStatus()
    let statusline=""

    "Show current GIT branch.
    let statusline.="%0*\%{StatuslineGit()}\ "

    "Show filename.
    let statusline.="%-.30f%{getbufvar(bufnr('%'),'&mod')?'*':''} "

    "help file flag
    let statusline.="%h"

    "read-only flag
    let statusline.="%r"

    "Add divider.
    let statusline.="%0*%="

    "Show current line and column"
    let statusline.="%l/%L:%v "

    "Show current buffer number
    let statusline.="%{BufferNumber()}\ "

    return statusline
endfunction

set laststatus=2                                    "Always show status line.
set statusline=%!ActiveStatus()                     "Set statusline to active statusline.

augroup status
  autocmd!
  autocmd WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END

"set noshowmode    "to get rid of thing like --INSERT--
"set noshowcmd     "to get rid of display of last command
set shortmess+=F  "to get rid of the file name displayed in the command line bar

" Define all the different modes
let g:currentmode={
    \ 'n'  : ['Normal', 1],
    \ 'no' : ['N·Operator Pending', 0],
    \ 'v'  : ['Visual', 0],
    \ 'V'  : ['V·Line', 0],
    \ '' : ['V·Block', 0],
    \ 's'  : ['Select', 0],
    \ 'S'  : ['S·Line', 0],
    \ '' : ['S·Block', 0],
    \ 'i'  : ['Insert', 0],
    \ 'R'  : ['Replace', 0],
    \ 'Rv' : ['V·Replace', 0],
    \ 'c'  : ['Command', 0],
    \ 'cv' : ['Vim Ex', 0],
    \ 'ce' : ['Ex', 0],
    \ 'r'  : ['Prompt', 0],
    \ 'rm' : ['More', 0],
    \ 'r?' : ['Confirm', 0],
    \ '!'  : ['Shell', 0],
    \}

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
    return 'help'!=&filetype?bufnr('%'):''
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
