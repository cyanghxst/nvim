return {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "LSP" },
            { "<leader>w", group = "Window/Buffer" },
            { "<leader>n", group = "Swap Next" },
            { "<leader>p", group = "Swap Previous" },
            { "<leader>rr", desc = "Rename symbol" },
            { "<leader>s", desc = "Toggle NvimTree" },
        })
    end,
}
