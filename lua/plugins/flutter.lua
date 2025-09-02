return {
  -- 1. 基础LSP配置（dartls）
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- 管理LSP服务器
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
    },
    opts = {
      servers = {
        dartls = {
          -- 自动为Dart文件启动LSP
          filetypes = { "dart" },
          -- 配置Dart SDK路径
          settings = {
            dart = {
              sdkPath = vim.fn.expand("$FLUTTER_SDK/bin/cache/dart-sdk/"),
              -- 代码格式化配置
              formatting = {
                lineLength = 120,
                enable = true,
              },
            },
          },
          -- LSP附加到缓冲区时的配置
          on_attach = function(client, bufnr)
            -- 禁用内置格式化（使用Flutter自带格式化）
            client.server_capabilities.documentFormattingProvider = false

            -- 基础LSP键位（跳转、重命名等）
            local map = vim.keymap.set
            map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr, desc = "Go to Definition" })
            map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr, desc = "Show References" })
            map("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = bufnr, desc = "Rename Symbol" })
          end,
        },
      },
    },
  },

  -- 2. Flutter增强工具（热重载、调试等）
  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- 立即加载以识别Dart文件
    dependencies = {
      "nvim-lua/plenary.nvim", -- 工具库依赖
      "stevearc/dressing.nvim", -- 优化弹窗UI（可选）
    },
    config = function()
      -- 配置Flutter工具
      require("flutter-tools").setup({
        -- 关联Flutter SDK
        flutter_path = vim.fn.expand("$FLUTTER_SDK/bin/flutter"),

        -- 集成LSP（复用上面的dartls配置）
        lsp = {
          on_attach = function(client, bufnr)
            -- 继承基础LSP键位
            require("lazyvim.plugins.lsp.keymaps").on_attach(client, bufnr)

            -- Flutter专属键位
            -- local map = vim.keymap.set
            -- map("n", "<leader>flr", "<cmd>FlutterRun<CR>", { buffer = bufnr, desc = "Flutter Run" })
            -- map("n", "<leader>fls", "<cmd>FlutterHotReload<CR>", { buffer = bufnr, desc = "Hot Reload" })
            -- map("n", "<leader>flS", "<cmd>FlutterHotRestart<CR>", { buffer = bufnr, desc = "Hot Restart" })
            -- map("n", "<leader>flq", "<cmd>FlutterQuit<CR>", { buffer = bufnr, desc = "Quit Run" })
            -- map("n", "<leader>fld", "<cmd>FlutterDevices<CR>", { buffer = bufnr, desc = "Show Devices" })
            -- map("n", "<leader>flv", "<cmd>FlutterVisualDebug<CR>", { buffer = bufnr, desc = "Visual Debug" })
          end,
        },

        -- 工具行为配置
        tools = {
          -- 热重载配置
          hot_reload = true, -- 保存时自动热重载

          -- 日志配置
          dev_log = {
            enabled = true,
            open_cmd = "tabedit", -- 日志在新标签页打开
          },

          -- 代码动作菜单（快速修复等）
          code_actions = {
            enabled = true,
            icon = "💡",
          },
        },

        -- 调试配置（可选，需配合nvim-dap）
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
      })
    end,
  },

  -- -- 3. 代码补全支持（适配LSP）
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp", -- LSP补全源
  --     "hrsh7th/cmp-buffer", -- 缓冲区补全
  --   },
  --   opts = function(_, opts)
  --     -- 添加LSP补全源
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, { name = "nvim_lsp" })
  --     table.insert(opts.sources, { name = "buffer" })
  --   end,
  -- },
}
