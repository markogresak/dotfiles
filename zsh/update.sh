#!/bin/bash

source ./config_files.sh

for file in ${config_files[@]}; do
  eval ../.helpers/copy-if-exists.sh "$file"
done

unset config_files

echo 'Please update ~/.secretrc manually.'
