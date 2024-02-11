return {
    {
        "akinsho/bufferline.nvim",
        config = {},
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
}
