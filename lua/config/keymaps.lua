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

-- 核心函数：删除并重新设置n/N键映射（封装为函数便于复用）
local function setup_n_mappings()
  -- 1. 彻底删除所有模式的n键映射（包括可能的递归绑定）
  pcall(vim.keymap.del, "n", "n")
  pcall(vim.keymap.del, "x", "n")
  pcall(vim.keymap.del, "o", "n")
  -- 强制覆盖原生搜索的n键映射（关键：使用<Plug>映射的底层替代）
  map({ "n", "x", "o" }, "n", "^", {
    noremap = true, -- 禁用递归，彻底切断与原生搜索的关联
    silent = true,
    desc = "跳转到行首非空字符（覆盖搜索）",
  })

  -- 2. 同步处理N键
  pcall(vim.keymap.del, "n", "N")
  pcall(vim.keymap.del, "x", "N")
  pcall(vim.keymap.del, "o", "N")
  map({ "n", "x", "o" }, "N", "0", {
    noremap = true,
    desc = "跳转到行首（覆盖搜索）",
  })
end

-- 事件1：Lazy插件加载完成后（首次设置）
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = setup_n_mappings,
})

-- 事件2：每次进入缓冲区时（防止后续操作重新绑定原生映射）
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*", -- 对所有文件生效
  callback = setup_n_mappings,
})

-- 事件3：搜索操作完成后（防止搜索后原生映射被重新激活）
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "/,?", -- 针对搜索命令模式
  callback = setup_n_mappings,
})
