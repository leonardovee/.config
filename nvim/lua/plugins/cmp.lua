return {
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
                { name = 'nvim_lsp', keyword_length = 3 },
                { name = 'nvim_lsp_signature_help'},
                { name = 'nvim_lua', keyword_length = 2},
                { name = 'buffer', keyword_length = 2 },
                { name = 'vsnip', keyword_length = 2 },
                { name = 'calc'},
            })
          })
    end,
}

