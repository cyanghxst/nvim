return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
        local colors = { gray = "#414868" }
        local minimal_theme = {
            normal = {
                a = { fg = colors.gray, bg = nil },
                b = { fg = colors.gray, bg = nil },
                c = { fg = colors.gray, bg = nil },
            },
            inactive = {
                a = { fg = colors.gray, bg = nil },
                b = { fg = colors.gray, bg = nil },
                c = { fg = colors.gray, bg = nil },
            },
        }
        return {
            options = {
                theme = minimal_theme,
                disabled_filetypes = { statusline = { "alpha", "lazy", "NvimTree", "Telescope" } },
                globalstatus = true,
                component_separators = "",
                section_separators = "",
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = { { "branch", icons_enabled = false } },
                lualine_y = { "location", "filename" },
                lualine_z = { { "progress", padding = { left = 1, right = 0 } } },
            },
        }
    end,
}
