vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.opt.colorcolumn = "80"
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.fillchars = 'eob: '
vim.o.textwidth = 80
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect,noinsert"
vim.g.mapleader = " "

vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/windwp/nvim-ts-autotag" }
})

vim.api.nvim_create_autocmd("InsertCharPre", {
    pattern = {
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "lua",
        "python",
        "rust",
        "cpp",
        "html",
        "css"
    },
    callback = function()
        local col = vim.fn.col(".")
        if col > 80 then
            vim.v.char = ""
        end
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true
            })
        end
    end,
})

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

vim.keymap.set('n', 'gre', vim.diagnostic.open_float,
    { desc = "Show error message" })
vim.keymap.set('n', 'grf', vim.lsp.buf.format)

vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi LineNr guibg=NONE")
vim.cmd(":hi CursorLineNr guibg=NONE")
vim.cmd(":hi SignColumn guibg=NONE")
