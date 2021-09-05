for FN in $HOME/.zshrc.d/*.zsh; do
    if [[ -n $DEBUG ]]; then
        echo "$FN"
        start=$(( $(gdate +%s%N) / 1000000 ))
    fi
    source "$FN"
    if [[ -n $DEBUG ]]; then
        end=$(( $(gdate +%s%N) / 1000000 ))
        echo "delta $(( end - start ))"
    fi
done

