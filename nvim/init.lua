vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildmenu = true
vim.o.wrap = false
vim.o.showmatch = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.opt.colorcolumn = "80"
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.list = true
vim.opt.listchars = { tab = "→ ", space = "·", trail = "·", nbsp = "␣" }
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.pumheight = 10
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.fillchars = "eob: "
vim.o.textwidth = 80
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect,noinsert"
vim.o.cursorline = true
vim.g.mapleader = " "

vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/akinsho/bufferline.nvim.git" },
    { src = "https://github.com/metalelf0/base16-black-metal-scheme.git" }
})

require('lspconfig').lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})
require("bufferline").setup{}
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

vim.cmd.colorscheme("base16-black-metal-dark-funeral")
--vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
--vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
--vim.cmd(":hi statusline guibg=NONE")
--vim.cmd(":hi LineNr guibg=NONE")
--vim.cmd(":hi CursorLineNr guibg=NONE")
--vim.cmd(":hi SignColumn guibg=NONE")
