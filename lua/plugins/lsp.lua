return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- 第一步：禁用LSP默认的K键hover映射
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      for i, key in ipairs(keys) do
        if key[1] == "K" then
          keys[i] = { "K", false } -- 覆盖默认K键绑定
          break
        end
      end
      if
        not vim.tbl_contains(
          vim.tbl_map(function(k)
            return k[1]
          end, keys),
          "K"
        )
      then
        keys[#keys + 1] = { "K", false } -- 兜底：若未找到则追加禁用
      end
    end,
    dependencies = {
      -- 第二步：确保安装Dart LSP服务器
      { "williamboman/mason.nvim", opts = { ensure_installed = { "dartls" } } },
      -- Flutter增强插件
      {
        "akinsho/flutter-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("flutter-tools").setup({
            -- 关联Flutter SDK路径（依赖环境变量）
            flutter_path = vim.fn.expand("$FLUTTER_SDK/bin/flutter"),
            -- 集成dartls（与LSP配置联动）
            lsp = {
              on_attach = require("lazyvim.plugins.lsp.keymaps").on_attach, -- 复用LSP键位
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              settings = {
                dart = {
                  sdkPath = vim.fn.expand("$FLUTTER_SDK/bin/cache/dart-sdk/"), -- Dart SDK路径
                  formatting = { lineLength = 120 }, -- 代码格式化配置
                },
              },
            },
            -- Flutter工具配置
            tools = {
              hot_reload = true, -- 自动热重载
              dev_log = { enabled = true, open_cmd = "tabedit" }, -- 日志在新标签页打开
            },
          })

          -- Flutter专用快捷键
          -- local map = vim.keymap.set
          -- map("n", "<leader>fr", "<cmd>FlutterRun<CR>", { desc = "Flutter Run" })
          -- map("n", "<leader>fs", "<cmd>FlutterHotReload<CR>", { desc = "Hot Reload" })
          -- map("n", "<leader>fS", "<cmd>FlutterHotRestart<CR>", { desc = "Hot Restart" })
          -- map("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Quit Run" })
        end,
      },
    },
    opts = {
      servers = {
        -- 第三步：配置Dart LSP服务器
        dartls = {
          filetypes = { "dart" }, -- 仅对dart文件生效
          settings = {
            dart = {
              sdkPath = vim.fn.expand("$FLUTTER_SDK/bin/cache/dart-sdk/"), -- 与flutter-tools保持一致
              formatting = { enable = true, lineLength = 120 },
            },
          },
          on_attach = function(client, bufnr)
            -- 保留LazyVim默认LSP键位（已移除K键）
            require("lazyvim.plugins.lsp.keymaps").on_attach(client, bufnr)

            -- 额外Dart专用键位
            local map = vim.keymap.set
            map(
              "n",
              "<leader>fd",
              "<cmd>lua vim.lsp.buf.definition()<CR>",
              { buffer = bufnr, desc = "Go to Definition" }
            )
            map("n", "<leader>ff", "<cmd>lua vim.lsp.buf.format()<CR>", { buffer = bufnr, desc = "Format Code" })
          end,
        },
      },
    },
  },
}
