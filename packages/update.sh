#!/bin/bash

function update_brew {
  eval ../.helpers/log.sh "brew" "Updating formulas..."
  brew list -1 > brew
  eval ../.helpers/log.sh "brew" "Formulas updated."
}

function update_taps {
  eval ../.helpers/log.sh "brew" "Updating taps..."
  brew tap > taps
  eval ../.helpers/log.sh "brew" "Taps updated."
}

function update_npm {
  eval ../.helpers/log.sh "npm" "Updating global modules..."
  npm ls --depth 0 -g  2>/dev/null | grep -v UNMET | grep '@' | cut -d' ' -f2 > npm
  eval ../.helpers/log.sh "npm" "Global modules updated."
}

# update brew to prevent listing packages from auto-update
brew update > /dev/null

update_brew &
update_taps &
update_npm &
wait
