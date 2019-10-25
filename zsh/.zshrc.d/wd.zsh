# path alises (inspired by wd)
local projects_path="~/Projects"
alias projects="$projects_path"
alias prezly="$projects_path/prezly/prezly"
alias backend="$projects_path/prezly/prezly/apps/backend"
alias press="$projects_path/prezly/prezly/apps/press"
alias website="$projects_path/prezly/website"
alias other="$projects_path/other"
alias blog="$projects_path/other/markogresak.github.io"

alias wd="alias | grep -E \"\w+='~\" | sed \"s/'//g\" | sed 's/=/ => /'"

if [[ -z $_PATH_ALIASES_EXPORTED_ ]]; then
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
    # set a flag to prevent subsequent exports (creates conflicts)
    export _PATH_ALIASES_EXPORTED_=true
fi
