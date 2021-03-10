#!/bin/sh

DOTFILES=$HOME/dotfiles

ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -s $DOTFILES/tmux $HOME/.tmux
ln -s $DOTFILES/alias/aliasrc $HOME/.aliasrc
ln -s $DOTFILES/vim $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
ln -s $DOTFILES/config $HOME/.config
ln -s $DOTFILES/hammerspoon $HOME/.hammerspoon

# neovim
ln -s $DOTFILES/vim $HOME/.config/nvim
ln -s $HOME/.vimrc $DOTFILES/vim/init.vim

echo "\n\nPOST INSTALL TASKS:"
echo "  homebrew: /usr/bin/ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""
echo "  brew install ag"
echo "  brew install source-highlight"
echo "  brew install diff-so-fancy"
echo "  brew install --cask karabiner-elements"
echo "  brew install macdown"

echo "  brew install tmux"
echo "    prefix + I in tmux to fetch plugins"

echo "  sudo pip3 install neovim"
echo "  sudo pip3 install virtualenv"
echo "  brew install neovim"
echo "    :PlugInstall"
echo "    symlink nvim -> vim in /usr/local/bin"

echo "  brew install zsh"
echo "  chsh -s \$(which zsh)"
echo "  git submodule init / git submodule update"
