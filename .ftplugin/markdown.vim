nnoremap <silent> <leader>p :call MarkdownClipboardImage()<cr>

function! MarkdownClipboardImage() abort
  " find all potential image mime-types of current clipboard content
  let targets = filter(
        \ systemlist('wl-paste -l'),
        \ 'v:val =~# ''image''')
  if empty(targets) | return | endif

  " create `img` directory if it doesn't exist
  " let img_dir = getcwd() . '/img'
  let img_dir = $HOME . '/notes/img'
  if !isdirectory(img_dir)
    silent call mkdir(img_dir)
  endif

  " build filename from current timestamp
  let mimetype = targets[0]
  let extension = trim(split(mimetype, '/')[-1])
  let filename = trim(system('date -Iseconds'))
  let file_path = img_dir . '/paste_image_' . filename . '.' . extension

  " paste into file
  let paste_into_file_command = 'wl-paste > ' . file_path
  silent call system(paste_into_file_command)

  " if error, do a normal paste
  if v:shell_error == 1
    normal! p
  " otherwise add a markdown image reference
  else
    execute 'normal! i[](' . file_path . ')'
  endif
endfunction
