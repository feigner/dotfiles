#
# no my zsh config
#


#
# basics
#

setopt autocd extendedglob nomatch interactive_comments globdots

#
# init plugin / package manager + exports
#
source "$ZDOTDIR/pkg.sh"
zsh_add_config "config/exports.sh"

#
# history
#

HISTSIZE=10000000000  # gimme more
SAVEHIST=$HISTSIZE
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history


setopt extendedhistory       # tack metadata onto histfile entries
setopt appendhistory         # append when the shell exits
setopt incappendhistory      # write to history incrementally
setopt sharehistory          # share across sessions
setopt histignorealldups     # only keep the latest duplicate
setopt histreduceblanks      # trim excess blanks
unsetopt histignorespace     # keep space-prefixed cmds

#
# cmd completions
#

unsetopt menu_complete   # don't auto-select the first completion entry
setopt auto_menu         # show completion menu on successive tab presses
setopt complete_in_word  # allow completion within a word, not just at the end
setopt always_to_end     # move cursor to the end after completing a word

# pre-compinit requirements
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)       # homebrew completions
source "${HOME}/.orbstack/shell/init.zsh" 2>/dev/null || :  # orbstack completions

# compinit init
autoload -Uz compinit; compinit

# basic completer
zstyle ':completion:*' completer _complete
# case-insensitive matchin'
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
# ensure tab completion shows both directories and files
zstyle ':completion:*' file-patterns '*:all-files *(-/):directories'
# enable menu selection for completion menu
zstyle ':completion:*:*:*:*:*' menu select
# colored file / dir autocomplete
zstyle -e ':completion:*' list-colors 'reply=("${(s.:.)LS_COLORS}")'

_comp_options+=(globdots) # include hidden files in completion results

zmodload zsh/complist                           # gimme menus, selection highlighting
autoload -U +X bashcompinit && bashcompinit     # enable bash-style completions

#
# plugins
#

zsh_add_plugin "zsh-users/zsh-history-substring-search"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets)
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold'

#
# packages
#

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

# Disable highlight of pasted text
zle_highlight=('paste:none')

# mise
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# <3
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
