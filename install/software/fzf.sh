#!/bin/bash

echo '[FZF] Installing FZF'
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo '[FZF] Installing rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo '[FZF] Installing ripgrep'
cargo install ripgrep
