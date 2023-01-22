local cache_dir = vim.env.XDG_CACHE_HOME or "~/.cache"
local undo_dir = cache_dir .. "/nvim/undo"
os.execute("mkdir -p " .. undo_dir)
vim.o.undodir = undo_dir
vim.bo.undofile = true

vim.g.mapleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- Spacing + Tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true

-- Clipboard uses system
vim.opt.clipboard = 'unnamedplus'
