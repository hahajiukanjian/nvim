return {
    {
        "folke/tokyonight.nvim",
        dependencies = {
            "nvim-lualine/lualine.nvim",
            "nvim-tree/nvim-web-devicons",
            "utilyre/barbecue.nvim",
            "SmiteshP/nvim-navic",
        },
        config = function()
            vim.cmd([[colorscheme tokyonight-day]])
            require('lualine').setup {
                options = {
                    theme = 'tokyonight'
                },
            }
            require('barbecue').setup {
                theme = 'tokyonight',
            }
        end,
    },
}
