#!/bin/bash

touch ~/.secretrc
echo 'Please restore ~/.secretrc manually.'

install_zsh_log="install_zsh.log"

function install_zsh {
  if [[ ! -d "~/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &> $install_zsh_log
  fi
}

install_zsh
