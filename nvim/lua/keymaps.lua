vim.g.mapleader = " " -- set the leader key to the space bar

-- Globals
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last change" })

-- Nvim Tree
vim.keymap.set("n", "<leader>e", ":NvimTreeOpen<CR>", { desc = "Open file tree" })
vim.keymap.set("n", "<leader>E", ":NvimTreeClose<CR>", { desc = "Close file tree" })

-- Nav Buffers
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { desc = "Previous Buffer" })

-- Telescope + Live Rip Grep
vim.keymap.set("n", "<leader>f", ":Telescope find_files theme=dropdown<CR>", { desc = "Fuzzy find files" })
vim.keymap.set('n', '<leader>g', ":Telescope live_grep theme=dropdown<CR>", { desc = "Fuzzy find files" })
