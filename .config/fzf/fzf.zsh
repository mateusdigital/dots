# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/stdmatt/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/stdmatt/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/stdmatt/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/stdmatt/.fzf/shell/key-bindings.zsh"
