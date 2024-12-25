return {
    "numTostr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        padding = true,
        sticky = true,
        ignore = nil,

        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            line = "gcc",
            block = "gbc",
        },

        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            line = "gc",
            block = "gb",
        },

        ---LHS of extra mappings
        extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
        },

        ---Enable keybindings
        mappings = {
            basic = true,
            extra = true,
        },

        pre_hook = nil,
        post_hook = nil,
    },
}
