-- 引入 LuaSnip 代码片段引擎并进行基础配置
local luasnip = require 'luasnip'
luasnip.config.setup {}

-- 获取 Catppuccin Mocha 调色板
local palette = require('catppuccin.palettes').get_palette 'mocha'

-- 为补全窗口和浮动边框设置高亮
vim.api.nvim_set_hl(0, 'CmpNormal', { bg = palette.surface0 })  -- 设置补全窗口背景
vim.api.nvim_set_hl(0, 'CmpNormalDoc', { bg = palette.surface1 })  -- 设置文档窗口背景
vim.api.nvim_set_hl(0, 'CmpCursorLine', { bg = palette.blue, fg = palette.base })  -- 设置补全窗口中选中的行
vim.api.nvim_set_hl(0, 'CmpFloatBorder', { fg = palette.surface1, bg = palette.surface1 })  -- 设置浮动边框

-- 引入 nvim-cmp 自动补全引擎
local cmp = require 'cmp'
cmp.setup {
  -- 定义补全项的格式化方式
  formatting = {
    format = require('lspkind').cmp_format { maxwidth = 30, ellipsis_char = '   ' },
    expandable_indicator = true,
    fields = { 'abbr', 'kind', 'menu' },  -- 指定显示顺序为缩写、类型、菜单
  },
  -- 设置补全和文档窗口的样式
  window = {
    completion = { winhighlight = 'Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:CmpCursorLine,Search:None', side_padding = 1 },
    documentation = cmp.config.window.bordered { winhighlight = 'Normal:CmpNormalDoc,FloatBorder:CmpFloatBorder,CursorLine:CmpCursorLine,Search:None' },
  },
  -- 配置片段引擎
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)  -- 使用 LuaSnip 扩展代码片段
    end,
  },
  completion = { completeopt = 'menu, menuone, noinsert, preview, noselect' },  -- 设置补全选项的行为

  -- 定义按键映射
  mapping = cmp.mapping.preset.insert {
    ['<tab>'] = cmp.mapping.select_next_item(),  -- 选择下一个补全项
    ['<S-tab>'] = cmp.mapping.select_prev_item(),  -- 选择上一个补全项
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),  -- 向上滚动文档
    ['<C-u>'] = cmp.mapping.scroll_docs(4),  -- 向下滚动文档
    ['<CR>'] = cmp.mapping.confirm { select = true },  -- 确认补全项
    ['<C-c>'] = cmp.mapping.complete {},  -- 手动触发补全
    ['<C-S-j>'] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()  -- 向前跳到片段中的下一个位置
      end
    end, { 'i', 's' }),
    ['<C-S-k>'] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)  -- 向后跳到片段中的上一个位置
      end
    end, { 'i', 's' }),
  },

  -- 设置补全源的优先级
  sources = {
    { name = 'luasnip', priority = 1000 },  -- 代码片段补全
    { name = 'nvim_lsp', priority = 800 },  -- LSP 补全
    { name = 'path', priority = 600 },  -- 文件路径补全
    {
      name = 'buffer',  -- 基于缓冲区内容的补全
      option = {
        get_bufnrs = function()
          local buf = vim.api.nvim_get_current_buf()
          local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size > 1024 * 1024 then -- 超过 1 MB 时不启用补全
            return {}
          end
          return { buf }
        end,
      },
      priority = 400,
    },
    { name = 'lazydev' },  -- LazyDev 补全源
    { name = 'nvim_lsp_signature_help' },  -- LSP 签名帮助补全
  },
}

-- 设置快捷键 <C-s> 显示 LSP 签名帮助
vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)

