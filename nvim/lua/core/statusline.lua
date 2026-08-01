local M = {}

local disabled = { alpha = true, lazy = true, NvimTree = true, Telescope = true }

local function branch()
  local b = vim.fn.systemlist("git branch --show-current 2>/dev/null")[1]
  return b or ""
end

function M.render()
  if disabled[vim.bo.filetype] then return "" end
  local parts = {}
  local b = branch()
  if b ~= "" then table.insert(parts, b) end
  local name = vim.fn.expand("%:t")
  if vim.bo.modified then
    name = name .. " [+]"
  elseif vim.bo.readonly or not vim.bo.modifiable then
    name = name .. " [-]"
  end
  table.insert(parts, name)
  table.insert(parts, vim.fn.line(".") .. ":" .. vim.fn.col("."))
  return " " .. table.concat(parts, "  ")
end

return M
