return {
    "williamboman/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
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

        require("mason-lspconfig").setup({
            ensure_installed = { "html", "lua_ls", "pyright", "jdtls", "ruby_lsp", "clangd" },
            automatic_installation = true,
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
            },
        })

        -- Use blink.cmp for LSP capabilities
        local lspconfig = require("lspconfig")
        local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
        local lsp_attach = function(client, bufnr)
            -- Keybindings or additional setup here
        end

        -- Configure handlers with blink.cmp capabilities
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if server_name ~= "jdtls" then
                    lspconfig[server_name].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                    })
                end
            end,
        })
    end,
}
