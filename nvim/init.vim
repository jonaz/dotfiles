if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" let g:ale_disable_lsp = 1 "must be before plugin are loaded

call plug#begin('~/.vim/bundle')

Plug 'ggandor/leap.nvim'
Plug 'tpope/vim-fugitive'
Plug 'terrortylor/nvim-comment'
" Plug 'w0rp/ale'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-lua/plenary.nvim' " dep for null-ls
Plug 'nvim-lualine/lualine.nvim'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-eunuch'
Plug 'mhinz/vim-startify'
Plug 'kassio/neoterm'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" snippet stuff
Plug 'honza/vim-snippets'
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'

" language / syntax support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/nvim-treesitter-textobjects' " TODO configure this
" Plug 'nvim-treesitter/playground'
Plug 'joonty/vdebug', { 'for': 'php' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" Plug 'pangloss/vim-javascript'
" Plug 'othree/yajs.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'evidens/vim-twig'
Plug 'othree/html5.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'groenewege/vim-less'
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'maxmellon/vim-jsx-pretty'
Plug 'pearofducks/ansible-vim'

" completion
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' } "lsp loading info
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'windwp/nvim-autopairs'
Plug 'kylechui/nvim-surround'
" Plug 'mg979/vim-visual-multi'
" Plug 'machakann/vim-swap' " use treesitter-textobjects instead

call plug#end()
let mapleader = ','

lua require('config')

"colors
set termguicolors
colorscheme solarized

syntax enable
set background=dark
set shiftwidth=4
set softtabstop=4
set tabstop=4
set foldmethod=marker
set nowrap
"set list
"set listchars=tab:>-,trail:-
set showmatch
set completeopt=menu,menuone,noselect
set whichwrap=b,s,<,>,[,]
set mouse=a
set number
set scrolloff=5
set noswapfile
set tagfunc=v:lua.vim.lsp.tagfunc

" neovim natively support system clipboard
set clipboard+=unnamedplus

"line numbers

nnoremap <F11> :set relativenumber!<cr>
set pastetoggle=<F12>

" for C-like programming, have automatic indentation:
augroup webcode
	autocmd BufEnter,BufRead     *.inc   setf php
	autocmd BufEnter,BufRead     *.tpl   setf php
	autocmd BufNewFile,BufRead   *.tpl setf php
	autocmd BufNewFile,BufRead   *.inc setf php
	autocmd BufRead,BufNewFile *.pp set filetype=puppet
	autocmd BufRead,BufNewFile *.thtml set filetype=html.twig
	autocmd BufNewFile,BufRead *.hbt set filetype=html syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim
augroup END

augroup AU_NAME
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup end


let php_sql_query=1
let php_htmlInStrings=1

" undo stuff
if !isdirectory($HOME.'/.vim/undo-dir')
    call mkdir($HOME.'/.vim/undo-dir', '', 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" FZF stuff

" insert word under cursor in ctrlp;
nmap <leader>lw <cmd>lua require('fzf-lua').files({ fzf_opts = { ['--query'] = vim.fn.expand("<cword>") } } )<CR>


" Open files in fzf
nnoremap <silent> <C-p> <cmd>lua require('fzf-lua').files()<CR>

" search current buffer in fzf
nnoremap <silent> <C-l> <cmd>lua require('fzf-lua').blines()<CR>

" git status modified files
nnoremap <silent> <C-u> <cmd>lua require('fzf-lua').git_status()<CR>

" Open MRU in fzf
nnoremap <silent> <C-o> <cmd>lua require('fzf-lua').oldfiles()<CR>

"copy file path
nnoremap <silent> <Leader>cp :let @+=expand("%:p")<CR>

" normal keyword completion with ,,
inoremap <leader>, <C-x><C-n>

" map ctrl+s to save and run sync_server
noremap <C-S> :call TermCloseIfOK("sync_server")<CR>

"; in command mode  ; at EOL
" noremap ; :s/\([^;]\)$/\1;/<cr>:set nohlsearch<cr>


"session
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3


"git
map <Leader>gs :Git<CR>
map <Leader>gb :Git blame<CR>
map <Leader>gd :Gdiffsplit<CR>

" ctrl+a to quit current buffer
nnoremap <silent> <C-a> :bd<CR>

"pretty json
:command JsonPretty :set ft=json | :%!python -m json.tool --tab
" pretty xml
command XmlPretty :set ft=xml | :%!xmllint --format -

command DiffBuffers :windo diffthis

nnoremap <Leader>re :%s/\<<C-r><C-w>\>//g<Left><Left>


let g:vdebug_features = {
\    'max_data': 1000000,
\    'max_children': 256,
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


" " ale stuff
" let g:ale_completion_enabled = 0
" let g:ale_completion_autoimport = 0
" " Error and warning signs.
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
"
" " use tsserver which then calls tslint for now
" let g:ale_linters_ignore = {'typescript': ['tslint'], 'typescriptreact': ['tslint'], 'ansible': ['ansible_lint'], 'php': ['phpstan', 'phpmd']}
" let g:ale_linters = {
" 			\'go': ['go build', 'golangci-lint'],
" 			\}
" let g:ale_go_golangci_lint_options = '--enable-all --disable wsl --disable lll --disable goimports --disable gochecknoinits --disable gochecknoglobals --disable gomnd --disable gofmt --disable unused --disable nlreturn --disable exhaustivestruct --disable gofumpt --disable varnamelen --disable gci'
" let g:ale_go_golangci_lint_package = 1
" let g:ale_php_phpmd_ruleset = '~/.phpmd-ruleset.xml'

" används av vim.lsp.buf.signature_help istället
"nmap <silent> <C-k> <cmd>lua vim.diagnostic.goto_prev()<CR>
nmap <silent> <C-j> <cmd>lua vim.diagnostic.goto_next()<CR>

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

map <Leader>gc <cmd>lua require('fzf-lua').git_branches()<CR>

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

" vim-visual-multi
" messes wih shift-left/right without this
let g:VM_default_mappings = 0


" fix strange error sign with nvim-solarized-lua theme and ALE. This will only
" show red cross and not red background on it.
" hi Error cterm=bold,reverse ctermfg=23 ctermbg=203 gui=bold,reverse guifg=#002b36 guibg=#dc322f
