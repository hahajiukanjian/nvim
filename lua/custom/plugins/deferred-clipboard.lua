--- 该插件对于需要在不同系统（例如没有系统剪贴板的远程服务器）上使用 Neovim 时非常有用。
--- 可以延迟加载并处理剪贴板操作，在不同系统之间提供更加灵活的剪贴板功能。

return {
  'EtiamNullam/deferred-clipboard.nvim', -- 插件的路径（GitHub 仓库）

  config = function()
    -- 插件的配置函数
    require('deferred-clipboard').setup {
      lazy = true,              -- 延迟加载配置，只有在需要时才会启用剪贴板功能
      fallback = 'unnamedplus', -- 如果插件未能成功使用系统剪贴板，则回退到 'unnamedplus' 作为默认剪贴板设置
    }
  end,
}
