return {
  'rcarriga/nvim-notify',
  opts = {
    stages = 'static',  -- 取消淡入淡出动画
    render = 'compact', -- 紧凑模式
    -- max_width = 30,     -- 最大30字符
    fps = 5,
    level = 1,
    timeout = 2000,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end
}
