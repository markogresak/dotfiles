#!/bin/bash

set -m

update_script_name='update.sh'

function exec_update {
  local oldpwd
  oldpwd=$PWD
  cd `dirname $1`
  eval "./$update_script_name"
  cd $oldpwd
}

# Exec each of update scripts.
find . -name "$update_script_name" | while read script_path; do
  exec_update "$script_path"
done

git commit -a -m "auto-update on $(date "+%Y/%m/%d %H:%M:%S")"
