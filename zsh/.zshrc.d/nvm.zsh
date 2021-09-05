# The custom (non-brew) installation places the script in the `NVM_DIR`
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use

# A workaround to sourcing nvm script path because `nvm use` is slow
local NODE_VERSION="$(cat $NVM_DIR/alias/default | tail -1)"
export PATH="$PATH:$NVM_DIR/versions/node/$NODE_VERSION/bin"
