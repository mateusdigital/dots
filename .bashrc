## If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export BASH_SILENCE_DEPRECATION_WARNING=1; ## For macs to be quiet



echo "dots loaded...";

##
## _Exports
##

##------------------------------------------------------------------------------
declare -r PROFILE="${HOME}/.bashrc";
export PROFILE;

##------------------------------------------------------------------------------
readonly IS_WSL="$(uname -a | grep "WSL2")";
readonly IS_MAC="$(uname -a | grep "Darwin")";
readonly IS_GNU_LINUX="$(uname -a | grep "GNU")";

export IS_WSL;
export IS_MAC;
export IS_GNU_LINUX;

readonly OS_NAME="$(uname -s)";
readonly NODE_NAME="$(uname -n)";

if [ -n "${IS_WSL}" ]; then
    declare -r WIN_HOME="${HOME}/win_home";
fi;

##------------------------------------------------------------------------------
export EDITOR="vim";
if [ -z "$SSH_CLIENT" ]; then
	export VISUAL="code";
else
	export VISUAL="$EDITOR";
fi;


##------------------------------------------------------------------------------
readonly BIN_DIR="${HOME}/.local/bin/dots";
export BIN_DIR;

if [ -n "$IS_GNU_LINUX" ]; then
	readonly BIN_DIR_OS="${BIN_DIR}/gnu";
elif [ -n "$IS_MAC" ]; then
	readonly BIN_DIR_OS="${BIN_DIR}/mac";
fi;
export BIN_DIR_OS;

readonly CONFIG_DIR="${HOME}/.config";
export CONFIG_DIR;

readonly SCRAP_FILE_DIR="${HOME}/.scrap_files";
export SCRAP_FILE_DIR;

##------------------------------------------------------------------------------
declare -r GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01';
export GCC_COLORS;

##
##  _Imports
##

##------------------------------------------------------------------------------
## Gosh
test -f /home/mateus/.mateus-earth/bin/gosh/gosh.sh && \
    source "/home/mateus/.mateus-earth/bin/gosh/gosh.sh";


##
## Aliases - and small functions that should behave like aliases.
##


##------------------------------------------------------------------------------
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

##------------------------------------------------------------------------------
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF';


## Editor aliases
##------------------------------------------------------------------------------
function e() {
    if [ -z "$@" ] ;then
        ${EDITOR} .; ## Open current directory by default.
    else
        ${EDITOR} "$@"; ## Open with args.
    fi;
}

function v() {
    if [ -z "$@" ] ;then
        ${VISUAL} .; ## Open current directory by default.
    else
        ${VISUAL} "$@"; ## Open with args.
    fi;
}

readonly __original_editor=$EDITOR;
readonly __original_visual=$VISUAL;
function all-visual() {
    export EDITOR=$__original_visual;
    echo "e v -> $EDITOR";
}
function all-editor() {
    export VISUAL=$__original_editor;
    echo "e v -> $VISUAL";
}

## New File...
##------------------------------------------------------------------------------
function __nf_helper() {
    if [ -z "$1" ]; then
        local datetime=$(date +%Y-%m-%d_%H-%M-%S)
        local filename="file_${datetime}.txt"

        echo "${SCRAP_FILE_DIR}/${filename}";
    else
        echo "$1";
    fi;
}

function nf() {
    local filename="$(__nf_helper "$@")";
    make-file.sh "${filename}" && v "${filename}";
}

function nfe() {
    local filename="$(__nf_helper "$@")";
    make-file.sh -e "${filename}" && v "${filename}";
}


## File manager
##------------------------------------------------------------------------------
alias fm="files";


## Git aliases (Dots bellow)
##------------------------------------------------------------------------------
alias git="__my_git";

alias g="__my_git";
alias gg="__my_git g";
alias gs="__my_git s";
alias gp="__my_git p";

alias gr='cd $(git root)';

## --->
alias d="dots";
alias dg="dots g";
alias ds="dots s";
alias dp="dots p";

## Profile aliases
##------------------------------------------------------------------------------
alias reload-profile='source ${PROFILE}';

alias edit='$VISUAL ${HOME}';
alias edit-profile='$VISUAL ${HOME}/.bashrc';

alias list-bin='ls -1 $BIN_DIR';
alias edit-bin='$VISUAL $BIN_DIR';

alias bug='${VISUAL} ${HOME}/.mateus-earth/bugs.yml';


function edit-ignore() {
    local local_ignore="${PWD}/.gitignore";
    local global_ignore="${CONFIG_DIR}/.dots_gitignore";
    if [ -d "${local_ignore}" ]; then
        ${EDITOR} "${local_ignore}";
    else
        ${EDITOR} "${global_ignore}";
    fi;
}

## Python aliases
##------------------------------------------------------------------------------
alias pydoc="pydoc3";

## repochecker aliases
##------------------------------------------------------------------------------
alias repoall="repochecker --remote --show-all --submodules"

## WSL aliases
alias wsl-ip='expose-wsl | grep "WSL should" | cut -d":" -f2 | tr -d " "';



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
## Custom Functions
##

##------------------------------------------------------------------------------
function mkcd()
{
    mkdir -p "$1" && cd "$1" && pwd;
}


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

##------------------------------------------------------------------------------
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
        local clone_url="";

        if [ -n "$(echo "${1}" | grep "https://")" ] \
        || [ -n "$(echo "${1}" | grep "git@")" ]; then ## Complete path...
            clone_url="${1}";
        else
            if [ $args_count -eq 2 ]; then  ## github-clone TheFakeMontyOnTheRun dungeons-of-noudar
                user_repo="${1}/${2}";
            else
                if echo "$1" | grep -q '/'; then
                    user_repo="${1}";
                else
                    local git_user="mateus-earth";
                    user_repo="${git_user}/${1}";
                fi;
            fi;

            clone_url="git@github.com:${user_repo}";
        fi;

        echo "[${FUNCNAME[0]}] Clonning repo: (${clone_url})"; ## VERBOSE-LOG
        $git_exe clone --recursive "${clone_url}";
    else
        ## echo "[${FUNCNAME[0]}] exec: $git_exe $*)"; ## VERBOSE-LOG
        $git_exe "$@";
    fi;
}

function git-feature-start()
{
    git flow feature start "$@";
}

function git-feature-finish()
{
    git flow feature finish "$@";
}


##
## History
##

##------------------------------------------------------------------------------
# append to the history file, don't overwrite it
shopt -s histappend;
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Store multiline commands as one line.
shopt -s cmdhist

shopt -s checkwinsize # check the window size after each command and, if necessary,
                      # update the values of LINES and COLUMNS.

## shopt -s dirspell ## @bug: doesn't work on mac

export HISTCONTROL=ignoreboth;
export HISTIGNORE="&:ls:[bf]g:pwd:exit:cd ..";

export HISTSIZE=100000;
export HISTFILESIZE=200000;


##
## MISC
##

##------------------------------------------------------------------------------
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


##
## PATH
##

##------------------------------------------------------------------------------
PATH="${PATH}:${BIN_DIR}:${BIN_DIR_OS}:${HOME}/.local/bin";
export PATH;
alias list-path='echo "$PATH" | tr ":" "\n"';

##
## PS1
##

##------------------------------------------------------------------------------
function set_git_ps1() {
    local last_code=$?;
    local git_branch="$(git curr-branch 2>/dev/null)";

    if [[ -n $git_branch ]]; then
        ## HACK: Just to remove the ssh from the url, we must find a generic way...
        local git_url="$(git url | sed s/"git@github.com:"/""/g)";
        if [ -n "$git_url" ]; then
            local head="$(dirname $git_url)";
            local tail="$(basename $git_url)";
            str="[${head}/${tail}] ($PWD)";
        else
            local git_dir=$(basename "$(git root)");
            str="[$git_dir] : $git_branch";
        fi;

        str="${str} : ${git_branch}";
    else
        str="${PWD} ";
    fi

    local smile_face=":)";
    if [ $last_code -ne 0 ]; then
        smile_face=":(";
    fi;

    printf "%s @%s(%s)\n%s " "${str}" "${NODE_NAME}" "${OS_NAME}"  ${smile_face};
}

export PS1='$(set_git_ps1)'


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
##
##

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


## PRIVATE DOTFILES...
test -f "${HOME}/.bashrc_private" && source "${HOME}/.bashrc_private";
