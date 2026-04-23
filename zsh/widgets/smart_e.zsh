# Smart ^E: accept autosuggestion if present, otherwise open zfm bookmark picker
_smart_ctrl_e() {
    if [[ -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
    else
        zle zfm-insert-bookmark
    fi
}
zle -N _smart_ctrl_e
bindkey '^E' _smart_ctrl_e
