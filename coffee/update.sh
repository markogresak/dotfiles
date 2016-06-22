#!/bin/bash

coffeelint_config_path='~/coffeelint.json'

if eval ../.helpers/copy-if-exists.sh "$coffeelint_config_path"; then
  echo 'Updated CoffeeScript files.'
fi
