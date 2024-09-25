local pip_args = {}

-- -- 根据主机名来判断是否需要设置代理
-- if vim.startswith(vim.fn.hostname(), 'n819') then
--   -- 如果主机名以 'n819' 开头，设置代理为 'http://lbproxy:8080'
--   pip_args = { '--proxy', 'http://lbproxy:8080' }
-- else
--   -- 否则不使用代理
--   pip_args = {}
-- end

return {
  {
    -- Neovim LSP 配置主插件
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' }, -- 在打开文件或新建文件时加载
    dependencies = {
      -- 自动安装 LSP 及相关工具到 Neovim 的 stdpath
      {
        'williamboman/mason.nvim',
        event = 'VeryLazy', -- 在懒加载时触发
        opts = {
          pip = {
            upgrade_pip = false,     -- 不升级 pip
            install_args = pip_args, -- 根据条件设置 pip 安装时的额外参数
          },
        },
      },
      'williamboman/mason-lspconfig.nvim',               -- LSP 安装和配置插件
      { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' }, -- 用于自动补全的 LSP 插件
    },
    config = function()
      require 'custom.config.lsp'                      -- 引入自定义 LSP 配置
    end,
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' }, -- LSP 相关命令
  },

  {
    -- `lazydev` 用于 Neovim 的 Lua LSP 配置
    'folke/lazydev.nvim',
    ft = 'lua', -- 仅在编辑 Lua 文件时加载
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } }, -- 当使用 `vim.uv` 时加载 `luvit` 类型
      },
    },
  },
  { 'Bilal2453/luvit-meta',     lazy = true }, -- `luvit` 的元数据，懒加载
  {
    -- 自动格式化插件
    'stevearc/conform.nvim',
    event = { 'BufWritePre' }, -- 在保存文件之前触发
    cmd = { 'ConformInfo' },   -- 格式化信息命令
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true } -- 异步格式化
        end,
        mode = '',                                                        -- 适用于所有模式
        desc = 'Lsp Format buffer',                                       -- 键绑定的描述
      },
    },
    config = function()
      require 'custom.config.conform' -- 引入自定义格式化配置
    end,
  },
  { 'patricorgi/vim-snakemake', ft = 'Snakefile' }, -- `snakemake` 文件支持
  {
    -- LSP 签名插件
    'ray-x/lsp_signature.nvim',
    ft = { 'python', 'cpp', 'dart', 'java' }, -- 仅在 Python 和 C++ 文件时加载
    main = 'lsp_signature',
    opts = {
      hint_enable = false, -- 禁用提示，避免在某些终端中崩溃
    },
    specs = {
      {
        'folke/noice.nvim', -- 可选插件，用于 UI 增强
        optional = true,
        opts = {
          lsp = {
            signature = { enabled = false }, -- 禁用 LSP 签名功能
            hover = { enabled = false },     -- 禁用 LSP 悬停提示
          },
        },
      },
    },
  },
}
