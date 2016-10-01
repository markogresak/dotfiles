#!/bin/bash

source_file_path="$(basename $1)"
target_file_path="$1"

if [ -f "$source_file_path" ]; then
  # make sure full path exists before trying to copy file
  mkdir -p $(dirname "$target_file_path")
  cp -r "$source_file_path" "$target_file_path"
  eval ../.helpers/log.sh "config files" "Restored $source_file_path at $target_file_path."
  exit 0
else
  eval ../.helpers/log.sh "config files" "File $source_file_path does not exist, skip restoring." "error"
  exit 1
fi
