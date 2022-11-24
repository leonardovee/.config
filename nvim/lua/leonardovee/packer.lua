vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" }
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    use { "neovim/nvim-lspconfig" }
    use { "simrat39/rust-tools.nvim" }
    use { "hrsh7th/nvim-cmp" } 
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }
    use { "hrsh7th/cmp-nvim-lsp-signature-help" }
    use { "hrsh7th/cmp-vsnip" } 
    use { "hrsh7th/cmp-path" } 
    use { "hrsh7th/cmp-buffer" } 
    use { "hrsh7th/vim-vsnip" }
    use { "voldikss/vim-floaterm" }
    use { "nvim-telescope/telescope.nvim", tag = "0.1.0", requires = { { "nvim-lua/plenary.nvim" } } }
    use { "nvim-tree/nvim-tree.lua", requires = { { "nvim-tree/nvim-web-devicons" } } }
    use { "danilamihailov/beacon.nvim" }
    use { "navarasu/onedark.nvim" }
    use { "feline-nvim/feline.nvim" }
end)
