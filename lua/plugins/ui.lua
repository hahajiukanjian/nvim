return {
  -- 滚动动画
  {
    "echasnovski/mini.animate",
    enabled = false,
  },

  -- 若仍有动画，可能是其他平滑滚动插件（如 neoscroll），一并禁用
  {
    "karb94/neoscroll.nvim",
    enabled = false
  },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- 帮助文档边框
      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- { "<Tab>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      -- { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        -- mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      views = {
        mini = {
          -- 1. 样式调整：半透明 + 浅色调边框
          border = { style = "single", highlight = "NoiceMiniBorder" },
          win_options = {
            winblend = 60, -- 增加透明度（0-100，越高越透明）
            winhighlight = "Normal:NoiceMiniNormal,FloatBorder:NoiceMiniBorder",
          },
          -- 2. 位置微调：向右上偏移，远离编辑区
          position = { row = -2, col = -2 }, -- 从右下角稍作偏移
          -- 3. 自动隐藏：显示 2 秒后消失（减少停留时间）
          timeout = 2000,
        },
      },
      -- 4. 过滤冗余 LSP 通知（避免重复弹出）
      routes = {
        {
          filter = {
            event = "notify",
            find = "Publish Diagnostics", -- 过滤 LSP 诊断通知
            -- 可根据需要添加更多过滤条件，如特定 LSP 服务器
            -- server = "jdtls",
          },
          opts = { skip = true }, -- 跳过显示这类通知
        },
        {
          filter = {
            event = "lsp",
            kind = "progress",       -- 过滤 LSP 进度通知（如编译进度）
          },
          view = "mini",             -- 用 mini 视图显示，避免大弹窗
          opts = { timeout = 1000 }, -- 1 秒后消失
        },
      },
      -- 保持原有 LSP 相关配置
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
}
