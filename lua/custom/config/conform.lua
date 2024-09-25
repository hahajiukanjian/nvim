require('conform').setup {
  -- 当格式化器出错时，禁用通知
  notify_on_error = false,

  -- 定义保存文件时自动格式化的逻辑
  format_on_save = function(bufnr)
    -- 禁用自动格式化保存功能的语言（没有标准化风格的语言）
    -- 可以在此添加更多语言，或重新启用被禁用的语言
    local disable_filetypes = { c = true }
    return {
      timeout_ms = 2000,                                            -- 格式化超时时间设置为 2000 毫秒
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype], -- 如果不在禁用列表中，启用 LSP 备选格式化器
    }
  end,

  -- 按文件类型设置的格式化器
  formatters_by_ft = {
    lua = { 'stylua' },                  -- 使用 stylua 格式化 Lua 文件
    cpp = { 'clang-format' },            -- 使用 clang-format 格式化 C++ 文件
    python = { 'yapf', 'isort' },        -- 使用 yapf 和 isort 格式化 Python 文件
    sh = { 'shfmt' },                    -- 使用 shfmt 格式化 shell 脚本
    snakemake = { 'snakefmt' },          -- 使用 snakefmt 格式化 Snakemake 文件
    markdown = { 'prettierd', 'cbfmt' }, -- 使用 prettierd 和 cbfmt 格式化 Markdown 文件
  },

  -- 自定义的格式化器配置
  formatters = {
    cbfmt = {
      command = 'cbfmt',
      args = { '-w', '--config', vim.fn.expand '~' .. '/.config/cbfmt.toml', '$FILENAME' }, -- 使用自定义配置文件 cbfmt.toml 格式化文件
    },
    yapf = { command = 'yapf' },                                                            -- 使用 yapf 格式化 Python 文件
  },
}
