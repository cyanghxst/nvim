return {
    "numTostr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        padding = true,
        sticky = true,
        ignore = nil,

        -- normal mode
        toggler = {
            line = "gcc",
            block = "gbc",
        },

        -- normal and visual mode
        opleader = {
            line = "gc",
            block = "gb",
        },

        --- extra mappings
        extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
        },

        -- enable keybindings
        mappings = {
            basic = true,
            extra = true,
        },

        pre_hook = nil,
        post_hook = nil,
    },
}
