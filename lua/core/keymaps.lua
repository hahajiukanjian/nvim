vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, { desc = "代码修复", noremap = true, silent = true })
vim.keymap.set("v", "<M-CR>", vim.lsp.buf.code_action, { desc = "代码修复（选中）", noremap = true, silent = true })


-- 定义一个函数来设置键位映射
local function map(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true, desc = desc } -- 默认为禁止递归映射并添加描述
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)                        -- 使用 vim.keymap.set 来支持 desc 参数
end

function smart_quit()
    -- 获取当前列出的 buffer 数量
    local buffers = vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
    -- 获取当前窗口数量
    local windows = vim.fn.win_getid() -- 获取窗口的数量

    -- 如果有多个窗口，执行 :q 退出当前窗口
    if windows > 1000 then
        vim.cmd('q')
        -- 如果只有一个窗口，判断 buffer 的数量
    elseif buffers == 1 then
        vim.cmd('q')
        -- 否则执行 :bd 关闭当前 buffer
    else
        vim.cmd('bd')
    end
end

------------------------------ command config -----------------------------
-- cmd+1~9 跳转到第 N 个 buffer
for i = 1, 9 do
  vim.keymap.set({ "n", "v" }, "<D-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "跳转到第 " .. i .. " 个 buffer"
  })
end

-- cmd+w 关闭当前 buffer
vim.keymap.set({ "n", "v" }, "<D-w>", ":lua smart_quit()<CR>", {
  desc = "关闭当前 buffer"
})

-- shift+cmd+w 关闭除当前外的其他 buffer
vim.keymap.set({ "n", "x" }, "<D-W>", "<Cmd>BufferLineCloseOthers<CR>", {
  desc = "关闭其他 buffer"
})

vim.keymap.set({ "n", "x" }, "<D-v>", '"+p', { desc = "使用系统剪切板的粘贴" })
vim.keymap.set({ "n", "x" }, "<D-c>", '"+y', { desc = "使用系统剪切板的复制" })

------------------------------ normal config -----------------------------
-- 将 Q 键映射到 smart_quit 函数
vim.api.nvim_set_keymap('n', 'Q', ':lua smart_quit()<CR>', { noremap = true, silent = true })

-- 禁用 Ctrl+方向键
map('n', '<C-l>', '<NOP>', '禁用 Ctrl + l')
map('n', '<C-k>', '<NOP>', '禁用 Ctrl + k')
map('n', '<C-j>', '<NOP>', '禁用 Ctrl + j')
map('n', '<C-h>', '<NOP>', '禁用 Ctrl + h')

map('n', 'W', '%')

map('n', '<leader>y', '\"+y', '复制到系统剪贴板')

-- 水平新增窗口
-- 垂直新增窗口
map('n', '<leader>ss', '<C-w>v', '水平分割窗口')
map('n', '<leader>sh', '<C-w>s', '垂直分割窗口')

-- 禁用 s 键
map('n', 's', '<NOP>', '禁用 s 键')
-- vim.keymap.set("n", "K", "<Nop>", { silent = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "man",
--   callback = function()
--     -- 删除默认的 :Man 绑定
--     pcall(vim.keymap.del, "n", "K", { buffer = 0 })
-- 
--     -- 映射为向上移动 5 行
--     vim.keymap.set("n", "K", "5k", { buffer = 0, desc = "浮窗中 K 移动 5 行" })
--   end,
-- })

-- vim.keymap.set("n", "K", nil, { buffer = bufnr })
-- 按 s 键取消高亮搜索结果
map('n', 's', '<cmd>noh<CR>', '清除搜索高亮')
-- S 键保存文件
map('n', 'S', '<cmd>w<CR>', '保存文件')
map('n', '<D-s>', '<cmd>w<CR>', '保存文件')

-- J 和 K 键快速移动 5 行
map('n', 'J', '5j', '向下跳 5 行')
map('n', 'K', '5k', '向上跳 5 行')
-- H 和 L 键快速在单词间跳转
map('n', 'H', 'b', '跳到上一个单词的开头')
map('n', 'L', 'w', '跳到下一个单词的开头')

-- 0 和 ) 键自定义导航
-- map('n', '0', 'K', '')
vim.keymap.set("n", "0", function()
  vim.lsp.buf.hover()
end, { desc = "LSP Hover" })
map('n', ')', 'J', '')

-- n 和 N 键自定义行为
map('n', 'n', '^', '跳到行首')
map('n', 'N', '0', '跳到行首')
-- m 和 M 键移动到行尾
map('n', 'm', '$', '跳到行尾')
map('n', 'M', '$', '跳到行尾')

-- ; 键映射为命令模式
map('n', ';', ':', '打开命令行模式')

-- e 和 E 键进入可视模式
map('n', 'e', '<C-v>', '进入可视块模式')
map('n', 'E', 'V', '进入可视行模式')

-- zz 键将当前行移动到窗口顶部
map('n', 'zz', 'zt', '将当前行移动到窗口顶部')

-- n 和 N 键的居中跳转
map('n', '-', 'nzz', '向下搜索并居中显示')
map('n', '_', 'Nzz', '向上搜索并居中显示')

-- 处理折行时的移动操作
map('n', 'j', [[v:count ? 'j' : 'gj']], '处理折行时向下移动', { noremap = true, expr = true })
map('n', 'k', [[v:count ? 'k' : 'gk']], '处理折行时向上移动', { noremap = true, expr = true })

-- 在窗口之间切换
map('n', '<leader>ww', '<C-w><C-w>', '切换到下一个窗口')

-- U 键映射为撤销恢复
map('n', 'U', '<C-r>', '重新做上一次撤销的操作')

-- 切换到上下一个 buffer
map('n', '<C-S-l>', '<cmd>bnext<cr>', '切换到上一个buffer')
map('n', '<C-S-h>', '<cmd>bprev<cr>', '切换到下一个buffer')

-- 快速切换到上下一个快速修复项（quickfix item）
map('n', ']q', '<cmd>cnext<cr>', '切换到下一个快速修复项')
map('n', '[q', '<cmd>cprev<cr>', '切换到上一个快速修复项')

map('n', '[[', '<C-o>', '回到上次编辑的位置')
map('n', ']]', '<C-i>', '返回上次编辑的位置')

map('n', 'y', '"+y', '复制到系统剪切板')
map('n', 'd', '"+d', '剪切到系统剪切板')

------------------------------ insert config -----------------------------
-- 插入模式下使用 'jk' 退出
map('i', 'jk', '<ESC>', '插入模式下退出到普通模式')
map('i', '<D-s>', '<cmd>w<CR>', '保存文件')
map("i", "D-v>", "<C-r>+", "使用系统剪切板的粘贴")

------------------------------ visual config -----------------------------
-- 可视模式中的快速移动
map('x', 'n', '^', '跳到行首')
map('x', 'N', '0', '跳到行首')
map('x', 'm', '$', '跳到行尾')
map('x', 'M', '$', '跳到行尾')
map('x', 'J', '5j', '向下跳 5 行')
map('x', 'K', '5k', '向上跳 5 行')
map('x', 'H', 'b', '跳到上一个单词的开头')
map('x', 'L', 'w', '跳到下一个单词的开头')

-- 缩进和反向缩进
map('x', '<tab>', '>gv', '增加缩进')
map('x', '<S-tab>', '<gv', '减少缩进')

-- 可视模式下复制到系统剪贴板
map('x', '<leader>y', '\"+y', '复制到系统剪贴板')
map('x', 'W', '%')

map('x', 'S', '<cmd>w<CR>')
map('x', 'y', '"+y', '复制到系统剪切板')
map('x', 'd', '"+d', '剪切到系统剪切板')
map('x', '<D-s>', '<cmd>w<CR>', '保存文件')
