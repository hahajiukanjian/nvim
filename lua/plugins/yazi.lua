return {
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
}

