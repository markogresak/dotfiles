#!/bin/bash

config_files=(
  '~/.vimrc'
  '~/.nvimrc'
)

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done
