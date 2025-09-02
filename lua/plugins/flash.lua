return {
  {
    "folke/flash.nvim",
    -- 先禁用LazyVim对Flash的默认配置（关键步骤）
    dependencies = {
      { "LazyVim/LazyVim", opts = { plugins = { flash = false } } },
    },
    opts = {
      modes = {
        normal = { keys = { "s" } }, -- 只保留s键
        visual = { keys = { "s" } },
        operator = { keys = { "s" } },
        search = { keys = { "s" } },
      },
    },
    config = function(_, opts)
      -- 加载Flash插件
      local flash = require("flash")
      flash.setup(opts)

      -- 强制删除所有模式下的S键映射（关键操作）
      vim.keymap.del("n", "S") -- normal模式
      vim.keymap.del("x", "S") -- visual模式
      vim.keymap.del("o", "S") -- operator-pending模式

      -- 重新设置你的S键映射（保存功能）
      vim.keymap.set({ "n", "x", "o" }, "S", "<cmd>w<CR>", {
        noremap = true,
        desc = "保存文件",
      })
    end,
  },
}
