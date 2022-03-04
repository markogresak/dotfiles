export PATH="/usr/local/sbin:$PATH"

HISTFILESIZE=25000

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

export EDITOR="code"

export NODE_ENV="development"

export GOPATH="${HOME}/.go"
# Should be "$(brew --prefix golang)/libexec", but brew --prefix is slow
export GOROOT="/usr/local/opt/go/libexec"

export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin:$HOME/.deno/bin"

export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"
