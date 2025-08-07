vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.fillchars = 'eob: '
vim.o.textwidth = 80
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.g.vimtex_view_method = "zathura"
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/echasnovski/mini.pick" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/lervag/vimtex" },
  { src = "https://github.com/metalelf0/base16-black-metal-scheme" }
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Autocomplete
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.cmd("set completeopt+=noselect")

require("oil").setup()
require("mini.pick").setup()
require("nvim-autopairs").setup()
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false
  }
})
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "typescript",
    "javascript",
    "tsx",
    "rust",
    "python",
    "c",
    "cpp",
    "lua",
    "bash",
    "html",
    "css"
  },
  highlight = { enable = true }
})
vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "rust_analyzer",
  "ruff",
  "clangd",
  "bashls",
  "html",
  "cssls",
})

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end
})


vim.keymap.set("n", "<leader>R", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" })
vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>b", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set('n', '<leader>ph', ":Pick help<CR>")
vim.keymap.set('n', '<leader>pf', ":Pick files<CR>")
vim.keymap.set('n', '<leader>pg', ":Pick grep live<CR>")
vim.keymap.set('n', '<leader>oe', ":Oil<CR>")
vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>lo', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float,
  { desc = "Show error message" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.cmd("colorscheme base16-black-metal")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi LineNr guibg=NONE")
vim.cmd(":hi CursorLineNr guibg=NONE")
vim.cmd(":hi SignColumn guibg=NONE")
