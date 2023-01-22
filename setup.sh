#!/usr/bin/env sh

ln -fs $(realpath tmux.conf) ~/.tmux.conf

mkdir -p ~/.config/nvim/lua
ln -fs $(realpath nvim/init.vim) ~/.config/nvim/init.vim
ln -fs $(realpath nvim/lua/base.lua) ~/.config/nvim/lua/base.lua
ln -fs $(realpath nvim/lua/plugins.lua) ~/.config/nvim/lua/plugins.lua
