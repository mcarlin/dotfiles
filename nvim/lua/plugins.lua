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
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
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
   tag = '0.1.1',
   event = "VeryLazy",
   dependencies = { { 'nvim-lua/plenary.nvim' }, { 'smartpde/telescope-recent-files' },
     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, {'kdheepak/lazygit.nvim'} },
   config = function()
     local builtin = require('telescope.builtin')
     vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
     vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
     vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
     vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
     vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
     vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, {})
     vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
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
   'nvim-tree/nvim-tree.lua',
   dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
   config = function()
     require("nvim-tree").setup({
       sync_root_with_cwd = true,
       respect_buf_cwd = true,
       -- update_focd_file = {
       --   enable = true,
       --   update_root = true
       -- },
     })
     vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle <CR>', { noremap = true, silent = true })
   end
 },
 
 {
   'windwp/nvim-autopairs',
    event = "InsertEnter",
   dependencies = { 'hrsh7th/nvim-cmp', 'saadparwaiz1/cmp_luasnip', 'saecki/crates.nvim'},
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
 
 {'tpope/vim-repeat'},
 
 {
   'neovim/nvim-lspconfig',
   dependencies = { { 'hrsh7th/cmp-nvim-lsp' }, { 'saadparwaiz1/cmp_luasnip' }, { 'joechrisellis/lsp-format-modifications.nvim' } },
   config = function()
     local lspconfig = require('lspconfig')
     local capabilities = require("cmp_nvim_lsp").default_capabilities()
 
     local opts = { noremap = true, silent = true }
     vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
     vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
     vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
     vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
     local on_attach = function(client, bufnr)
       vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
 
       local lsp_format_modifications = require"lsp-format-modifications"
       lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
 
       local bufopts = { noremap = true, silent = true, buffer = bufnr }
       vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
       vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
       vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
       vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
       vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
       vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
       vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
       vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
       vim.keymap.set('n', '<space>wl', function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
       end, bufopts)
       vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
       vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
       vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
 
       if client.server_capabilities.documentSymbolProvider then
         local navic = require("nvim-navic")
         navic.attach(client, bufnr)
       end
     end
 
     local lsp_flags = {
       debounce_text_changes = 150,
     }
     -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
     local servers = { 'clangd', 'pyright', 'tsserver', 'lua_ls', 'taplo', 'sqlls' }
     for _, lsp in ipairs(servers) do
       lspconfig[lsp].setup {
         -- on_attach = my_custom_on_attach,
         capabilities = capabilities,
         on_attach = on_attach,
         flags = lsp_flags,
 
       }
     end
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
   dependencies = "williamboman/mason.nvim",
   config = function()
     local extension_path = require('mason-registry').get_package('codelldb'):get_install_path()
 
 
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
           vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
           vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
           vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
           vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
           vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
           vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
           vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
           vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
           vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
           vim.keymap.set('n', '<space>wl', function()
             print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
           end, bufopts)
           vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
           vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, bufopts)
           vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
 
           -- if client.server_capabilities.documentSymbolProvider then
           local navic = require("nvim-navic")
           navic.attach(client, bufnr)
           -- end
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
   dependencies = { 'rcarriga/nvim-dap-ui' },
   config = function()
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
   end
 },
 
 -- Improves default nvim ui interfaces
 {'stevearc/dressing.nvim', event = "VeryLazy"},
 
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
   config = function()
     require("trouble").setup {}
     vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
       { silent = true, noremap = true }
     )
     vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
       { silent = true, noremap = true }
     )
     vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
       { silent = true, noremap = true }
     )
     vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
       { silent = true, noremap = true }
     )
     vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
       { silent = true, noremap = true }
     )
     vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
       { silent = true, noremap = true }
     )
   end
 },
 
 {
   'kdheepak/lazygit.nvim',
   config = function()
     vim.keymap.set("n", "<leader>vg", "<cmd>LazyGit<cr>",
       { silent = true, noremap = true }
     )
   end
 },
 
 {
   'rmagatti/auto-session',
   config = function()
     require("auto-session").setup {
       log_level = "error",
       auto_restore_enabled = true,
     }
   end
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
     require("clangd_extensions").prepare()
   end
 },
 
 {
   "williamboman/mason.nvim",
   config = function()
     require("mason").setup()
   end,
 },
 
 {
   'numToStr/Comment.nvim',
   config = function()
     require('Comment').setup()
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
 
 {
   'romgrk/barbar.nvim',
   dependencies = 'nvim-web-devicons'
 },
 
 {
   "lukas-reineke/indent-blankline.nvim",
   config = function()
     vim.opt.list = true
     vim.opt.listchars:append "space:⋅"
     vim.opt.listchars:append "eol:↴"
 
     require("indent_blankline").setup {
       space_char_blankline = " ",
       _treesitter_scope = true,
       show_end_of_line = true,
       show_current_context = true,
       show_current_context_start = true,
     }
   end
 },
 
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
 
         -- Navigation
         map('n', '<leader>rr', function()
           if vim.wo.diff then return ']c' end
           vim.schedule(function() gs.next_hunk() end)
           return '<Ignore>'
         end, { expr = true })
 
         map('n', '<leader>ee', function()
           if vim.wo.diff then return '[c' end
           vim.schedule(function() gs.prev_hunk() end)
           return '<Ignore>'
         end, { expr = true })
 
         -- Actions
         map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
         map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
         map('n', '<leader>hS', gs.stage_buffer)
         map('n', '<leader>hu', gs.undo_stage_hunk)
         map('n', '<leader>hR', gs.reset_buffer)
         map('n', '<leader>hp', gs.preview_hunk)
         map('n', '<leader>hb', function() gs.blame_line { full = true } end)
         map('n', '<leader>tb', gs.toggle_current_line_blame)
         map('n', '<leader>hd', gs.diffthis)
         map('n', '<leader>hD', function() gs.diffthis('~') end)
         map('n', '<leader>td', gs.toggle_deleted)
 
         -- Text object
         map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
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
   config = function()
     require('aerial').setup({
       vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>')
     })
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
           -- Automatically jump forward to textobj, similar to targets.vim
           lookahead = true,
           keymaps = {
             -- You can the capture groups defined in textobjects.scm
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
             ["<leader>sA"] = "@parameter.inner",
           },
         },
       },
     })
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
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          progress = {
            enabled = true,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
          signature = {
            enabled = false
          }
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end
  }
}
)
