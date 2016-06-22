#!/bin/bash

config_files=(
  '~/.zshrc'
  '~/.globalsrc'
  '~/.oh-my-zsh/custom/themes/agnoster.zsh-theme'
)

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done

echo 'Please update ~/.secretrc manually.'
