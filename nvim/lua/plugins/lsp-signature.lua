return {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
        local signature = require("lsp_signature")
        signature.setup{
            doc_lines = 0,
            hint_enable = false,
            handler_opts = {
                border = "none"
            },
        }
    end
}
