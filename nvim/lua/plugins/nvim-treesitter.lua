return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = { "tmux" },
        },

        indent = {
            enable = false,
            disable = { "python" },
        },

        ensure_installed = {
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
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
        textobjects = {
            move = {
                enable = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            select = {
                enable = true,
                lookahead = true,
                include_surrounding_whitespace = true,
                keymaps = {
                    ["aa"] = "@parameter.outer",

                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",

                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",

                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>na"] = "@parameter.inner",
                    ["<leader>nf"] = "@function.outer",
                },
                swap_previous = {
                    ["<leader>pa"] = "@parameter.inner",
                    ["<leader>pf"] = "@function.outer",
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
