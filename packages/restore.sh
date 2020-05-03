#!/bin/bash

install_nvm_log="install_nvm.log"
install_npm_log="install_npm.log"
restore_npm_log="restore_npm.log"

function install_nvm {
  eval ../.helpers/log.sh "npm" "Checking for nvm command..."
  # using size check, hash does not detect nvm because it's a script
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    eval ../.helpers/log.sh "npm" "nvm already installed."
  else
    eval ../.helpers/log.sh "npm" "nvm not installed. Installing nvm now..."

    curl -so- ttps://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash &> $install_nvm_log
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    eval ../.helpers/log.sh "npm" "nvm installed."
  fi
}

function install_npm {
  eval ../.helpers/log.sh "npm" "Checking for npm command..."
  if hash npm 2>/dev/null; then
    eval ../.helpers/log.sh "npm" "npm already installed..."
  else
    eval ../.helpers/log.sh "npm" "npm not installed. Installing latest version of node and npm now..."

    if hash nvm 2>/dev/null; then
      nvm install --lts &> $install_npm_log
      eval ../.helpers/log.sh "npm" "Latest version of node and npm installed."
    else
      eval ../.helpers/log.sh "npm" "Unable to install npm, nvm was not found!" "error"
    fi
  fi
}


function restore_npm {
  eval ../.helpers/log.sh "npm" "Restoring global modules..."
  cat ./npm | xargs npm install -g &> $restore_npm_log
  eval ../.helpers/log.sh "npm" "Global modules restored."
}

function node_all {
  install_nvm
  install_npm
  restore_npm
}

node_all &
wait
