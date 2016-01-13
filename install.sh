#!/bin/sh

DOTFILES=$HOME/dotfiles

ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -s $DOTFILES/alias/aliasrc $HOME/.aliasrc
ln -s $DOTFILES/vim $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES/config $HOME/.config
ln -s $DOTFILES/vim $HOME/.config/nvim # neovim
