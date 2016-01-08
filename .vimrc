autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"Pluginmanager für Python starten
execute pathogen#infect()

"Syntaxhighlighting an
syntax on

"Einrückung
filetype plugin indent on

"Syntax Farben anpassen an dunklen Terminalhintergrund
set t_Co=256
set background=dark
highlight Pmenu ctermbg=100 gui=bold

"Einrückung für Typescript, Javascript, mfiles, c++
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 nu
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2 nu

"Markdown Unterstützung
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"Ein paar Ideen für Klammervervollständigung
":inoremap ( ()<Esc>i
autocmd FileType typescript inoremap {. {<CR>}<Esc>O

"timestamp command
command Timestamp :r! date "+\%Y-\%m-\%d \%H:\%M:\%S"
