set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set ignorecase
set softtabstop=2

if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
  augroup END
endif
syntax on
set pastetoggle=<F12>

iabbr Hook <C-R>=HookFunc()<CR>

" HookFunc(): Drupal helper function
function! HookFunc()
  let f = substitute(expand("%:t"), ".module", "", "g")
  return "function " . f . "_"
endfunction
