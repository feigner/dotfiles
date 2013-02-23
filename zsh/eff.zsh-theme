# eff
# features:
#   _ nothin yet!

purp=$FG[097]

# prompt
PROMPT='%{$purp%}[%{$fg[$NCOLOR]%}%B%n%b%{$fb_bold[gray]%}@%{$fg[white]%}%m%{$reset_color%}:%{$fg[white]%}%45<...<%~%<<%{$purp%}]%{$reset_color%}%(!.#.$) '
RPROMPT='$(git_prompt_info)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}(%{$purp%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"

