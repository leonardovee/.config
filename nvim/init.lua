-- set.lua
vim.opt.guicursor = ""
vim.opt.nu = true
--vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.so = 999
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_set_option('updatetime', 500)

vim.g.mapleader = " "
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

-- keymap.lua
local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

-- remap.lua
local nnoremap = M.nnoremap

nnoremap("<leader>te", "<cmd>:Telescope<CR>")
nnoremap("<leader>ff", "<cmd>:Telescope find_files<CR>")
nnoremap("<leader>fg", "<cmd>:Telescope live_grep<CR>")
nnoremap("<leader>fb", "<cmd>:Telescope buffers<CR>")
nnoremap("<leader>fh", "<cmd>:Telescope help_tags<CR>")

--nnoremap("<leader>fe", "<cmd>:Explore<CR>")
nnoremap("<leader>fe", "<cmd>:NvimTreeToggle<CR>")
nnoremap("<leader>fw", "<cmd>:NvimTreeFocus<CR>")

nnoremap("<leader>db", "<cmd>:DapContinue<CR>")
nnoremap("<leader>dq", "<cmd>:DapTerminate<CR>")
nnoremap("<leader>do", "<cmd>:DapStepOut<CR>")
nnoremap("<leader>di", "<cmd>:DapStepInto<CR>")
nnoremap("<leader>dt", "<cmd>:DapStepOut<CR>")
nnoremap("<leader>dr", "<cmd>:DapToggleRepl<CR>")
nnoremap("<leader>dp", "<cmd>:DapToggleBreakpoint<CR>")

-- init.lua
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

-- plugins folder
require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
            lspconfig.tsserver.setup {}
            lspconfig.clangd.setup {}
            lspconfig.ocamllsp.setup {}
            lspconfig.lua_ls.setup {}
            lspconfig.elixirls.setup {
                cmd = { "/usr/local/elixir-ls/scripts/language_server.sh" },
            }
            lspconfig.rust_analyzer.setup {
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                }
            }
            lspconfig.gopls.setup {
                cmd = { "gopls", "serve" },
                filetypes = { "go", "gomod" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                    },
                },
            }
            lspconfig.pyright.setup({
                on_attach = function(client, bufnr)
                    custom_attach(client, bufnr, { allowed_clients = { "efm" } })
                end,
                settings = {
                    pyright = {
                        disableOrganizeImports = false,
                        analysis = {
                            useLibraryCodeForTypes = true,
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            autoImportCompletions = true,
                        },
                    },
                },
            })
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<space>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<space>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end,
    },
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
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                window = {
                    --completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'nvim_lsp',               keyword_length = 3 },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lua',               keyword_length = 2 },
                    { name = 'buffer',                 keyword_length = 2 },
                    { name = 'vsnip',                  keyword_length = 2 },
                    { name = 'calc' },
                })
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            local ts = require("nvim-treesitter.configs")
            ts.setup({
                ensure_installed = { "javascript", "typescript", "rust", "go", "lua" },
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
            conform.setup {
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    javascript = { { "prettierd", "prettier" } },
                    html = { "djlint" },
                    css = { "djlint" },
                    go = { "goimports", "gofmt" },
                    json = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            }
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, _)
            local signature = require("lsp_signature")
            signature.setup {
                doc_lines = 0,
                hint_enable = false,
                handler_opts = {
                    border = "none"
                },
            }
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end

            vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end)

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>q", function() harpoon:list():clear() end)

            vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'auto',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '|', right = '|' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end,
    },
    {
        "mfussenegger/nvim-dap",
        {
            "leoluz/nvim-dap-go",
            config = function()
                require("dap-go").setup()
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
            config = function()
                local dap, dapui = require("dap"), require("dapui")
                dapui.setup()

                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end

                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end

                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        }
    },
    { "airblade/vim-gitgutter" },
    { "github/copilot.vim" },
    {
        "briones-gabriel/darcula-solid.nvim",
        dependencies = { "rktjmp/lush.nvim" }
    },
    { "ellisonleao/gruvbox.nvim" },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            local nvim_tree = require("nvim-tree")
            nvim_tree.setup({
                view = {
                    width = 30,
                    side = "right",
                },
                renderer = {
                    group_empty = false,
                    icons = {
                        show = {
                            file = false,
                            folder = false,
                            folder_arrow = false,
                            git = false,
                            modified = false,
                            bookmarks = false,
                        },
                    },
                },
            })
        end,
    }
})

-- color.lua
vim.opt.termguicolors = true
vim.opt.background = 'light'
vim.cmd.colorscheme 'gruvbox'
