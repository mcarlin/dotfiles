return {
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            -- automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- you can the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
            selection_modes = 'v',
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sa"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sa"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            -- below will go to either the start or the end, whichever is closer.
            -- use if you want more granular movements
            -- make it even more gradual by adding multiple queries and regex.
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]b"] = "@block.outer",
              ["]p"] = "@parameter.outer",
            },
            goto_next_end = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]b"] = "@block.outer",
              ["]p"] = "@parameter.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[b"] = "@block.outer",
              ["[p"] = "@parameter.outer",
            },
            goto_previous_end = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[b"] = "@block.outer",
              ["[p"] = "@parameter.outer",
            }
          }
        },
      })
      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

      -- repeat movement with ; and , ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    end
  },
  -- automatically detect the indentation style used in a buffer and updating the buffer options accordingly
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require('guess-indent').setup {}
    end
  },
  -- unique f/F indicators for each word on the line.
  {
    "jinh0/eyeliner.nvim",
  },
  -- Adds stickylines (e.g., hierarchical context)
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
  {
    'chentoast/marks.nvim',
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      bookmark_0 = {
        sign = "⚑",
        virt_text = "hello world",
        -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
        -- defaults to false.
        annotate = false,
      },
      mappings = {}
    }
  },
  -- Add vertical indentation lines
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  -- automatically highlighting other uses of the word under the cursor using
  {
    'RRethy/vim-illuminate'
  },
  { 'tpope/vim-repeat' },
}
