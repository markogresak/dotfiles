#!/bin/bash

function update_brew {
  echo 'Updating Homebrew...'
  brew list -1 > brew
}

function update_cask {
  echo 'Updating Homebrew Cask...'
  brew cask list -1 > casks
}

function update_taps {
  echo 'Updating Homebrew Taps...'
  brew tap --list > taps
}

function update_npm {
  echo 'Updating npm global modules...'
  npm ls -g --depth 0 | grep '@' | cut -d' ' -f2 > npm
}

# update brew to prevent listing packages from auto-update
brew update > /dev/null

update_brew &
update_cask &
update_taps &
update_npm &
wait
