return {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },            -- 不把全局变量 vim 视为 undefined
        },
        workspace = {
          checkThirdParty = false,       -- 不提示 third-party 检查
        },
      },
    },
  },

  clangd = {},                            -- C / C++：默认配置即可
  jdtls = {},                             -- Java：使用默认配置
  pyright = {},                           -- Python：常用 LSP，无需特殊设置
  html = {},                              -- HTML：默认配置
  cssls = {},                             -- CSS：默认配置
  ts_ls = {},                             -- JavaScript / TypeScript
  bashls = {},                            -- bash
}

