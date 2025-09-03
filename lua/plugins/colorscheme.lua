return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 最高优先级
		opts = function(_, opts)
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
			return opts
		end,
    config = function()
      require("catppuccin").setup({
        flavor = "macchiato",
        transparent_background = false,
        float = { transparent = false, solid = false },
      })
      vim.cmd.colorscheme("catppuccin-macchiato")
      vim.api.nvim_set_hl(0, "visual", { reverse = true })
    end,
  },
}
