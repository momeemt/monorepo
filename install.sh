#!/bin/sh

brew bundle install

unlink ~/.zshrc
ln -s ${PWD}/src/.zshrc ~/.zshrc

unlink ~/.zprofile
ln -s ${PWD}/src/.zprofile ~/.zprofile
