local jdtls = require("jdtls")

-----------
-- paths --
-----------

local home = vim.env.HOME
local java_21 = "/opt/homebrew/opt/sdkman-cli/libexec/candidates/java/21.0.4-tem/bin/java"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = home .. "/.jdtls-workspace/" .. project_name

local root_dir = require("jdtls.setup").find_root({
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
})

local jdtls_base = home .. "/.local/share/nvim/mason/packages/jdtls" -- mason jdtls install root
local launcher_path = vim.fn.glob(jdtls_base .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_path = home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar"

local bundles = {
    vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

---------------
-- formatter --
---------------

local formatter_path = home .. "/.config/java/jdtls-format.xml"
local formatter_uri = "file://" .. formatter_path

------------
-- config --
------------

local config = {
    cmd = {
        java_21, -- seems jdtls doesn't like old JVMs ¯\_(ツ)_/¯

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",

        "-javaagent:" .. lombok_path,
        "-Xmx4g",

        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        launcher_path,
        "-configuration",
        jdtls_base .. "/config_mac_arm",
        "-data",
        workspace_dir,
    },

    root_dir = root_dir,

    settings = {
        java = {
            project = { sourcePaths = { "src/main", "src/test" } },
            eclipse = { downloadSources = true },

            configuration = {
                updateBuildConfiguration = "interactive",

                -- for project source/target levels (not jdtls runtime)
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

            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            signatureHelp = { enabled = true },

            format = {
                enabled = true,
                settings = {
                    url = formatter_uri,
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
    -- only use jdtls formats Java on save
    local java_group = vim.api.nvim_create_augroup("FormatOnSaveJdtls", { clear = false })
    vim.api.nvim_clear_autocmds({ group = java_group, buffer = bufnr })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = java_group,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                filter = function(c)
                    return c.name == "jdtls"
                end,
            })
        end,
    })
end

jdtls.start_or_attach(config)
