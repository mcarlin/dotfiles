#!/usr/bin/env fish

mkdir -p ~/.config/fish/
ln -fs (realpath config.fish) ~/.config/fish/config.fish

ln -fs (realpath skhdrc) ~/.skhdrc
ln -fs (realpath tmux.conf) ~/.tmux.conf
ln -fs (realpath yabairc) ~/.yabairc

mkdir -p ~/.config/nvim
ln -fs (realpath nvim/init.vim) ~/.config/nvim/init.vim
ln -fs (realpath nvim/lua) ~/.config/nvim/lua
ln -fs (realpath nvim/luasnip) ~/.config/nvim/luasnip
ln -fs (realpath nvim/lazy-lock.json) ~/.config/nvim/lazy-lock.json

mkdir -p ~/.config/kitty
ln -fs (realpath kitty.conf) ~/.config/kitty/kitty.conf
ln -fs (realpath kitty-theme.conf) ~/.config/kitty/kitty-theme.conf

ln -fs (realpath ideavimrc) ~/.ideavimrc

mkdir -p ~/.config/alacritty
ln -fs (realpath alacritty.yml) ~/.config/alacritty/alacritty.yml

if test ! -e ~/.alacritty-colorscheme
  git clone https://github.com/eendroroy/alacritty-theme.git ~/.alacritty-colorscheme
end 

ln -fs (realpath wezterm/wezterm.lua) ~/.wezterm.lua

ln -fs (realpath git/gitconfig) ~/.gitconfig

set uname (uname)
if [ "$uname" = "Darwin" ]
  mkdir -p ~/Library/Application\ Support/lazygit
  ln -fs (realpath lazygit/config.yml) ~/Library/Application\ Support/lazygit/config.yml
else
  mkdir -p ~/.config/lazygit
  ln -fs (realpath alacritty.yml) ~/.config/lazygit/config.yml
end

mkdir -p ~/.config/zellij
ln -fs (realpath zellij/config.kdl) ~/.config/zellij/config.kdl

mkdir -p ~/.config/borders
ln -fs (realpath bordersrc) ~/.config/borders/bordersrc

ln -fs (realpath tridactylrc) ~/.tridactylrc
