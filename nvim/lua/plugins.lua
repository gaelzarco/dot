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
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
      'akinsho/bufferline.nvim',
      version = "*",
      dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
      end,
    },
    {
      'mikew/nvim-drawer',
      opts = {},
      config = function(_, opts)
        local drawer = require('nvim-drawer')
        drawer.setup(opts)

        drawer.create_drawer({
          -- This is needed for nvim-tree.
          nvim_tree_hack = true,

          -- Alternatively, you can have it floating.
          size = 30,
          position = 'float',
          win_config = {
            margin = 2,
            border = 'rounded',
            anchor = 'CE',
            width = 40,
            height = '80%',
          },

          on_vim_enter = function(event)
            vim.keymap.set('n', '<leader>e', function()
              event.instance.focus_or_toggle()
            end)
          end,

          on_did_create_buffer = function()
            local nvim_tree_api = require('nvim-tree.api')
            nvim_tree_api.tree.open({ current_window = true })
          end,

          on_did_open = function()
            local nvim_tree_api = require('nvim-tree.api')

            vim.opt_local.number = false
            vim.opt_local.signcolumn = 'no'
            vim.opt_local.statuscolumn = ''
          end,

          --- Cleans up some things when closing the drawer.
          on_did_close = function()
            local nvim_tree_api = require('nvim-tree.api')
            nvim_tree_api.tree.close()
          end,
        })
      end
    },
    { "craftzdog/solarized-osaka.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("solarized-osaka").setup({
          styles = {
              floats = "transparent"
          },
        })
      end
    },
})

require("bufferline").setup{}

require('lualine').setup {
  options = {
    component_separators = '',
    section_separators = { left = '', right = '' },
    --section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      '%=', --[[ add your center compoentnts here in place of this comment ]]
    },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
   lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  actions = {
    open_file = {
      quit_on_open = true, -- Automatically close nvim-tree after opening a file
    },
  },
})
