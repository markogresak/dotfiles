#!/bin/bash

config_files=(
  '~/tslint.json'
)

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done
