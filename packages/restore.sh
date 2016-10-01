#!/bin/bash

install_brew_log="install_brew.log"
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
    nvm install $(nvm ls-remote | tail -1) &> $install_npm_log

    echo -e "\Latest version of node and npm installed.\n"
  fi
}

function restore_taps {
  cat ./taps | xargs -n1 brew tap &> $restore_taps_log
}

function restore_brew {
  cat ./brew | xargs brew install &> $restore_brew_log
}

function restore_cask {
  cat ./casks | xargs brew cask install &> $restore_cask_log
}

function restore_npm {
  cat ./npm | xargs npm install -g &> $restore_npm_log
}


install_brew
restore_taps
restore_brew
# install_npm requires nvm, which is installed as part of restore_brew
install_npm

install_rvm &
restore_cask &
restore_npm &
wait
