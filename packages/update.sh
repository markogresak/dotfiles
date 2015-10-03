#!/bin/bash
brew list -1 > brew
brew cask list -1 > casks
npm ls --global --depth 0 > npm
