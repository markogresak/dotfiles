#!/bin/bash

touch ~/.secretrc
echo 'Please restore ~/.secretrc manually.'

install_zsh_log="install_zsh.log"

function install_zsh {
  if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    # remove ~/.oh-my-zsh folder in case it exists before installing
    rm -rf "$HOME/.oh-my-zsh"
    echo "~/.oh-my-zsh does not exist. Installing oh-my-zsh now..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &> $install_zsh_log

    echo -e "\noh-my-zsh installed.\n"
  fi
}

install_zsh
