set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set rtp+=~/.fzf

call plug#begin('~/.vim/bundle')

Plug 'junegunn/vim-plug'

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'joonty/vdebug', { 'for': 'php' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iCyMind/NeoSolarized'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-eunuch'
Plug 'mhinz/vim-startify'

" snippet stuff
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" language / syntax support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }
Plug 'chrisbra/csv.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'pangloss/vim-javascript'
Plug 'othree/yajs.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'evidens/vim-twig'
Plug 'othree/html5.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'groenewege/vim-less'
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'phpactor/phpactor' ,  {'do': 'composer install', 'for': 'php'}
Plug 'kristijanhusak/deoplete-phpactor'

Plug 'kassio/neoterm'
Plug 'Raimondi/delimitMate'

call plug#end()

let g:deoplete#enable_at_startup = 1

colorscheme NeoSolarized
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
set ttyfast                     " Indicate fast terminal conn for faster redraw
set noswapfile

" neovim natively support system clipboard
set clipboard+=unnamedplus

"line numbers

nnoremap <F11> :set relativenumber!<cr>

"this works. we must have support and not beeing in a screen!
if !has('nvim')
	if has("mouse_urxvt") && !exists('$STY')
		set ttymouse=urxvt
	else
		set ttymouse=xterm2
	end
endif
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

if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

source $HOME/.vimrc-custom
