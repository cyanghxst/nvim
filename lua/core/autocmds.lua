-- Autoclose Nvimtree
vim.api.nvim_create_autocmd({"QuitPre"}, {
    callback = function() vim.cmd("NvimTreeClose") end,
})

-- Disable automatic comment insertion
vim.cmd[[autocmd FileType * setlocal formatoptions-=cro]]

-- Disable mini.indentscope when entering insert mode
vim.cmd[[
augroup DisableMiniIndentScope
autocmd!
autocmd InsertEnter * lua vim.g.miniindentscope_disable = true
autocmd InsertLeave * lua vim.g.miniindentscope_disable = false
augroup END
]]

-- Highlight yanked text for 300ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=300})
augroup END
]]

-- Jump to last edit position on opening file
vim.cmd([[
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

-- Disable lsp semantic tokens
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
});
