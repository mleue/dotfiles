let mapleader = ","		"set the leader key to be ,
"leader+space to abort a search once you found what you were looking for
nnoremap <leader><space> :noh<CR>
" open ctrl-p buffer fuzzy finder
nnoremap <leader>b :CtrlPBuffer<cr>
" open ctrl-p file fuzzy finder
nnoremap <leader>f :CtrlP<cr>
"edit .vimrc in a split
nnoremap <leader>ev <C-w>v<C-w>l:edit $HOME/.dotfiles/.vimrc<cr>
"source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
