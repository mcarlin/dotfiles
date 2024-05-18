#!/usr/bin/env sh

ln -fs $(realpath tmux.conf) ~/.tmux.conf

mkdir -p ~/.config/nvim/lua
ln -fs $(realpath nvim/init.vim) ~/.config/nvim/init.vim
ln -fs $(realpath nvim/lua/base.lua) ~/.config/nvim/lua/base.lua
ln -fs $(realpath nvim/lua/plugins.lua) ~/.config/nvim/lua/plugins.lua
ln -fs $(realpath nvim/lua/util.lua) ~/.config/nvim/lua/util.lua
ln -fs $(realpath nvim/lazy-lock.json) ~/.config/nvim/lazy-lock.json

ln -fs (realpath git/gitconfig) ~/.gitconfig

mkdir -p ~/.config/lazygit/
ln -fs $(realpath lazygit/config.yml) ~/.config/lazygit/config.yml

mkdir -p ~/.config/borders
ln -fs $(realpath bordersrc) ~/.config/borders/bordersrc

ln -fs $(realpath tridactylrc) ~/.tridactylrc
