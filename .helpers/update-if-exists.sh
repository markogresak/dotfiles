#!/bin/bash

file_path="$1"

if [ -f "$file_path" ]; then
  cp -r "$file_path" ./
  eval ../.helpers/log.sh "config files" "Updated $file_path."
  exit 0
else
  eval ../.helpers/log.sh "config files" "File $file_path does not exist, skip updating." "error"
  exit 1
fi
