return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
    },
    version = "*",
    opts = {
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },
        completion = {
            accept = { auto_brackets = { enabled = true } },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                update_delay_ms = 50,
                treesitter_highlighting = true,
                window = {
                    border = "rounded",
                    winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder",
                },
            },
            list = { selection = { preselect = true, auto_insert = true } },
            menu = {
                winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel",
                scrollbar = false,
                border = "rounded",
                cmdline_position = function()
                    if vim.g.ui_cmdline_pos ~= nil then
                        local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                        return { pos[1] - 1, pos[2] }
                    end
                    local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                    return { vim.o.lines - height, 0 }
                end,
                draw = {
                    columns = { { "label", "kind_icon", gap = 2 }, { "kind" } },
                    components = {
                        kind_icon = {
                            text = function(item)
                                local kind = require("lspkind").symbol_map[item.kind] or ""
                                return kind .. " "
                            end,
                            -- highlight = "cmpitemkind",
                        },
                        label = {
                            text = function(item)
                                return item.label
                            end,
                            highlight = "cmpitemabbr",
                        },
                        kind = {
                            text = function(item)
                                return item.kind
                            end,
                            -- highlight = "cmpitemkind",
                        },
                    },
                },
            },
        },

        keymap = {
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-up>"] = { "scroll_documentation_up", "fallback" },
            ["<C-down>"] = { "scroll_documentation_down", "fallback" },
        },

        -- experimental signature help support
        signature = {
            enabled = true,
            window = {
                border = "rounded",
                winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder",
            },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            cmdline = function()
                local type = vim.fn.getcmdtype()
                -- search forward and backward
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                -- commands
                if type == ":" then
                    return { "cmdline" }
                end
                return {}
            end,
            providers = {
                lsp = {
                    min_keyword_length = 1,
                    score_offset = 0,
                },
                path = {
                    min_keyword_length = 0,
                },
                snippets = {
                    min_keyword_length = 3,
                    score_offset = 100,
                },
                buffer = {
                    min_keyword_length = 5,
                    max_items = 5,
                },
                cmdline = {
                    min_keyword_length = 3,
                },
            },
        },
    },
}
