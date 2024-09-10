require('options')
require('plugins')
require('telescope')
require('colorscheme')
require('lsp')
require('keymaps')

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require("nvim-tree.api")
    -- Close NvimTree if a regular file is opened and it's not the NvimTree buffer
    if not api.tree.is_tree_buf() and #vim.api.nvim_list_wins() > 1 then
      api.tree.close()
    end
  end
})
