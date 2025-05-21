return {
  {
    "akinsho/flutter-tools.nvim",                           -- Flutter LSP & DevTools 插件
    dependencies = {
      "nvim-lua/plenary.nvim",                              -- 必须依赖
      "stevearc/dressing.nvim",                             -- 可选 UI 弹窗增强
      "neovim/nvim-lspconfig",                              -- 基础 LSP 支持
    },
    ft = "dart",
    config = function()
      require("flutter-tools").setup({
        -- ‼️指定flutter的路径，为了方便在yazi中运行
        flutter_path = "/Users/hahajiukanjian/Dev/flutter/bin/flutter",
        lsp = {
          -- capabilities = require("cmp_nvim_lsp").default_capabilities(), -- 与 cmp 补全集成
          capabilities = vim.lsp.protocol.make_client_capabilities(),
          on_attach = function(client, bufnr)
            -- 你可以在这里绑定 Flutter 特有快捷键
            local map = vim.keymap.set
            map("n", "<leader>fr", "<cmd>FlutterRun<cr>", { buffer = bufnr, desc = "Flutter Run" })
            map("n", "<leader>fd", "<cmd>FlutterDevices<cr>", { buffer = bufnr, desc = "Devices" })
            map("n", "<leader>fR", "<cmd>FlutterRestart<cr>", { buffer = bufnr, desc = "Restart" })
            -- 自动格式化 dart
            if client.name == "dartls" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ async = false })
                end,
              })
            end
          end,
          root_dir = function (fname)
            return require("lspconfig.util").root_pattern("pubspec.yaml")(fname)
          end,
          settings = {
            dart = {
              enableSdkFormatter = true,
            },
          },
        },
        dev_tools = {
          -- 可选：自动打开 Flutter DevTools
          autostart = true,
        },
      })
    end,
  },
}

