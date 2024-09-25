-- 加载 telescope.builtin 模块以使用内置的文件搜索功能
local builtin = require 'telescope.builtin'

-- 加载自定义工具模块 custom.utils，其中包含 reveal_in_neotree 和 edit_respect_winfixbuf 函数
local custom_utils = require 'custom.utils'

-- 配置 search.nvim 插件
require('search').setup {
  -- 定义切换标签页的快捷键映射
  mappings = {
    next = '<Tab>',   -- 在搜索界面中按下 Tab 键切换到下一个标签
    prev = '<S-Tab>', -- 在搜索界面中按下 Shift+Tab 键切换到上一个标签
  },

  -- 追加自定义标签页到默认的标签页中
  append_tabs = {
    {
      -- 'Recent' 标签用于显示最近打开的文件
      'Recent',
      function()
        -- 调用 telescope 的 oldfiles 函数查找最近文件
        builtin.oldfiles {
          attach_mappings = function(_, map)
            -- 自定义快捷键映射
            map('i', '<C-r>', custom_utils.reveal_in_neotree)     -- Ctrl+r 用于在 neotree 中显示文件
            map('i', '<CR>', custom_utils.edit_respect_winfixbuf) -- 回车键用于打开文件，但保留 winfixbuf 状态
            return true                                           -- 返回 true 以应用映射
          end,
        }
      end,
    },
    {
      -- 'Buffers' 标签用于显示当前打开的缓冲区
      'Buffers',
      function()
        -- 调用 telescope 的 buffers 函数查找缓冲区
        builtin.buffers {
          attach_mappings = function(_, map)
            -- 自定义快捷键映射
            map('i', '<C-r>', custom_utils.reveal_in_neotree)     -- Ctrl+r 用于在 neotree 中显示缓冲区
            map('i', '<CR>', custom_utils.edit_respect_winfixbuf) -- 回车键用于打开缓冲区，但保留 winfixbuf 状态
            return true                                           -- 返回 true 以应用映射
          end,
        }
      end,
    },
  },

  -- 自定义标签页配置，用于覆盖默认标签页
  tabs = {
    {
      -- 'Files' 标签用于查找当前工作目录中的文件
      'Files',
      function()
        -- 调用 telescope 的 find_files 函数查找文件
        builtin.find_files {
          cwd = vim.fn.getcwd(),             -- 设置当前工作目录为搜索目录
          search_dirs = { vim.fn.getcwd() }, -- 限制搜索范围为当前工作目录
          attach_mappings = function(_, map)
            -- 自定义快捷键映射
            map('i', '<C-r>', custom_utils.reveal_in_neotree)     -- Ctrl+r 用于在 neotree 中显示文件
            map('i', '<CR>', custom_utils.edit_respect_winfixbuf) -- 回车键用于打开文件，但保留 winfixbuf 状态
            return true                                           -- 返回 true 以应用映射
          end,
        }
      end,
    },
  },
}

-- 设置键映射以打开不同的搜索标签
-- <leader>ff 打开 'Files' 标签
vim.keymap.set('n', '<leader>ff', function()
  require('search').open { tab_name = 'Files' }
end, { desc = 'Find File' })

-- <leader><leader> 打开 'Buffers' 标签
vim.keymap.set('n', '<leader><leader>', function()
  require('search').open { tab_name = 'Buffers' }
end, { desc = 'Find Buffer' })

-- <leader>fo 打开 'Recent' 标签
vim.keymap.set('n', '<leader>fo', function()
  require('search').open { tab_name = 'Recent' }
end, { desc = 'Find Recent File' })
