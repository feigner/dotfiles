#!/bin/sh

DOTFILES=$HOME/dotfiles

ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -s $DOTFILES/alias/aliasrc $HOME/.aliasrc
ln -s $DOTFILES/vim $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES/config $HOME/.config

# neovim
ln -s $DOTFILES/vim $HOME/.config/nvim
ln -s $HOME/.vimrc $DOTFILES/vim/init.vim

echo "\n\nPOST INSTALL TASKS:"
echo "  homebrew: /usr/bin/ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
echo "  brew install neovim/neovim/neovim"
echo "  brew install zsh"
echo "  git submodule init / git submodule update"
echo "  chsh -s \$(which zsh)"
