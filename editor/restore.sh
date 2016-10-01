#!/bin/bash

install_vundle_log="install_vundle.log"

function install_vundle {
  eval ../.helpers/log.sh "editor" "Checking for vundle..."
  if ! hash vim 2>/dev/null; then
    eval ../.helpers/log.sh "editor" "ERROR: vim is not installed, unable to install vundle without vim." "error"
  elif [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    eval ../.helpers/log.sh "editor" "~/.vim/bundle/Vundle.vim does not exist. Installing Vundle now..."

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> $install_vundle_log
    echo "" >> $install_vundle_log
    vim +PluginInstall +qall >> $install_vundle_log 2>&1

    eval ../.helpers/log.sh "editor" "Vundle installed."
  else
    eval ../.helpers/log.sh "editor" "Vundle is already installed."
  fi
}

install_vundle
