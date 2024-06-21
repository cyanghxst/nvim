return {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "hrsh7th/cmp-nvim-lsp",
    config = function()
        local lsp = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        lsp.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        })
        lsp.clangd.setup({ capabilities = capabilities })

        vim.keymap.set("n", "<leader>M", vim.diagnostic.open_float)
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.setqflist)

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = ev.buf })
                vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { buffer = ev.buf })
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = ev.buf })
                vim.keymap.set("n", "<leader>C", vim.lsp.buf.code_action, { buffer = ev.buf })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
                vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, { buffer = ev.buf })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
                vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = ev.buf })
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.declaration, { buffer = ev.buf })
            end,
        })
        handler = {
            vim.diagnostic.config({
                virtual_text = false,
            })
        }
    end,
}
