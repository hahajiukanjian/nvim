local palette = require('catppuccin.palettes').get_palette 'mocha' -- 获取 Catppuccin 主题的调色板
local utils = require 'heirline.utils' -- Heirline 的实用工具函数
local conditions = require 'heirline.conditions' -- Heirline 的状态条件函数，例如是否启用 LSP
local icons = require 'custom.ui.icons' -- 自定义图标集
local colors = {
  diag_warn = utils.get_highlight('DiagnosticWarn').fg, -- 诊断警告颜色
  diag_error = utils.get_highlight('DiagnosticError').fg, -- 诊断错误颜色
  diag_hint = utils.get_highlight('DiagnosticHint').fg, -- 诊断提示颜色
  diag_info = utils.get_highlight('DiagnosticInfo').fg, -- 诊断信息颜色
  git_del = utils.get_highlight('diffDeleted').fg, -- Git 删除颜色
  git_add = utils.get_highlight('diffAdded').fg, -- Git 添加颜色
  git_change = utils.get_highlight('diffChanged').fg, -- Git 修改颜色
}

-- 显示 Overseer 任务状态，如运行、成功、失败等
local function OverseerTasksForStatus(st)
  return {
    condition = function(self)
      return self.tasks[st]
    end,
    provider = function(self)
      return string.format('%s%d', self.symbols[st], #self.tasks[st])
    end,
    hl = function(_)
      return {
        fg = utils.get_highlight(string.format('Overseer%s', st)).fg,
      }
    end,
  }
end

local M = {}
M.Spacer = { provider = ' ' } -- 空格
M.Fill = { provider = '%=' } -- 填充符，保持两边对齐
M.Ruler = {
  provider = '%(%l/%L%)(%P)', -- 显示行号、总行数、文件位置百分比
}
M.ScrollBar = {
  static = {
    sbar = { ' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }, -- 滚动条字符
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = palette.yellow, bg = palette.base }, -- 滚动条的前景和背景颜色
}

-- 定义右边的填充和间隔，适应多种组件布局
M.RightPadding = function(child, num_space)
  local result = {
    condition = child.condition,
    child,
    M.Spacer,
  }
  if num_space ~= nil then
    for _ = 2, num_space do
      table.insert(result, M.Spacer) -- 添加额外空格
    end
  end
  return result
end

-- 显示vim的各种模式
M.Mode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = '',
      no = '?',
      nov = '?',
      noV = '?',
      ['no\22'] = '?',
      niI = 'i',
      niR = 'r',
      niV = 'Nv',
      nt = '',
      v = '',
      vs = 'Vs',
      V = '-',
      Vs = 'Vs',
      ['\22'] = '\\',
      ['\22s'] = '\\',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = '',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = '',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = '',
    },
    mode_colors = {
      n = palette.blue,
      nt = palette.red,
      i = palette.green,
      v = palette.mauve,
      V = palette.mauve,
      ['\22'] = palette.mauve,
      c = palette.red,
      s = palette.pink,
      S = palette.pink,
      ['\19'] = palette.pink,
      R = palette.peach,
      r = palette.peach,
      ['!'] = palette.red,
      t = palette.green,
    },
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return '%1(' .. self.mode_names[self.mode] .. '%)'
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = palette.base, bg = self.mode_colors[mode], bold = true }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    'ModeChanged', -- 当模式改变时更新
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      vim.cmd 'redrawstatus' -- 重新绘制状态栏
    end),
  },
}

-- 录制宏时的状态显示
M.MacroRecording = {
  condition = conditions.is_active, -- 仅在活动窗口显示
  init = function(self)
    self.reg_recording = vim.fn.reg_recording() -- 获取当前正在录制的宏
    self.status_dict = vim.b.gitsigns_status_dict or { added = 0, removed = 0, changed = 0 }
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  {
    condition = function(self)
      return self.reg_recording ~= '' -- 如果正在录制宏
    end,
    {
      provider = '󰻃 ',
      hl = { fg = palette.maroon },
    },
    {
      provider = function(self)
        return self.reg_recording
      end,
      hl = { fg = palette.maroon, italic = false, bold = true },
    },
    hl = { fg = palette.text, bg = palette.base },
  },
  update = { 'RecordingEnter', 'RecordingLeave' },
}

-- 显示 LSP 启用状态
M.LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do -- 获取当前 LSP 客户端
      table.insert(names, server.name)
    end
    return table.concat(names, ',')
  end,
  hl = { fg = palette.surface1, bold = false },
}

-- 显示文件类型
M.FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { fg = utils.get_highlight('Type').fg, bold = true },
}

-- 显示 Codeium 状态
M.CodeiumStatus = {
  init = function(self)
    self.codeium_exist = vim.fn.exists '*codeium#GetStatusString' == 1
    self.codeium_status = self.codeium_exist and vim.fn['codeium#GetStatusString']() or nil
  end,
  provider = function(self)
    if not self.codeium_exist then
      return ''
    end
    if self.codeium_status == ' ON' then
      return '󰚩 '
    elseif self.codeium_status == ' OFF' then
      return '󱚡 '
    else
      return '󱚝 '
    end
  end,
  hl = function(self)
    if self.codeium_status == ' ON' then
      return { fg = palette.green }
    elseif self.codeium_status == ' OFF' then
      return { fg = palette.gray }
    else
      return { fg = palette.maroon }
    end
  end,
}

-- Git 状态显示组件
M.Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = palette.flamingo },

  {
    -- Git 分支名称
    provider = function(self)
      return ' ' .. self.status_dict.head
    end,
    hl = { bold = true },
  },
  {
    -- Git 添加的文件数量
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (' +' .. count)
    end,
    hl = { fg = colors.git_add },
  },
  {
    -- Git 删除的文件数量
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (' -' .. count)
    end,
    hl = { fg = colors.git_del },
  },
  {
    -- Git 修改的文件数量
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (' ~' .. count)
    end,
    hl = { fg = colors.git_change },
  },
}

-- 显示诊断信息，例如错误、警告、提示等
M.Diagnostics = {
  condition = conditions.has_diagnostics, -- 当存在诊断信息时显示
  static = {
    error_icon = icons.diagnostics.Error, -- 错误图标
    warn_icon = icons.diagnostics.Warn, -- 警告图标
    info_icon = icons.diagnostics.Info, -- 信息图标
    hint_icon = icons.diagnostics.Hint, -- 提示图标
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) -- 获取错误数量
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) -- 获取警告数量
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) -- 获取提示数量
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) -- 获取信息数量
  end,

  update = { 'DiagnosticChanged', 'BufEnter' }, -- 在诊断信息或缓冲区变化时更新

  {
    -- 显示错误数量
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
    end,
    hl = { fg = colors.diag_error },
  },
  {
    -- 显示警告数量
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
    end,
    hl = { fg = colors.diag_warn },
  },
  {
    -- 显示信息数量
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. ' ')
    end,
    hl = { fg = colors.diag_info },
  },
  {
    -- 显示提示数量
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = colors.diag_hint },
  },
}

-- 文件图标显示组件
M.FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

-- 文件名显示组件
M.FileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
    return filename
  end,
  hl = function(self)
    return { fg = self.is_active and palette.text or palette.subtext0, bold = self.is_active or self.is_visible, italic = self.is_active }
  end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
-- 文件标志组件，如只读、不可修改等状态
M.FileFlags = {
  {
    condition = function(self)
      return vim.api.nvim_get_option_value('modified', { buf = self.bufnr })
    end,
    provider = '  ',
    hl = function(self)
      return { fg = palette.text, bold = self.is_active }
    end,
  },
  {
    condition = function(self)
      return not vim.api.nvim_get_option_value('modifiable', { buf = self.bufnr }) or vim.api.nvim_get_option_value('readonly', { buf = self.bufnr })
    end,
    provider = function(self)
      if vim.api.nvim_get_option_value('buftype', { buf = self.bufnr }) == 'terminal' then
        return ' '
      else
        return ' '
      end
    end,
    hl = { fg = palette.text },
  },
}

-- Overseer 任务状态显示组件
M.Overseer = {
  condition = function()
    return package.loaded.overseer
  end,
  init = function(self)
    local tasks = require('overseer.task_list').list_tasks { unique = true }
    local tasks_by_status = require('overseer.util').tbl_group_by(tasks, 'status')
    self.tasks = tasks_by_status
  end,
  static = {
    symbols = {
      ['CANCELED'] = ' 󰜺 ',
      ['FAILURE'] = '  ',
      ['SUCCESS'] = '  ',
      ['RUNNING'] = '  ',
    },
  },
  M.RightPadding(OverseerTasksForStatus 'CANCELED'), -- 显示已取消任务的数量
  M.RightPadding(OverseerTasksForStatus 'RUNNING'), -- 显示正在运行任务的数量
  M.RightPadding(OverseerTasksForStatus 'SUCCESS'), -- 显示成功完成任务的数量
  M.RightPadding(OverseerTasksForStatus 'FAILURE'), -- 显示失败任务的数量
}

-- 文件名块组件，包括文件图标、文件名和文件标志
M.FileNameBlock = {
  init = function(self)
    local bufnr = self.bufnr and self.bufnr or 0
    self.filename = vim.api.nvim_buf_get_name(bufnr)
  end,
  hl = { bg = palette.base, fg = palette.text },
  M.FileIcon,
  M.FileName,
  M.FileFlags,
}

-- Tabline 文件名块组件，允许点击操作
M.TablineFileNameBlock = vim.tbl_extend('force', M.FileNameBlock, {
  on_click = {
    callback = function(_, minwid, _, button)
      if button == 'm' then -- close on mouse middle click
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = 'heirline_tabline_buffer_callback',
  },
})

return M
