if [[ "$TERM" == *"kitty" ]]; then
  autoload -Uz compinit
  compinit
  # Completion for kitty
  kitty + complete setup zsh | source /dev/stdin
fi