#!/bin/sh

unlink ~/.zshrc
ln -s ${PWD}/src/.zshrc ~/.zshrc

unlink ~/.zprofile
ln -s ${PWD}/src/.zprofile ~/.zprofile

source ~/.zprofile
echo '🎉 Complete to install .zprofile'

source ~/.zshrc
echo '🎉 Complete to install .zshrc'
