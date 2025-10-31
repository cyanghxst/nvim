return {
    "folke/tokyonight.nvim",
    priority = 1000,

    opts = {
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            sidebars = "transparent",
            floats = "transparent",
        },
        sidebars = { "qf", "help", "terminal", "packer", "nvimtree" },
        hide_inactive_statusline = true,
        dim_inactive = false,
        lualine_bold = false,

        on_highlights = function(hl, _)
            local palette = {
                white = "#c0caf5",
                blue = "#7aa2f7",
                green = "#9ece6a",
                bone = "#a9b1d6",
                gray1 = "#414868",
                gray2 = "#3b4261",
                gray3 = "#232435",
                black = "#1e2231",
                red = "#f7768e",
                background = "#16151d",
            }

            -- EOB
            hl.EndOfBuffer = { fg = palette.background }

            -- Telescope
            hl.TelescopePromptBorder = { fg = palette.gray1 }
            hl.TelescopePromptTitle = { fg = palette.gray1 }
            hl.TelescopeResultsTitle = { bg = palette.blue, fg = palette.background }
            hl.TelescopeResultsBorder = { fg = palette.gray1 }
            -- hl.TelescopePromptTitle = { bg = palette.blue, fg = palette.background }
            -- hl.TelescopeSelection  = { bg = palette.blue, fg = palette.background }

            -- Dashboard
            hl.AlphaHeader = { fg = palette.blue }
            hl.AlphaButtons = { fg = palette.blue }
            hl.AlphaShortcut = { fg = palette.blue }
            hl.AlphaFooter = { fg = palette.gray2 }

            -- CursorLine
            hl.CursorLineNr = { fg = palette.white }
            hl.CursorLine = { bg = palette.gray3 }

            -- Menu
            hl.Pmenu = { bg = "NONE" }
            hl.NormalFloat = { bg = "NONE" }
            hl.FloatBorder = { fg = palette.gray1 }
            hl.PmenuSel = { fg = palette.background, bg = palette.blue }

            -- Mason
            hl.MasonNormal = { bg = "NONE" }

            -- MiniIndentScope
            hl.MiniIndentscopeSymbol = { fg = palette.gray2 }

            -- Lazy
            hl.LazyNormal = { bg = "NONE" }

            -- GitSigns
            hl.GitSignsAdd = { fg = palette.gray2 }
            hl.GitSignsAddNr = { fg = palette.gray2 }
            hl.GitSignsAddLn = { fg = palette.gray2 }
            hl.GitSignsChange = { fg = palette.gray2 }
            hl.GitSignsChangeNr = { fg = palette.gray2 }
            hl.GitSignsChangeLn = { fg = palette.gray2 }
            hl.GitSignsDelete = { fg = palette.gray2 }
            hl.GitSignsDeleteNr = { fg = palette.gray2 }
            hl.GitSignsTopDelete = { fg = palette.gray2 }
            hl.GitSignsCurrentLineBlame = { fg = palette.gray2 }

            -- NvimTree
            hl.NvimTreeFolderName = { fg = palette.blue }
            hl.NvimTreeFolderArrowOpen = { fg = palette.gray2 }
            hl.NvimTreeFolderArrowClosed = { fg = palette.gray2 }
            hl.NvimTreeOpenedFolderName = { fg = palette.blue }
            hl.NvimTreeEmptyFolderName = { fg = palette.blue }
            hl.NvimTreeRootFolder = { fg = palette.bone, bold = true }
            hl.NvimTreeSpecialFile = { fg = palette.bone, bold = true }
            hl.NvimTreeExecFile = { fg = palette.red }

            -- Leap
            hl.LeapLabel = { fg = palette.green }
        end,
    },

    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight")

        -- clear backgrounds for statusline and lualine groups
        local function clear_bg(group)
            vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end

        clear_bg("StatusLine")
        clear_bg("StatusLineNC")

        -- lualine defines separate highlight groups per mode and section
        for _, sec in ipairs({ "a", "b", "c", "x", "y", "z" }) do
            for _, mode in ipairs({
                "normal",
                "insert",
                "visual",
                "replace",
                "command",
                "inactive",
            }) do
                pcall(clear_bg, "lualine_" .. sec .. "_" .. mode)
            end
        end
    end,
}
