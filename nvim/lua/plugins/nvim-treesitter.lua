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

        require("nvim-treesitter").install({
            "query",
            "html",
            "javascript",
            "java",
            "css",
            "vim",
            "vimdoc",
            "lua",
            "luadoc",
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
            "doxygen",
            "cpp",
        })
    end,
}
