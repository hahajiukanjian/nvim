return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- 禁用LSP默认的K键映射（hover功能）
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false } -- 取消K的默认绑定
    end,
  },
}
