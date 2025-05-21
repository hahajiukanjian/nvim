-- 设置 vim.env.PATH 与系统 PATH 一致
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH

require('core.options')
require('core.keymaps')
require('core.autocmds')
require('lazy_setup')

