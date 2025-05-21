return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
      char = "┃",
      smart_indent_cap = true,
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      char = "┃",
      injected_languages = true,
    },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "neo-tree", "lazy" },
    },
  },
}

