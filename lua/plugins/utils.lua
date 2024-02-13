return {
    {
        -- 保存当前buffer的工作状态，如：保存上下左右窗口布局
        "folke/persistence.nvim",
        config = function()
            require("persistence").setup()
            vim.keymap.set("n","<leader>qs", [[<cmd>lua require("persistence").load()<cr>]])
            vim.keymap.set("n","<leader>ql", [[<cmd>lua require("persistence").load({ last = true})<cr>]])
            vim.keymap.set("n","<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]])
        end
    },
    {
        -- 自动补全标点符号
        "windwp/nvim-autopairs",
        opts = {
            enable_check_bracket_line = true,
        },
    },
    {
        -- 打开文件后，将光标移动到上次关闭该文件时所在的位置
        "ethanholz/nvim-lastplace",
        config = true,
    },
    {
        -- 跳转插件
        "folke/flash.nvim",
        config = function()
            require("flash").setup()
            vim.keymap.set({"n","x","o"},"s",
                function()
                    require("flash").jump({
                        search = {
                            mode = function(str)
                                return "\\<" .. str
                            end,
                        },
                    })
                end
            )
            -- 按下y后按r可以复制单词
            vim.keymap.set({"o"},"r",
                function()
                    require("flash").remote()
                end
            )
        end,
    },
    -- {
    --     -- 拼写检查
    --     "kamykn/spelunker.vim",
    --     config = function()
    --         vim.g.spelunker_check_type = 2
    --     end
    -- },
    {
        -- md文件预览
        "ellisonleao/glow.nvim",
        config = true,
    },
    {
        -- 文件树
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup()
            vim.keymap.set({"n", "v"},"<leader>e",[[<cmd>Neotree toggle<CR>]])
        end
    },
    {
        -- 显示快捷键
        "folke/which-key.nvim",
        config = true,
    },
    {
        -- 提供更好的text objects
        'echasnovski/mini.ai',
        config = true,
    },
    {
        -- 快速注释
        "echasnovski/mini.comment",
        config = true,
    },
    {
        -- 过滤窗口
        "s1n7ax/nvim-window-picker",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = true,
                    bo = {
                        filetype = { "fidget", "neo-tree" }
                    }
                }
            })
            vim.keymap.set("n",
                "<c-w>p",
                function()
                    local window_number = require('window-picker').pick_window()
                    if window_number then vim.api.nvim_set_current_win(window_number) end
                end
            )
        end
    },
}
