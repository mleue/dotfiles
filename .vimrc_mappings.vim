" disable arrow keys to force hjkl
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" make ctrl-c behave exactly like ESC
" (otherwise there are slight differences, e.g. https://vi.stackexchange.com/questions/25764/use-control-c-instead-of-escape-key)
inoremap <C-c> <ESC>

" clipboard settings (for wayland)
" ----------------------------------------------------------------------------
"  https://old.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/
"  https://github.com/thestinger/termite/issues/620
" TODO remove this once obsolete
"  xnoremap <c-c> y:!wl-copy <C-r>"<cr><cr>gv
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
