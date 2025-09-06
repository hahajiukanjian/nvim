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
        clangd = {
          -- 可选：通过 clangd 直接指定格式化风格
          cmd = {
            "clangd",
            -- 移除 --clang-format-style=Google（clangd 不支持该参数）
            "--enable-config",             -- 允许加载项目中的 .clang-format 文件
            "--completion-style=detailed", -- 增强补全体验（可选）
          },
        },
        -- Java
        jdtls = {
          -- 关键：配置jdtls加载Lombok
          init_options = {
            vmArgs = "-javaagent:" ..
                vim.fn.expand("~/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar"),
            -- 注意：路径需替换为你本地Lombok的实际路径（可通过Maven/Gradle下载）
          },
          settings = {
            java = {
              eclipse = {
                downloadSources = true,
              },
              maven = {
                downloadSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
            },
          },
        },
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


  -- lua/plugins/blink.lua
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
    },
    config = function()
      local blink = require("blink.cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      blink.setup({
        keymap = {
          preset = "none", -- 不加载默认预设，自定义全部快捷键

          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<CR>"] = { "accept", "fallback" },

          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },

          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },

          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

          -- ⌘+空格主动触发补全（手动触发）
          ["<C-e>"] = {
            function(cmp)
              cmp.show({}) -- 可根据需要指定 providers
            end,
          },

          ["<C-S-e>"] = {
            function()
              vim.lsp.buf.signature_help() -- 调用LSP的函数提示
            end,
          },
        },

        appearance = {
          nerd_font_variant = "mono",
        },

        completion = {
          documentation = { auto_show = true },
          trigger = {
            show_in_snippet = false, -- 与 super-tab 配合建议关闭
          },
          list = {
            selection = {
              -- 默认不选中第一个补全选项
              preselect = false
              -- preselect = function(ctx)
              --   return not blink.snippet_active({ direction = 1 })
              -- end,
            },
          },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },

        cmdline = {
          sources = function()
            local cmd_type = vim.fn.getcmdtype()
            if cmd_type == "/" or cmd_type == "?" then
              return { "buffer" }
            end
            if cmd_type == ":" then
              return { "cmdline" }
            end
            return {}
          end,
        },
      })
    end,
  },

  {
    "github/copilot.vim",
    event = "InsertEnter", -- 进入插入模式时加载
    config = function()
      -- 配置 Copilot 快捷键（与 nvim-cmp 兼容）
      vim.g.copilot_no_tab_map = true -- 禁用 Tab 映射（避免与补全冲突）
      vim.api.nvim_set_keymap(
        "i",
        "<C-l>", -- 使用 Ctrl+l 接受补全
        'copilot#Accept("")',
        { expr = true, silent = true, desc = "Accept Copilot suggestion" }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<C-]>", -- 使用 Ctrl+] 查看下一个建议
        "<Plug>(copilot-next)",
        { silent = true, desc = "Next Copilot suggestion" }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<C-[>", -- 使用 Ctrl+[ 查看上一个建议
        "<Plug>(copilot-prev)",
        { silent = true, desc = "Previous Copilot suggestion" }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<C-d>", -- 使用 Ctrl+d 关闭当前建议
        "<Plug>(copilot-dismiss)",
        { silent = true, desc = "Dismiss Copilot suggestion" }
      )
    end,
  },
}
