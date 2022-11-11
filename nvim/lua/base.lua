vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop=2
vim.o.softtabstop=2

local cache_dir = vim.env.XDG_CACHE_HOME or "~/.cache"
local undo_dir = cache_dir .. "/nvim/undo"
os.execute("mkdir -p " .. undo_dir)
vim.o.undodir = undo_dir
vim.bo.undofile = true

vim.g.mapleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'ellisonleao/gruvbox.nvim' 
Plug 'tpope/vim-sensible'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate'] } )
Plug('neoclide/coc.nvim', {['branch'] = 'release'})
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', {['tag'] = '0.1.0'})
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do']= vim.fn['cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'] })
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

Plug 'Pocco81/true-zen.nvim'
Plug 'windwp/nvim-autopairs'

Plug 'ggandor/lightspeed.nvim'
Plug 'tpope/vim-repeat'

vim.call('plug#end')

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Tree Sitter Config
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua", "rust" },

	auto_install = true,

	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

-- Telescope Config
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
builtin.buffers({ sort_lastused = true, ignore_current_buffer = true })

require('telescope').setup {
	extensions = {
	    fzf = {
	      fuzzy = true,                    -- false will only do exact matching
	      override_generic_sorter = true,  -- override the generic sorter
	      override_file_sorter = true,     -- override the file sorter
	      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
					       -- the default case_mode is "smart_case"
	    }
	}
}
require('telescope').load_extension('fzf')

-- Lualine Config
require('lualine').setup {
	options = { theme = 'gruvbox' }
}

-- True Zen Config
require('true-zen').setup {
	modes = { -- configurations per mode
		ataraxis = {
			shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
			backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
			minimum_writing_area = { -- minimum size of main window
				width = 70,
				height = 44,
			},
			quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
			padding = { -- padding windows
			left = 52,
			right = 52,
			top = 0,
			bottom = 0,
			},
		},
	}
}

local truezen = require('true-zen')
local keymap = vim.keymap

keymap.set('n', '<leader>zn', function()
  local first = 0
  local last = vim.api.nvim_buf_line_count(0)
  truezen.narrow(first, last)
end, { noremap = true })
keymap.set('v', '<leader>zn', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  truezen.narrow(first, last)
end, { noremap = true })
keymap.set('n', '<leader>zf', truezen.focus, { noremap = true })
keymap.set('n', '<leader>zm', truezen.minimalist, { noremap = true })
keymap.set('n', '<leader>za', truezen.ataraxis, { noremap = true })

-- autopairs
require("nvim-autopairs").setup {}

-- NVIM Tree
require("nvim-tree").setup()
keymap.set('n', '<leader>tt', ':NvimTreeToggle <CR>', { noremap = true, silent = true })

-- COC
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

keymap.set("n", "<leader>r", "<Plug>(coc-rename)", {silent = true})
local opts = {silent = true, nowait = true}
keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keymap.set("i", "<TAB>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Remap <C-f> and <C-b> for scroll float windows/popups.
---@diagnostic disable-next-line: redefined-local
keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keymap.set("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keymap.set("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

require'lightspeed'.setup {
  jump_to_unique_chars = false,
  safe_labels = {}
}

keymap.set("n", "s", '<Plug>Lightspeed_omni_s', {silent = true})
keymap.set("v", "s", '<Plug>Lightspeed_omni_s', {silent = true})
