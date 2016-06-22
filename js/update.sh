#!/bin/bash

config_files=(
  '~/.eslintrc'
  '~/.eslintignore'
  '~/.babelrc'
)

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done
