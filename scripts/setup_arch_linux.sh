#!/bin/bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

yay -S rustup
rustup default stable
yay -S fzf
yay -S go
yay -S fd
yay -S luarocks
sudo luarocks --lua-version 5.1 install magick
yay -S clazy
yay -S lazygit
yay -S ripgrep
npm install -g tree-sitter-cli
yay -S gdu
yay -S bottom
yay -S protobuf
yay -S mercurial
yay -S xxd
yay -S lynx
yay -S luajit-tiktoken-bin
yay -S tectonic
sudo pacman -S trash-cli

pip install notebook nbclassic jupyter-console
pip install git+https://github.com/will8211/unimatrix.git
npm install -g neovim
pip install pynvim
pip install terminaltexteffects
pip install pylatexenc 

yay -S lazydocker-bin
