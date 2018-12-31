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

" async :Make and :Dispatch for defined :compiler components
Plug 'tpope/vim-dispatch'
autocmd FileType python nnoremap <leader>pt :Dispatch py.test --tb=short -q<CR>

" adds a 'py.test' compiler component (i.e. to set :makeprg and :errorformat
" for pytest (e.g. to be used in :Dispatch))
Plug '5long/pytest-vim-compiler'

" visual indentations (to see that indentation levels are correct)
" toggle using <leader>ig
Plug 'nathanaelkane/vim-indent-guides'

" display currently open buffers in the VIM status line
Plug 'bling/vim-bufferline'

" status bar at the bottom of the vim screen, integrates e.g. with
" vim-bufferline
Plug 'vim-airline/vim-airline'

" adds the 's' action to add/change/delete surroundings of text objects
Plug 'tpope/vim-surround'

" linting/autocomplete
Plug 'w0rp/ale'

" Add plugins to &runtimepath
call plug#end()

let g:ale_linters = {
\   'python': ['pyls', 'pyflake8'],
\}
let g:ale_completion_enabled = 1

" Settings for the python-mode linter
"let g:pymode_lint_checkers = ['mccabe', 'pyflakes', 'pylint', 'pep8', 'pep257']
"let g:pymode_python = 'python3'
"let g:pymode_lint_ignore = 'E111,E114,W0311,C0111,D100,D213,D203'

" ----------------------------------------------------------------------------
" basic settings
" ----------------------------------------------------------------------------
let mapleader = ","		"set the leader key to be ,
filetype plugin indent on 	"filetype detection and standard settings per file
syntax on 				"syntax highlighting
set title				"terminal window name becomes name of vim file
set shiftwidth=4		"a shift is 4 spaces wide
set tabstop=4			"a tab is 4 spaces wide
set autoindent			"always autoindent (i.e. next line indent is equal to current line indent)
set nocompatible 		"don't pretend to be vi instead of vim
set tabpagemax=100		"max number of tag pages that can be opened (default is 10 only)
set number relativenumber 	"hybrid line numbers
set encoding=utf-8		"work with utf-8 characters
set wildmenu 			"display all matching files when we tab complete
set scrolloff=3			"always keep at least 3 lines below/above vursor visible when scrolling
set showmatch			"when you type a closing bracket, quickly jump to the corresponding opening bracket
"set cursorline			"put a linemarker at where the cursor is
set backupcopy=yes 		"so webpack actually sees a file-write event
set undofile			"keep undo information even when you have closed a file in between
set splitright			"make vertical splits to the right as a standard
set hidden				"allow switching of buffers even if one is not saved yet
"set list
"set listchars=tab:>.,trail:.,extends:#,nbsp:.
" ----------------------------------------------------------------------------
" search settings
" ----------------------------------------------------------------------------
"turn off vim regexping and instead use normal perl style regexing
nnoremap / /\v
vnoremap / /\v
"use <C-p> and <C-n> in command mode to search the command history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
"%% expands to the directory of the currently active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
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
" ----------------------------------------------------------------------------
" some leader commands
" ----------------------------------------------------------------------------
"edit .vimrc in a split
nnoremap <leader>ev <C-w>v<C-w>l:edit $HOME/.dotfiles/.vimrc<cr>
"source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
