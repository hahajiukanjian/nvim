return {
  'folke/noice.nvim', -- 插件的 GitHub 仓库
  -- keys = { ':', '/', '?' },      -- 在插入模式下，按这些键将触发 lazy load
  config = function()
    require('noice').setup {     -- 设置 noice.nvim 的配置
      presets = {
        command_palette = false, -- 禁用命令面板的预设
      },
      messages = {
        enabled = true, -- 启用消息通知
      },
      popupmenu = {
        enabled = false, -- 禁用弹出菜单
      },
      lsp = {
        signature = {
          enabled = false, -- 禁用 LSP 签名提示
        },
        progress = {
          enabled = true, -- 启用 LSP 进度通知
        },
        hover = {
          enabled = false, -- 禁用 LSP 悬停提示
        },
      },
    }
  end,
}
