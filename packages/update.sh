#!/bin/bash
echo 'Updating Homebrew...'
brew list -1 > brew
echo 'Updating Homebrew Cask...'
brew cask list -1 > casks
echo 'Updating npm global modules...'
npm ls -g --depth 0 | grep -oP '(?<= ).*' > npm
