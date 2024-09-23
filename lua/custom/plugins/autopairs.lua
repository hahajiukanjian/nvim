-- 自动补全括号的插件配置
-- 插件地址：https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',  -- 引入 nvim-autopairs 插件
  event = 'InsertEnter',  -- 插件将在进入插入模式时加载
  -- 可选依赖 nvim-cmp，nvim-cmp 是一个补全插件
  dependencies = { 'hrsh7th/nvim-cmp' },

  config = function()
    -- 基础设置：加载并初始化 nvim-autopairs 插件
    require('nvim-autopairs').setup {}

    -- 自动在函数或方法选择后添加 `(` 的功能
    -- 需要 nvim-cmp 插件的支持
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'  -- 引入 nvim-autopairs 的 cmp 集成模块
    local cmp = require 'cmp'  -- 引入 nvim-cmp 补全插件

    -- 当选择一个补全项并确认时，自动调用 cmp_autopairs 进行处理
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
