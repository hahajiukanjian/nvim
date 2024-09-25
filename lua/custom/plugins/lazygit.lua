return {
  'kdheepak/lazygit.nvim',  -- 使用 LazyGit 的 Neovim 插件
  dependencies = {
    'nvim-lua/plenary.nvim',  -- 依赖 plenary.nvim 插件，提供常用的 Lua 函数库
  },
  event = 'User AstroFile',  -- 在 `User AstroFile` 事件时加载插件
  cmd = { 'LazyGit', 'LazyGitCurrentFile' },  -- 定义可用的命令：`LazyGit` 和 `LazyGitCurrentFile`
  keys = {
    -- 为快捷键 `<leader>gg` 绑定 LazyGit 的当前文件命令
    { '<leader>gg', '<cmd>LazyGitCurrentFile<CR>', desc = '打开 LazyGit' }, 
  },
}

