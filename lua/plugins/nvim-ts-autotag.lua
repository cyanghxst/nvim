return {
    "PriceHiller/nvim-ts-autotag",
    enabled = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("nvim-ts-autotag").setup({

        })
    end
}
