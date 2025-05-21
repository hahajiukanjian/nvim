return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")

    -- 显式设置 Visual 高亮背景，而不是 reverse
    vim.api.nvim_set_hl(0, "Visual", {
      bg = "#33467c",  -- 来自 tokyonight visual 选区蓝
      fg = "NONE",
    })

    -- 高亮选中区域为 reverse
    -- vim.api.nvim_set_hl(0, "visual", { reverse = true })
  end
}
