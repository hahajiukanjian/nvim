--- 为 Neovim 提供颜色高亮显示，比如在代码中显示颜色值（如十六进制或 RGB）对应的颜色块。
return {
  -- 指定插件仓库
  'NvChad/nvim-colorizer.lua',

  -- 指定启用插件的文件类型
  ft = { 'html', 'xml', 'python', 'lua', 'dart' }, -- 在 lua、html、xml、python 文件中启用 colorizer 插件

  -- 配置插件的选项
  opts = {
    user_default_options = {
      -- 禁用颜色名称识别（例如 'red', 'blue'），仅支持十六进制或 RGB 颜色值
      names = false,
    },
  },
}
