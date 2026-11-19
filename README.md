# nvim

Personal Neovim configuration, managed with [Dotbot](https://github.com/anishathalye/dotbot). The config lives under `nvim/` and is symlinked into `~/.config/nvim` by `./install`. Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim), which bootstraps itself on first launch.

## Showcase

![Dashboard](docs/screenshots/dashboard.webp)

*Startup dashboard.*

![Right-click context menu](docs/screenshots/context-menu.webp)

*Right-click context menu.*

## Structure

```bash
.
├── .dotbot/            # Dotbot (git submodule)
├── .install.conf.yaml  # Dotbot config: which file links where
├── install             # Entry point: syncs submodules, runs Dotbot
├── LICENSE
├── docs/               # Keymap reference and screenshots
└── nvim/               # The Neovim config, linked to ~/.config/nvim
```

## Config

```bash
nvim/
├── init.lua            # Leader keys, then loads the core modules
├── ftplugin/           # Per-filetype settings (C++, Java)
├── after/ftplugin/     # Overrides loaded after runtime ftplugins (conf, gitconfig)
├── snippets/           # VSCode-style snippets: cpp, java, javascript, lua, python, typescript
└── lua/
    ├── core/           # autocmds, filetypes, keymaps, options, plugins (lazy.nvim bootstrap), statusline
    ├── config/nvmenu/  # Right-click and Ctrl-t context menu: items and UI
    └── plugins/        # One spec file per plugin, auto-loaded by lazy.nvim
```

## Plugins

| Area | Plugins |
| --- | --- |
| Colorscheme | [tokyonight](https://github.com/folke/tokyonight.nvim) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [mason](https://github.com/williamboman/mason.nvim), [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim), [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim), [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls), [schemastore](https://github.com/b0o/SchemaStore.nvim) |
| Completion and snippets | [blink.cmp](https://github.com/saghen/blink.cmp), [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| Formatting | [conform.nvim](https://github.com/stevearc/conform.nvim) (stylua, prettier, yamlfmt, clang-format; trailing whitespace trimmed on save) |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag), [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) |
| Navigation | [telescope](https://github.com/nvim-telescope/telescope.nvim), [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua), [leap](https://codeberg.org/andyg/leap.nvim) (plus [leap-spooky](https://github.com/ggandor/leap-spooky.nvim)) |
| Editing | [nvim-surround](https://github.com/kylechui/nvim-surround), [nvim-autopairs](https://github.com/windwp/nvim-autopairs), [vim-repeat](https://github.com/tpope/vim-repeat) |
| UI | [alpha](https://github.com/goolord/alpha-nvim), [gitsigns](https://github.com/lewis6991/gitsigns.nvim), [mini.icons](https://github.com/echasnovski/mini.icons), [mini.indentscope](https://github.com/echasnovski/mini.indentscope), [mini.bufremove](https://github.com/echasnovski/mini.bufremove), [neoscroll](https://github.com/karb94/neoscroll.nvim), [menu](https://github.com/nvzone/menu) |
| AI | [opencode](https://github.com/sudo-tee/opencode.nvim) |

## Keymaps

The leader key is `Space`. See [docs/keymaps.md](docs/keymaps.md) for the full list.

## Language servers

Installed through Mason: `html`, `cssls`, `lua_ls`, `pyright`, `jsonls`, `clangd`, `marksman`, `tailwindcss`, `ts_ls`, `bashls`, `astro`, `arduino_language_server`, plus `jdtls` for Java.

## Setup

### Requirements

- Neovim 0.11 or newer (the config uses `vim.lsp.config`)
- `git`, and a C compiler for building Treesitter parsers
- A [Nerd Font](https://www.nerdfonts.com/) for icons. I use JetBrains Mono Nerd Font at size 14
- `node` and `npm` for several Mason packages

### Install

> [!WARNING]
> This config is tailored to my setup and may overwrite your existing `~/.config/nvim`. Use it as a reference and borrow what you need. Install at your own risk.

1. Clone the repo with its submodules:

```bash
git clone --recurse-submodules https://github.com/cyanghxst/nvim.git ~/code/config/nvim
```

2. Move into the repo:

```bash
cd ~/code/config/nvim
```

3. Run the installer:

```bash
./install
```

4. Open Neovim. lazy.nvim installs itself and all plugins on first launch, and Mason installs the language servers and formatters listed above.

## License

This Neovim config is licensed under the [MIT License](LICENSE).
