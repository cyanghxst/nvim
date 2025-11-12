return {
    "williamboman/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "neovim/nvim-lspconfig" },
    },

    config = function()
        require("mason").setup({
            ui = {
                check_outdated_packages_on_open = true,
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                -- border = "single",
                width = 0.8,
                height = 0.9,
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        require("mason-lspconfig").setup({
            ensure_installed = { "html", "lua_ls", "pyright", "jdtls", "jsonls", "clangd", "marksman" },
            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "require", "hs" },
                                },
                                workspace = { checkThirdParty = false },
                                completion = { callSnippet = "Replace" },
                            },
                        },
                    })
                end,

                clangd = function()
                    require("lspconfig").clangd.setup({
                        cmd = { "clangd", "--fallback-style=webkit" },
                        filetypes = { "cpp", "c", "objc", "objcpp" },
                        capabilities = capabilities,
                    })
                end,

                json_ls = function()
                    require("lspconfig").jsonls.setup({
                        settings = {
                            json = {
                                schemas = require("schemastore").json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    })
                end,

                ts_ls = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = capabilities,
                        cmd = { "typescript-language-server", "--stdio" },
                        filetypes = {
                            "typescript",
                            "typescriptreact",
                            "typescript.tsx",
                            "javascript",
                            "javascriptreact",
                            "javascript.jsx",
                        },
                        on_attach = function(client, _)
                            client.server_capabilities.documentFormattingProvider = false
                        end,
                    })
                end,

                bashls = function()
                    require("lspconfig").bashls.setup({
                        capabilities = capabilities,
                        filetypes = { "sh", "bash", "zsh" },
                        cmd = { "bash-language-server", "start" },
                    })
                end,
            },
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = { prefix = "*" },
            signs = {
                text = {
                    [vim.diagnostic.severity.HINT] = "*",
                    [vim.diagnostic.severity.INFO] = "*",
                    [vim.diagnostic.severity.WARN] = "*",
                    [vim.diagnostic.severity.ERROR] = "*",
                },
            },
        })

        -- Hover and signature handlers with rounded borders
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
                "prettierd",
                "stylua",
            },
        })
    end,
}
