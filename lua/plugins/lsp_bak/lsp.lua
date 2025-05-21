return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local blink = require("blink.cmp")

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "jdtls",
          "pyright",
          "html",
          "cssls",
          "bashls",
        },
      })

      local servers = require("plugins.lspconfig.servers")
      for server, config in pairs(servers) do
        config.capabilities = blink.get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
}


-- return {
--   {
--     "williamboman/mason.nvim",             -- LSP 安装器，用于安装各种语言服务
--     build = ":MasonUpdate",                -- 安装后执行更新命令
--     config = true,                         -- 启动后自动调用 setup()
--   },
--   {
--     "williamboman/mason-lspconfig.nvim",   -- mason 与 lspconfig 的桥梁插件
--     dependencies = {
--       "neovim/nvim-lspconfig",             -- LSP 配置核心插件
--       "hrsh7th/cmp-nvim-lsp",              -- 让 cmp 能获取 LSP 的补全能力
--     },
--     config = function()
--       local mason_lspconfig = require("mason-lspconfig")           -- 加载 mason-lspconfig
--       local lspconfig = require("lspconfig")                       -- 加载 LSP 配置核心
--       local capabilities = require("cmp_nvim_lsp").default_capabilities()  -- 获取补全能力配置
-- 
--       mason_lspconfig.setup({
--         ensure_installed = {              -- 自动安装的语言服务列表
--           "lua_ls",      -- Lua
--           "clangd",      -- C / C++
--           "jdtls",       -- Java
--           "pyright",     -- Python
--           "html",        -- HTML
--           "cssls",       -- CSS
--           "ts_ls",       -- JavaScript / TypeScript
--           "bashls",      -- bash
--         },
--       })
-- 
--       local servers = require("plugins.lspconfig.servers")            -- 引入具体语言配置
--       for server, config in pairs(servers) do           -- 遍历每个语言配置
--         config.capabilities = capabilities              -- 注入自动补全能力
--         lspconfig[server].setup(config)                 -- 启动该 LSP 服务
--       end
--     end,
--   },
-- }
