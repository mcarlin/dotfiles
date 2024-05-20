return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- navigation
          map('n', '<leader>rr', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<ignore>'
          end, { expr = true, desc = "git next changed hunk" })
          map('n', '<leader>ee', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<ignore>'
          end, { expr = true, desc = "git previous changed hunk" })
          -- actions
          map({ 'n', 'v' }, '<leader>hs', ':gitsigns stage_hunk<cr>', { desc = "git stage hunk" })
          map({ 'n', 'v' }, '<leader>hr', ':gitsigns reset_hunk<cr>', { desc = "git reset hunk" })
          map('n', '<leader>hs', gs.stage_buffer, { desc = "git stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "git undo stage hunk" })
          map('n', '<leader>hr', gs.reset_buffer, { desc = "git reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "git preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "git blame line" })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "git toggle blame line" })
          map('n', '<leader>hd', gs.diffthis, { desc = "git diff this" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "git diff this ~" })
          map('n', '<leader>td', gs.toggle_deleted, { desc = "git toggle deleted" })
          -- text object
          map({ 'o', 'x' }, 'ih', ':<c-u>gitsigns select_hunk<cr>', { desc = "git textobj in hunk" })
        end
      }
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    keys = {
      { "<leader>vo", "<cmd>Neogit<cr>",        { silent = true, noremap = true }, desc = "Toggle neogit" },
      { "<leader>vc", "<cmd>Neogit commit<cr>", { silent = true, noremap = true }, desc = "Neogit commit" },
    },

  },

}
