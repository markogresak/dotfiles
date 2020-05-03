#!/bin/bash

install_zsh_log="install_zsh.log"

function install_zsh {
  eval ../.helpers/log.sh "zsh" "Checking for oh-my-zsh..."
  if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    eval ../.helpers/log.sh "zsh" "~/.oh-my-zsh does not exist. Installing oh-my-zsh now..."

    # remove ~/.oh-my-zsh folder in case it exists before installing
    rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &> $install_zsh_log

    eval ../.helpers/log.sh "zsh" "oh-my-zsh installed."
  else
    eval ../.helpers/log.sh "zsh" "oh-my-zsh is already installed."
  fi
}

install_zsh
