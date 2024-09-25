local icons = require 'custom.ui.icons' -- 引入自定义图标库

-- 配置诊断信息的显示方式
vim.diagnostic.config {
  virtual_text = {
    spacing = 4, -- 文本间距
    prefix = '󰧞', -- 自定义前缀图标
  },
  float = {
    severity_sort = true, -- 按严重性排序
    source = 'if_many',   -- 当有多个来源时才显示诊断来源
  },
  severity_sort = true,   -- 启用按严重性排序
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error, -- 错误类型的图标
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,   -- 警告类型的图标
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,   -- 信息类型的图标
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,   -- 提示类型的图标
    },
  },
}

-- 绑定键用于调用外部命令 lb-format 格式化文件
vim.keymap.set('n', '<leader>lF', '<cmd>!lb-format %<cr>', { desc = 'Use lb-format' })

-- 创建一个 LSP 附加到 buffer 时触发的自动命令
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- 定义简化的映射函数，避免重复代码
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- 切换诊断信息的显示和隐藏
    map(
      '<leader>td',
      (function()
        local diag_status = 1 -- 1 表示显示，0 表示隐藏
        return function()
          if diag_status == 1 then
            diag_status = 0
            vim.diagnostic.config { underline = false, virtual_text = false, signs = false, update_in_insert = false }
          else
            diag_status = 1
            vim.diagnostic.config { underline = true, virtual_text = true, signs = true, update_in_insert = true }
          end
        end
      end)(),
      'Toggle diagnostics display'
    )

    -- 打开诊断浮动窗口
    map('<leader>ld', function()
      vim.diagnostic.open_float { source = true }
    end, 'LSP Open Diagnostic')

    -- 跳转到符号定义位置
    map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

    -- 查找引用
    map('gr', require('telescope.builtin').lsp_references, 'Goto References')

    -- 跳转到实现
    map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

    -- 跳转到类型定义
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

    -- 重命名符号
    map('<leader>rn', vim.lsp.buf.rename, 'Lsp Rename')

    map(')', vim.lsp.buf.hover, '显示光标下的内容文档')

    -- 执行代码操作
    map('<A-CR>', vim.lsp.buf.code_action, 'Lsp Action')

    -- 跳转到声明位置
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

    -- 高亮光标下的符号
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and vim.bo.filetype ~= 'bigfile' then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- 切换代码中的 Inlay Hints（需要 LSP 支持）
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})

-- 设置默认的 LSP 功能
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- 设置 LSP 服务器配置，包括 clangd, pylsp, lua_ls 等
local mason_servers = {
  clangd = {
    capabilities = { offsetEncoding = 'utf-8' },
    cmd = { 'clangd' }
  },
  pylsp = {
    pyflake = { enabled = false },
    pylint = { enabled = false },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
}

require 'lspconfig'.dartls.setup {
  capabilities = capabilities,
}

-- 启动 Mason 插件
require('mason').setup()

-- 设置 Mason 的 LSP 安装和配置
require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server = mason_servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}


-- 本地 LSP 服务器配置
local local_servers = {
  basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    root_dir = function(fname)
      local util = require 'lspconfig.util'
      local dir_name = util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',
        'pyrightconfig.json', '.git')(fname)
      if dir_name == nil then
        return vim.fs.dirname(fname)
      else
        return dir_name
      end
    end,
  },
}

-- 为本地 LSP 服务器设置配置
for server_name, server_opts in pairs(local_servers) do
  require('lspconfig')[server_name].setup(server_opts)
end

-- 启动 LSP
vim.cmd 'LspStart'
