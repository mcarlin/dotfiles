#!/usr/bin/env fish

ln -fs (realpath skhdrc) ~/.skhdrc
ln -fs (realpath tmux.conf) ~/.tmux.conf
ln -fs (realpath yabairc) ~/.yabairc
mkdir -p ~/.config/nvim/lua
ln -fs (realpath nvim/init.vim) ~/.config/nvim/init.vim
ln -fs (realpath nvim/lua/base.lua) ~/.config/nvim/lua/base.lua
