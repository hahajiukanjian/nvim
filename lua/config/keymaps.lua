-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("n", "zz", "zt")

map({ "n", "x" }, "K", "<NOP>")

map({ "n", "x" }, "J", "5gj")
map({ "n", "x" }, "K", "5gk", { noremap = true })

map({ "n", "x" }, "0", function()
  return vim.lsp.buf.hover()
end)

map({ "n", "x" }, ")", "J")

map({ "n", "x", "o" }, "n", "^", {
  noremap = true, -- 关键：禁用递归映射，确保覆盖默认值
  silent = true, -- 不显示命令回显（可选，提升体验）
  desc = "跳转到行首非空字符", -- which-key 描述
})
map({ "n", "x" }, "m", "$")
map({ "n", "x" }, "N", "0")
map({ "n", "x" }, "M", "$")

map({ "n", "x", "o" }, "S", "<cmd>w<CR>", { noremap = true })
map({ "n", "x", "o" }, "s", "<NOP>")
map({ "n", "x", "o" }, "ss", "<cmd>noh<CR>")

map({ "n", "x" }, ";", ":")
map({ "n", "x" }, "；", ":")
map({ "n", "x" }, "-", "n")
map({ "n", "x" }, "_", "N")
map({ "n", "x" }, "W", "%")
map({ "n", "x" }, "E", "V")
map({ "n", "x" }, "e", "<C-v>")

map({ "n", "x", "o" }, "{", "<Cmd>BufferLineCyclePrev<CR>", { desc = "上一个buffer" })
map({ "n", "x", "o" }, "}", "<Cmd>BufferLineCycleNext<CR>", { desc = "下一个buffer" })

map({ "n", "x", "o" }, "L", "w")

map('x', '<tab>', '>gv', { desc = '增加缩进' })
map('x', '<S-tab>', '<gv', { desc = '减少缩进' })

for i = 1, 9 do
  vim.keymap.set({ "n", "v", "i" }, "<leader>" .. i .. "", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "跳转到第 " .. i .. " 个 buffer"
  })
end

-- 核心函数：删除并重新设置n/N键映射（封装为函数便于复用）
local function setup_n_mappings()
  pcall(vim.keymap.del, "n", "n")
  pcall(vim.keymap.del, "x", "n")
  pcall(vim.keymap.del, "o", "n")
  map({ "n", "x", "o" }, "n", "^", {
    noremap = true,
    silent = true,
    desc = "跳转到行首非空字符",
    unique = false,
  })

  pcall(vim.keymap.del, "n", "N")
  pcall(vim.keymap.del, "x", "N")
  pcall(vim.keymap.del, "o", "N")
  map({ "n", "x", "o" }, "N", "0", {
    noremap = true,
    desc = "跳转到行首",
    unique = false,
  })

  pcall(vim.keymap.del, "n", "H")
  pcall(vim.keymap.del, "x", "H")
  pcall(vim.keymap.del, "o", "H")
  map({ "n", "x", "o" }, "H", "b", {
    noremap = true,
    desc = "上一个单词",
    unique = false,
  })

  pcall(vim.keymap.del, "n", "L")
  pcall(vim.keymap.del, "x", "L")
  pcall(vim.keymap.del, "o", "L")
  map({ "n", "x", "o" }, "L", "w", {
    noremap = true,
    desc = "下一个单词",
    unique = false,
  })
end

-- Lazy 完全加载后
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = setup_n_mappings,
})

-- 每次 attach LSP 时再覆盖
vim.api.nvim_create_autocmd("LspAttach", {
  callback = setup_n_mappings,
})
