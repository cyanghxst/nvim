return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
        require("nvim-treesitter").setup {}
        vim.filetype.add({ extension = { mdx = "markdown" } })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        local parsers = {
            "query", "html", "javascript", "java", "css", "vim", "vimdoc",
            "lua", "luadoc", "bash", "json", "toml", "yaml", "sql",
            "markdown", "markdown_inline", "python", "regex", "c",
            "make", "doxygen", "cpp",
        }
        require("nvim-treesitter").install(parsers)
    end,
}
