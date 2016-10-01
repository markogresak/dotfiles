#!/bin/bash

install_vundle_log="install_vundle.log"

function install_vundle {
  if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    echo "~/.vim/bundle/Vundle.vim does not exist. Installing Vundle now..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> $install_vundle_log
    echo "" >> $install_vundle_log
    vim +PluginInstall +qall >> $install_vundle_log 2>&1
  fi
}

install_vundle
