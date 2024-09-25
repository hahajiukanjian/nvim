return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>ff', require('telescope.builtin').find_files, desc = '[f]查找文件' },
    { '<leader>fg', require('telescope.builtin').live_grep, desc = '[g]查找字符串' },
    { '<leader><leader>', require('telescope.builtin').buffers, desc = '[<leader>]切换打开的buffer' },
    { '<leader>fh', require('telescope.builtin').help_tags, desc = '[h]查找帮助文档' },
    { '<leader>f.', require('telescope.builtin').oldfiles, desc = '[.]查找最近打开的文件' },
  },
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    })
    require('telescope').load_extension('fzf')
  end,
}
