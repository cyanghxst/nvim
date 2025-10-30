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
                "prettierd", -- js/ts/css/html/json/md/yaml
                "yamlfmt",
                -- "eslint_d",   -- js/ts
            },
            automatic_installation = true,
            handlers = {
                function() end,
                checkstyle = function() end,
            },
        })

        local null_ls = require("null-ls")
        local format_group = vim.api.nvim_create_augroup("NoneLsFormatOnSave", { clear = false })

        null_ls.setup({
            sources = {
                ----------------
                -- Formatters --
                ----------------

                -- stylua
                null_ls.builtins.formatting.stylua.with({
                    -- force indent width to 4
                    extra_args = {
                        "--indent-width",
                        "4",
                        "--indent-type",
                        "Spaces",
                    },
                }),

                -- yamlfmt (via .yamlfmt.yaml)
                null_ls.builtins.formatting.yamlfmt,

                -- prettierd/prettier
                (null_ls.builtins.formatting.prettierd or null_ls.builtins.formatting.prettier).with({
                    filetypes = { "javascript", "typescript", "css", "html", "json", "markdown", "yaml" },
                    extra_args = {
                        "--tab-width",
                        "4",
                    },
                }),

                -----------------
                -- Diagnostics --
                -----------------
                null_ls.builtins.diagnostics.checkstyle.with({
                    extra_args = { "-c", vim.env.HOME .. "/.config/java/checkstyle.xml" },
                }),
                -- null_ls.builtins.diagnostics.eslint_d,
                -- null_ls.builtins.code_actions.eslint_d,
            },

            on_attach = function(client, bufnr)
                local ft = vim.bo[bufnr].filetype
                if client.name == "null-ls" and client.supports_method("textDocument/formatting") and ft ~= "java" then
                    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_group,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                async = false,
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
