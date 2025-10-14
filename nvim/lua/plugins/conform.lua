return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescriptreact = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                json = { "prettierd" },
                markdown = { "prettierd" },
            },
            formatters = {
                prettierd = {
                    prepend_args = { "--tab-width=4", "--prose-wrap=never" },
                },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })
    end,
}
