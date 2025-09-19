local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = vim.env.HOME .. "/.jdtls-workspace/" .. project_name
local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

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

    root_dir = root_dir,

    settings = {
        java = {
            -- home = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.4-tem",

            project = {
                sourcePaths = { "src" },
            },
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/11.0.28-tem",
                    },
                    {
                        name = "JavaSE-21",
                        path = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.4-tem",
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
    flags = { allow_incremental_sync = true },
    init_options = { bundles = bundles },
}

config["on_attach"] = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })
end

jdtls.start_or_attach(config)
