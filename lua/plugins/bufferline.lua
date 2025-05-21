-- return {
--   config = function()
--     local colors = require("tokyonight.colors").setup()
-- 
--     require("bufferline").setup({
--       options = {
--         mode = "buffers",
--         diagnostics = "nvim_lsp",
--         separator_style = "slant",
--         show_buffer_close_icons = false,
--         show_close_icon = false,
--       },
--     })
--   end,
-- }
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- 关闭所有斜体
    local bufferline = require('bufferline')
    local highlights = require("tokyonight.colors").setup()

    require("bufferline").setup({
      options = {
        -- style_preset = bufferline.style_preset.no_italic,
        style_preset = {
          bufferline.style_preset.no_italic,
        },
        separator_style = "thin",
        highlights = highlights,
      }
    })
  end,
}

