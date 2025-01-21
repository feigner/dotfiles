#
# no my zsh config
#


#
# basics
#

setopt autocd extendedglob nomatch interactive_comments globdots

#
# history
#

HISTSIZE=10000000000  # gimme more
SAVEHIST=$HISTSIZE
INC_APPEND_HISTORY="true"
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

setopt extendedhistory
setopt appendhistory
setopt histignoredups
unsetopt histignorespace
setopt sharehistory
setopt incappendhistory

#
# cmd completions
#

unsetopt menu_complete   # don't auto-select the first completion entry
setopt auto_menu         # show completion menu on successive tab presses
setopt complete_in_word  # allow completion within a word, not just at the end
setopt always_to_end     # move cursor to the end after completing a word

autoload -Uz compinit; compinit    # init completion sys

# basic completer
zstyle ':completion:*' completer _complete
# case-insensitive and partial matching
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
# ensure tab completion shows both directories and files
zstyle ':completion:*' file-patterns '*:all-files *(-/):directories'
# enable menu selection for completion menu
zstyle ':completion:*:*:*:*:*' menu select
# colored menu
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

_comp_options+=(globdots) # include hidden files in completion results

zmodload zsh/complist                           # gimme menus, selection highlighting
autoload -U +X bashcompinit && bashcompinit     # enable bash-style completions

#
# plugins
#

source "$ZDOTDIR/pkg.sh"

zsh_add_plugin "zsh-users/zsh-history-substring-search"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

ZSH_AUTOSUGGEST_STRATEGY=('completion')

#
# packages
#

zsh_add_config "config/exports.sh"
zsh_add_config "config/aliases.sh"
zsh_add_config "config/vim-mode.sh"
zsh_add_config "config/fns.sh"

#
# theming
#

autoload -Uz colors && colors
zsh_add_config "config/spectrum.sh"
zsh_add_config "config/base16-eff.sh"
zsh_add_config "config/prompt.sh"

#
# bindings
# NOTE: vim-mode-specific bindings in vim-mode.sh
#

# ctrl-a + ctrl-e jumpin' aka old habits die hard
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line


#
# extras
#

# don't use magenta for highlightin'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold'

# Disable highlight of pastes text
zle_highlight=('paste:none')

# <3
eval "$(fzf --zsh)"
