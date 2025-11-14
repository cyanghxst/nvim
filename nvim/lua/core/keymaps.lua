local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ----------------
-- General Keymaps
-- ----------------

-- plugin management
keymap("n", "<leader>l", "<cmd>Lazy<cr>", opts)

-- search and highlights
keymap("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- duplicate line and comment
keymap("n", "yc", "yygccp", { remap = true, silent = true })

-- block movement
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- indent blocks
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- better line navigation
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- clear highlight search and toggle floating windows
keymap("n", "<cr>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
    else
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end
end, { desc = "Clear Highlights or Toggle Diagnostics" })

-- ---------------------------
-- Window & Buffer Navigation
-- ---------------------------

-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- buffer navigation
keymap("n", "H", "<cmd>bprevious<cr>", opts)
keymap("n", "L", "<cmd>bnext<cr>", opts)

-- ------------------------
-- Plugin-Specific Keymaps
-- ------------------------

-- nvimtree
keymap("n", "<leader>s", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle" })

-- bufremove
keymap("n", "<leader>ww", function()
    require("mini.bufremove").delete(0, false)
end, { desc = "Delete Buffer" })
keymap("n", "<leader>wq", function()
    require("mini.bufremove").delete(0, true)
end, { desc = "Delete Buffer (Force)" })

-- ------------------
-- Telescope Keymaps
-- ------------------

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
keymap(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "Find All Files" }
)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find Grep" })
keymap("n", "<leader>ft", "<cmd>Telescope help_tags<CR>", { desc = "Find Tags" })
keymap("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Find Highlights" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find Oldfiles" })

-- ------------
-- LSP Keymaps
-- ------------

keymap("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, { desc = "Hover" })
keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts, { desc = "Go to definition" })
keymap("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts, { desc = "Go to declaration" })
keymap("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts, { desc = "Go to implementation" })
keymap("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts, { desc = "Go to type definition" })
keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, { desc = "Go to references" })
keymap("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, { desc = "Go to signature" })
keymap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, { desc = "Rename symbol" })
keymap({ "n", "v" }, "<leader>gf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts, { desc = "Format" })
keymap("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, { desc = "Code action" })
keymap("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, { desc = "Open float" })
keymap("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts, { desc = "Go to previous" })
keymap("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts, { desc = "Go to next" })
keymap("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts, { desc = "Document symbol" })
keymap("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", opts, { desc = "Completion" })

-- --------------------------
-- Filetype-Specific Keymaps
-- --------------------------

keymap("n", "<leader>go", function()
    if vim.bo.filetype == "java" then
        require("jdtls").organize_imports()
    end
end, opts)

keymap("n", "<leader>gu", function()
    if vim.bo.filetype == "java" then
        require("jdtls").update_projects_config()
    end
end, opts)

keymap("n", "<leader>tc", function()
    if vim.bo.filetype == "java" then
        require("jdtls").test_class()
    end
end, opts)

-- ----------
-- LuaSnip
-- ----------

keymap({ "i", "s" }, "<C-k>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true, desc = "Expand or jump snippet" })

keymap({ "i", "s" }, "<C-j>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true, desc = "Jump to previous snippet placeholder" })

keymap("i", "<C-l>", function()
    local ls = require("luasnip")
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true, desc = "Cycle snippet choices" })
