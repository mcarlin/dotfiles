#!/usr/bin/env fish

mkdir -p ~/.config/fish/
ln -fs (realpath config.fish) ~/.config/fish/config.fish

ln -fs (realpath skhdrc) ~/.skhdrc
ln -fs (realpath tmux.conf) ~/.tmux.conf
ln -fs (realpath yabairc) ~/.yabairc

mkdir -p ~/.config/nvim/lua
ln -fs (realpath nvim/init.vim) ~/.config/nvim/init.vim
ln -fs (realpath nvim/lua/base.lua) ~/.config/nvim/lua/base.lua

mkdir -p ~/.config/kitty
ln -fs (realpath kitty.conf) ~/.config/kitty/kitty.conf
ln -fs (realpath kitty-theme.conf) ~/.config/kitty/kitty-theme.conf

ln -fs (realpath ideavimrc) ~/.ideavimrc

mkdir -p ~/.config/alacritty
ln -fs (realpath alacritty.yml) ~/.config/alacritty/alacritty.yml

if test ! -e ~/.alacritty-colorscheme
  git clone https://github.com/eendroroy/alacritty-theme.git ~/.alacritty-colorscheme
end 
