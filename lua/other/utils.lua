-- 引入Telescope、Plenary、以及一些工具模块
local actions_state = require 'telescope.actions.state' -- 提供Telescope状态相关的函数
local utils = require 'telescope.utils'                 -- 提供Telescope通用实用工具
local a = vim.api                                       -- 缩写为'a'以简化对Neovim API的调用
local Path = require 'plenary.path'                     -- 提供与路径操作相关的实用功能

-- 定义一个用于编辑缓冲区的函数，支持不同的打开方式
local edit_buffer
do
  -- 定义一个映射表，将命令（如'edit'）映射为相应的Vim命令
  local map = {
    edit = 'buffer',       -- 打开缓冲区
    new = 'sbuffer',       -- 在新窗口中打开缓冲区
    vnew = 'vert sbuffer', -- 垂直分割窗口并打开缓冲区
    tabedit = 'tab sb',    -- 在新标签页中打开缓冲区
  }

  -- 定义用于执行缓冲区编辑的函数
  edit_buffer = function(command, bufnr)
    command = map[command]                           -- 获取相应的Vim命令
    if command == nil then
      error 'There was no associated buffer command' -- 如果命令不存在，抛出错误
    end
    vim.cmd(string.format('%s %d', command, bufnr))  -- 执行相应的Vim命令，使用传入的缓冲区编号
  end
end

-- 定义一个模块M用于暴露功能
local M = {}

-- 检查当前系统是否为MacOS
M.is_mac = function()
  local uname = vim.uv.os_uname()  -- 获取操作系统信息
  return uname.sysname == 'Darwin' -- 检查系统名是否为'Darwin'（MacOS的系统名）
end

-- 在Neotree中显示选中文件的功能
M.reveal_in_neotree = function()
  local selection = actions_state.get_selected_entry() -- 获取当前选中的条目
  local filename = selection.filename                  -- 获取文件名
  if filename == nil then
    filename = selection[1]                            -- 如果没有文件名，则从第一个条目中获取
  end
  -- 执行Neotree命令，展示选中的文件
  require('neo-tree.command').execute {
    action = 'focus',        -- 焦点定位到Neotree
    source = 'filesystem',   -- Neotree的源为文件系统
    position = 'left',       -- Neotree显示在左侧
    reveal_file = filename,  -- 显示选中的文件
    reveal_force_cwd = true, -- 强制将工作目录切换到文件的路径
  }
  -- 退出插入模式
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

-- 在指定窗口中编辑文件，同时保持窗口布局不变
M.edit_respect_winfixbuf = function(prompt_bufnr)
  actions_state.get_current_history():append(actions_state.get_current_line(),
    actions_state.get_current_picker(prompt_bufnr))                                                                            -- 记录当前输入历史

  -- 根据按下的键（如<CR>）获取相应的编辑命令
  local command = actions_state.select_key_to_edit_key 'default'
  local entry = actions_state.get_selected_entry() -- 获取选中的条目

  if not entry then
    utils.notify('actions.set.edit', { msg = 'Nothing currently selected', level = 'WARN' }) -- 如果没有条目被选中，发出警告
    return
  end

  -- 定义文件名、行号和列号变量，用于跳转
  local filename, row, col

  -- 检查条目是否包含文件路径
  if entry.path or entry.filename then
    filename = entry.path or entry.filename
    row = entry.row or entry.lnum
    col = entry.col
  elseif not entry.bufnr then
    local value = entry.value                                                                                -- 获取条目值
    if not value then
      utils.notify('actions.set.edit', { msg = 'Could not do anything with blank line...', level = 'WARN' }) -- 如果为空值，发出警告
      return
    end

    -- 解析文件路径和行号、列号
    if type(value) == 'table' then
      value = entry.display
    end
    local sections = vim.split(value, ':')
    filename = sections[1]
    row = tonumber(sections[2])
    col = tonumber(sections[3])
  end

  local entry_bufnr = entry.bufnr -- 获取条目的缓冲区编号

  -- 获取Telescope的选择器和窗口ID
  local picker = actions_state.get_current_picker(prompt_bufnr)
  require('telescope.pickers').on_close_prompt(prompt_bufnr) -- 关闭Telescope提示窗口
  pcall(vim.api.nvim_set_current_win, picker.original_win_id)
  local win_id = picker.get_selection_window(picker, entry)

  -- 如果启用了光标位置保存功能，则将当前光标位置保存到寄存器
  if picker.push_cursor_on_edit then
    vim.cmd "normal! m'"
  end

  -- 如果启用了TagStack，则将当前位置加入到TagStack
  if picker.push_tagstack_on_edit then
    local from = { vim.fn.bufnr '%', vim.fn.line '.', vim.fn.col '.', 0 }
    local items = { { tagname = vim.fn.expand '<cword>', from = from } }
    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
  end

  -- 如果窗口不允许修改缓冲区，则切换到可修改的窗口
  if vim.api.nvim_get_option_value('winfixbuf', { win = win_id }) then
    local windows = vim.api.nvim_list_wins()
    for _, winid in ipairs(windows) do
      if not vim.api.nvim_get_option_value('winfixbuf', { win = winid }) then
        vim.api.nvim_set_current_win(winid)
        break
      end
    end
  end

  -- 如果已存在缓冲区，则切换到该缓冲区
  if entry_bufnr then
    if not vim.api.nvim_get_option_value('buflisted', { buf = entry_bufnr }) then
      vim.api.nvim_set_option_value('buflisted', true, { buf = entry_bufnr })
    end
    edit_buffer(command, entry_bufnr)
  else
    filename = Path:new(filename):normalize(vim.loop.cwd())
    pcall(vim.cmd, string.format('%s %s', command, vim.fn.fnameescape(filename))) -- 打开文件
  end

  -- 修复折叠功能（如果开启了expr模式的折叠）
  if vim.wo.foldmethod == 'expr' then
    vim.schedule(function()
      vim.opt.foldmethod = 'expr'
    end)
  end

  -- 移动光标到指定的行列
  local pos = vim.api.nvim_win_get_cursor(0)
  if col == nil then
    if row == pos[1] then
      col = pos[2] + 1
    elseif row == nil then
      row, col = pos[1], pos[2] + 1
    else
      col = 1
    end
  end

  if row and col then
    local ok, err_msg = pcall(a.nvim_win_set_cursor, 0, { row, col })
    if not ok then
      log.debug('Failed to move to cursor:', err_msg, row, col)
    end
  end
end

-- 返回模块
return M
