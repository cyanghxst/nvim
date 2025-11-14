local M = {}

M.setup = function()
  -- Override menu modules with custom versions
  package.preload["menu.ui"] = function() return require("config.nvmenu.ui") end
  package.preload["menus.default"] = function() return require("config.nvmenu.default") end

  -- Override nvim_open_win to use rounded borders
  local api = vim.api
  local original_nvim_open_win = api.nvim_open_win
  api.nvim_open_win = function(buf, enter, config)
    if config.border == "single" then
      config.border = "rounded"
    end
    return original_nvim_open_win(buf, enter, config)
  end
end

return M
