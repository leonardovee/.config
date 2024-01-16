return {
    {
        "rose-pine/neovim",
        config = function()
            local rosepine = require("rose-pine")
            rosepine.setup({
                disable_background = true
            })
        end,
    }
}
