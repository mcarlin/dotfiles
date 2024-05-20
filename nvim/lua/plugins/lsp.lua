require("util")
return {
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
            vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action,
              merge(bufopts, { desc = "Lsp code action" }))
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
    config = function()
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
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "L3MON4D3/LuaSnip",
    version = "1.*",
    build = "make install_jsregexp"
  },
  {
    "rafamadriz/friendly-snippets"
  },

}
