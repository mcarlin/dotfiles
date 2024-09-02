return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    keys = {
      { "<leader>vo", "<cmd>Neogit<cr>", { silent = true, noremap = true }, desc = "Toggle neogit" },
      { "<leader>vc", "<cmd>Neogit commit<cr>", { silent = true, noremap = true }, desc = "Neogit commit" },
    },
  },
}
