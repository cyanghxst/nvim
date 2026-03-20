local jdtls = require("jdtls")

-----------
-- paths --
-----------

local home = vim.env.HOME
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = home .. "/.jdtls-workspace/" .. project_name

local function find_java()
    -- prefer JAVA_HOME, fall back to exepath
    local java_home = vim.env.JAVA_HOME
    if java_home and java_home ~= "" then
        return java_home .. "/bin/java"
    end
    return vim.fn.exepath("java")
end

local function jdtls_config_dir()
    local os_name = vim.loop.os_uname().sysname
    local arch = vim.loop.os_uname().machine
    if os_name == "Darwin" then
        return arch == "arm64" and "config_mac_arm" or "config_mac"
    elseif os_name == "Linux" then
        return "config_linux"
    else
        return "config_win"
    end
end

local java_path = find_java()
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

-----------------------
-- java runtimes     --
-----------------------

local function detect_java_runtimes()
    local runtimes = {}
    local java_home = vim.env.JAVA_HOME
    local sdkman = vim.env.SDKMAN_DIR

    -- SDKMAN candidates
    if sdkman and sdkman ~= "" then
        local candidates_dir = sdkman .. "/candidates/java"
        local handle = vim.loop.fs_scandir(candidates_dir)
        if handle then
            while true do
                local name = vim.loop.fs_scandir_next(handle)
                if not name then break end
                local path = candidates_dir .. "/" .. name
                -- extract major version from path (e.g., "21.0.4-tem" -> 21)
                local major = name:match("^(%d+)")
                if major then
                    table.insert(runtimes, {
                        name = "JavaSE-" .. major,
                        path = path,
                    })
                end
            end
        end
    end

    -- JAVA_HOME as fallback runtime
    if #runtimes == 0 and java_home and java_home ~= "" then
        local version_output = vim.fn.system("java -version 2>&1")
        local major = version_output:match('version "%u?(%d+)')
        if major then
            table.insert(runtimes, {
                name = "JavaSE-" .. major,
                path = java_home,
            })
        end
    end

    return runtimes
end

------------
-- config --
------------

local config = {
    cmd = {
        java_path,

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
        jdtls_base .. "/" .. jdtls_config_dir(),
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
                runtimes = detect_java_runtimes(),
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
            postfix = { enabled = true },
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
            generateConstructors = { enabled = true },
            getters = { enabled = true },
            setters = { enabled = true },
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
