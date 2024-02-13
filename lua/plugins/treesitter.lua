return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/playground",
    },
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "vim",
            "vimdoc",
            "java",
        },
        highlight = {
            enable = true,
        },
        indent = { 
            enable = true 
        },
        playground = {
            enable = true,
        },
    }
}
