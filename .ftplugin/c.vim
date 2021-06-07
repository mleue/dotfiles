setlocal shiftwidth=2	" a shift is 2 spaces wide
setlocal tabstop=2		" a tab is 4 spaces wide
setlocal expandtab		" a tab is represented as the appropriate number of spaces (and not as \t)
setlocal softtabstop=2
setlocal smarttab
setlocal colorcolumn=80 " insert a column at 80 spaces


let b:ale_linters = {
\   'c': ['ccls'],
\}
let b:ale_fixers = {
\   'c': ['clang-format'],
\}
" leader commands for ALE
nnoremap <leader>af :ALEFix<cr>
nnoremap <leader>ad :ALEGoToDefinition<cr>
nnoremap <leader>asd :ALEGoToDefinitionInSplit<cr>
nnoremap <leader>ar :ALEFindReferences<cr>
nnoremap <leader>ah :ALEHover<cr>
" manual autocomplete command
imap <C-Space> <Plug>(ale_complete)
" inoremap <C-Space> <C-\><C-O>:ALEComplete<CR>
imap <C-@> <C-Space>

" trigger via <C-X><C-O>
setlocal omnifunc=ale#completion#OmniFunc
