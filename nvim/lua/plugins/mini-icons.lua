return {
    "echasnovski/mini.icons",
    enabled = true,
    opts = {},
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
    -- config = {
    --     style = "ascii",
    -- },
}
