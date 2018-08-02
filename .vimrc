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
let mapleader = ","		"set the leader key to be ,
filetype plugin indent on 	"filetype detection and standard settings per file
set nocompatible 		"don't pretend to be vi instead of vim
syntax on 			"syntax highlighting
set tabpagemax=100		"max number of tag pages that can be opened (default is 10 only)
set number relativenumber 	"hybrid line numbers
set encoding=utf-8		"work with utf-8 characters
set wildmenu 			"display all matching files when we tab complete
set scrolloff=3			"always keep at least 3 lines below/above vursor visible when scrolling
set showmatch			"when you type a closing bracket, quickly jump to the corresponding opening bracket
"set cursorline			"put a linemarker at where the cursor is
set backupcopy=yes 		"so webpack actually sees a file-write event
set undofile			"keep undo information even when you have closed a file in between
" ----------------------------------------------------------------------------
" search settings
" ----------------------------------------------------------------------------
"turn off vim regexping and instead use normal perl style regexing
nnoremap / /\v
vnoremap / /\v
set ignorecase			"ignore case in search
set smartcase			"this overrides ignorecase in case you use upper case letters in a search
set hlsearch incsearch 		"highlight all search matches incrementally
"leader+space to abort a search once you found what you were looking for
nnoremap <leader><space> :noh<CR>
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
autocmd FileType python nnoremap <leader>pyclass :r $HOME/.snippets/.python/.pyclass.py<CR>


" ----------------------------------------------------------------------------
" disable arrow keys to learn hjkl
" ----------------------------------------------------------------------------
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
"make j,k work correctly for wrapped lines in small terminal
nnoremap j gj
nnoremap k gk

" ----------------------------------------------------------------------------
" some leader commands
" ----------------------------------------------------------------------------
"edit .vimrc in a split
nnoremap <leader>ev <C-w>v<C-w>l:edit $HOME/.dotfiles/.vimrc<cr>
"source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
