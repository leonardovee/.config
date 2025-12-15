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
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                local opts = { buffer = ev.buf }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<space>f", function()
                        vim.lsp.buf.format({ async = true })
                end, opts)
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
vim.keymap.set("n", "<leader>dr", "<cmd>DapToggleRepl<CR>")
vim.keymap.set("n", "<leader>dp", "<cmd>DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- lsp
vim.lsp.config("lua_ls", {})
vim.lsp.config("ts_ls", { root_markers = { "package.json" } })
vim.lsp.config("rust_analyzer", { root_markers = { "Cargo.toml" } })
vim.lsp.config("clangd", {
        cmd = { "clangd", "--compile-commands-dir=build" },
        root_markers = { "compile_commands.json" }
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

require("lazy").setup({
        -- lsp
        {
                "hrsh7th/nvim-cmp",
                dependencies = {
                        "neovim/nvim-lspconfig",
                        "hrsh7th/cmp-nvim-lsp",
                        "hrsh7th/cmp-buffer",
                        "hrsh7th/cmp-path",
                },
                config = function()
                        local cmp = require("cmp")
                        cmp.setup({
                                mapping = cmp.mapping.preset.insert({
                                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                        ["<C-Space>"] = cmp.mapping.complete(),
                                        ["<C-e>"] = cmp.mapping.abort(),
                                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                }),
                                sources = cmp.config.sources({
                                        { name = "path" },
                                        { name = "nvim_lsp",               keyword_length = 3 },
                                        { name = "nvim_lsp_signature_help" },
                                        { name = "nvim_lua",               keyword_length = 2 },
                                        { name = "buffer",                 keyword_length = 2 },
                                        { name = "calc" },
                                }),
                        })
                end,
        },
        {
                "nvim-treesitter/nvim-treesitter",
                config = function()
                        local ts = require("nvim-treesitter.configs")
                        ts.setup({
                                ensure_installed = { "javascript", "typescript", "rust", "go", "lua", "yaml", "json", "toml", "ocaml", "c", "cpp", "python" },
                                sync_install = false,
                                auto_install = true,
                                highlight = {
                                        enable = true,
                                        additional_vim_regex_highlighting = false,
                                },
                        })
                end,
        },
        {
                "williamboman/mason.nvim",
                opts = {},
                config = function(_, _)
                        local mason = require("mason")
                        mason.setup()
                end,
        },
        {
                "stevearc/conform.nvim",
                opts = {},
                event = "VeryLazy",
                config = function(_, _)
                        local conform = require("conform")
                        conform.setup({
                                formatters_by_ft = {
                                        lua = { "stylua" },
                                        python = { "isort", "black" },
                                        go = { "goimports", "gofmt" },
                                        json = { "prettier" },
                                        typescript = { 'prettier' },
                                        typescriptreact = { 'prettier' },
                                        javascript = { 'prettier' },
                                        javascriptreact = { 'prettier' },
                                        ocaml = { 'ocamlformat' },

                                },
                                format_on_save = {
                                        timeout_ms = 1500,
                                        lsp_fallback = true,
                                },
                        })
                        require('conform.formatters.prettier').args = function(_, ctx)
                                local prettier_roots = { '.prettierrc', '.prettierrc.json', 'prettier.config.js' }
                                local args = { '--stdin-filepath', '$FILENAME' }
                                local config_path = vim.fn.stdpath('config')

                                local localPrettierConfig = vim.fs.find(prettier_roots, {
                                        upward = true,
                                        path = ctx.dirname,
                                        type = 'file'
                                })[1]
                                local globalPrettierConfig = vim.fs.find(prettier_roots, {
                                        path = type(config_path) == 'string' and config_path or config_path[1],
                                        type = 'file'
                                })[1]
                                local disableGlobalPrettierConfig = os.getenv('DISABLE_GLOBAL_PRETTIER_CONFIG')

                                -- Project config takes precedence over global config
                                if localPrettierConfig then
                                        vim.list_extend(args, { '--config', localPrettierConfig })
                                elseif globalPrettierConfig and not disableGlobalPrettierConfig then
                                        vim.list_extend(args, { '--config', globalPrettierConfig })
                                end

                                local hasTailwindPrettierPlugin = vim.fs.find('node_modules/prettier-plugin-tailwindcss',
                                        {
                                                upward = true,
                                                path = ctx.dirname,
                                                type = 'directory'
                                        })[1]

                                if hasTailwindPrettierPlugin then
                                        vim.list_extend(args, { '--plugin', 'prettier-plugin-tailwindcss' })
                                end

                                return args
                        end

                        conform.formatters.beautysh = {
                                prepend_args = function()
                                        return { '--indent-size', '2', '--force-function-style', 'fnpar' }
                                end
                        }


                        conform.formatters['ocaml-format'] = {
                                prepend_args = function()
                                        return { '-i', '--enable-outside-detected-project' }
                                end
                        }
                end,
        },
        {
                "ray-x/lsp_signature.nvim",
                event = "VeryLazy",
                opts = {},
                config = function(_, _)
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

        -- debugger
        {
                "mfussenegger/nvim-dap",
                dependencies = {
                        "leoluz/nvim-dap-go",
                        "rcarriga/nvim-dap-ui",
                        "nvim-neotest/nvim-nio",
                },
                config = function()
                        require("dap-go").setup()

                        local dap, dapui = require("dap"), require("dapui")

                        dap.adapters.cppdbg = {
                                id = 'cppdbg',
                                type = 'executable',
                                command =
                                '/home/leonardocee/.cpptools-linux-x64/extension/debugAdapters/bin/OpenDebugAD7',
                        }
                        dap.configurations.cpp = {
                                {
                                        name = "Launch file",
                                        type = "cppdbg",
                                        request = "launch",
                                        program = function()
                                                return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
                                        end,
                                        cwd = '${workspaceFolder}',
                                        stopAtEntry = true,
                                }
                        }
                        dap.configurations.c = dap.configurations.cpp

                        dapui.setup()

                        dap.listeners.before.attach.dapui_config = function()
                                dapui.open()
                        end
                        dap.listeners.before.launch.dapui_config = function()
                                dapui.open()
                        end
                        dap.listeners.before.event_terminated.dapui_config = function()
                                dapui.close()
                        end
                        dap.listeners.before.event_exited.dapui_config = function()
                                dapui.close()
                        end
                        dap.listeners.after.disconnect.dapui_config = function()
                                dapui.close()
                        end
                end,
        },

        -- useful stuff
        { "airblade/vim-gitgutter" },
        {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                        require("telescope").setup({
                                defaults = {
                                        layout_strategy = "vertical",
                                        layout_config = {
                                                height = vim.o.lines,
                                                width = vim.o.columns,
                                                prompt_position = "bottom",
                                                preview_height = 0.5,
                                        },
                                        file_ignore_patterns = {
                                                "node_modules", "build", "dist", "yarn.lock", "package-lock.json",
                                                "lazy-lock.json", "Cargo.lock", "target", "third_party", ".git",
                                        },
                                },
                                pickers = {
                                        find_files = {
                                                hidden = true
                                        }
                                }
                        })
                end,
        },

        -- theme
        {
                'bettervim/yugen.nvim',
                config = function()
                        vim.cmd.colorscheme('yugen')
                end,
        }
})

-- color.lua
vim.opt.termguicolors = true
