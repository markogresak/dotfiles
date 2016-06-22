#!/bin/bash
# Homebrew
brew list -1 > brew
# Homebrew Cask
brew cask list -1 > casks
# npm global modules
npm ls -g --depth 0 | grep -oP '(?<= ).*' > npm
