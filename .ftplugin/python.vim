setlocal shiftwidth=4	" a shift is 4 spaces wide
setlocal tabstop=4		" a tab is 4 spaces wide
setlocal expandtab		" a tab is represented as the appropriate number of spaces (and not as \t)
setlocal softtabstop=4
setlocal smarttab
setlocal colorcolumn=80 " insert a column at 80 spaces

" leader command for vim-dispatch plugin to run pytest
autocmd FileType python nnoremap <leader>pt :Dispatch py.test --tb=short -q<CR>

" define the ale linters/fixers/options for python
let b:ale_linters = {
\   'python': ['pyls'],
\}
let b:ale_fixers = {
\   'python': ['black'],
\}
let g:ale_python_black_options = '--line-length 79'
" enable autocomplete via pyls
let b:ale_completion_enabled = 1
" always keep the sign gutter open on the left
let b:ale_sign_column_always = 1
