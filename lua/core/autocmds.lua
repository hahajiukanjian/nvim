-- [[ Basic Autocommands ]]
-- 参见 `:help lua-guide-autocommands` 了解更多关于自动命令的帮助信息

-- 定义一个用于创建自动命令组的函数
local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

-- 当复制文本时高亮显示
-- 可以在普通模式下用 `yap` 试试 (复制一个段落)
-- 参见 `:help vim.highlight.on_yank()` 获取更多帮助信息
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',  -- 描述该自动命令的作用
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),  -- 创建自动命令组
  callback = function()
    vim.highlight.on_yank()  -- 执行高亮操作
  end,
})

-- 恢复光标位置
-- 在文件读取后恢复到上次编辑的光标位置
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },  -- 匹配所有文件
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)  -- 恢复光标位置
  end,
})

-- 大文件处理
-- 通过 `vim.filetype.add` 为大文件类型设置特殊处理
vim.filetype.add {
  pattern = {
    ['.*'] = {  -- 匹配所有文件
      function(path, buf)
        -- 如果文件不是 'bigfile' 类型，并且文件大小大于 `vim.g.bigfile_size`
        if vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > vim.g.bigfile_size then
          vim.opt.cursorline = false  -- 禁用光标行高亮
          return 'bigfile'  -- 设置文件类型为 'bigfile'
        else
          return nil
        end
      end,
    },
  },
}

-- 当文件类型为 'bigfile' 时执行的自动命令
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'bigfile',  -- 使用之前定义的组 'bigfile'
  pattern = 'bigfile',  -- 针对 'bigfile' 文件类型
  callback = function(ev)
    vim.b.minianimate_disable = true  -- 禁用 'minianimate' 插件
    vim.schedule(function()
      -- 设置文件语法高亮
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ''
    end)
  end,
})

-- 终端窗口的自动命令
-- 打开终端时，禁用行号和相对行号
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',  -- 针对所有终端
  callback = function()
    vim.opt_local.number = false  -- 禁用行号
  end,
})

-- 2空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json", "yaml", "html", "css", "javascript", "typescript", "dart" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

-- 4空格缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "java", "cpp", "c" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})


-- 禁用K
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function(args)
    local win_cfg = vim.api.nvim_win_get_config(0)
    if win_cfg.relative == "" then
      return          -- 普通窗口，忽略
    end

    -- 把操作排到事件队列最后，确保比任何插件都晚
    vim.defer_fn(function()
      pcall(vim.keymap.del, "n", "K", { buffer = args.buf })
      vim.keymap.set(
        "n", "K", "5k",
        { buffer = args.buf, silent = true, desc = "浮窗中 K 上移 5 行" }
      )
    end, 0)
  end,
})
