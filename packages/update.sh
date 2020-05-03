#!/bin/bash

function update_npm {
  eval ../.helpers/log.sh "npm" "Updating global modules..."
  npm ls --depth 0 -g  2>/dev/null | grep -v UNMET | grep '@' | cut -d' ' -f2 > npm
  eval ../.helpers/log.sh "npm" "Global modules updated."
}

update_npm &
wait
