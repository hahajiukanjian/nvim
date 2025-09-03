local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- 添加 LazyVim 并覆盖默认主题配置
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      -- 关键：强制 LazyVim 使用 catppuccin 作为默认主题
      opts = {
        colorscheme = "catppuccin-macchiato", -- 这里会覆盖 LazyVim 内部的 tokyonight 默认值
      },
    },
    -- 导入你的插件
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  -- 安装时的默认主题（仅首次安装生效）
  install = { colorscheme = { "catppuccin" } }, -- 移除 tokyonight
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
