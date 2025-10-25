return {
    "nvimtools/none-ls.nvim",
    enabled = true,
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
    },

    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mason").setup()
        require("mason-null-ls").setup({
            ensure_installed = {
                "stylua", -- lua
                "prettierd", -- js/ts/css/html/json/md
                -- "eslint_d", -- js/ts
            },

            automatic_installation = true, -- formatting and diagnostics via none-ls
            handlers = {}, -- let mason-null-ls register sources automatically
        })

        local null_ls = require("null-ls")
        local format_group = vim.api.nvim_create_augroup("NoneLsFormatOnSave", {})

        null_ls.setup({
            sources = {

                --------------
                -- FORMATTING
                --------------

                -- lua
                null_ls.builtins.formatting.stylua,

                -- js/ts/css/html/json/md
                null_ls.builtins.formatting.prettierd or null_ls.builtins.formatting.prettier, -- prefer prettierd. if it doesn't exist, fall back to prettier

                -- java
                null_ls.builtins.formatting.google_java_format,

                -- java but AOSP style
                -- null_ls.builtins.formatting.google_java_format.with({
                --     extra_args = { "--aosp" },
                -- })

                ---------------
                -- DIAGNOSTICS
                ---------------

                -- look for java checkstyle in the root directory
                null_ls.builtins.diagnostics.checkstyle.with({
                    extra_args = {
                        "-c",
                        vim.fn.getcwd() .. "/checkstyle.xml",
                    },
                }),

                -- optional: eslint_d for js/ts diagnostics (fast asf)
                -- null_ls.builtins.diagnostics.eslint_d,
                -- null_ls.builtins.code_actions.eslint_d,
            },

            on_attach = function(client, bufnr)
                -- format on save for any buffer
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({
                        group = format_group,
                        buffer = bufnr,
                    })

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_group,
                        buffer = bufnr,
                        callback = function()
                            -- use only null-ls for formatting
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(c)
                                    return c.name == "null-ls"
                                end,
                            })
                        end,
                    })
                end
            end,
        })
    end,
}
