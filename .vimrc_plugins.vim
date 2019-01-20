" automatic install of Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" display currently open buffers in the VIM status line
Plug 'bling/vim-bufferline'

" status bar at the bottom of the vim screen, integrates e.g. with
" vim-bufferline
Plug 'vim-airline/vim-airline'

" adds the 's' action to add/change/delete surroundings of text objects
Plug 'tpope/vim-surround'

" language-server client for linting/autocomplete/go-to-definition/hover
Plug 'w0rp/ale'

" async :Make and :Dispatch for defined :compiler components
Plug 'tpope/vim-dispatch'

" adds a 'py.test' compiler component (i.e. to set :makeprg and :errorformat
" for pytest (e.g. to be used in :Dispatch))
Plug '5long/pytest-vim-compiler'

" Add plugins to &runtimepath
call plug#end()
