return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- flutter-tools 需要尽早加载
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- 可选，提供更好UI
    },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          on_attach = function(client, bufnr)
            -- 继承 LazyVim 的 LSP keymaps
            require("lazyvim.util").lsp.on_attach(client, bufnr)
          end,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        },
        debugger = { -- 如果需要调试
          enabled = true,
          run_via_dap = true,
          register_configurations = function(paths)
            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
}
