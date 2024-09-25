return {
  'FabianWirth/search.nvim',
  event = 'VeryLazy',

  -- 插件依赖
  dependencies = { 'nvim-telescope/telescope.nvim' }, -- 依赖 telescope 插件，用于强大的搜索功能

  -- 插件配置
  config = function()
    -- 调用自定义的搜索配置
    require 'custom.config.search' -- 从 'custom/config/search.lua' 中加载配置文件
  end,
}
