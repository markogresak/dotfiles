#!/bin/bash

function update_brew {
  echo 'Updating Homebrew...'
  brew list -1 > brew
}

function update_cask {
  echo 'Updating Homebrew Cask...'
  brew cask list -1 > casks
}

function update_npm {
  echo 'Updating npm global modules...'
  npm ls -g --depth 0 | grep '@' | cut -d' ' -f2 > npm
}

update_brew &
update_cask &
update_npm &
wait
