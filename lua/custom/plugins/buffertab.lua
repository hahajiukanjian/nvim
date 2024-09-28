return {
  'akinsho/bufferline.nvim',
  config = function()
    -- 关闭所有斜体
    local bufferline = require('bufferline')
    local highlights = require("catppuccin.groups.integrations.bufferline").get()

    bufferline.setup({
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
