return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            yaml = { "yamlfmt", "prettier" },
            astro = { "prettier" },
            c = { "clang-format" },
            cpp = { "clang-format" },
        },

        formatters = {
            stylua = {
                prepend_args = { "--indent-width", "4", "--indent-type", "Spaces" },
            },
            prettier = {
                prepend_args = { "--tab-width", "4" },
            },
        },
        format_on_save = function(bufnr)
            if vim.bo[bufnr].filetype == "java" then
                return nil
            end
            return { timeout_ms = 500 }
        end,
    },
}
