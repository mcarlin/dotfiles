return {
  -- Add document structure window
  {
    "stevearc/aerial.nvim",
    opts = {},
    keys = {
      { '<leader>ta', '<cmd>AerialToggle!<cr>', desc = "toggle aerial document structure" }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require('aerial').setup()
    end
  },
  -- diagnostic window
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle<cr>",
        { silent = true, noremap = true },
        desc =
        "Toggle trouble diagnostics"
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        { silent = true, noremap = true },
        desc =
        "Toggle trouble workspace diagnostics"
      },
      {
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        { silent = true, noremap = true },
        desc =
        "Toggle trouble document diagnostics"
      },
      {
        "<leader>xl",
        "<cmd>TroubleToggle loclist<cr>",
        { silent = true, noremap = true },
        desc =
        "Trouble location list"
      },
      {
        "<leader>xq",
        "<cmd>TroubleToggle quickfix<cr>",
        { silent = true, noremap = true },
        desc =
        "Trouble quickfix"
      },
    },
    config = function()
      require("trouble").setup {}
    end
  },
  -- markdown preview tool
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- project management tool
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
    end
  },
  -- debug adapter protocol tool
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'rcarriga/nvim-dap-ui', 'williamboman/mason.nvim', 'nvim-neotest/nvim-nio' },
    config = function()
      local extension_path = require('mason-registry').get_package('codelldb'):get_install_path()
      local codelldb_path = extension_path .. '/extension/adapter/codelldb'
      require("dapui").setup()

      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        }
      }

      vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "Debug continue" })
      vim.keymap.set('n', '<F8>', function() require('dap').step_over() end, { desc = "Debug step over" })
      vim.keymap.set('n', '<F7>', function() require('dap').step_into() end, { desc = "Debug step into" })
      vim.keymap.set('n', '<F9>', function() require('dap').step_out() end, { desc = "Debug step out" })
      vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end,
        { desc = "Debug toggle breakpoint" })
      vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint() end, { desc = "Debug set breakpoint" })
      vim.keymap.set('n', '<Leader>lp',
        function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
        { desc = "Debug log point message" })
      vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "Debug open repl" })
      vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = "Debug run last config" })
      vim.keymap.set('n', '<Leader>dx', function() require('dap').disconnect() end, { desc = "Debug disconnect" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
      end, { desc = "Debug hover" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
      end, { desc = "Debug preview" })
      vim.keymap.set('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end, { desc = "Debug centered float frames" })
      vim.keymap.set('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
      end, { desc = "Debug centered float scopes" })

      require('dap.ext.vscode').load_launchjs(nil, { codelldb = { 'rust' } })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        '<leader>tt',
        ':Neotree<CR>',
        { noremap = true, silent = true },
        desc =
        "Toggle file system tree"
      },
      {
        '<leader>tg',
        ':Neotree float git_status<CR>',
        { noremap = true, silent = true },
        desc =
        "Toggle floating git tree"
      },
    },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    event = "VeryLazy",
    keys = {
      { '<leader>ff',   desc = "Find files" },
      { '<leader>fg',   desc = "Find grep" },
      { '<leader>fb',   desc = "Find buffers" },
      { '<leader>fh',   desc = "Find help tags" },
      { '<leader>fs',   desc = "Find document symbols" },
      { '<leader>fS',   desc = "Find workspace symbols" },
      { '<leader>fr',   desc = "Find references" },
      { '<leader><cr>', desc = "Find recent files" },
      { '<leader>fp',   desc = "Find recent projects" },
      { '<leader>fv',   desc = "Find git repos" },
      { '<leader>fm',   desc = "Find git repos" },
    },
    dependencies = { { 'nvim-lua/plenary.nvim' }, { 'smartpde/telescope-recent-files' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, { 'kdheepak/lazygit.nvim' } },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
      vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, {})
      vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
      vim.keymap.set('n', '<leader>fm', builtin.marks, {})
      builtin.buffers({ sort_lastd = true, ignore_current_buffer = true })

      local telescope = require('telescope')
      local telescopeConfig = require("telescope.config")

      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

      -- I want to follow symlinked directories
      table.insert(vimgrep_arguments, "-L")
      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      telescope.setup {
        defaults = {
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--ignore", "-L", "--hidden", "--files" }
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        }
      }
      telescope.load_extension('fzf')
      telescope.load_extension("recent_files")

      -- Telescope Recent Files Extension
      vim.api.nvim_set_keymap("n", "<leader><cr>",
        [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
        { noremap = true, silent = true })

      -- Telescope Project Extension
      telescope.load_extension('projects')
      vim.api.nvim_set_keymap("n", "<leader>fp",
        [[<cmd>lua require'telescope'.extensions.projects.projects{}<CR>]],
        { noremap = true, silent = true })

      -- Telescope Lazygit Extension
      telescope.load_extension("lazygit")
      vim.api.nvim_set_keymap("n", "<leader>fv",
        [[<cmd>lua require'telescope'.extensions.lazygit.lazygit()<CR>]],
        { noremap = true, silent = true })
    end
  },

}
