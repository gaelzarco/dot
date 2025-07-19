vim.g.mapleader = " "

-- Misc
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last change" })
vim.keymap.set("n", "<leader>R", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Nav Buffers
vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>b", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>f", "<cmd>:e .<CR>", { desc = "Open parent directory" })

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>o', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>s', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>h', function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})
