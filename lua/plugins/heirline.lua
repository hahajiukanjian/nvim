return {
  "rebelot/heirline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufWinEnter",
  config = function()
    require("heirline").setup({
      statusline = require("other.heirline_settings"),
    })
  end,
}

