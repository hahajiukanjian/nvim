return {
  -- 滚动动画
  {
    "echasnovski/mini.animate",
    enable = false,
  },

  -- 若仍有动画，可能是其他平滑滚动插件（如 neoscroll），一并禁用
  {
    "karb94/neoscroll.nvim",
    enabled = false
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
}
