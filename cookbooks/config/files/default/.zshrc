setopt interactivecomments

if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"
