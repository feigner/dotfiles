# plugin + config management
# Lifted from Mach-OS Machfiles before zap-zsh was a thing

# Source config files if they exist
# Usage: zsh_add_config "zsh-prompt"
function zsh_add_config() {
  [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

# Source files from anywhere if they exist
# Usage: zsh_add_file "./zsh-prompt"
function zsh_add_file() {
  [ -f "$1" ] && source "$1"
}

# Auto-clone plugins + source 'em
# Usage: zsh_add_plugin "zsh-users/zsh-autosuggestions"
function zsh_add_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)

  if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
    zsh_add_config "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || zsh_add_config "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
  else
    echo "Cloning $1"
    git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    zsh_add_config "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || zsh_add_config "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
  fi
}
