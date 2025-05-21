return {

  -- 自动补全括号
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- 补全选中单词的引号
  -- ysiw" ' ( [ {
  -- ysiwt
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- 快速跳转
  {
    "smoka7/hop.nvim",
    opts = {
      hint_position = 1,
    },
    keys = {
      { "F", "<Cmd>HopWord<CR>", desc = "hop word", silent = true },
    }
  }

}
