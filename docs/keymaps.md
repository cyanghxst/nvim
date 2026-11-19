# Keymaps

The leader key is `Space`, and the local leader is also `Space`. All modes are normal (`n`) unless noted.

## General

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>l` | n | Open Lazy |
| `<Esc>` | n | Clear search highlight |
| `<CR>` | n | Close a floating window, else clear search highlight, else show diagnostics under the cursor |
| `yc` | n | Duplicate line and comment out the original |
| `J` / `K` | v | Move selection down / up |
| `<` / `>` | v | Indent and keep the selection |
| `j` / `k` | n | Move by display line when no count is given |

## Windows and buffers

| Keys | Action |
| --- | --- |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move to the left / lower / upper / right window |
| `H` / `L` | Previous / next buffer |
| `<leader>ww` | Delete buffer |
| `<leader>wq` | Delete buffer (force) |
| `<leader>s` | Toggle file tree |

## Telescope

| Keys | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fa` | Find all files (hidden, ignored, followed symlinks) |
| `<leader>fg` | Live grep |
| `<leader>ft` | Help tags |
| `<leader>fh` | Highlights |
| `<leader>fb` | Buffers |
| `<leader>fo` | Old files |

Inside the Telescope prompt: `<Esc>` closes it and `?` toggles the preview.

## LSP

Set when a language server attaches to the buffer.

| Keys | Mode | Action |
| --- | --- | --- |
| `<leader>gg` | n | Hover |
| `<leader>gd` | n | Go to definition |
| `<leader>gD` | n | Go to declaration |
| `<leader>gi` | n | Go to implementation |
| `<leader>gt` | n | Go to type definition |
| `<leader>gr` | n | Go to references |
| `<leader>gs` | n | Signature help |
| `<leader>rr` | n | Rename symbol |
| `<leader>gf` | n, v | Format |
| `<leader>ga` | n | Code action |
| `<leader>gl` | n | Open diagnostic float |
| `<leader>gp` / `<leader>gn` | n | Previous / next diagnostic |
| `<leader>tr` | n | Document symbols |

## Java

Only active in Java buffers.

| Keys | Action |
| --- | --- |
| `<leader>go` | Organize imports |
| `<leader>gu` | Update project config |
| `<leader>tc` | Run test class |

## Completion

Provided by blink.cmp.

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-Space>` | i | Show completion or documentation, press again to hide documentation |
| `<C-e>` | i | Hide completion |
| `<CR>` | i | Accept |
| `<Up>` / `<C-p>` | i | Select previous |
| `<Down>` / `<C-n>` | i | Select next |
| `<C-Up>` / `<C-Down>` | i | Scroll documentation up / down |

## Snippets

Provided by LuaSnip.

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-k>` | i, s | Expand snippet or jump to the next placeholder |
| `<C-j>` | i, s | Jump to the previous placeholder |
| `<C-l>` | i | Cycle snippet choices |

## Motion

| Keys | Mode | Action |
| --- | --- | --- |
| `s` | n, x, o | Leap within the current window |
| `gs` | n, x, o | Leap across all windows |

## Menu

| Keys | Mode | Action |
| --- | --- | --- |
| `<C-t>` | n | Open the default menu |
| `<RightMouse>` | n, v, i | Open the context menu |
