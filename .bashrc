# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

##
## Exports 
##

export PROFILE="${HOME}/.bashrc";


## 
## History
## 

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

##
## MISC
## 

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


## 
## Colors
## 

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

##
## Aliases
##

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF';
alias fm="files";

alias reload-profile="source $PROFILE";
alias edit-profile="code $PROFILE";


## 
## Bash Completion
##

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


##
## Functions 
## 

function files() 
{
    ## @incomplete: Just works on wsl right now... - Mesquita 22-09-20
    if [ -z "$1" ]; then 
        explorer.exe .
    else 
        explorer.exe $1;
    fi;
}


##
## Entry Point
## 

echo "Welcome Matt - Let's do it for the family!!! $(date)"; ## @incomplete: Add some more random motivation...