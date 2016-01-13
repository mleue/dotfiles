" ----------------------------------------------------------------------------
" start vundle plugin manager
" ----------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ----------------------------------------------------------------------------
" basic settings
" ----------------------------------------------------------------------------
syntax on			"syntax highlighting

" ----------------------------------------------------------------------------
" adjust color settings for dark terminal
" ----------------------------------------------------------------------------
set t_Co=256
set background=dark
highlight Pmenu ctermbg=100 gui=bold

" ----------------------------------------------------------------------------
" specific options for certain file types
" (typescript,javascript,mfiles,cpp,markdown)
" ----------------------------------------------------------------------------
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nu colorcolumn=80  
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"change coloring of max column for cpp files
highlight ColorColumn ctermbg=darkgray

"markdown support
autocmd BufNewFile,BufReadPost *.md set filetype=markdown 

" ----------------------------------------------------------------------------
" add paths to vim standard path (mainly for gf command)
" ----------------------------------------------------------------------------
let &path.="/src/include,/src/,"

" ----------------------------------------------------------------------------
" some scripts
" ----------------------------------------------------------------------------

"C-style scope brackets by typing {. in cpp files
autocmd FileType cpp inoremap {. <CR>{<CR>}<Esc>O

"Java-style scope brackets by typing {. in typescript files
autocmd FileType typescript inoremap {. {<CR>}<Esc>O

"timestamp command
command Timestamp :r! date "+\%Y-\%m-\%d \%H:\%M:\%S"
