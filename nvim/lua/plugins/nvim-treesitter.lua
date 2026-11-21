return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
        require("nvim-treesitter").setup({
            auto_install = true,
        })

        vim.filetype.add({ extension = { mdx = "markdown" } })

        -- The main branch compiles parsers with the tree-sitter CLI. Without it
        -- every install fails, so each startup re-downloads every parser and
        -- (with cmdheight=0) floods the screen with hit-enter prompts.
        if vim.fn.executable("tree-sitter") == 0 then
            return
        end

        require("nvim-treesitter").install({
            "astro",
            "html",
            "javascript",
            "java",
            "css",
            "vim",
            "vimdoc",
            "lua",
            "bash",
            "json",
            "toml",
            "yaml",
            "sql",
            "markdown",
            "markdown_inline",
            "python",
            "regex",
            "c",
            "make",
            "cpp",
        })
    end,
}
