export NVM_DIR="$HOME/.nvm"
# not using $(brew --prefix nvm) because it's slow
[ -s "$BREW_PATH/opt/nvm/nvm.sh" ] && . "$BREW_PATH/opt/nvm/nvm.sh" --no-use

# A workaround to setting node path because `nvm use` is slow
PATH="$PATH:$NVM_DIR/versions/node/v12.16.1/bin"
