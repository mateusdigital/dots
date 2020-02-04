##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : misc.sh                                                       ##
##  Project   : dots                                                          ##
##  Date      : Jan 06, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2019, 2020                                          ##
##                                                                            ##
##  Description :                                                             ##
##    My custom PS1.                                                          ##
##---------------------------------------------------------------------------~##


##----------------------------------------------------------------------------##
## Constants                                                                  ##
##----------------------------------------------------------------------------##
_DOTS_COLOR_PWD=64
_DOTS_COLOR_GIT=241
_DOTS_COLOR_PROMPT=247

##
## Prompt
_DOTS_PROMPT_LAMBDA="λ";
_DOTS_PROMPT_SMILE=":)";


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_dots_parse_git_branch()
{
    local BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]; then
        local TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2> /dev/null);
        if [ -n "$TAG" ]; then
            echo "(${BRANCH}:${TAG})";
        else
            echo "(${BRANCH})";
        fi;
    else
       echo ""
    fi
}

##------------------------------------------------------------------------------
_dots_random_prompt()
{
    ## @todo(stdmatt): Put the prompts on an array and 
    ## make it choose them automatically...
    local COUNT=2;
    local INDEX=$(( RANDOM % COUNT ));
    if [ $INDEX == 0 ]; then 
        echo "$_DOTS_PROMPT_LAMBDA";
    else 
        echo "$_DOTS_PROMPT_SMILE";
    fi;
}

##----------------------------------------------------------------------------##
## Exports                                                                    ##
##----------------------------------------------------------------------------##
_DOTS_STR_PROMPT=$(_dots_random_prompt)

##------------------------------------------------------------------------------
export PS1="\n\[\033[38;5;${_DOTS_COLOR_PWD}m\]\W\[$(tput sgr0)\]:\[\033[38;5;${_DOTS_COLOR_GIT}m\]\`_dots_parse_git_branch\`\[$(tput sgr0)\]\n\[$(tput bold)\033[38;5;${_DOTS_COLOR_PROMPT}m\]${_DOTS_STR_PROMPT}\[$(tput sgr0)\] "
