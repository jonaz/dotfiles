syntax on
set hlsearch
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set foldmethod=marker
set background=dark
set nowrap
set expandtab
set textwidth=0
map <F2> :w!<CR>
map <F9> :! gcc -Wall -o %< %<CR>
map <F10> :! ./%<<CR>

au BufEnter,BufRead     *.inc   setf php
au BufEnter,BufRead     *.tpl   setf php
au BufNewFile,BufRead   *.tpl setf php
au BufNewFile,BufRead   *.inc setf php
au BufRead,BufNewFile *.go set filetype=go
set mouse=a
set number
set autoindent
set ttymouse=xterm2
filetype on
" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang,php,js set cindent

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType js set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType htm set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
let php_sql_query=1
let php_htmlInStrings=1
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif 

if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
    \ if &omnifunc == "" |
    \   setlocal omnifunc=syntaxcomplete#Complete |
    \ endif
endif

let g:syntastic_phpcs_conf=" --standard=Drupal --extensions=php,module,inc,install,test,profile,theme"

if has('statusline')
  set laststatus=2
" Broken down into easily includeable segments
  set statusline=%<%f\ " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y] " filetype
  set statusline+=\ [%{getcwd()}] " current dir
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_enable_signs=1
  set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif

let g:stop_autocomplete=0
function! CleverTab(type)
    if a:type=='omni' && !pumvisible()
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
            let g:stop_autocomplete=1
            return "\<TAB>"
        elseif !&omnifunc && &omnifunc != ''
            return "\<C-X>\<C-O>\<C-P>"
        endif
    elseif a:type=='keyword' && !pumvisible() && !g:stop_autocomplete
        return "\<C-X>\<C-N>\<C-P>"
    elseif a:type=='next'
        if pumvisible()
            let g:stop_autocomplete=0
            return "\<C-N>"
        elseif g:stop_autocomplete
            let g:stop_autocomplete=0
        else
            return "\<C-N>"
        endif
    elseif a:type=='back'
        if pumvisible() 
            return "\<C-P>"
        endif
    endif
    return ''
endfunction
inoremap <silent><TAB> <C-R>=CleverTab('omni')<CR><C-R>=CleverTab('keyword')<CR><C-R>=CleverTab('next')<CR>
inoremap <silent><S-TAB> <C-R>=CleverTab('back')<CR>

set list
set listchars=tab:>-,trail:-
set showmode                    " always show command or insert mode
set ruler
set showmatch
set whichwrap=b,s,<,>,[,]

" More common in PEAR coding standard
inoremap  { {<CR>}<C-O>O
" Maybe this way in other coding standards
" inoremap  { <CR>{<CR>}<C-O>O

" Standard mapping after PEAR coding standard
" Maybe this way in other coding standards
" inoremap ( ( )<LEFT><LEFT>

"; i command mode ger ; i slutet på raden
noremap ; :s/\([^;]\)$/\1;/<cr>
noremap <tab> :%s/\t/    /g<cr>
