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
Plugin 'w0rp/ale'
"Plugin 'majutsushi/tagbar'
"Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'SirVer/ultisnips'
Plugin 'joonty/vdebug'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'fatih/vim-go'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'groenewege/vim-less'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'evidens/vim-twig'
Plugin 'tobyS/vmustache'
Plugin 'terryma/vim-expand-region'
Plugin 'google/vim-jsonnet'

if has('nvim')
	Plugin 'Shougo/deoplete.nvim'
	Plugin 'zchee/deoplete-go'
	Plugin 'padawan-php/deoplete-padawan'
	Plugin 'kassio/neoterm'
else
	Plugin 'Valloric/YouCompleteMe'
end
Plugin 'chrisbra/csv.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'shime/vim-livedown'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'nathanielc/vim-tickscript'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on

let g:deoplete#enable_at_startup = 1

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
