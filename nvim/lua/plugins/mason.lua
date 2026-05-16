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

        local function on_attach(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            map("n", "<leader>gg", vim.lsp.buf.hover, "Hover")
            map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
            map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to declaration")
            map("n", "<leader>gi", vim.lsp.buf.implementation, "Go to implementation")
            map("n", "<leader>gt", vim.lsp.buf.type_definition, "Go to type definition")
            map("n", "<leader>gr", vim.lsp.buf.references, "Go to references")
            map("n", "<leader>gs", vim.lsp.buf.signature_help, "Signature help")
            map("n", "<leader>rr", vim.lsp.buf.rename, "Rename symbol")
            map({ "n", "v" }, "<leader>gf", function()
                vim.lsp.buf.format({ async = true })
            end, "Format")
            map("n", "<leader>ga", vim.lsp.buf.code_action, "Code action")
            map("n", "<leader>gl", vim.diagnostic.open_float, "Open float")
            map("n", "<leader>gp", vim.diagnostic.goto_prev, "Go to previous")
            map("n", "<leader>gn", vim.diagnostic.goto_next, "Go to next")
            map("n", "<leader>tr", vim.lsp.buf.document_symbol, "Document symbol")
        end

        require("mason-lspconfig").setup({
            ensure_installed = {
                "html",
                "cssls",
                "lua_ls",
                "pyright",
                "jdtls",
                "jsonls",
                "clangd",
                "marksman",
                "tailwindcss",
                "ts_ls",
                "bashls",
                "astro",
                "arduino_language_server",
            },

            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,

                arduino_language_server = function()
                    local mason_registry = require("mason-registry")

                    local clangd_path = mason_registry.get_package("clangd"):get_install_path() .. "/extension/LLVM/bin/clangd"
                    local arduino_cli_path = mason_registry.get_package("arduino-cli"):get_install_path() .. "/arduino-cli"

                    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
                    local cli_config = home .. "/.arduino15/arduino-cli.yaml"

                    require("lspconfig").arduino_language_server.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        cmd = {
                            "arduino-language-server",
                            "-cli-config", cli_config,
                            "-cli", arduino_cli_path,
                            "-clangd", clangd_path,
                            "-fqbn", "arduino:avr:uno",
                        },
                    })
                end,

                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "hs" },
                                },
                                workspace = { checkThirdParty = false },
                                completion = { callSnippet = "Replace" },
                            },
                        },
                    })
                end,

                clangd = function()
                    local util = require("lspconfig.util")

                    require("lspconfig").clangd.setup({
                        cmd = { "clangd", "--fallback-style=webkit" },
                        filetypes = { "cpp", "c", "objc", "objcpp" },
                        capabilities = capabilities,
                        on_attach = on_attach,

                        root_dir = function(fname)
                            local root = util.root_pattern(
                                "compile_commands.json",
                                ".clangd",
                                ".git",
                                "Makefile",
                                "configure.ac"
                            )(fname)

                            if root then
                                return root
                            end

                            return util.path.dirname(fname)
                        end,
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
                        on_attach = function(client, bufnr)
                            on_attach(client, bufnr)
                            client.server_capabilities.documentFormattingProvider = false
                        end,
                    })
                end,

                bashls = function()
                    require("lspconfig").bashls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = { "sh", "bash", "zsh" },
                        cmd = { "bash-language-server", "start" },
                    })
                end,

                astro = function()
                    require("lspconfig").astro.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
            },
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = { prefix = "*" },
            float = { border = "rounded" },
            signs = {
                text = {
                    [vim.diagnostic.severity.HINT] = "*",
                    [vim.diagnostic.severity.INFO] = "*",
                    [vim.diagnostic.severity.WARN] = "*",
                    [vim.diagnostic.severity.ERROR] = "*",
                },
            },
        })

        -- Hover and signature borders
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
                "prettier",
                "stylua",
                "clang-format",
            },
        })
    end,
}
