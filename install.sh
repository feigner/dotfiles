#!/bin/sh

# dotfiles checkout location
DOTFILES=$HOME/dotfiles

ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -s $DOTFILES/alias/aliasrc $HOME/.aliasrc
# NOTE: some vim plugins might need to be compiled separately
# eg: `command-t` via `rake make`
ln -s $DOTFILES/vim $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES/vim/gvimrc $HOME/.gvimrc
