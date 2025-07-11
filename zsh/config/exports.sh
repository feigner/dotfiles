################################################################################
# Exported Variables
################################################################################

# The big one -- first elements added first, but resolved last
export PATH=$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/build-tools:$HOME/Android/sdk/platform-tools:$PATH
export PATH=/opt/homebrew/opt/yarn:$PATH
export PATH=/usr/local/bin:$PATH     # Recommended by brew doctor
export PATH=/opt/homebrew/sbin:$PATH # Recommended by brew doctor
export PATH=/opt/homebrew/bin:$PATH  # Brew is first as everything else uses that
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# vim everywhere
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

# ls colors via http://geoff.greer.fm/lscolors/
export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# fzf theme
export FZF_DEFAULT_OPTS='
  --height=50%
  --margin="0,2,0,2"
  --border="bold" --preview-window="sharp" --prompt="▶ "
  --marker="▶" --pointer="▶" --separator="─" --scrollbar="│"
  --layout="default" --info="right"
  --color=fg:#f5f4f1,fg+:#f9f8f5,bg:#303030,bg+:#383838
  --color=hl:#C792EA,hl+:#C792EA,info:#6a6a6a,marker:#C3E88D
  --color=prompt:#C792EA,spinner:#C792EA,pointer:#F78C6C,header:#87afaf
  --color=border:#444444,separator:#4a4a4a,label:#aeaeae,query:#f9f8f5'

# bat theme (ie: fzf vim preview)
export BAT_THEME='base16'

# `less` colors
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "

# main projects dir (see `cdp`)
export PROJECTS_DIR="${HOME}/projects"

# rg
export RIPGREP_CONFIG_PATH="${HOME}/.config/.ripgreprc"

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# android studio :/
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
