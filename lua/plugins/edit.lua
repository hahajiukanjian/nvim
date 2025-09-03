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
}
