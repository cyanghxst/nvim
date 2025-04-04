local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.env.HOME .. "/.jdtls-workspace/" .. project_name

local bundles = {
    vim.fn.glob(
        vim.env.HOME .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"
    ),
}

vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(vim.env.HOME .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n")
)

local config = {
    cmd = {
        "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/current/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. vim.env.HOME .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.env.HOME .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
        "-configuration",
        vim.env.HOME .. "/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
        "-data",
        workspace_dir,
    },

    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

    settings = {
        java = {
            home = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/current/bin/java",
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/8.0.442.fx-zulu",
                    },
                    {
                        name = "JavaSE-17",
                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/17.0.14.fx-zulu",
                    },
                    {
                        name = "JavaSE-21",
                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.6.fx-zulu",
                    },
                },
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            signatureHelp = { enabled = true },
            format = {
                enabled = true,
                settings = {
                    url = vim.env.HOME .. "/.config/jdtls/jdtls-format.xml",
                    profile = "GoogleStyle",
                },
            },
        },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org",
            },
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },
    capabilities = require("blink-cmp").get_lsp_capabilities(),
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        bundles = bundles,
    },
}

-- Needed for debugging
config["on_attach"] = function(client, bufnr)
    -- jdtls.setup_dap({ hotcodereplace = 'auto' })
    -- require('jdtls.dap').setup_dap_main_class_configs()

    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false }) -- Blocking format before saving
        end,
    })
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
