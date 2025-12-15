-- opt
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.opt.clipboard = "unnamedplus"
vim.opt.laststatus = 2

-- api
vim.api.nvim_set_option("updatetime", 500)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buffer = args.buf

		if client.server_capabilities.completionProvider then
			local triggers = client.server_capabilities.completionProvider.triggerCharacters or {}
			for i = string.byte("a"), string.byte("z") do
				table.insert(triggers, string.char(i))
			end
			for i = string.byte("A"), string.byte("Z") do
				table.insert(triggers, string.char(i))
			end
		end

		vim.lsp.completion.enable(true, client.id, buffer, {
			autotrigger = true,
		})

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer })
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = buffer })
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { buffer = buffer })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer })
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = buffer })
	end,
})

-- g
vim.g.mapleader = " "

-- keymap
vim.keymap.set("n", "<leader>te", "<cmd>Telescope<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

vim.keymap.set("n", "<leader>fe", "<cmd>Explore<CR>")

vim.keymap.set("n", "<leader>db", "<cmd>DapContinue<CR>")
vim.keymap.set("n", "<leader>dq", "<cmd>DapTerminate<CR>")
vim.keymap.set("n", "<leader>do", "<cmd>DapStepOut<CR>")
vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>")
vim.keymap.set("n", "<leader>dp", "<cmd>DapToggleBreakpoint<CR>")

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- lsp
vim.lsp.config("lua_ls", {})
vim.lsp.config("ts_ls", { root_markers = { "package.json" } })
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml" },
})
vim.lsp.config("clangd", {
	cmd = { "clangd", "--compile-commands-dir=build" },
	filetypes = { "c", "cpp" },
	root_markers = { "compile_commands.json" },
})
vim.lsp.config("gopls", {
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_markers = { "go.work", "go.mod" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
	single_file_support = true,
})
vim.lsp.enable({ "ts_ls", "lua_ls", "rust_analyzer", "clangd", "gopls" })

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
lazy.setup({
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup({ auto_install = true })
		end,
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			local mason = require("mason")

			mason.setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			local conform = require("conform")
			local prettier = require("conform.formatters.prettier")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofmt" },
					json = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			prettier.args = function(_, ctx)
				local prettier_roots = { ".prettierrc", ".prettierrc.json", "prettier.config.js" }
				local args = { "--stdin-filepath", "$FILENAME" }
				local config_path = vim.fn.stdpath("config")

				local localPrettierConfig = vim.fs.find(prettier_roots, {
					upward = true,
					path = ctx.dirname,
					type = "file",
				})[1]

				local globalPrettierConfig = vim.fs.find(prettier_roots, {
					path = type(config_path) == "string" and config_path or config_path[1],
					type = "file",
				})[1]

				local disableGlobalPrettierConfig = os.getenv("DISABLE_GLOBAL_PRETTIER_CONFIG")

				if localPrettierConfig then
					vim.list_extend(args, { "--config", localPrettierConfig })
				elseif globalPrettierConfig and not disableGlobalPrettierConfig then
					vim.list_extend(args, { "--config", globalPrettierConfig })
				end

				return args
			end
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		config = function()
			local signature = require("lsp_signature")

			signature.setup({
				doc_lines = 0,
				hint_enable = false,
				handler_opts = {
					border = "none",
				},
			})
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		event = "VeryLazy",
		config = function()
			local dap_view = require("dap-view")

			dap_view.setup({
				winbar = {
					default_section = "scopes",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			local dap_view = require("dap-view")

			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = "/home/leonardocee/.cpptools-linux-x64/extension/debugAdapters/bin/OpenDebugAD7",
			}
			dap.adapters.delve = {
				id = "delve",
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
				},
			}
			dap.configurations.c = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
				},
			}
			dap.configurations.go = {
				{
					name = "Launch file",
					type = "delve",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
				},
				{
					name = "Launch test",
					type = "delve",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}

			dap.listeners.before.attach.dap_view_config = function()
				dap_view.open()
			end
			dap.listeners.before.launch.dap_view_config = function()
				dap_view.open()
			end

			dap.listeners.before.event_terminated.dap_view_config = function()
				vim.cmd("DapViewClose!")
			end
			dap.listeners.before.event_exited.dap_view_config = function()
				vim.cmd("DapViewClose!")
			end
			dap.listeners.after.disconnect.dap_view_config = function()
				vim.cmd("DapViewClose!")
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						height = vim.o.lines,
						width = vim.o.columns,
						prompt_position = "bottom",
						preview_height = 0.5,
					},
					file_ignore_patterns = {
						"node_modules",
						"build",
						"dist",
						"yarn.lock",
						"package-lock.json",
						"lazy-lock.json",
						"Cargo.lock",
						"target",
						"third_party",
						".git",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})
		end,
	},
	{
		"airblade/vim-gitgutter",
		event = "VeryLazy",
		config = function() end,
	},
	{
		"bettervim/yugen.nvim",
		config = function() end,
	},
})

-- colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("yugen")
