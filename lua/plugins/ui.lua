return {
    {
        "akinsho/bufferline.nvim",
        config = function()
            require('bufferline').setup {
                highlights = {
                    buffer_selected = {
                        italic = false,
                    },
                }
            }
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },

    {
        "goolord/alpha-nvim",
        config = function()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    },

    {
        "RRethy/vim-illuminate",
        config = function()
            require('illuminate').configure()
        end
    },
}
