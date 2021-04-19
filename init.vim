set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

:tnoremap <C-w> <C-\><C-n><C-w>
:nnoremap T :split \| terminal<CR>i
