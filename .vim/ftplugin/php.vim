"--------PHP shortcuts--------"

"Add keymaps for running phpunit tests
nnoremap <Leader>tt ?function \w\+<CR>wyiw:!phpunit --filter <C-r>"<CR>
"nnoremap <Leader>t yiw:!phpunit --filter <C-r>"<CR>
nnoremap <Leader>tf :!phpunit %<CR>

"Add keymap for sorting imports by line length
nnoremap <Leader>q :g/^use/,/^$/- !awk '{ print length, $0 \| "sort -n \| cut -d \" \" -f2-" }'<CR>:nohlsearch<CR>
