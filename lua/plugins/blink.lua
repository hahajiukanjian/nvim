return {
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
        ["<D-Space>"] = {
          function(cmp)
            cmp.show({}) -- 可根据需要指定 providers
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
}

-- return {
--   {
--     "hrsh7th/nvim-cmp",                           -- 自动补全主插件
--     event = "InsertEnter",                        -- 插入模式时加载（懒加载）
--     dependencies = {
--       "L3MON4D3/LuaSnip",                         -- 代码片段引擎
--       "rafamadriz/friendly-snippets",            -- 多语言常用代码片段库
--       "saadparwaiz1/cmp_luasnip",                -- LuaSnip 和 cmp 的集成插件
--       "hrsh7th/cmp-buffer",                      -- 来自当前 buffer 的补全
--       "hrsh7th/cmp-path",                        -- 文件路径补全
--       "hrsh7th/cmp-nvim-lsp",                    -- LSP 补全支持
--     },
--     config = function()
--       local cmp = require("cmp")
--       local luasnip = require("luasnip")
-- 
--       require("luasnip.loaders.from_vscode").lazy_load()  -- 加载代码片段（VSCode格式）
-- 
--       cmp.setup({
--         snippet = {
--           expand = function(args)
--             luasnip.lsp_expand(args.body)        -- 展开代码片段
--           end,
--         },
--         mapping = cmp.mapping.preset.insert({    -- 快捷键设置
--           ["<Tab>"]     = cmp.mapping.select_next_item(),      -- Tab 选择下一个
--           ["<S-Tab>"]   = cmp.mapping.select_prev_item(),      -- Shift-Tab 上一个
--           ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- 回车确认补全
--           ["<D-Space>"] = cmp.mapping.complete(),              -- Ctrl-Space 手动补全
--         }),
--         sources = cmp.config.sources({           -- 补全内容来源
--           { name = "nvim_lsp" },                 -- 来自语言服务器
--           { name = "luasnip" },                  -- 来自代码片段
--           { name = "buffer" },                   -- 当前文件的内容
--           { name = "path" },                     -- 文件路径
--         }),
--         formatting = {
--           format = function(entry, vim_item)
--             vim_item.menu = ({
--               nvim_lsp = "[LSP]",                -- LSP 来源标识
--               luasnip = "[Snip]",                -- 片段来源标识
--               buffer   = "[Buf]",                -- Buffer 来源标识
--               path     = "[Path]",               -- 路径来源标识
--             })[entry.source.name]
--             return vim_item
--           end,
--         },
--       })
--     end,
--   },
-- }
