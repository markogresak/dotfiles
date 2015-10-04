#!/bin/bash
# Homebrew
brew list -1 > brew
# Homebrew Cask
brew cask list -1 > casks
# npm global modules
npm ls --global --depth 0 > npm
