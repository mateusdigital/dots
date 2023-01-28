# ## If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#       *) return;;
# esac


##
## _Exports
##

##------------------------------------------------------------------------------
declare -r PROFILE="${HOME}/.bashrc";
export PROFILE;

declare -r IS_WSL="$(uname -a | grep "WSL2")";
export IS_WSL;

if [ -n "${IS_WSL}" ]; then
    declare -r WIN_HOME="${HOME}/win_home";
    declare -r USER_DATA_HOME="${WIN_HOME}";
else
    declare -r USER_DATA_HOME="${HOME}";
fi;

declare -r AUDIOBOOKS_DIR="$USER_DATA_HOME/Documents/Audiobooks";

export EDITOR="code";
export VISUAL="${EDITOR}";

## PATH
PATH="$PATH:/home/mateus/.mateus-earth/bin";
export PATH ;



##
##  _Imports
##

##------------------------------------------------------------------------------
## Gosh
source "/home/mateus/.mateus-earth/bin/gosh/gosh.sh";


##
## Aliases
##

##------------------------------------------------------------------------------
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF';

## Editor aliases
##------------------------------------------------------------------------------
alias e='${EDITOR}';
alias ee="e .";

## File manager
##------------------------------------------------------------------------------
alias fm="files";

## Profile aliases
##------------------------------------------------------------------------------
alias reload-profile='source ${PROFILE}';
alias edit-profile='code ${PROFILE}';

## Git aliases
##------------------------------------------------------------------------------
alias git="__my_git";

alias g="git";
alias gg="g g";
alias gs="g s";

## Dots aliases
##------------------------------------------------------------------------------
alias d="dots";

## Python aliases
##------------------------------------------------------------------------------
alias pydoc="pydoc3";


##
## Bash Completion
##

##------------------------------------------------------------------------------
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

##------------------------------------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

declare -r GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01';
export GCC_COLORS;


##
## Custom Functions
##

##------------------------------------------------------------------------------
function mkcd()
{
    mkdir -p "$1" && cd "$1" && pwd;
}

##------------------------------------------------------------------------------
function download-audiobook()
{
    test -d "${AUDIOBOOKS_DIR}" || mkdir -p "${AUDIOBOOKS_DIR}";
    pushd "${AUDIOBOOKS_DIR}";
        youtube-mp3 "$@";
    popd;
}

##
## Directories
##

##------------------------------------------------------------------------------
readonly BIN_DIR="${HOME}/.bin/dots/gnu";
export BIN_DIR;

readonly CONFIG_DIR="${HOME}/.config";
export CONFIG_DIR;


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
    ## needed hacks and forwards the arguments to the underlying tools.
    ##
    ## For now we are just handling:
    ##   git, gitui

    local GIT_DIR="${HOME}/.dots-bare";
    local GIT_WORK_TREE="${HOME}";

    if [ $# -eq 0 ]; then
        dots status -u;
    else
        git                                \
            --git-dir   "${GIT_DIR}"       \
            --work-tree "${GIT_WORK_TREE}" \
            "$@";
    fi;
}


##
## Emscriptem
##

if [ -f "${HOME}/.emsdk/emsdk_env.sh" ]; then
    export EMSDK_QUIET=1;
    source "${HOME}/.emsdk/emsdk_env.sh";
fi;


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
        explorer.exe "$1";
    fi;
}


##
## GIT
##

##------------------------------------------------------------------------------
function __my_git() {
    local git_exe="$(which git)"; ## The original git executable.

    if [ "$1" == "clone" ]; then
        shift; ## Remove the "clone" argument.

        local args_count=${#};
        local user_repo="";

        if [ $args_count -eq 2 ]; then  ## github-clone TheFakeMontyOnTheRun dungeons-of-noudar
            user_repo="${1}/${2}";
        else
            if [ -n "$(echo "$1" | grep \/)" ]; then ## github-clone firsh/jsnes
                user_repo="${1}";
            else
                local git_user="mateus-earth";
                user_repo="${git_user}/${1}";
            fi;
        fi;

        local clone_url="git@github.com:${user_repo}";

        echo "[${FUNCNAME[0]}] Clonning repo: (${clone_url})";
        $git_exe clone --recursive "${clone_url}";
    else
        echo "[${FUNCNAME[0]}] exec: $git_exe $@)";
        $git_exe "$@";
    fi;
}


##
## History
##

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000


##
## MISC
##

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


##
## PATH
##

PATH="${PATH}:${HOME}/.bin/dots/gnu:${HOME}/.local/bin";


##
## PS1
##

##------------------------------------------------------------------------------
function _update_ps1()
{
    PS1=$(powerline-shell $?)
}

if [ -f ".local/bin/powerline-shell" ]; then
    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi;

export PS1;


##
## Youtube-dl
##

##------------------------------------------------------------------------------
function youtube-dl()
{
    /usr/bin/youtube-dl        \
        --write-description    \
        --write-info-json      \
        --write-annotations    \
        --write-thumbnail      \
        --prefer-free-formats  \
        --add-metadata         \
        "$@"                   \
    ;
}

##------------------------------------------------------------------------------
function youtube-mp3()
{
    youtube-dl               \
        --extract-audio      \
        --audio-format="mp3" \
        --embed-thumbnail    \
        "$@"                 \
    ;
}


##
## Entry Point
##

#echo "Welcome Matt - Let's do it for the family!!! $(date)"; ## @incomplete: Add some more random motivation...


## Starship...
eval "$(starship init bash)"
