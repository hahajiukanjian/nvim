return {
  -- 用于管理语言服务器
  "williamboman/mason.nvim",
  event = "VeryLazy",
  dependencies = {
    -- neovim官方的lsp插件，用于将语言服务器和neovim做连接
    "neovim/nvim-lspconfig",
    -- neovim-lspconfig和mason的语言服务器命名规则不统一
    "williamboman/mason-lspconfig.nvim"
  },
  opts = {},
  config = function (_, opts)
    require("mason").setup(opts)
    local registry = require "mason-registry"

    local function setup(name, config)
      -- 安装语言服务器
      local success, package = pcall(registry.get_package, name)
      if success and not package:is_installed() then
          package:install()
      end

      local nvim_lsp = require("mason-lspconfig").get_mappings().package_to_lspconfig[name]
      config.capabilities = require("blink.cmp").get_lsp_capabilities()
      require("lspconfig")[nvim_lsp].setup(config)
    end

    local servers = {
      ["lua-language-server"] = {},
      pyright = {},
      ["html-lsp"] = {},
      ["css-lsp"] = {},
      ["typescript-language-server"] = {},
      ["emmet-ls"] = {},
    }

    for server, config in pairs(servers) do
      setup(server, config)
    end
    setup("lua-language-server", {})

    vim.cmd("LspStart")
    -- 在插入模式下，仍然显示信息
    -- vim.diagnostic.config({ update_in_insert = true })
  end,
}
