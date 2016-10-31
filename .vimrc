" ----------------------------------------------------------------------------
" start Plug plugin manager
" ----------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'scrooloose/syntastic'

" Add plugins to &runtimepath
call plug#end()

" ----------------------------------------------------------------------------
" basic settings
" ----------------------------------------------------------------------------
syntax on			"syntax highlighting
let g:ycm_show_diagnostics_ui = 0 "ycm highlighting?

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
autocmd FileType html setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType python setlocal shiftwidth=4 tabstop=4 nu expandtab softtabstop=4 smarttab
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab nu colorcolumn=80  

" allow JSX syntax checking in .js files
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
" use eslint for syntastic javascript syntax checking
let g:syntastic_javascript_checkers = ['eslint']

" automatic removal of trailing whitespaces when saving .py files
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

"C-style languages config file for YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"macro to insert header guards into .h files on the press of F12
nnoremap <F12> "%phr_I#ifndef __<Esc>gUwyypldwidefine <Esc>yypldwiendif //<Esc>O<Esc>

"macro to insert html skeleton into .html files on the press of F12
nnoremap <F12> i<!DOCTYPE html><Esc>o<html><Esc>o<head><Esc>o<meta charset="utf-8"><Esc>o<script src=""></script><Esc>o<link type="text/css" rel="stylesheet" href=""><Esc>o<title></title><Esc>o</head><Esc>o<body><Esc>o</body><Esc>o</html><Esc>

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
autocmd FileType cpp inoremap {. {<CR>}<Esc>O

"Java-style scope brackets by typing {. in typescript/typescript files
autocmd FileType typescript inoremap {. {<CR>}<Esc>O
autocmd FileType javascript inoremap {. {<CR>}<Esc>O
