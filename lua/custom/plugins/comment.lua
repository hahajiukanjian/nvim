return {
  'numToStr/Comment.nvim',  -- 插件名称

  -- 自定义按键绑定
  keys = function(_, keys)
    local plugin = require('lazy.core.config').spec.plugins['Comment.nvim']
    local opts = require('lazy.core.plugin').values(plugin, 'opts', false)

    -- 如果未禁用基础注释映射，则添加默认按键绑定
    if vim.tbl_get(opts, 'mappings', 'basic') ~= false then
      vim.list_extend(keys, {
        { vim.tbl_get(opts, 'toggler', 'line') or 'gcc', desc = 'Comment toggle current line' },       -- 切换当前行的注释
        { vim.tbl_get(opts, 'toggler', 'block') or 'gbc', desc = 'Comment toggle current block' },      -- 切换当前块的注释
        { vim.tbl_get(opts, 'opleader', 'line') or 'gc', desc = 'Comment toggle linewise' },            -- 行注释切换
        { vim.tbl_get(opts, 'opleader', 'block') or 'gb', desc = 'Comment toggle blockwise' },          -- 块注释切换
        { vim.tbl_get(opts, 'opleader', 'line') or 'gc', mode = 'x', desc = 'Comment toggle linewise (visual)' },  -- 视觉模式下的行注释切换
        { vim.tbl_get(opts, 'opleader', 'block') or 'gb', mode = 'x', desc = 'Comment toggle blockwise (visual)' },-- 视觉模式下的块注释切换
      })
    end

    -- 如果未禁用额外的映射，则添加额外的按键绑定
    if vim.tbl_get(opts, 'mappings', 'extra') ~= false then
      vim.list_extend(keys, {
        { vim.tbl_get(keys, 'extra', 'below') or 'gco', desc = 'Comment insert below' },   -- 在当前行下方插入注释
        { vim.tbl_get(opts, 'extra', 'above') or 'gcO', desc = 'Comment insert above' },   -- 在当前行上方插入注释
        { vim.tbl_get(opts, 'extra', 'eol') or 'gcA', desc = 'Comment insert end of line' },-- 在行尾插入注释
      })
    end
  end,

  -- 插件选项配置
  opts = function(_, opts)
    -- 为注释功能设置快捷键 '<leader>/'
    vim.keymap.set('n', '<leader>/', function()
      return require('Comment.api').call('toggle.linewise.' .. (vim.v.count == 0 and 'current' or 'count_repeat'), 'g@$')()
    end, { desc = '注释行', silent = true, expr = true })

    -- 视觉模式下的注释快捷键
    vim.keymap.set('x', '<leader>/', "<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>", { desc = '注释行' })

    -- 检查是否安装了 `ts_context_commentstring`，用于更加上下文敏感的注释
    local commentstring_avail, commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
    if commentstring_avail then
      opts.pre_hook = commentstring.create_pre_hook()  -- 为插件设置上下文注释的钩子
    end
  end,
}

