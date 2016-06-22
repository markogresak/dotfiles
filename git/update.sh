#!/bin/bash

config_files=(
  '~/.gitconfig'
  '~/.gitignore_global'
)

for file in ${config_files[@]}; do
  if eval ../.helpers/copy-if-exists.sh "$file"; then
    echo "Updated $file."
  fi
done