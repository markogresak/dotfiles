#!/bin/bash

install_vundle_log="install_vundle.log"

function install_vundle {
  if ! hash vim 2>/dev/null; then
    echo "ERROR: vim is not installed, unable to install vundle without vim."
  elif [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    echo "~/.vim/bundle/Vundle.vim does not exist. Installing Vundle now..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> $install_vundle_log
    echo "" >> $install_vundle_log
    vim +PluginInstall +qall >> $install_vundle_log 2>&1

    echo -e "\nvundle installed.\n"
  fi
}

install_vundle
