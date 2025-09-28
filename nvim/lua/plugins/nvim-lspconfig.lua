return {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "Saghen/blink.cmp" },
    config = function()
        local lsp = require("lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- Lua
        lsp.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                            "require",
                            "hs",
                        },
                    },
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        })

        -- Clangd
        lsp.clangd.setup({
            cmd = { "clangd", "--fallback-style=webkit" },
            filetypes = { "cpp", "c", "objc", "objcpp" },
            capabilities = capabilities,
        })

        -- TypeScript / JavaScript
        lsp.ts_ls.setup({
            capabilities = capabilities,
            cmd = { "typescript-language-server", "--stdio" },
            -- root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
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

        -- Additional Language Servers
        lsp.html.setup({ capabilities = capabilities })
        lsp.cssls.setup({ capabilities = capabilities })
        lsp.jsonls.setup({ capabilities = capabilities })
        lsp.ruby_lsp.setup({ capabilities = capabilities })
        lsp.pyright.setup({ capabilities = capabilities })

        -- Bash Language Server
        lsp.bashls.setup({
            capabilities = capabilities,
            filetypes = { "sh", "bash", "zsh" },
            cmd = { "bash-language-server", "start" },
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
    end,
}
