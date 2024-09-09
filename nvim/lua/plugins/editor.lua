return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python" }, -- etc
    lazy = true,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },
}
