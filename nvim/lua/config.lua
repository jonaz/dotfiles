-- Setup nvim-cmp.
local cmp = require 'cmp'
local snippy = require("snippy")
local null_ls = require("null-ls")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("oil").setup()
require("dbee").setup()

local curl = require("curl")
curl.setup({})

vim.keymap.set("n", "<leader>cc", function()
	curl.open_curl_tab()
end, { desc = "Open a curl tab scoped to the current working directory" })
vim.keymap.set("n", "<leader>fsc", function()
	curl.pick_scoped_collection()
end, { desc = "Choose a scoped collection and open it" })

vim.keymap.set("n", "<leader>fgc", function()
	curl.pick_global_collection()
end, { desc = "Choose a global collection and open it" })

local fzfLua = require('fzf-lua')
fzfLua.setup({
	winopts = {
		fullscreen = true,
		border = false,
	},
	fzf_opts = {
		['--layout'] = false,
		-- ['--info']      = false,
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
})
fzfLua.register_ui_select()

-- Open files in fzf
vim.keymap.set('n', '<C-p>', '<cmd>lua require(\'fzf-lua\').files()<CR>')

-- search current buffer in fzf
vim.keymap.set('n', '<C-l>', '<cmd>lua require(\'fzf-lua\').blines()<CR>')

-- git status modified files
vim.keymap.set('n', '<C-u>', '<cmd>lua require(\'fzf-lua\').git_status()<CR>')

-- Open MRU in fzf
vim.keymap.set('n', '<C-o>', '<cmd>lua require(\'fzf-lua\').git_status()<CR>')

-- grep all files in project
vim.keymap.set('n', '<C-f>', '<cmd>lua require(\'fzf-lua\').live_grep()<CR>')
vim.keymap.set('n', '<C-g>', '<cmd>lua require(\'fzf-lua\').grep()<CR>')

vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.nginx_beautifier,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.staticcheck,
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.diagnostics.hadolint,
		-- null_ls.builtins.diagnostics.phpmd.with({
		--             extra_args = { os.getenv("HOME")..'/.phpmd-ruleset.xml' },
		--           }),
	},
})

-- nvim-comment stuff
require('nvim_comment').setup({
	create_mappings = false,
	-- line_mapping = '<leader>c<space>',
	-- operator_mapping = '<leader>c<space>',
})
-- i want same mappings for insert/visual
vim.api.nvim_set_keymap('n', '<leader>c<space>', ':CommentToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>c<space>', ":'<,'>CommentToggle<CR>", { noremap = true, silent = true })

require('nvim-autopairs').setup()
require('lualine').setup({
	inactive_sections = {
		lualine_c = {
			{
				'filename',
				path = 1,
				shorting_target = 10,
			}
		},
	}
})

require "fidget".setup {} -- lsp loading info
require("nvim-surround").setup({})
require('leap').add_default_mappings()

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			require('snippy').expand_snippet(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snippy.can_expand_or_advance() then
				snippy.expand_or_advance()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snippy.can_jump(-1) then
				snippy.previous()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'snippy' },
		{ name = 'path' },
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

vim.diagnostic.config({ virtual_text = true })

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lspconfig = require('lspconfig')
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local servers = {
	-- TODO css/scss html etc: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss
	clangd = {},
	rust_analyzer = {},
	pyright = {},
	ts_ls = {},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
			},
		},
	},
	phpactor = {},
	vimls = {},
	jsonnet_ls = {},
	bashls = {},
	ansiblels = {
		-- settings = {
		-- 	ansible = {
		-- 		ansible = {
		-- 			path = "/home/jonasfalck/.local/bin/ansible"
		-- 		},
		-- python = {
		-- 	interpreterPath = '/usr/bin/python3',
		-- },
		-- 	},
		-- },
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { 'vim' },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	},
}


for server, opts in pairs(servers) do
	opts.on_attach = on_attach
	opts.capabilities = capabilities

	vim.lsp.config[server] = opts
	vim.lsp.enable(server)
end

-- treesitter stuff
require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		'dockerfile',
		'c',
		'cpp',
		'go',
		'gomod',
		'lua',
		'python',
		'rust',
		'typescript',
		'tsx',
		'javascript',
		'vimdoc',
		'vim',
		'php',
		'comment',
		'yaml',
		'bash',
		'jsonnet',
		'json',
		'http',
		'java',
		'groovy',
	},

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { 'python' } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<c-backspace>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

-- require("rest-nvim").setup({
-- 	env_file = '.requests.env'
-- })
