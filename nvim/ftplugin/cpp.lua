local ft = require('guard.filetype')

-- Setup clang-format
ft("cpp"):fmt("clang-format")

-- Fix syntax highlighting for preprocessor directives
vim.api.nvim_set_hl(0, '@lsp.type.comment.cpp', {})
