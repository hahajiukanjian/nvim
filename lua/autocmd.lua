-- 复制后高亮显示复制内容
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- 定义 Tokyonight 主题的视觉选区颜色
function tokyonight_visual_colors()
    vim.cmd('highlight Visual ctermfg=NONE ctermbg=NONE guifg=green guibg=white')
    vim.cmd('highlight VisualNOS ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE')
end

-- 在每次加载 Tokyonight 主题时调用函数以应用视觉选区颜色
vim.api.nvim_exec([[
  autocmd ColorScheme tokyonight-day lua tokyonight_visual_colors()
  autocmd ColorScheme tokyonight lua tokyonight_visual_colors()
]], false)

