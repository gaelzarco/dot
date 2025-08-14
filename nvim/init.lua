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
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/lervag/vimtex" },
  { src = "https://github.com/metalelf0/base16-black-metal-scheme" },
  { src = "https://github.com/metalelf0/black-metal-theme-neovim" }
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

require("oil").setup()
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


vim.keymap.set('n', 'gre', vim.diagnostic.open_float,
  { desc = "Show error message" })
vim.keymap.set('n', 'grf', vim.lsp.buf.format)

vim.cmd("colorscheme base16-black-metal-dark-funeral")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi LineNr guibg=NONE")
vim.cmd(":hi CursorLineNr guibg=NONE")
vim.cmd(":hi SignColumn guibg=NONE")
