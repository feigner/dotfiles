# eff
# features:
#   _ sexy purp (stolen from r2)
#   _ chop cwd to 45 chars

purp=$FG[097]

# prompt
PROMPT='
%{$purp%}[%{$fg[$NCOLOR]%}%B%n%b%{$fb_bold[gray]%}@%{$fg[white]%}%m%{$reset_color%}:%45<...<%~%<<%{$purp%}]$reset_color $(git_prompt_info)
→ '
RPROMPT=''

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$purp%}(%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$purp%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✱"

