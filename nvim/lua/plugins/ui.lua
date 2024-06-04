return {
  -- Add status line to nvim
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local navic = require("nvim-navic")
      require('lualine').setup({
        options = {
          theme = 'gruvbox',
          globalstatus = true
        },
        sections = {
          lualine_c = {
            { 'filename',         path = 1,                 shorting_target = 40 },
            { navic.get_location, cond = navic.is_available },
          }
        }
      })
    end
  },
  -- Improves default nvim ui interfaces
  { 'stevearc/dressing.nvim', event = "VeryLazy" },
  -- Add scrollbars to nvim
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },
  {
    'kyazdani42/nvim-web-devicons'
  },
  -- Extensible UI for Neovim notifications and LSP progress messages.
  {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup {}
    end
  },
  {
    "folke/zen-mode.nvim",
    keys = {
      { '<leader>za', '<cmd>ZenMode<cr>', desc = "toggle zen mode" }
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
}
