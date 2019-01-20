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
