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
  eval ../.helpers/log.sh "brew" "Checking for Homebrew brew command..."
  if hash brew 2>/dev/null; then
    eval ../.helpers/log.sh "brew" "Homebrew is already installed."
  else
    eval ../.helpers/log.sh "brew" "Homebrew not installed. Installing Homebrew now..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> $install_brew_log

    eval ../.helpers/log.sh "brew" "Homebrew installed."
  fi
}

function install_nvm {
  eval ../.helpers/log.sh "npm" "Checking for nvm command..."
  # using size check, hash does not detect nvm because it's a script
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    eval ../.helpers/log.sh "npm" "nvm already installed."
  else
    eval ../.helpers/log.sh "npm" "nvm not installed. Installing nvm now..."

    curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash &> $install_nvm_log
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    eval ../.helpers/log.sh "npm" "nvm installed."
  fi
}

function install_rvm {
  eval ../.helpers/log.sh "ruby" "Checking for rvm command..."
  if hash rvm 2>/dev/null; then
    eval ../.helpers/log.sh "ruby" "rvm already installed."
  else
    eval ../.helpers/log.sh "ruby" "rvm not installed. Installing rvm and latest ruby now..."
    curl -sSL https://get.rvm.io | bash -s stable --ruby &> $install_rvm_log

    eval ../.helpers/log.sh "ruby" "rvm and latest version of ruby installed."
  fi
}

function install_npm {
  eval ../.helpers/log.sh "npm" "Checking for npm command..."
  if hash npm 2>/dev/null; then
    eval ../.helpers/log.sh "npm" "npm already installed..."
  else
    eval ../.helpers/log.sh "npm" "npm not installed. Installing latest version of node and npm now..."

    if hash nvm 2>/dev/null; then
      nvm install $(nvm ls-remote | grep -oE '(v\d+.\d+.\d+)' | tail -1) &> $install_npm_log
      eval ../.helpers/log.sh "npm" "Latest version of node and npm installed."
    else
      eval ../.helpers/log.sh "npm" "Unable to install npm, nvm was not found!" "error"
    fi
  fi
}

function restore_taps {
  eval ../.helpers/log.sh "brew" "Restoring taps..."
  cat ./taps | xargs -n1 brew tap &> $restore_taps_log
  eval ../.helpers/log.sh "brew" "Taps restored."
}

function restore_brew {
  eval ../.helpers/log.sh "brew" "Restoring formulas..."
  cat ./brew | xargs brew install &> $restore_brew_log
  eval ../.helpers/log.sh "brew" "Formulas restored."
}

function restore_cask {
  eval ../.helpers/log.sh "brew" "Restoring casks..."
  cat ./casks | xargs brew cask install &> $restore_cask_log
  eval ../.helpers/log.sh "brew" "Casks restored."
}

function restore_npm {
  eval ../.helpers/log.sh "npm" "Restoring global modules..."
  cat ./npm | xargs npm install -g &> $restore_npm_log
  eval ../.helpers/log.sh "npm" "Global modules restored."
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
