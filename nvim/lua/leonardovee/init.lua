require("leonardovee.set")
require("leonardovee.remap")
require("leonardovee.mason")
require("leonardovee.packer")

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ""
  })
end

sign({name = "DiagnosticSignError", text = ""})
sign({name = "DiagnosticSignWarn", text = ""})
sign({name = "DiagnosticSignHint", text = ""})
sign({name = "DiagnosticSignInfo", text = ""})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require"cmp"
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = "path" },                              -- file paths
    { name = "nvim_lsp", keyword_length = 3 },      -- from language server
    { name = "nvim_lsp_signature_help"},            -- display function signatures with current parameter emphasized
    { name = "nvim_lua", keyword_length = 2},       -- complete neovim"s Lua runtime API such vim.lsp.*
    { name = "buffer", keyword_length = 2 },        -- source current buffer
    { name = "vsnip", keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = "calc"},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {"menu", "abbr", "kind"},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = "λ",
              vsnip = "⋗",
              buffer = "Ω",
              path = "🖫",
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

require("nvim-tree").setup()
require("feline").setup()

-- print("hello from /lua/leonardovee/init.lua")
