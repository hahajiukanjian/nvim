local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 加载插件模块
    { import = "plugins.autopairs" },       -- 自动补全括号
    { import = "plugins.blink" },           -- 自动补全
    { import = "plugins.color" },           -- 主题
    { import = "plugins.flutter" },         -- flutter
    { import = "plugins.heirline" },        -- 底部状态栏
    { import = "plugins.indentline" },      -- 函数块的线
    { import = "plugins.kitty" },           -- kitty配置文件语法检查
    -- { import = "plugins.lsp" },             -- 语言服务器
    { import = "plugins.mason" },           -- 语言服务器
    { import = "plugins.noice" },           -- 通知
    { import = "plugins.treesitter" },      -- 代码着色
    { import = "plugins.yazi" },            -- 文件资源管理器
    { import = "plugins.bufferline" },      -- 标签页
    { import = "plugins.dropbar" },         -- 导航栏
    { import = "plugins.neodev" },          -- 消除vim警告
    { import = "plugins.scrollview" },      -- 滚动条
  },
})
