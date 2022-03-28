if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set runtimepath+=~/.fzf

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
Plug 'kassio/neoterm'
Plug 'junegunn/fzf.vim'

" snippet stuff
Plug 'honza/vim-snippets'
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'

" language / syntax support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }
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
Plug 'pearofducks/ansible-vim'

" completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'Raimondi/delimitMate'
Plug 'mg979/vim-visual-multi'

call plug#end()

lua require('config')

"let g:deoplete#enable_at_startup = 1

set termguicolors
colorscheme NeoSolarized
let g:airline_theme='solarized'


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
set completeopt=menu,menuone,noselect
set whichwrap=b,s,<,>,[,]
set mouse=a
set number
set autoindent
set scrolloff=5
set ttyfast                     " Indicate fast terminal conn for faster redraw
set noswapfile
set tagfunc=v:lua.vim.lsp.tagfunc

" neovim natively support system clipboard
set clipboard+=unnamedplus

"line numbers

nnoremap <F11> :set relativenumber!<cr>

"this works. we must have support and not beeing in a screen!
if !has('nvim')
	if has('mouse_urxvt') && !exists('$STY')
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
augroup webcode
	"autocmd FileType c,cpp,slang,php,js set cindent
	autocmd FileType php noremap K :call OpenPhpFunction(expand('<cword>'))<CR>
	autocmd BufEnter,BufRead     *.inc   setf php
	autocmd BufEnter,BufRead     *.tpl   setf php
	autocmd BufNewFile,BufRead   *.tpl setf php
	autocmd BufNewFile,BufRead   *.inc setf php
	autocmd BufRead,BufNewFile *.pp set filetype=puppet
	autocmd BufRead,BufNewFile *.thtml set filetype=html.twig
	"autocmd BufEnter *.css set nocindent
	"autocmd BufLeave *.css set cindent
	autocmd BufNewFile,BufRead *.hbt set filetype=html syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim
augroup END

augroup AU_NAME
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup end


let php_sql_query=1
let php_htmlInStrings=1
let mapleader = ','
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

if !isdirectory($HOME.'/.vim/undo-dir')
    call mkdir($HOME.'/.vim/undo-dir', '', 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" FZF stuff

" insert word under cursor in ctrlp;
fu CtrlPUnderCursor()
	let l:Command = expand('<cword>')
	call fzf#run({'sink': 'e','options': '-q '.l:Command })
endfu 
nmap <leader>lw :call CtrlPUnderCursor()<CR>

let g:fzf_preview_window = ['down:50%', 'ctrl-/']

" Open files in fzf
nnoremap <silent> <C-p> :call fzf#run({'sink': 'e', 'options':'--prompt "files> " ','down': '50%' })<CR>

" search current buffer in fzf
nnoremap <silent> <C-l> :BLines<CR>

" Open git status files in fzf
function! s:gitstatusopen(line)
	execute 'edit' split(a:line, ' ')[1]
endfunction
nnoremap <silent> <C-u> :call fzf#run({
	\'sink': function('<sid>gitstatusopen'),
	\'source':'git -c color.status=always status --short',
	\'options':'--ansi',
	\ 'down': '50%'}
	\)<CR>

" Open MRU in fzf
nnoremap <silent> <C-o> :History<CR>

"copy file path
nnoremap <silent> <Leader>cp :let @+=expand("%:p")<CR>

" normal keyword completion with ,,
inoremap <leader>, <C-x><C-n>

" map ctrl+s to save and run sync_server
noremap <C-S> :call TermCloseIfOK("sync_server")<CR>

"; in command mode  ; at EOL
noremap ; :s/\([^;]\)$/\1;/<cr>:set nohlsearch<cr>


"session
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3


"git
map <Leader>gs :Git<CR>
map <Leader>gb :Git blame<CR>

" ctrl+a to quit current buffer
nnoremap <silent> <C-a> :bd<CR>

"pretty json
:command JsonPretty :set ft=json | :%!python -m json.tool
" pretty xml
command XmlPretty :set ft=xml | :%!xmllint --format -

nnoremap <Leader>re :%s/\<<C-r><C-w>\>//g<Left><Left>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:vdebug_features = {
\    'max_data': 100000,
\}

let g:vdebug_options = {
\       'path_maps': {
\			'/home/jonaz/git/fortnox': '/home/jonaz/git/fortnox',
\			'/storage/vol3/fortnox-jf': '/home/jonaz/git/fortnox'
\		},
\       'server': '0.0.0.0',
\       'ide_key' : 'jf',
\       'break_on_open' : 0,
\       'continuous_mode' : 1,
\}

" this algorithm works well for /** */ style comments in a tab-indented file
let g:airline#extensions#whitespace#mixed_indent_algo = 1

"vim-go stuff
let g:go_code_completion_enabled = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
" highlight variables and functions with same name
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_addtags_transform = 'camelcase'
let g:go_def_mapping_enabled = 0

" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>


map <Leader>gi :GoInstall<CR>
map <Leader>gl :GoLint<CR>
map <Leader>gr :GoRun<CR>


augroup go
  autocmd!

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>gt  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  autocmd FileType go nmap <Leader>i <Plug>(go-install)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END


" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction


" ale stuff
let g:ale_completion_enabled = 0
let g:ale_completion_autoimport = 0
" Error and warning signs.
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

" use tsserver which then calls tslint for now
let g:ale_linters_ignore = {'typescript': ['tslint'], 'typescriptreact': ['tslint']}
let g:ale_linters = {
			\'go': ['go build', 'golangci-lint'],
			\}
let g:ale_go_golangci_lint_options = '--enable-all --disable wsl --disable lll --disable goimports --disable gochecknoinits --disable gochecknoglobals --disable gomnd --disable gofmt --disable unused --disable nlreturn --disable exhaustivestruct --disable gofumpt --disable varnamelen --fix'
let g:ale_go_golangci_lint_package = 1
let g:ale_php_phpmd_ruleset = '~/.phpmd-ruleset.xml'
let g:airline#extensions#ale#enabled = 1

nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

"terminal stuff
nmap <Leader>t :Topen<CR>

fun! TermCloseIfOK(cmd)
	let l:origin = exists('*win_getid') ? win_getid() : 0
	:split
	:enew
	let opts = {'suffix': ' # vim-test', 'origin': l:origin}
	let opts.new_window_id = exists('*win_getid') ? win_getid() : 0
	function! opts.on_exit(job_id, exit_code, event) dict
		if a:exit_code == 0
			call win_gotoid(self.new_window_id)
			close
		endif
	endfunction
	function! opts.on_stdout(job_id, data, event) dict
		if self.origin != 0
			call win_gotoid(self.origin)
		endif
	endfunction

	call termopen(a:cmd, opts)
endfun


fun! s:change_branch(e)
	let res = system('git checkout ' . a:e)
	if v:shell_error != 0
		echo res
		return
	endif
	if @% !=? ''
		:e!
	endif
	:AirlineRefresh
	echom 'Changed branch to ' . a:e
endfun

command! Gbranch call fzf#run(
	\ {
	\ 'source': 'git branch -a --format "%(refname:short)" | sed "s#^origin/##" | sort | uniq',
	\ 'sink': function('<sid>change_branch'),
	\ 'options': '-m',
	\ 'down': '20%'
	\})

map <Leader>gc :Gbranch<CR>

" Startify stuff
let g:startify_files_number = 5
let g:startify_change_to_dir = 0
let g:startify_custom_header = [ ]
let g:startify_relative_path = 1
let g:startify_use_env = 1

function! s:list_commits()
	let git = 'git -C ' . getcwd()
	let commits = systemlist(git . ' log --oneline | head -n10')
	let git = 'G' . git[1:]
	return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

" Custom startup list, only show MRU from current directory/project
let g:startify_lists = [
\  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
\  { 'type': function('s:list_commits'), 'header': [ 'Recent Commits' ] },
\  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
\  { 'type': 'commands',  'header': [ 'Commands' ]       },
\ ]

let g:startify_commands = [
\   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
\   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
\ ]

augroup startify
	autocmd User Startified setlocal cursorline
augroup end


" delimitMate
let delimitMate_expand_cr = 1
let delimitMate_balance_matchpairs = 1

" vim-visual-multi
" messes wih shift-left/right without this
let g:VM_default_mappings = 0



" lsp go to def etc
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <space>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
