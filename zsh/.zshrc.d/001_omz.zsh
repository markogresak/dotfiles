export ZSH="$HOME/.oh-my-zsh"

THEME_CHAR="λ"
ZSH_THEME="robbyrussell-custom"

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Disable marking untracked VCS files as dirty.
# This makes repository status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  sudo
  fzf
)

source $ZSH/oh-my-zsh.sh
alias zshconfig="$EDITOR ~/.zshrc"
# alias ohmyzsh="$EDITOR ~/.oh-my-zsh"