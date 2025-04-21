local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { 'L3MON4D3/LuaSnip' },
  { 'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp'
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "hyprlang" },
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      }
    }
  },  
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end
  },
  { 'metalelf0/base16-black-metal-scheme' },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim"
    },
    keys = {
      {
        "<leader>f",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>F",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  }
})
