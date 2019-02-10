HISTFILESIZE=25000

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell-custom"

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  sudo
)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

export EDITOR="code"
export NODE_ENV="development"
# export GPG_TTY=$(tty)

alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias gopn="git-open"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/sbin:$PATH"

local projects_path="~/Projects"

alias projects="$projects_path"
alias prezly="$projects_path/prezly/prezly"
alias backend="$projects_path/prezly/prezly/apps/backend"
alias press="$projects_path/prezly/prezly/apps/press"
alias website="$projects_path/prezly/website"
alias admin="$projects_path/prezly/admin-ui"
alias other="$projects_path/other"

alias wd="alias | grep -E \"\w+='~\" | sed \"s/'//g\" | sed 's/=/ => /'"

# Export each alias (detected by `wd`) as a variable named after the alias.
while read path_alias; do
  local path_export=$(echo $path_alias | sed 's/ => /=/')
  local export_name=$(echo $path_export | cut -d= -f1)
  if env | grep -q "^$export_name="; then
    echo "Conflict: Tried to export $path_export, but it would overwrite env variable $export_name. Skipped."
  else
    eval "export $path_export"
  fi
done <<< $(wd)
unset path_export
unset export_name

alias mergepdf="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py"

