return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      -- 移除 format_on_save 配置（由 LazyVim 自动管理）

      -- 仅保留格式化工具配置（手动格式化和 LazyVim 自动机制都依赖这个）
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        python = { "black" },
        markdown = { "prettier" },
        -- 其他文件类型...
      },

      formatters = {
        stylua = { command = "stylua" },
        prettier = { command = "prettier" },
      },
    },

    init = function()
      -- LazyVim 原生使用 vim.g.autoformat 控制自动格式化
      -- 默认关闭自动格式化（等价于原来的 format_on_save = false）
      vim.g.autoformat = false

      -- 定义命令切换自动格式化状态（兼容 LazyVim 原生机制）
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- 缓冲区局部禁用
          vim.b.autoformat = false
        else
          -- 全局禁用
          vim.g.autoformat = false
        end
      end, { desc = "Disable autoformat", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        -- 恢复全局和缓冲区自动格式化
        vim.g.autoformat = true
        vim.b.autoformat = true
      end, { desc = "Enable autoformat" })
    end,
  },

  {
    "mikavilpas/yazi.nvim",

    event = "VeryLazy",

    dependencies = {
      -- snacks.nvim 是 yazi.nvim 官方推荐的依赖
      -- 安装说明参考：https://github.com/folke/snacks.nvim
      "folke/snacks.nvim"
    },

    -- 快捷键设置
    keys = {
      -- 在普通模式和可视模式下按 B 打开当前文件位置的 yazi
      {
        "B",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "在当前文件处打开 yazi",
      },
      {
        "<D-b>",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "在当前文件处打开 yazi",
      }
    },

    -- 插件参数配置（对应插件内部的 YaziConfig 定义）
    opts = {
      -- 是否在打开目录时自动替代 netrw（设置为 false 表示不替代）
      open_for_directories = false,
      open_in = "tab", -- 或 "split"，也可设为 "vsplit"
    },

    -- 插件初始化逻辑，在插件实际加载前执行
    init = function()
      -- 禁用默认的 netrw 插件（避免与 yazi 冲突）
      -- vim.g.loaded_netrw = 1  -- 若需要彻底禁用可解开注释
      vim.g.loaded_netrwPlugin = 1
    end,
  },

}
