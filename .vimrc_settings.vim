" basic settings
" ----------------------------------------------------------------------------
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
set showmatch			"when you type a closing bracket, quickly jump to the corr. opening bracket
set backupcopy=yes 		"so webpack actually sees a file-write event
set undofile			"keep undo information even when you have closed a file in between
set splitright			"make vertical splits to the right as a standard
set hidden				"allow switching of buffers even if one is not saved yet

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

" adjust color settings for dark terminal
" ----------------------------------------------------------------------------
" set t_Co=256				"use 256 colors
" set background=dark			"set a dark background
colorscheme codedark
"coloring of the popup menu
" highlight Pmenu ctermbg=100 gui=bold
"change coloring of max column
" highlight ColorColumn ctermbg=darkgray
