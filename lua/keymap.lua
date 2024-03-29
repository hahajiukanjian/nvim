-- 定义一个函数来设置键位映射
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true } -- 默认为禁止递归映射
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function smart_quit()
    -- 获取当前列出的 buffer 数量
    local buffers = vim.fn.len(vim.fn.getbufinfo({buflisted = 1}))
    -- 如果只有一个 buffer，执行 :q
    if buffers == 1 then
        vim.cmd('q')
    -- 否则，执行 :bd 关闭当前 buffer
    else
        vim.cmd('bd')
    end
end

-- 将 Q 键映射到 smart_quit 函数
vim.api.nvim_set_keymap('n', 'Q', ':lua smart_quit()<CR>', {noremap = true, silent = true})


-- noremal mode
map('n', 's', '<NOP>')
map('n', '<C-l>', '<NOP>')
map('n', '<C-k>', '<NOP>')
map('n', '<C-j>', '<NOP>')
map('n', '<C-h>', '<NOP>')
map('n', 's', '<cmd>noh<CR>')
map('n', 'S', '<cmd>w<CR>')
-- map('n', 'Q', '<cmd>bd<CR>')
map('n', 'J', '5j')
map('n', 'K', '5k')
map('n', 'H', 'b')
map('n', 'L', 'w')
map('n', '0', 'J')
map('n', ')', 'K')
map('n', 'n', '^')
map('n', 'N', '0')
map('n', 'm', '$')
map('n', 'M', '$')
map('n', ';', ':')
map('n', 'e', '<C-v>')
map('n', 'E', 'V')
map('n', '1', '.')
map('n', 'zz', 'zt')
map('n', '-', 'nzz')
map('n', '_', 'Nzz')
map('n', '<leader>ss', '<C-w>v')
map('n', '<leader>sh', '<C-w>s')
-- https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
map("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
map("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })
map("n", "<leader>n", "<cmd>bNext<CR>")
-- map("n", "<leader>qq", "<cmd>q<CR>")
map("n", "<leader>ww", "<C-w><C-w>")
map("n", "U", "<C-r>")

-- insert mode
map('i', 'jk', '<ESC>')

-- visual mode
map('x', 'n', '^')
map('x', 'N', '0')
map('x', 'm', '$')
map('x', 'M', '$')
map('x', 'J', '5j')
map('x', 'K', '5k')
map('x', 'H', 'b')
map('x', 'L', 'w')
map('x', '<tab>', '>gv')
map('x', '<S-tab>', '<gv')

