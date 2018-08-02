" ----------------------------------------------------------------------------
" start Plug plugin manager
" ----------------------------------------------------------------------------
" automatic install of Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
Plug 'python-mode/python-mode'

" Add plugins to &runtimepath
call plug#end()

" Settings for the python-mode linter
let g:pymode_lint_checkers = ['mccabe', 'pyflakes', 'pylint', 'pep8', 'pep257']
let g:pymode_python = 'python3'
let g:pymode_lint_ignore = 'E111,E114,W0311,C0111,D100,D213,D203'

" ----------------------------------------------------------------------------
" basic settings
" ----------------------------------------------------------------------------
filetype plugin indent on 	"filetype detection and standard settings per file
set nocompatible 		"don't pretend to be vi instead of vim
syntax on 			"syntax highlighting
set tabpagemax=100		"max number of tag pages that can be opened (default is 10 only)
set backupcopy=yes 		"so webpack actually sees a file-write event
set number relativenumber 	"hybrid line numbers
set encoding=utf-8		"work with utf-8 characters
set hlsearch incsearch 		"highlight all search matches incrementally
set wildmenu 			"display all matching files when we tab complete
" ----------------------------------------------------------------------------
" adjust color settings for dark terminal
" ----------------------------------------------------------------------------
set t_Co=256				"use 256 colors
set background=dark			"set a dark background
"coloring of the popup menu
highlight Pmenu ctermbg=100 gui=bold	
"change coloring of max column
highlight ColorColumn ctermbg=darkgray
" ----------------------------------------------------------------------------
" specific options for certain file types
" (typescript,javascript,mfiles,cpp)
" ----------------------------------------------------------------------------
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab smarttab nu
autocmd FileType html setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType vue setlocal shiftwidth=2 tabstop=2 expandtab smarttab nu
autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType python setlocal shiftwidth=2 tabstop=2 nu expandtab softtabstop=2 smarttab colorcolumn=80
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nu colorcolumn=80  


" ----------------------------------------------------------------------------
" snippets
" ----------------------------------------------------------------------------
" python snippets
autocmd FileType python nnoremap ,pyclass :r $HOME/.snippets/.python/.pyclass.py<CR>
