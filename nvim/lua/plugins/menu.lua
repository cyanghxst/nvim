return {
    "nvzone/menu",
    lazy = true,
    dependencies = {
        { "nvzone/volt", lazy = true },
        { "nvzone/minty", lazy = true },
    },

    -- Load when you actually need it; we’ll use a keymap to trigger opening
    keys = {
        { "<C-t>", mode = "n" }, -- open default menu
        { "<RightMouse>", mode = { "n", "v" } }, -- right-click menu
    },

    config = function()
        -- Keyboard: Ctrl-t to open the default menu
        vim.keymap.set("n", "<C-t>", function()
            require("menu").open("default")
        end, { desc = "Open menu (default)" })

        -- Mouse: Right-click opens context menu; detects NvimTree
        vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
            local menu = require("menu")
            local utils = require("menu.utils")

            -- Close any previously opened menus to avoid stacking
            utils.delete_old_menus()

            -- Forward the actual right click to Neovim (e.g., to move cursor)
            vim.cmd.exec('"normal! \\<RightMouse>"')

            -- Determine clicked buffer's filetype to choose menu
            local winid = vim.fn.getmousepos().winid
            local buf = vim.api.nvim_win_get_buf(winid)
            local ft = vim.bo[buf].ft

            local options = (ft == "NvimTree") and "nvimtree" or "default"

            -- Open with mouse mode so items are clickable
            menu.open(options, { mouse = true, border = false })
        end, { desc = "Open menu (context/right-click)" })
    end,
}
