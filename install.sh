#!/bin/sh

unlink ~/.zshrc
ln -s ${PWD}/src/.zshrc ~/.zshrc

unlink ~/.zprofile
ln -s ${PWD}/src/.zprofile ~/.zprofile

unlink ~/.config/nvim/init.vim
ln -s ${PWD}/neovim/init.vim ~/.config/nvim/init.vim
