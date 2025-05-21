return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    stages = 'static',  -- 取消淡入淡出动画
    render = 'compact', -- 紧凑模式
    max_width = 30,     -- 最大30字符
    fps = 5,
    level = 1,
    timeout = 2000,
    cmdline = {
      view = "cmdline", -- 命令行样式
    },
    messages = {
      enabled = true,
      view = "mini", -- 或 "notify"
    },
    popupmenu = {
      enabled = true,
    },
    lsp = {
      hover      = { border = { style = "rounded" } },
      signature  = { border = { style = "rounded" } },

      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      command_palette = true,
      long_message_to_split = true,
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end

}

