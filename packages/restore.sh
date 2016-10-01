#!/bin/bash

install_brew_log="install_brew.log"
install_nvm_log="install_nvm.log"
install_rvm_log="install_rvm.log"
install_npm_log="install_npm.log"
restore_taps_log="restore_taps.log"
restore_brew_log="restore_brew.log"
restore_cask_log="restore_cask.log"
restore_npm_log="restore_npm.log"

function install_brew {
  echo "Checking for Homebrew..."
  if hash brew 2>/dev/null; then
    echo "Homebrew already installed."
  else
    echo "Homebrew not installed. Installing Homebrew now..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> $install_brew_log

    echo -e "\nHomebrew installed.\n"
  fi
}

function install_nvm {
  echo "Checking for nvm..."
  if hash nvm 2>/dev/null; then
    echo "nvm already installed."
  else
    echo "nvm not installed. Installing nvm now..."
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash &> $install_nvm_log
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    echo -e "\nnvm installed. Remember to add sourcing nvm.sh to [.profile]\n"
  fi
}

function install_rvm {
  echo "Checking for rvm..."
  if hash rvm 2>/dev/null; then
    echo "rvm already installed."
  else
    echo "rvm not installed. Installing rvm and latest ruby now..." &> $install_rvm_log
    curl -sSL https://get.rvm.io | bash -s stable --ruby

    echo -e "\nrvm and latest version of ruby installed.\n"
  fi
}

function install_npm {
  echo "Checking for npm..."
  if hash npm 2>/dev/null; then
    echo "npm already installed."
  else
    echo "npm not installed. Installing latest version of node + npm now..."
    nvm install $(nvm ls-remote | tail -1) &> install_npm_log

    echo -e "\Latest version of node and npm installed.\n"
  fi
}

function restore_taps {
  cat ./taps | xargs brew tap &> restore_taps_log
}

function restore_brew {
  cat ./brew | xargs brew install &> restore_brew_log
}

function restore_cask {
  cat ./cask | xargs brew cask install &> restore_cask_log
}

function restore_npm {
  cat ./npm | xargs npm install -g &> restore_npm_log
}

function brew_restore_all {
  install_brew
  restore_taps
  restore_brew &
  restore_cask &
  wait
}

function npm_restore_all {
  install_nvm
  install_npm
  restore_npm
}


brew_restore_all &
npm_restore_all &
install_rvm &
wait