return {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    enabled = true,
    init = function()
        vim.api.nvim_set_hl(0, "NvimTreeModifiedFile", { fg = "#a9b1d6" })
        vim.g.loaded_netrw = 1 -- disable netrw
        vim.g.loaded_netrwPlugin = 1
        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("nvim-tree")
            end
        end
    end,

    opts = {
        filters = { dotfiles = true },
        hijack_cursor = true,
        sort = { sorter = "extension" },
        update_focused_file = { enable = true, update_root = false },
        sync_root_with_cwd = true,
        view = { width = 25, side = "left" },
        git = {
            enable = false,
            ignore = false,
            show_on_dirs = true,
            timeout = 400,
        },
        diagnostics = {
            enable = false,
            show_on_dirs = true,
            icons = { hint = "", info = "", warning = "", error = "" },
        },
        modified = {
            enable = false,
            show_on_dirs = false,
            show_on_open_dirs = true,
        },
        renderer = {
            highlight_git = false,
            root_folder_label = function(path)
                local project = vim.fn.fnamemodify(path, ":t")
                return string.upper(project)
            end,
            icons = {
                modified_placement = "before",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = false,
                    modified = true,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    bookmark = "",
                    modified = "[+]",
                    folder = {
                        arrow_open = "",
                        arrow_closed = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                    },
                    git = {
                        unstaged = "[u]",
                        staged = "",
                        unmerged = "",
                        renamed = "󰛿",
                        untracked = "󰋗",
                        deleted = "󰍶",
                        ignored = "◌",
                    },
                },
            },
        },
    },
}
