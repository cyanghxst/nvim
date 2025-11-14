return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local vscode = require("luasnip.loaders.from_vscode")

        vscode.lazy_load()
        vscode.lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
    end,
}
