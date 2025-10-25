vim.filetype.add({
    filename = {
        [".zprofile"] = "zsh",
        [".zshrc"] = "zsh",
        ["zprofile"] = "zsh",
        ["zshrc"] = "zsh",
        ["gitconfig"] = "gitconfig",
    },
    extension = {
        zsh = "zsh",
        jsonc = "jsonc",
        toml = "toml",
        conf = "conf",
    },
    pattern = {
        [".*%.conf%.yml"] = "yaml",
        [".*%.conf%.yaml"] = "yaml",
        [".*%.env%..*"] = "sh",
        ["%.env"] = "sh",
    },
})
