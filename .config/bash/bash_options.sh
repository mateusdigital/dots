test $BASH_OPTIONS_SH_LOADED && return;
BASH_OPTIONS_SH_LOADED=1;

##
## Inspired by:
##    https://github.com/stdmatt/bash-sensible/blob/master/sensible.bash

##------------------------------------------------------------------------------
## SHOPT
shopt -s autocd                 ## change to named directory
shopt -s cdspell                ## autocorrects cd misspellings
shopt -s cmdhist                ## save multi-line commands in history as single line
shopt -s expand_aliases         ## expand aliases
shopt -s histappend             ## Append to the history file
shopt -s checkwinsize           ## Check the window size after each command ($LINES, $COLUMNS)
shopt -s nocaseglob;            ## Case-insensitive globbing (used in pathname expansion)
shopt -s globstar 2> /dev/null  ## Turn on recursive globbing (enables ** to recurse all directories)

bind "set completion-ignore-case on" ## ignore upper and lowercase when TAB completion

## Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

## VI mode on command line.
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert  'Control-l: clear-screen'

PROMPT_DIRTRIM=2 # Automatically trim long paths in the prompt


## SMARTER TAB-COMPLETION (Readline bindings) ##

bind "set completion-ignore-case on"     ## Perform file completion in a case insensitive fashion
bind "set completion-map-case on"        ## Treat hyphens and underscores as equivalent
bind "set show-all-if-ambiguous on"      ## Display matches for ambiguous patterns at first tab press
bind "set mark-symlinked-directories on" ## Immediately add a trailing slash when autocompleting symlinks to directories


## This allows you to bookmark your favorite places across the file system
## Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"
