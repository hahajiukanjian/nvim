---@diagnostic disable: missing-fields, duplicate-set-field
return { -- 自动补全
  'hrsh7th/nvim-cmp',  -- 核心自动补全插件
  event = 'InsertEnter',  -- 在插入模式下触发加载
  dependencies = {  -- 依赖插件
    'onsails/lspkind.nvim',  -- 为补全项添加图标

    -- 片段引擎及其相关的 nvim-cmp 源
    {
      'L3MON4D3/LuaSnip',  -- 片段引擎
      event = 'InsertEnter',  -- 插入模式下加载
      build = (function()
        -- 构建步骤：为片段引擎添加正则表达式支持
        -- Windows 环境中不支持 `make`，因此为 Windows 系统跳过构建步骤
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',  -- 预设的代码片段
          config = function()
            require('luasnip.loaders.from_lua').load {
              paths = { '~/.config/nvim/lua/snippets' },  -- 加载自定义代码片段
            }
            require('luasnip.loaders.from_vscode').lazy_load()  -- 懒加载 VSCode 样式的代码片段
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',  -- LuaSnip 的 nvim-cmp 补全源

    -- 添加其他补全功能
    'hrsh7th/cmp-nvim-lsp',  -- LSP 补全源
    'hrsh7th/cmp-path',  -- 文件路径补全
    { 'hrsh7th/cmp-buffer', lazy = true },  -- 缓冲区内容补全，懒加载
    {
      'hrsh7th/cmp-cmdline',  -- 命令行模式下的补全
      keys = { ':', '/', '?' },  -- 在命令行模式的特定按键下懒加载
      dependencies = { 'hrsh7th/nvim-cmp' },  -- 依赖于 nvim-cmp
      opts = function()
        local cmp = require 'cmp'
        return {
          {
            type = '/',  -- 为 `/` 和 `?` 提供缓冲区搜索补全
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' },
            },
          },
          {
            type = ':',  -- 为 `:` 提供命令行补全
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' },  -- 文件路径补全
            }, {
              {
                name = 'cmdline',  -- 命令行补全
                option = {
                  ignore_cmds = { 'Man', '!' },  -- 忽略某些命令
                },
              },
            }),
          },
        }
      end,
      config = function(_, opts)
        local cmp = require 'cmp'
        -- 为不同的命令行类型设置补全
        vim.tbl_map(function(val)
          cmp.setup.cmdline(val.type, val)
        end, opts)
      end,
    },
  },
  config = function()
    require 'custom.config.completion'  -- 引入自定义的自动补全配置
  end,
}

