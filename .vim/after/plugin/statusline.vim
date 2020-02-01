
"--------Statusline--------"
function! ActiveStatus()
    "1: grey, 2: red, 3: blue, 4: green

    let statusline=""

    "Show input mode
    let statusline.=" %{toupper(g:currentmode[mode()])} "

    "Show current GIT branch.
    let statusline.="%0*\ %{StatuslineGit()}\ "

    "Show filename.
    let statusline.="%0*\%-.30f\  "

    "Add divider.
    let statusline.="%0*%="

    "Show current buffer number
    let statusline.="%0*\ %{BufferNumber()}\ "

    "Show filesize and current line/col
    let statusline.="%0*\ %{FileSize()}\ [%l:%v] [%b][0x%B] |"

    "Show file type, encoding and format.
    let statusline.="%0* %y\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ "

    "help file flag
    let statusline.="%0*\ %h \ "

    "modified flag
    let statusline.="%0*\ [%{getbufvar(bufnr('%'),'&mod')?'modified':'saved'}] \ "

    "read-only flag
    let statusline.="%0*\ %r \ "

    "Show current time.
    "let statusline.="%0*\| %{strftime('%a %d %h %R')}\ "

    return statusline
endfunction

function! InactiveStatus()
    let statusline=""
    let statusline.="%0*\ %{BufferNumber()}\ "      "Show current buffer number.
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

set noshowmode    "to get rid of thing like --INSERT--
set noshowcmd     "to get rid of display of last command
set shortmess+=F  "to get rid of the file name displayed in the command line bar

" Define all the different modes
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \}

function! ShowCurrentMode(mode)
    return a:mode
endfunction

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
