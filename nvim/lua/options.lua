vim.opt.clipboard = 'unnamedplus'   -- use system clipboard 
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.mouse = 'a'                 -- allow the mouse to be used in Nvim

-- Goated
vim.o.scrolloff = 10 
vim.o.sidescrolloff = 10
vim.o.fillchars='eob: '            -- fuck tildes
vim.o.textwidth = 80

-- Tab
vim.opt.tabstop = 2                 -- number of visual spaces per TAB
vim.opt.softtabstop = 2             -- number of spacesin tab when editing
vim.opt.shiftwidth = 2              -- insert 2 spaces on a tab
vim.opt.expandtab = true            -- tabs are spaces
vim.opt.smartindent = true          -- self-explanatory

-- UI config
vim.opt.number = true               -- show absolute number
vim.opt.relativenumber = true       -- add numbers to each line on the left side
vim.opt.cursorline = true           -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal splits right
vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false            -- no "-- INSERT --" mode hint
vim.o.updatetime = 2                -- fast diagnostics

-- Searching
vim.opt.incsearch = true            -- search as characters are entered
vim.opt.hlsearch = false            -- do not highlight matches
vim.opt.ignorecase = true           -- ignore case in searches by default
vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered
