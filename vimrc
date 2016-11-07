set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
set rtp+=~/.fzf
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/vundle'

"plugins
"Plugin 'kien/ctrlp.vim' "replaced by fzf
Plugin 'tpope/vim-fugitive'
Plugin 'othree/html5.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tobyS/pdv'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'SirVer/ultisnips'
Plugin 'joonty/vdebug'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'fatih/vim-go'
Plugin 'groenewege/vim-less'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'jonaz/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'evidens/vim-twig'
Plugin 'tobyS/vmustache'
Plugin 'terryma/vim-expand-region'
"Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'chrisbra/csv.vim'
Plugin 'Raimondi/delimitMate'
"Plugin 'avakhov/vim-yaml'
Plugin 'shime/vim-livedown'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'nathanielc/vim-tickscript'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on

colorscheme solarized
let g:airline_theme="solarized"

syntax enable
set background=dark
set shiftwidth=4
set softtabstop=4
set tabstop=4
set hlsearch
set foldmethod=marker
set nowrap
set textwidth=0
set nolist
set noexpandtab
"set list
"set listchars=tab:>-,trail:-
set showmode " always show command or insert mode
set ruler
set showmatch
set completeopt=menuone "always show matches and dont show preview!
set whichwrap=b,s,<,>,[,]
set mouse=a
set number
set autoindent
set scrolloff=5

"this works. we must have support and not beeing in a screen!
if has("mouse_urxvt") && !exists('$STY')
    set ttymouse=urxvt
else
    set ttymouse=xterm2
end
set pastetoggle=<F12>
if has('statusline')
  set laststatus=2
endif

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang,php,js set cindent
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType htm set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php noremap K :call OpenPhpFunction(expand('<cword>'))<CR>
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
autocmd BufEnter,BufRead     *.inc   setf php
autocmd BufEnter,BufRead     *.tpl   setf php
autocmd BufNewFile,BufRead   *.tpl setf php
autocmd BufNewFile,BufRead   *.inc setf php
autocmd BufRead,BufNewFile *.pp set filetype=puppet
autocmd BufRead,BufNewFile *.thtml set filetype=html.twig
autocmd BufEnter *.css set nocindent
autocmd BufLeave *.css set cindent
autocmd BufNewFile,BufRead *.hbt set filetype=html syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim

"autocmd FileType *
  "\ if &omnifunc != '' |
  "\   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
  "\   call SuperTabChain(&omnifunc, "<c-n>") |
  "\ endif

let g:syntastic_phpcs_conf=" --standard=Drupal --extensions=php,module,inc,install,test,profile,theme"
let php_sql_query=1
let php_htmlInStrings=1
let mapleader = ","
"set errorformat=%m\ in\ %f\ on\ line\ %l

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

"fix autocomplete menu
"highlight PMenu ctermbg=0 ctermfg=white cterm=None
"highlight PMenuSel ctermbg=5 ctermfg=white cterm=Bold


source $HOME/.vimrc-custom
