local utils = require 'heirline.utils' -- 引入 heirline 的工具库
local palette = require('catppuccin.palettes').get_palette 'mocha' -- 获取 Catppuccin 主题的颜色调色板
local components = require 'custom.config.heirline.components' -- 引入自定义的 Heirline 组件


-- 定义一个关闭按钮（TablineCloseButton），用于关闭未修改的缓冲区
local TablineCloseButton = {
  condition = function(self)
    -- 条件：只有在缓冲区未被修改时才显示关闭按钮
    return not vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
  end,
  { provider = ' ' },
  {
    provider = '✗ ',
    hl = { fg = 'gray' },
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = 'heirline_tabline_close_buffer_callback',
    },
  },
}

-- 定义缓冲区左侧的分割线（TablineBufferLeftIndicator）
local TablineBufferLeftIndicator = {
  provider = '┃ ',
  hl = function(self)
    -- 根据缓冲区是否处于活动状态设置不同的前景色
    return { fg = self.is_active and palette.yellow or palette.base, bg = palette.base, bold = true }
  end,
}
local TablineBufferBlock = { TablineBufferLeftIndicator, components.TablineFileNameBlock, TablineCloseButton }

-- and here we go
local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = ' ', hl = { fg = 'gray' } }, -- left truncation, optional (defaults to "<")
  { provider = ' ', hl = { fg = 'gray' } } -- right trunctation, also optional (defaults to ...... yep, ">")
  -- by the way, open a lot of buffers and try clicking them ;)
)

-- this is the default function used to retrieve buffers
-- 获取缓冲区列表的函数
local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
-- 初始化缓冲区列表缓存
local buflist_cache = {}

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
-- 设置自动命令，每当缓冲区添加/删除时更新缓冲区缓存
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufAdd', 'BufDelete' }, {
  callback = function()
    vim.schedule(function()
      local buffers = get_bufs()
      for i, v in ipairs(buffers) do
        buflist_cache[i] = v
      end
      for i = #buffers + 1, #buflist_cache do
        buflist_cache[i] = nil
      end

      -- check how many buffers we have and set showtabline accordingly
      -- 根据缓冲区数量设置 showtabline 选项
      if #buflist_cache > 1 then
        vim.o.showtabline = 2 -- always
      elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
        vim.o.showtabline = 1 -- only when #tabpages > 1 -- 只在有多个标签页时显示 tabline
      end
    end)
  end,
})

-- TabLine 偏移量组件，显示一些插件如 neo-tree 的宽度信息
local TabLineOffset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == 'neo-tree' then
      self.title = '' -- 如果文件类型为 neo-tree，不显示标题
      self.hl = { bg = palette.base }
      return true
      -- elseif vim.bo[bufnr].filetype == "TagBar" then
      --     ...
    end
  end,

  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)
    return string.rep(' ', pad) .. title .. string.rep(' ', pad)
  end,

  hl = function(self)
    if vim.api.nvim_get_current_win() == self.winid then
      return 'TablineSel' -- 如果是当前窗口，使用 TablineSel 的高亮样式
    else
      return 'Tabline' -- 否则使用默认Tabline 的高亮样式
    end
  end,
}

-- 标签页组件
local Tabpage = {
  provider = function(self)
    return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T' -- 显示标签页编号
  end,
  hl = function(self)
    if not self.is_active then
      return 'TabLine'
    else
      return 'TabLineSel' -- 活动标签页使用 TabLineSel 样式
    end
  end,
}

-- 标签页关闭按钮
local TabpageClose = {
  provider = '%999X ✗ %X',
  hl = 'TabLine',
}

-- 标签页显示组件
local TabPages = {
  -- only show this component if there's 2 or more tabpages
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = '%=' },
  utils.make_tablist(Tabpage),
  TabpageClose,
}

return { TabLineOffset, BufferLine, TabPages }

