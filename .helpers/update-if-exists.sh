#!/bin/bash

file_path="$1"

rm -rf "./$(basename $file_path)"

if [ -f "$file_path" ] || [ -d "$file_path" ]; then
  cp -Lr "$file_path" ./
  eval ../.helpers/log.sh "config_files" "Updated $file_path."
  exit 0
else
  eval ../.helpers/log.sh "config_files" "File $file_path does not exist, skip updating." "error"
  exit 1
fi
