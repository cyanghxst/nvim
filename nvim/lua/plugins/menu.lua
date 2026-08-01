return {
    "nvzone/menu",
    lazy = true,
    dependencies = {
        { "nvzone/volt", lazy = true },
    },

    -- Load when you actually need it; we’ll use a keymap to trigger opening
    keys = {
        { "<C-t>", mode = "n" }, -- open default menu
        { "<RightMouse>", mode = { "n", "v", "i" } }, -- right-click menu
    },

    config = function()
        require("config.nvmenu").setup()

        -- Keyboard: Ctrl-t to open the default menu
        vim.keymap.set("n", "<C-t>", function()
            require("menu").open("default")
        end, { desc = "Open menu (default)" })

        -- Mouse: Right-click opens context menu; detects NvimTree
        local function open_context_menu()
            local menu = require("menu")
            local utils = require("menu.utils")

            -- Close any previously opened menus to avoid stacking
            utils.delete_old_menus()

            -- Move the cursor to the click location ourselves instead of
            -- forwarding <RightMouse> to Neovim's default handling: since
            -- Neovim 0.11 that default mapping also opens its own built-in
            -- PopUp context menu, which collides with the menu we open below.
            local mousepos = vim.fn.getmousepos()
            local winid = mousepos.winid
            if winid ~= 0 then
                vim.api.nvim_set_current_win(winid)
                pcall(vim.api.nvim_win_set_cursor, winid, { mousepos.line, math.max(0, mousepos.column - 1) })
            end

            -- Determine clicked buffer's filetype to choose menu
            local buf = vim.api.nvim_win_get_buf(winid)
            local ft = vim.bo[buf].ft

            local options = (ft == "NvimTree") and "nvimtree" or "default"

            -- Open with mouse mode so items are clickable
            menu.open(options, { mouse = true, border = true })
        end

        vim.keymap.set({ "n", "v" }, "<RightMouse>", open_context_menu, {
            desc = "Open menu (context/right-click)",
        })

        -- Insert mode needs its own mapping, otherwise <RightMouse> falls
        -- through to Neovim's built-in (borderless) PopUp menu. Leave insert
        -- first so the menu opens in the same state as the normal-mode one.
        vim.keymap.set("i", "<RightMouse>", function()
            vim.cmd("stopinsert")
            vim.schedule(open_context_menu)
        end, { desc = "Open menu (context/right-click)" })
    end,
}
