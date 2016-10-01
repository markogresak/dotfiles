#!/bin/bash

function update_brew {
  echo 'Updating Homebrew formulas...'
  brew list -1 > brew
  echo -e '\nHomebrew formulas updated.\n'
}

function update_cask {
  echo 'Updating Homebrew Cask...'
  brew cask list -1 > casks
  echo -e '\nHomebrew Cask updated.\n'
}

function update_taps {
  echo 'Updating Homebrew Taps...'
  brew tap --list > taps
  echo -e '\nHomebrew taps updated.\n'
}

function update_npm {
  echo 'Updating npm global modules...'
  npm ls -g --depth 0 | grep '@' | cut -d' ' -f2 > npm
  echo -e '\nnpm global modules updated.\n'
}

# update brew to prevent listing packages from auto-update
brew update > /dev/null

update_brew &
update_cask &
update_taps &
update_npm &
wait
