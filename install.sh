#!/bin/sh

# dotfiles checkout location
DOTFILES=$HOME/dotfiles

# shells
ln -s $DOTFILES/bash/bash_profile $HOME/.bash_profile
ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc

# vim
# NOTE: some vim plugins might need to be compiled (command-t) 
#       separately
ln -s $DOTFILES/vim $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES/vim/gvimrc $HOME/.gvimrc

# git
ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
