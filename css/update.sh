#!/bin/bash

config_files=(
  '~/.scss-lint.yml'
)

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done
