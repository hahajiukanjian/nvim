-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local g = vim.g
local opt = vim.opt

-- 常规窗口边框（分割窗口、标签页等）
opt.winborder = "rounded" -- 单实线边框
-- 可选值："none"（无）、"single"（单实线）、"double"（双实线）、"rounded"（圆角，部分终端支持）

opt.colorcolumn = "80"

g.disable_autoformat = true

if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_theme = 'auto'
  vim.g.neovide_input_ime = true
  vim.g.neovide_cursor_animation_length = 0.10
  vim.g.neovide_cursor_trail_size = 1.0
  vim.opt.linespace = 3
end
