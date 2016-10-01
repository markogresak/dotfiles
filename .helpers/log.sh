# !/bin/bash

# NOTE: Due to how bash processes arguments, if the last word in message
#       matches a color, it will be treated as a color instead as message.

default_color="\e[39m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
gray="\e[90m"
white="\e[97m"
light_red="\e[91m"
light_green="\e[92m"
light_yellow="\e[93m"
light_blue="\e[94m"
light_magenta="\e[95m"
light_cyan="\e[96m"
light_gray="\e[37m"
color_error="\e[41m"

text_normal="\e[0m"
text_bold="\e[1m"

operation="$1"
shift
message=""
color_name="${@: -1}"

for arg in "$@"; do
  if [[ "$arg" == "$color_name" ]]; then
    break
  fi
  message="$message $arg"
done

case $operation in
  brew) color=$yellow ;;
  npm) color=$green ;;
  ruby) color=$red ;;
  zsh) color=$cyan ;;
  editor) color=$light_blue ;;
  git) color=$light_magenta ;;
  css) color=$light_cyan ;;
  js) color=$light_yellow ;;
  *) color=$default_color ;;
esac

if [[ -n $color_name ]]; then
  case $color_name in
    black) color=$black ;;
    red) color=$red ;;
    green) color=$green ;;
    yellow) color=$yellow ;;
    blue) color=$blue ;;
    magenta) color=$magenta ;;
    cyan) color=$cyan ;;
    gray) color=$gray ;;
    white) color=$white ;;
    light_red) color=$light_red ;;
    light_green) color=$light_green ;;
    light_yellow) color=$light_yellow ;;
    light_blue) color=$light_blue ;;
    light_magenta) color=$light_magenta ;;
    light_cyan) color=$light_cyan ;;
    light_gray) color=$light_gray ;;
    error) color=$color_error ;;
    *)
      color=$default_color
      # last arg was not color name, must have been a part of message
      message="$message $color_name"
    ;;
  esac
fi

printf "$color$text_bold$operation:$default_color$text_normal$message\n"
