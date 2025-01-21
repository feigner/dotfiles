bindkey -v

export KEYTIMEOUT=1

# normal mode / vim modehistory substring search via arrow & jk
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# normal mode delete key fix
bindkey -M vicmd "^[[3~" delete-char

# Use vim keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^[[Z' vi-up-line-or-history
bindkey -v '^?' backward-delete-char

# select quoted, ie `ci"` support
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,i}{\',\",\`}; do
	  bindkey -M $m $c select-quoted
	done
done

# select bracked, ie `ci(` support
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
	  bindkey -M $m $c select-bracketed
	done
done

#
# cursor mode tricks
#

# Change cursor shape for different vi modes.
function zle-keymap-select() {
    # local purp_cursor="\e]12;#C792EA\a"
    # local white_cursor="\e]12;#FFFFFF\a"

    case $KEYMAP in
        vicmd)
            echo -ne '\e[1 q'  # Block
            # echo -ne "$purp_cursor" # Change cursor to purple for extra visibility
            RPROMPT="%{$fg[green]%}[NORMAL]%{$reset_color%}"
            # RPROMPT="%K{green}%F{black} NORMAL %k%f"  # Green background, black text
            ;;
        viins|main)
            echo -ne '\e[5 q'  # Beam
            # echo -ne "$white_cursor" # Reset cursor color
            RPROMPT="" # no cursor on insert mored
            ;;
    esac
    zle reset-prompt
}

zle -N zle-keymap-select

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
