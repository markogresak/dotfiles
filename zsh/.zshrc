for FN in $HOME/.zshrc.d/*.zsh; do
    # echo "$FN"
    # start=$(( $(gdate +%s%N) /1000000 ))
    source "$FN"
    # end=$(( $(gdate +%s%N) /1000000 ))
    # echo "delta $(( end - start ))"
done

