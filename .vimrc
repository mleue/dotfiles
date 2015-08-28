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

"Einrückung für Typescript
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 nu

"Einrückung und Zeilennummern für javascript
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 nu

"Markdown Unterstützung
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"Vollsuche in allen Dateien im Ordner nach Wort unter Cursor bei Klick °
nmap ° :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Ag

"Ein paar Ideen für Klammervervollständigung
":inoremap ( ()<Esc>i
autocmd FileType typescript inoremap {. {<CR>}<Esc>O

"autoreload (works in tmux and because of focus-events plugin)
set autoread

"timestamp command
command Timestamp :r! date "+\%Y-\%m-\%d \%H:\%M:\%S"
