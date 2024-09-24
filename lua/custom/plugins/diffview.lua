return {
  'sindrets/diffview.nvim',  -- 插件的路径（GitHub 仓库）

  -- 配置触发命令
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },  -- 当运行这些命令时，插件才会加载

  -- 键位映射
  keys = {
    { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'DiffView Open' },  -- 打开 DiffView 视图
    { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'DiffView Close' },  -- 关闭 DiffView 视图
    { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = 'DiffView History' },  -- 查看当前文件的历史记录
  },

  -- 关联的其他插件
  specs = {
    {
      'NeogitOrg/neogit',  -- Neogit 插件，类似于 Git 的交互式前端
      optional = true,  -- 可选插件
      opts = { integrations = { diffview = true } },  -- 将 diffview 插件与 neogit 插件集成
    },
  },

  -- 插件的配置
  config = function()
    require 'custom.config.diffview'  -- 加载自定义配置，文件位于 `custom/config/diffview.lua`
  end,
}

