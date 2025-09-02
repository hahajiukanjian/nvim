-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<ESC>")

map({ "n", "x" }, "K", "<NOP>")

map({ "n", "x" }, "J", "5gj")
map({ "n", "x" }, "K", "5gk", { noremap = true })

map({ "n", "x" }, "0", function()
  return vim.lsp.buf.hover()
end)

map({ "n", "x" }, ")", "J")

map({ "n", "x", "o" }, "n", "^", {
  noremap = true, -- 关键：禁用递归映射，确保覆盖默认值
  -- force = true, -- 强制覆盖默认的"下一个搜索结果"
  silent = true, -- 不显示命令回显（可选，提升体验）
  desc = "跳转到行首非空字符", -- which-key 描述
})
map({ "n", "x" }, "m", "$")
map({ "n", "x" }, "N", "0")
map({ "n", "x" }, "M", "$")

map({ "n", "x", "o" }, "S", "<cmd>w<CR>", { noremap = true })

map({ "n", "x" }, ";", ":")
map({ "n", "x" }, "；", ":")
map({ "n", "x" }, "-", "n")
map({ "n", "x" }, "_", "N")
map({ "n", "x" }, "W", "%")
map({ "n", "x" }, "E", "V")
map({ "n", "x" }, "e", "<C-v>")
