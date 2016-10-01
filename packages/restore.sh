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
  # using size check, hash does not detect nvm because it's a script
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "nvm already installed."
  else
    echo "nvm not installed. Installing nvm now..."
    curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash &> $install_nvm_log

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    echo -e "\nnvm installed.\n"
  fi
}

function install_rvm {
  echo "Checking for rvm..."
  if hash rvm 2>/dev/null; then
    echo "rvm already installed."
  else
    echo "rvm not installed. Installing rvm and latest ruby now..."
    curl -sSL https://get.rvm.io | bash -s stable --ruby &> $install_rvm_log

    echo -e "\nrvm and latest version of ruby installed.\n"
  fi
}

function install_npm {
  echo "Checking for npm..."
  if hash npm 2>/dev/null; then
    echo "npm already installed."
  else
    echo "npm not installed. Installing latest version of node + npm now..."

    if hash nvm 2>/dev/null; then
      nvm install $(nvm ls-remote | grep -oE '(v\d+.\d+.\d+)' | tail -1) &> $install_npm_log

      echo -e "\nLatest version of node and npm installed.\n"
    else
      echo "Unable to install npm, nvm was not found!"
    fi
  fi
}

function restore_taps {
  echo "Restoring Homebrew taps..."
  cat ./taps | xargs -n1 brew tap &> $restore_taps_log
  echo -e "\nHomebrew taps restored.\n"
}

function restore_brew {
  echo "Restoring Homebrew formulas..."
  cat ./brew | xargs brew install &> $restore_brew_log
  echo -e "\nHomebrew formulas restored.\n"
}

function restore_cask {
  echo "Restoring Homebrew casks..."
  cat ./casks | xargs brew cask install &> $restore_cask_log
  echo -e "\nHomebrew casks restored.\n"
}

function restore_npm {
  echo "Restoring npm global modules..."
  cat ./npm | xargs npm install -g &> $restore_npm_log
  echo -e "\nnpm global modules restored.\n"
}

function brew_all {
  install_brew
  restore_taps
  restore_brew &
  restore_cask &
  wait
}

function node_all {
  install_nvm
  install_npm
  restore_npm
}

function ruby_all {
  install_rvm
}

brew_all &
node_all &
ruby_all &
wait
