#!/bin/bash

echo "[r2] Creating symlink for .radare2rc"
rm -rf $HOME/.radare2rc
ln -s $HOME/.dotfiles/.radare2rc $HOME/.radare2rc

