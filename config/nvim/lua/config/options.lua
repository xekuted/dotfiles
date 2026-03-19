-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false
vim.api.nvim_set_hl(0, "Cursor", { fg = "#121212", bg = "#C4693D" })
vim.api.nvim_set_hl(0, "lCursor", { fg = "#121212", bg = "#C4693D" })
vim.api.nvim_set_hl(0, "CursorIM", { fg = "#121212", bg = "#C4693D" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#C4693D", italic = true })
