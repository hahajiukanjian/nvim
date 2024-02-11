local opt = vim.opt

-- 设置空格为leader键
vim.g.mapleader = " "

-- 不显示模式
opt.showmode = false

-- 设置行号
opt.number = true
-- opt.relativenumber = true

-- 设置缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true

-- 设置鼠标支持
opt.mouse = 'a'

-- 设置高亮显示当前行
opt.cursorline = true

-- 设置自动补全
opt.completeopt = 'menuone,noselect'

-- 设置颜色主题
-- vim.cmd('colorscheme vim')

-- 禁用备份文件和临时文件
opt.backup = false
opt.swapfile = false

-- 设置自动保存
opt.autowrite = true

-- 设置搜索时忽略大小写
-- opt.hlsearch = false -- 关闭搜索结果高亮
opt.ignorecase = true
opt.smartcase = true

-- 设置光标移动到屏幕边缘时自动滚动
opt.scrolloff = 8

-- 设置符号匹配
opt.matchpairs:append('<:>')
opt.matchpairs:append('":"')
opt.matchpairs:append("':'")

-- 打通剪切板
opt.clipboard = "unnamed"

-- 命令行模式时，按下tab自动补全
opt.wildmenu = true

-- 设置补全窗口的显示方式
opt.completeopt = { "menuone" }

-- 终端真彩色
opt.termguicolors = true

-- 行号与终端之间有一个空格
opt.signcolumn = "yes"

-- Vim 会尝试在终端的标题栏中显示一些有用的信息，比如当前编辑的文件名。这可以让你更容易地辨认出当前正在编辑的文件。
opt.title = true

-- 在插入模式下暂停输入后，Vim 将会在 50 毫秒内触发自动写入缓冲区的操作。默认值是 4000 毫秒（4 秒）
opt.updatetime = 50

-- 存储文件所有的编辑记录
opt.undofile = true
opt.undodir = vim.fn.expand('$HOME/.local/share/nvim/undo')

-- 可以给项目单独设置.nvim来配置nvim
opt.exrc = true

-- 设置折行
opt.wrap = true

-- 设置在右边打开新的缓冲区
opt.splitright = true

vim.b.fileenconding = "utf-8"
