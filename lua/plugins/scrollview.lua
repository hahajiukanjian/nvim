return {
  "dstein64/nvim-scrollview",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("scrollview").setup({
      signs_on_startup = { "diagnostics", "git_signs" }, -- 显示哪些信息
      current_only = true,
      base = "right",     -- 滚动条显示在右边
      column = 1,         -- 靠右边一列
      diagnostics_severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
    })
    vim.api.nvim_set_hl(0, "ScrollView", {
      -- fg = "#ffffff",      -- 前景色（滚动条颜色）
      bg = "#545c7e",      -- 背景透明
      blend = 30,          -- 透明度（越高越透明）
    })
  end,
}

