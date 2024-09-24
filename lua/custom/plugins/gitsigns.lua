-- 添加 Git 相关的符号到侧边栏，并提供管理更改的实用工具
-- 注：gitsigns 已经在 init.lua 中包含了基础配置，此配置为其添加推荐的快捷键。

return {
  {
    'lewis6991/gitsigns.nvim', -- 加载 gitsigns.nvim 插件
    event = 'InsertEnter', -- 在进入插入模式时加载该插件
    keys = {
      ']h', -- 跳转到下一个 Git hunk
      '[h', -- 跳转到上一个 Git hunk
      '<leader>h', -- Git hunk 相关操作的快捷键前缀
    },
    opts = {
      -- 配置 Git 操作的符号
      signs = {
        add = { text = '┃' }, -- 添加的行左侧显示竖线
        change = { text = '┃' }, -- 修改的行左侧显示竖线
        delete = { text = '_' }, -- 删除的行左侧显示下划线
        topdelete = { text = '‾' }, -- 顶部删除的行左侧显示符号
        changedelete = { text = '~' }, -- 修改后删除的行显示波浪线
        untracked = { text = '┆' }, -- 未跟踪的文件行显示符号
      },
      -- 当插件附加到当前 buffer 时，设置一些快捷键
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        -- 辅助函数，用于简化快捷键映射
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- 导航到下一个或上一个 Git hunk
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']h', bang = true }
          else
            gitsigns.nav_hunk 'next' -- 跳转到下一个 Git hunk
          end
        end, { desc = '跳转到下一个 Git hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[h', bang = true }
          else
            gitsigns.nav_hunk 'prev' -- 跳转到上一个 Git hunk
          end
        end, { desc = '跳转到上一个 Git hunk' })

        -- 操作 Git hunk
        -- 可视模式下暂存选中的 hunk
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '暂存 Git hunk' })

        -- 可视模式下重置选中的 hunk
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '重置 Git hunk' })

        -- 正常模式下暂存当前的 Git hunk
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git 暂存 hunk' })

        -- 重置当前的 Git hunk
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git 重置 hunk' })

        -- 暂存整个 buffer 的所有更改
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git 暂存 buffer' })

        -- 撤销暂存的 hunk
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git 撤销暂存 hunk' })

        -- 重置整个 buffer 的所有更改
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git 重置 buffer' })

        -- 预览当前的 Git hunk
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git 预览 hunk' })

        -- 显示当前行的 Git 责任人（blame）
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'Git 行 blame' })

        -- 显示当前 buffer 与索引的差异
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git 显示与索引的差异' })

        -- 显示当前 buffer 与上次提交的差异
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Git 显示与上次提交的差异' })

        -- 开关功能
        -- 开关当前行的 Git 责任人显示
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '切换 Git blame 显示' })

        -- 开关已删除的行的显示
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '切换 Git 已删除的行显示' })
      end,
    },
  },
}

