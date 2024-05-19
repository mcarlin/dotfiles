require("util")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,               -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,            -- make sure to load this before all the other start plugins
    config = function()
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "rust" },

        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
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
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },
  { 'tpope/vim-repeat' },
  {
    'neovim/nvim-lspconfig',
    dependencies = { { 'hrsh7th/cmp-nvim-lsp' }, { 'saadparwaiz1/cmp_luasnip' },
    { 'joechrisellis/lsp-format-modifications.nvim' } },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, merge(opts, { desc = "Open diagnostic floating" }))
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, merge(opts, { desc = "Go to previous diagnostic" }))
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, merge(opts, { desc = "Go to next diagnostic" }))
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, merge(bufopts, { desc = "Go to declaration" }))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, merge(bufopts, { desc = "Go to definition" }))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(bufopts, { desc = "Go to references" }))
        --        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, merge(bufopts, { "Go to type definition" }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, merge(bufopts, { desc = "Lsp hover" }))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, merge(bufopts, { desc = "Go to implemenation" }))
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, merge(bufopts, { desc = "Lsp signature help" }))
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
        merge(bufopts, { desc = "Add workspace folder" }))
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
        merge(bufopts, { desc = "Remove workspace folder" }))
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, merge(bufopts, { desc = "List workspace folders" }))
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, merge(bufopts, { desc = "Lsp Rename" }))
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, merge(bufopts, { desc = "Lsp code action" }))
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end,
        merge(bufopts, { desc = "Format" }))
        if client.server_capabilities.documentRangeFormattingProvider then
          local lsp_format_modifications = require "lsp-format-modifications"
          lsp_format_modifications.attach(client, bufnr, { format_on_save = true })
        end

        if client.server_capabilities.documentSymbolProvider then
          local navic = require("nvim-navic")
          navic.attach(client, bufnr)
        end
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }
      -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
      local servers = { 'clangd', 'tsserver', 'taplo', 'sqlls', 'bashls' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          -- on_attach = my_custom_on_attach,
          capabilities = capabilities,
          on_attach = on_attach,
          flags = lsp_flags,

        }
      end

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }
      lspconfig.gopls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        }
      }
    end
  },
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    build = "make install_jsregexp"
  },
  {
    "rafamadriz/friendly-snippets"
  },
  {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    dependencies = "williamboman/mason.nvim",
    config = function()
      local extension_path = require('mason-registry').get_package('codelldb'):get_install_path() .. '/extension/'

      local codelldb_path = extension_path .. 'adapter/codelldb'
      local liblldb_path = ''
      if (vim.loop.os_uname().sysname == 'Darwin') then
        liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
      else
        liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
      end

      local rt = require('rust-tools')

      rt.setup({
        server = {
          on_attach = function(client, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float,
            merge(bufopts, { desc = "Open diagnostic floating" }))
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, merge(bufopts, { desc = "Go to prev diagnostic" }))
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, merge(bufopts, { desc = "Go to next diagnostic" }))

            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, merge(bufopts, { desc = "Go to declaration" }))
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, merge(bufopts, { desc = "Go to definition" }))
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(bufopts, { desc = "Go to references" }))
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, merge(bufopts, { desc = "Go to type definition" }))
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, merge(bufopts, { desc = "Lsp hover" }))
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, merge(bufopts, { desc = "Go to implemenation" }))
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, merge(bufopts, { desc = "Lsp signature help" }))
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
            merge(bufopts, { desc = "Add workspace folder" }))
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
            merge(bufopts, { desc = "Remove workspace folder" }))
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, merge(bufopts, { desc = "List workspace folders" }))
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, merge(bufopts, { desc = "Lsp Rename" }))
            vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, merge(bufopts, { desc = "Lsp code action" }))
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end,
            merge(bufopts, { desc = "Format" }))

            local navic = require("nvim-navic")
            navic.attach(client, bufnr)
          end,
        },
        dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(
          codelldb_path, liblldb_path)
        },
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = "clippy",
            },
          }
        }
      })
    end
  },
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
  -- Improves default nvim ui interfaces
  { 'stevearc/dressing.nvim', event = "VeryLazy" },
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      local cfg = {
        debug = false,                                              -- set to true to enable debug logging
        log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
        -- default is  ~/.cache/nvim/lsp_signature.log
        verbose = false,                                            -- show debug line number
        bind = true,
        doc_lines = 10,
        max_height = 12,
        max_width = 80,
        noice = false,
        wrap = true,
        floating_window = true,
        floating_window_above_cur_line = true,
        floating_window_off_x = 1,
        floating_window_off_y = 0,
        -- can be either number or function, see examples

        close_timeout = 4000,
        fix_pos = false,
        hint_enable = true,
        hint_prefix = "🐼 ",
        hint_scheme = "String",
        hi_parameter = "LspSignatureActiveParameter",
        handler_opts = {
          border = "rounded"
        },
        always_trigger = false,
        auto_close_after = nil,
        extra_trigger_chars = {},
        zindex = 200,
        padding = '',
        transparency = nil,
        shadow_blend = 36,
        shadow_guibg = 'Black',
        timer_interval = 200,
        toggle_key = nil,
        select_signature_key = nil,
        move_cursor_key = nil,
      }

      require 'lsp_signature'.setup(cfg)
    end
  },
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
  {
    'kdheepak/lazygit.nvim',
    keys = {
      { "<leader>vg", "<cmd>LazyGit<cr>", { silent = true, noremap = true }, desc = "Toggle lazy git" }
    },
  },
  {
    'saecki/crates.nvim',
    tag = 'v0.3.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },
  {
    'RRethy/vim-illuminate'
  },
  {
    'kyazdani42/nvim-web-devicons'
  },
  {
    'p00f/clangd_extensions.nvim',
    config = function()
      require("clangd_extensions").setup()
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "bashls",
          "clangd",
          "gopls",
          "lua_ls",
          "ruff_lsp",
          "rust_analyzer",
          "taplo",
        },
      }
    end
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
    end
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
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
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },

  {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup {}
    end
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        options = {
          signcolumn = "yes",
          number = true,
        },
        plugins = {
          gitsigns = {
            enabled = "true",
          },
          alacritty = {
            enabled = true,
            font = 22,
          },
        },
      }
    end
  },
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
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require('guess-indent').setup {}
    end
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
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
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
      { "<leader>vo", "<cmd>Neogit<cr>", { silent = true, noremap = true }, desc = "Toggle neogit" },
      { "<leader>vc", "<cmd>Neogit commit<cr>", { silent = true, noremap = true }, desc = "Toggle neogit" },
    },

  },
  {
    "jinh0/eyeliner.nvim",
  },
  {
    "nvim-treesitter/nvim-treesitter-context"
  }
}
)
