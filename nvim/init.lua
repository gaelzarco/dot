require('options')
require('plugins')
require('telescope')
require('colorscheme')
require('lsp')
require('keymaps')

vim.api.nvim_create_autocmd({"QuitPre"}, {
    callback = function() vim.cmd("NvimTreeClose") end,
})
