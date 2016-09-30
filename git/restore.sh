#!/bin/bash

source ./config_files

for file in ${config_files[@]}; do
  mkdir -p $(dirname "$file")
  cp "$file" "$HOME"
  echo "Restored $file to $HOME/$file"
done

unset config_files
