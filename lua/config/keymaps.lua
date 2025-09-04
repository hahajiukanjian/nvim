-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- ========= 基础映射 =========
map("i", "jk", "<ESC>")
map("n", "zz", "zt")

map({ "n", "x" }, "J", "5gj")
map({ "n", "x" }, "K", "5gk")

map({ "n", "x" }, ")", "J")
map({ "n", "x" }, "m", "$")
map({ "n", "x" }, "M", "$")

map({ "n", "x", "o" }, "S", "<cmd>w<CR>")
map({ "n", "x", "o" }, "s", "<NOP>")
map({ "n", "x", "o" }, "ss", "<cmd>noh<CR>")

-- map({ "n", "x" }, ";", ":")
-- map({ "n", "x" }, "；", ":")
map({ "n", "x" }, "；", ";")
map({ "n", "x" }, "：", ":")
map({ "n", "x" }, "-", "n")
map({ "n", "x" }, "_", "N")
map({ "n", "x" }, "W", "%")
map({ "n", "x" }, "E", "V")
map({ "n", "x" }, "e", "<C-v>")

map({ "n", "x" }, "0", function() return vim.lsp.buf.hover() end)

map({ "n", "x", "o" }, "{", "<Cmd>BufferLineCyclePrev<CR>", { desc = "上一个 buffer" })
map({ "n", "x", "o" }, "}", "<Cmd>BufferLineCycleNext<CR>", { desc = "下一个 buffer" })

map("x", "<tab>", ">gv", { desc = "增加缩进" })
map("x", "<S-tab>", "<gv", { desc = "减少缩进" })

for i = 1, 9 do
  map({ "n", "v" }, "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "跳转到第 " .. i .. " 个 buffer",
  })
end

-- ========= 强制覆盖映射 (n/N/H/L) =========
local function setup_motions()
  local function remap(keys, target, desc)
    map({ "n", "x", "o" }, keys, target, {
      noremap = true,
      silent = true,
      unique = false,
      desc = desc,
    })
  end

  remap("n", "^", "跳转到行首非空字符")
  remap("N", "0", "跳转到行首")
  remap("H", "b", "上一个单词")
  remap("L", "w", "下一个单词")
end

vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = setup_motions })
vim.api.nvim_create_autocmd("LspAttach", { callback = setup_motions })


-- ========= 函数参数提示与自动补全 =========
-- Insert 模式：Ctrl+Shift+E（Windows）触发函数参数提示
map("i", "<C-S-e>", function()
  vim.lsp.buf.signature_help()
end, { desc = "显示函数参数提示" })

-- Insert 模式：Cmd+Shift+E（Mac）触发函数参数提示
map("i", "<D-S-e>", function()
  vim.lsp.buf.signature_help()
end, { desc = "显示函数参数提示（Mac）" })

-- Insert 模式：Ctrl+E（Windows）/ Cmd+E（Mac）触发自动补全窗口
-- （注：此映射也可通过 nvim-cmp 的 mapping 配置，这里确保一致性）
map("i", "<C-e>", function()
  require("cmp").complete()
end, { desc = "触发自动补全窗口" })
map("i", "<D-e>", function()
  require("cmp").complete()
end, { desc = "触发自动补全窗口（Mac）" })

