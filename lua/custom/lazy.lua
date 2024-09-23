-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  {
    -- 自动检测 tabstop 和 shiftwidth，适用于不同的文件
    { 'tpope/vim-sleuth' },
    -- lsp美化
    { 'stevearc/dressing.nvim', event = 'VeryLazy', opts = {} },
    -- 在注释中高亮显示 TODO、NOTE等标签
    { 'folke/todo-comments.nvim', ft = { 'cpp', 'python', 'sh', 'dart', 'lua' }, dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    { import = 'custom.plugins' },
  },
  {
    ui = {
      icons = {},
    },
  }
)
