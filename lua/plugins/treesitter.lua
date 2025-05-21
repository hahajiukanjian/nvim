return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "bash", "dart", "json", "html", "css" },
    highlight = { enable = true },
    indent = { enable = true },
  },
}

