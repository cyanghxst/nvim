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

        vim.lsp.config["*"] = {
            capabilities = capabilities,
            on_attach = on_attach,
        }

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

        })

        -- Per-server config overrides
        -- (servers not listed here inherit defaults from
        --  nvim-lspconfig's built-in configs + global '*' above)

        vim.lsp.config.lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim", "hs" } },
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        }

        vim.lsp.config.clangd = {
            cmd = { "clangd", "--fallback-style=webkit" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = function(bufnr, on_dir)
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname == "" then return end
                local dir = vim.fs.dirname(bufname)
                on_dir(vim.fs.root(dir, { "compile_commands.json", ".clangd", ".git", "Makefile", "configure.ac" }) or dir)
            end,
        }

        vim.lsp.config.jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        }

        vim.lsp.config.ts_ls = {
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
        }

        vim.lsp.config.bashls = {
            cmd = { "bash-language-server", "start" },
            filetypes = { "sh", "bash", "zsh" },
        }

        -- arduino-language-server: requires explicit CLI args and config path
        do
            local data = vim.fn.stdpath("data")
            local als_path = data .. "/mason/bin/arduino-language-server"
            local clangd_path = data .. "/mason/bin/clangd"
            local arduino_cli_path = "/opt/homebrew/bin/arduino-cli"
            local home = os.getenv("HOME")
            local cli_config = home .. "/Library/Arduino15/arduino-cli.yaml"

            if vim.fn.filereadable(cli_config) == 0 then
                vim.fn.mkdir(home .. "/Library/Arduino15", "p")
                vim.fn.system({ arduino_cli_path, "config", "init", "--config-file", cli_config })
            end

            vim.lsp.config.arduino_language_server = {
                cmd = {
                    als_path,
                    "-cli-config",
                    cli_config,
                    "-cli",
                    arduino_cli_path,
                    "-clangd",
                    clangd_path,
                    "-fqbn",
                    "arduino:avr:uno",
                },
                filetypes = { "arduino" },
                root_dir = function(bufnr, on_dir)
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    if bufname ~= "" then
                        on_dir(vim.fs.dirname(bufname))
                    end
                end,
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end

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

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
                "prettier",
                "stylua",
                "yamlfmt",
                "clang-format",
            },
        })
    end,
}
