return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "deep",
        transparent = false,
      })
      require("onedark").load()
      vim.api.nvim_set_hl(0, "visual", { reverse = true })
    end,
  },
}
