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
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    dependencies = { 'hrsh7th/nvim-cmp', 'saadparwaiz1/cmp_luasnip', 'saecki/crates.nvim' },
    config = function()
      require("nvim-autopairs").setup {}

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'crates' },
          { name = 'nvim_lsp_signature_help' }
        },
      }
      require("luasnip/loaders/from_vscode").lazy_load()
    end
  },
}
