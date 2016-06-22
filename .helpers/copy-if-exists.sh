#!/bin/bash

file_path="$1"

if [ -f "$file_path" ]; then
  cp -r "$file_path" ./
  echo "Updated $file_path."
  exit 0
else
  echo "File $file_path does not exist, skip updating."
  exit 1
fi
