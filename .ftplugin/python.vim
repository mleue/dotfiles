setlocal shiftwidth=4	" a shift is 4 spaces wide
setlocal tabstop=4		" a tab is 4 spaces wide
setlocal expandtab		" a tab is represented as the appropriate number of spaces (and not as \t)
setlocal softtabstop=4
setlocal smarttab
setlocal colorcolumn=80 " insert a column at 80 spaces

" folding
setlocal foldmethod=indent
setlocal foldnestmax=2

" leader command for vim-dispatch plugin to run pytest
autocmd FileType python nnoremap <leader>pt :Dispatch py.test --tb=short -q<CR>

" define the ale linters/fixers/options for python
let b:ale_linters = {
\   'python': ['pyls'],
\}
let b:ale_fixers = {
\   'python': ['black'],
\}
" black autoformatter line-width limit set to 79
let g:ale_python_black_options = '--line-length 79'
" fix overeager autocomplete bug, see https://github.com/w0rp/ale/issues/1700
setlocal completeopt+=noinsert
" leader commands for ALE
nnoremap <leader>af :ALEFix<cr>
nnoremap <leader>ag :ALEGoToDefinition<cr>
