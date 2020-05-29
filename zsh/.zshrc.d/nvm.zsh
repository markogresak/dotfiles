# The custom (non-brew) installation places the script in the `NVM_DIR`
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use

# A workaround to setting node path because `nvm use` is slow
PATH="$PATH:$NVM_DIR/versions/node/v12.17.0/bin"
