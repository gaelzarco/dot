vim.g.mapleader = " " -- set the leader key to the space bar

-- Globals
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last change" })

-- Nvim Tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Nav Buffers
vim.keymap.set("n", "<leader>b", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>B", ":bp<CR>", { desc = "Previous Buffer" })

-- Telescope + Live Rip Grep
vim.keymap.set("n", "<leader>f", ":Telescope find_files theme=dropdown<CR>", { desc = "Fuzzy find files" })
vim.keymap.set('n', '<leader>g', ":Telescope live_grep theme=dropdown<CR>", { desc = "Fuzzy find files" })

-- Language Server 
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', '<leader>D', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', '<leader>i', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', '<leader>o', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', '<leader>s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<leader>X', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  end,
})

