return {
  -- 基础LSP配置（包含禁用K键映射）
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- 禁用LSP默认的K键映射（hover功能）
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false } -- 取消K的默认绑定
    end,
    opts = {
      -- 确保mason自动安装所需LSP服务器
      servers = {
        -- C/C++
        clangd = {},
        -- Java
        jdtls = {},
        -- Python
        pyright = {}, -- 或使用 pylsp（需在mason中安装）
        -- HTML
        html = {},
        -- CSS
        cssls = {},
        -- JavaScript/TypeScript
        tsserver = {},
        -- Vue（需安装vue-language-server）
        volar = {
          filetypes = { "vue" },
          settings = {
            vue = {
              format = {
                defaultFormatter = {
                  html = "prettier",
                  css = "prettier",
                  scss = "prettier",
                  javascript = "prettier",
                  typescript = "prettier",
                },
              },
            },
          },
        },
      },
      inlay_hints = { enabled = false },
    },
  },

  -- 确保mason安装所有LSP服务器
  {

    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP服务器
        "clangd",                     -- C/C++
        "jdtls",                      -- Java
        "pyright",                    -- Python
        "html-lsp",                   -- HTML
        "css-lsp",                    -- CSS
        "typescript-language-server", -- JS/TS
        "vue-language-server",        -- Vue
        -- 可选：对应语言的格式化工具
        "stylua",                     -- Lua格式化
        "prettier",                   -- HTML/CSS/JS/TS/Vue格式化
        "black",                      -- Python格式化
      },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,               -- 确保插件启动时加载（非懒加载）
    dependencies = {
      "nvim-lua/plenary.nvim",  -- 依赖库（LazyVim通常已安装）
      "stevearc/dressing.nvim", -- 优化UI（可选，提升弹窗体验）
    },
    config = function()
      require("flutter-tools").setup({
        -- 配置Flutter SDK路径（使用环境变量，与之前保持一致）
        flutter_path = vim.fn.expand("$FLUTTER_SDK/bin/flutter"),

        -- 自动检测项目中的Flutter SDK（优先于上面的全局路径）
        fvm = true, -- 支持FVM（Flutter版本管理工具），若无FVM可设为false

        -- 集成Dart LSP（自动使用Flutter内置的dartls，无需手动配置）
        lsp = {
          on_attach = function(client, bufnr)
            -- 在这里添加LSP回调（如快捷键映射）
            -- 例如：跳转到定义（gD）、查找引用（gr）等
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
          end,
          settings = {
            dart = {
              lineLength = 120,             -- 代码格式化行宽
              completeFunctionCalls = true, -- 自动补全函数参数
              showTodos = true,             -- 显示TODO注释
            },
          },
        },

        -- 工具命令配置（热重载、运行等）
        debugger = {
          enabled = true, -- 启用调试（需配合nvim-dap）
          run_via_dap = true,
        },

        -- 设备管理
        device = {
          enabled = true,
        },

        -- 命令行工具UI配置
        ui = {
          -- 提示信息的样式（使用LazyVim主题配色）
          border = "rounded",
          notification_style = "native",
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "cmake",
        "cpp",
        "css",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "http",
        "java",
        "php",
        "rust",
        "scss",
        "sql",
        "svelte",
        "dart",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
