#!/bin/bash

source_file_path="$(basename $1)"
target_file_path="$1"

if [ -f "$source_file_path" ]; then
  # make sure full path exists before trying to copy file 
  mkdir -p $(dirname "$target_file_path")
  cp -r "$target_file_path"
  echo "Updated $target_file_path."
  exit 0
else
  echo "File $source_file_path does not exist, skip updating."
  exit 1
fi
