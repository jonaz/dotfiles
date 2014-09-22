set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/vundle'

"plugins
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'othree/html5.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tobyS/pdv'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'SirVer/ultisnips'
Plugin 'joonty/vdebug'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'fatih/vim-go'
Plugin 'groenewege/vim-less'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'jonaz/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'evidens/vim-twig'
Plugin 'tobyS/vmustache'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on

syntax enable
set background=dark

set hlsearch
set expandtab
set foldmethod=marker
set nowrap
set textwidth=0
"map <F2> :w!<CR>
"map <F9> :! gcc -Wall -o %< %<CR>
map <F10> :! ./%<<CR>

au BufEnter,BufRead     *.inc   setf php
au BufEnter,BufRead     *.tpl   setf php
au BufNewFile,BufRead   *.tpl setf php
au BufNewFile,BufRead   *.inc setf php
au BufRead,BufNewFile *.pp set filetype=puppet
au BufRead,BufNewFile *.thtml set filetype=html.twig
au BufEnter *.css set nocindent
au BufLeave *.css set cindent
au  BufNewFile,BufRead *.hbt set filetype=html syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim
set mouse=a
set number
set autoindent
"set ttymouse=xterm2 this caused problems with wide terminals
"this works:
if has("mouse_urxvt")
    set ttymouse=urxvt
else
    set ttymouse=xterm2
end
set pastetoggle=<F12>


" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang,php,js set cindent
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType htm set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
let php_sql_query=1
let php_htmlInStrings=1
let mapleader = ","
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
  \   call SuperTabChain(&omnifunc, "<c-n>") |
  \ endif

let g:syntastic_phpcs_conf=" --standard=Drupal --extensions=php,module,inc,install,test,profile,theme"


if has('statusline')
  set laststatus=2
endif

set list
set listchars=tab:>-,trail:-
set showmode                    " always show command or insert mode
set ruler
set showmatch
set completeopt+=menuone
set whichwrap=b,s,<,>,[,]

"; i command mode ger ; i slutet på raden
noremap ; :s/\([^;]\)$/\1;/<cr>:set nohlsearch<cr>

function! OpenPhpFunction (keyword)
  let proc_keyword = substitute(a:keyword , '_', '-', 'g')
  exe '10 split'
  exe 'enew'
  exe 'set buftype=nofile'
  exe 'silent r!links -dump http://www.php.net/manual/en/print/function.'.proc_keyword.'.php'
  exe 'norm gg'
  exe 'call search ("Description")'
  exe 'norm jdgg'
  exe 'call search("User Contributed Notes")'
  exe 'norm dGgg'
  exe 'norm V'
endfunction
au FileType php noremap K :call OpenPhpFunction(expand('<cword>'))<CR>

"fix autocomplete menu
highlight PMenu ctermbg=0 ctermfg=white cterm=None
highlight PMenuSel ctermbg=5 ctermfg=white cterm=Bold

"insert word under cursor in ctrlp
nmap <leader>lw :CtrlP<CR><C-\>w

source $HOME/.vimrc-custom
