local g = vim.g
local opt = vim.opt

------------------------------ vim.g config -----------------------------
-- 启用 Neovim 的 Lua 模块加载器。这可以加快插件和配置的加载速度。
vim.loader.enable()

-- 将 leader 键设置为空格键。Leader 键是自定义快捷键组合的前缀键。
g.mapleader = ' '

-- 将 localleader 键也设置为空格键。localleader 通常用于在某些文件类型中使用不同的快捷键映射。
g.maplocalleader = ' '

-- 标记系统是否安装了 Nerd Fonts。如果你使用了带有符号的字体（例如 Nerd Fonts），可以根据这个变量进行配置。
g.have_nerd_font = true

-- 设置大文件的定义阈值为 1.5MB。当打开超过该大小的文件时，可以执行特定优化，比如禁用某些功能以加快加载速度。
g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

--- nord
-- 禁用 Nord 主题中的斜体和粗体
g.nord_italic = false
g.nord_bold = false
-- 透明的光标行高亮显示
-- g.nord_cursorline_transparent = true
-- 禁用背景颜色（适用于透明背景的主题）
g.nord_disable_background = true



------------------------------ vim.opt config -----------------------------
-- 启用 24 位 RGB 颜色支持。可以使用更多颜色的配色方案，显示更细腻的颜色。
opt.termguicolors = true

-- 启用行号显示。此选项让每一行的左侧显示实际的行号。
opt.number = true

-- 不启用软换行。如果一行太长而无法容纳在屏幕上，会将其分成多行显示。 
opt.wrap = true

-- 只显示一个全局状态栏，而不是每个窗口都有一个。设置 3 会在所有窗口共享一个状态栏。
opt.laststatus = 3

opt.mouse = 'a'
-- 禁用默认的模式显示（如 --INSERT--）。如果你的状态栏已经显示当前模式，这个可以关闭以避免重复。
opt.showmode = false

-- 设置缩进相关选项
-- opt.tabstop = 4          -- 一个 tab 字符的宽度为 4 个空格
-- opt.shiftwidth = 4       -- 每次缩进的空格数为 4
-- opt.expandtab = true     -- 将 tab 键转为空格
opt.shiftround = true    -- 将缩进对齐到 `shiftwidth` 的整数倍
opt.autoindent = true    -- 复制前一行的缩进
opt.smartindent = true   -- 根据代码结构自动设置缩进

-- 启用断行缩进。换行后，续行会保持与原行缩进一致，这样看起来更加整齐。
opt.breakindent = true

-- 启用持久化撤销。即使关闭文件或重启 Neovim，也可以通过撤销历史恢复以前的修改。
opt.undofile = true
opt.undodir = vim.fn.expand('$HOME/.local/share/nvim/undo')  -- 撤销历史的保存目录

-- 启用忽略大小写的搜索。启用智能大小写。
opt.ignorecase = true
opt.smartcase = true

-- 根据需要自动显示或隐藏符号列（通常用于显示诊断、断点等符号）。
opt.signcolumn = 'auto'

-- 设置光标悬停后触发事件的等待时间（例如诊断信息）为 250 毫秒。
opt.updatetime = 250

-- 设置映射序列的等待时间为 300 毫秒。用于等待多键快捷键的下一按键输入。
opt.timeoutlen = 300

-- 默认情况下，新的垂直拆分窗口将打开在当前窗口的右侧和底部。
opt.splitright = true
opt.splitbelow = true

-- 显示隐藏的字符，例如空格、制表符和换行符。
--- 配置显示隐藏字符的方式：
--- tab = '» '：使用 »  表示制表符。
--- trail = '·'：使用 · 表示行末的多余空格。
--- nbsp = '␣'：使用 ␣ 表示不间断空格。
opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 启用实时替换预览，在你键入 :s 替换命令时，显示预览窗口。
opt.inccommand = 'split'

-- 启用光标所在行的高亮显示，方便定位当前行。
opt.cursorline = true

-- 设置在光标上下方保留至少 5 行空白，不让光标过于贴近屏幕边缘。
opt.scrolloff = 5

-- 设置命令行高度为 0
-- 这样可以节省更多空间，通常用于启用状态栏插件（如 lualine），如果不需要额外的命令行空间。
-- 参考链接：https://www.reddit.com/r/neovim/comments/1cll8g8/statusline_is_not_at_the_bottom_of_the_terminal/
opt.cmdheight = 0

-- 设置命令的自动补全选项
-- 显示补全菜单，但不自动选择第一项
opt.completeopt = { "menuone", "noselect" }
-- 命令行模式下，按 Tab 键时显示补全菜单
opt.wildmenu = true

-- 禁用备份文件和交换文件
opt.backup = false
opt.swapfile = false

-- 启用自动写入缓冲区（例如，当在插入模式下暂停时）
opt.autowrite = true

-- 设置匹配符号对高亮显示，如括号、引号等
opt.matchpairs:append('<:>')
opt.matchpairs:append('":"')
opt.matchpairs:append("':'")

-- 在终端标题栏显示有用信息（如当前文件名）
opt.title = true

-- 允许每个项目使用 `.nvim.lua` 文件进行项目本地配置
opt.exrc = true
