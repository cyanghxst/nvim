return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        history = true,
        delete_check_events = "TextChanged",
    },
    config = function()
        local ls = require("luasnip")
        local vscode = require("lua.plugins.laoders.from_vscode")

        vscode.lazy_load()
        ls.filetype_extend("java", "javadoc")
    end,
}
