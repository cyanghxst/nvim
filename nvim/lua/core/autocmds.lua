-- Disable sign column in tree
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- if vim.bo.filetype == "neo-tree" then
        if vim.bo.filetype == "NvimTree" then
            vim.wo.statuscolumn = ""
        end
    end,
})

-- Disable sign column in alpha
vim.api.nvim_create_autocmd("Filetype", {
    pattern = "alpha",
    callback = function()
        vim.opt_local.statuscolumn = ""
    end,
})

-- Autoclose tree
vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        local wins = vim.api.nvim_list_wins()
        if #wins ~= 1 then
            return
        end
        local buf = vim.api.nvim_win_get_buf(wins[1])
        if vim.bo[buf].filetype == "NvimTree" then
            vim.api.nvim_win_close(wins[1], true)
        end
    end,
})

vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#a9b1d6", bold = false, italic = false })

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
    end,
})

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Disable mini.indentscope when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.g.miniindentscope_disable = true
    end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.g.miniindentscope_disable = false
    end,
})

-- Highlight yanked text for 300ms
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
    end,
})

-- Jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("%.git/") then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Fix auto-indentation for YAML files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        vim.opt_local.indentkeys:remove({ "0#", "<:>" })
    end,
})

-- Re-enable lsp diagnostics after autoformatting
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        vim.defer_fn(function()
            vim.diagnostic.enable(true, { bufnr = args.buf })
        end, 100)
    end,
})

-- Enable syntax highlighting for sshconfig
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sshconfig",
    callback = function(args)
        vim.bo[args.buf].syntax = "sshconfig"
    end,
})
