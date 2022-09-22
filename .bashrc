# If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#       *) return;;
# esac

##
## _Exports 
##

export PROFILE="${HOME}/.bashrc";
export IS_WSL="$(uname -a | grep "WSL2")";

if [ -n "${IS_WSL}" ]; then 
    export WIN_HOME="${HOME}/win_home";
fi;


##
## Aliases
##

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF';

alias reload-profile="source ${PROFILE}";
alias edit-profile="code ${PROFILE}";

alias g="git";
alias gg="g g";

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
## Colors
## 

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


##
## Dots
##

##------------------------------------------------------------------------------
function dots()
{
    ## @notice: [How dots are structure and mindset]
    ##
    ## We use a git bare repository with the work tree on $HOME.
    ## This means that with an addition of a custom gitignore 
    ## to avoid the noise, we can have all the files auto managed 
    ## by git itself, not needing for us to mess with syslinks and such.
    ##
    ## But in return we have a very long line to type everytime to make 
    ## git understand the repo's structure, even worse other tools doesn't 
    ## quite like the way that it's set by default (requiring a lot of typing as well.)
    ##
    ## So this function works as and entry point that actually makes the 
    ## needed hacks and forwards the maximum to the tools.
    ##
    ## For now we are just handling:
    ##   git, gitui

    local GIT_DIR="${HOME}/.dots-bare";
    local GIT_WORK_TREE="${HOME}";
    if [ $# -eq 0 ]; then 
        dots status;
    else 
        git                                \
            --git-dir    "${GIT_DIR}"      \
            --work-tree "${GIT_WORK_TREE}" \
            "$@";
    fi;
}

##------------------------------------------------------------------------------
dots config --local status.showUntrackedFiles no;                        ## Reduce noise.
dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore"; ## Custom gitignore.

##
## Emscriptem
##
export EMSDK_QUIET=1;
source "${HOME}/.emsdk/emsdk_env.sh";


##
## File Manager
## 

##------------------------------------------------------------------------------
function files() 
{
    ## @incomplete: Just works on wsl right now... - Mesquita 22-09-20
    if [ -z "$1" ]; then 
        explorer.exe .
    else 
        explorer.exe $1;
    fi;
}

##------------------------------------------------------------------------------
alias fm="files";

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
## PATH
##

PATH="${PATH}:${HOME}/.bin/dots/gnu:"


##
## Entry Point
## 

echo "Welcome Matt - Let's do it for the family!!! $(date)"; ## @incomplete: Add some more random motivation...