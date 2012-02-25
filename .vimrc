call pathogen#infect()

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

let g:syntastic_phpcs_conf=" --standard=Drupal --extensions=php,module,inc,install,test,profile,theme"

if has('statusline')
  set laststatus=2
  " Broken down into easily includeable segments
  set statusline=%<%f\    " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=%{fugitive#statusline()} "  Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " filetype
  set statusline+=\ [%{getcwd()}]          " current dir
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_enable_signs=1
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set dictionary-=~/.vim/php/functionlist.txt dictionary+=~/.vim/php/functionlist.txt
set complete-=k complete+=k

function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

imap § <Esc>
map § <Esc>

set background=dark
set mouse=a
