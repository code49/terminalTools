# terminalTools aliases — source this in your .bashrc/.zshrc
# e.g. source /path/to/terminalTools/aliases.sh

# Determine the tools directory relative to this script
TERMINAL_TOOLS_PATH="${TERMINAL_TOOLS_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tools}"

# Smart LS aliases
alias lss="$TERMINAL_TOOLS_PATH/sls/sls"
alias lst="$TERMINAL_TOOLS_PATH/sls/sls -t"
alias lsg="$TERMINAL_TOOLS_PATH/sls/sls -g"
alias lstg="$TERMINAL_TOOLS_PATH/sls/sls -t -g"

# Gitac alias
alias gitac="$TERMINAL_TOOLS_PATH/gitac/gitac"

# Firefox Shortcut Launcher
ff() {
  "$TERMINAL_TOOLS_PATH/ff/ff" "$@"
  
  # case on script exit code to decide whether to kill terminal
  local exit_code=$?
  if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    return 0
  elif [ $exit_code -eq 0 ] || [ $exit_code -eq 126 ]; then
    exit
  elif [ $exit_code -eq 130 ]; then
    return 0
  else
    echo "firefox shortcut script failed."
  fi
}
