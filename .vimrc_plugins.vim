" automatic install of Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" display currently open buffers in the VIM status line
" Plug 'bling/vim-bufferline'

" language-server client for linting/autocomplete/go-to-definition/hover
Plug 'w0rp/ale'

" fuzzy file/buffer/... finder
Plug 'ctrlpvim/ctrlp.vim'

" adds the 's' action to add/change/delete surroundings of text objects
Plug 'tpope/vim-surround'

" vim color scheme like visual studio code dark
Plug 'tomasiser/vim-code-dark'

" comment/uncomment in any language
Plug 'tpope/vim-commentary'

" Add plugins to &runtimepath
call plug#end()

" plugin settings
" ---------------
" show ale errors/warnings in vim-airline
let g:airline#extensions#ale#enabled = 1
" enable autocomplete
let g:ale_completion_enabled = 1
" always keep the sign gutter open on the left
let g:ale_sign_column_always = 1
