##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : gitcheck.sh                                                   ##
##  Project   : dots                                                          ##
##  Date      : Oct 11, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Some aliases and functions to make gitcheck even more awesome.          ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_gitcheck()
{
    ##
    ## Check if we want gitcheck in another directory.
    local directory=".";
    if [ -n "$1" ]; then
        if [ "${#1}" -ge "2" ] && [ ${1:0:2} != "--" ]; then
            directory="$1";
        fi;
    fi;

    ##
    ## Directory must be valid.
    if [ ! -d "$directory" ]; then
        echo "Invalid directory - Aborting... "
        echo "  Path: ($directory)";
        return 1;
    fi;

    ##
    ## Since gitcheck doesn't accept a directory (or I'm too lazy to actually
    ## check in the documentation, we changing the directory ;D
    cd "$directory";
        local the_real_gitcheck=$(which gitcheck)
        $the_real_gitcheck --quiet ##$2 $3; ## Maybe we passed other arguents as well..
    cd -;
}

##------------------------------------------------------------------------------
gitcheck() {
    _gitcheck "$1";
}

##------------------------------------------------------------------------------
gitcheck-raq() {
   _gitcheck  "$1" --remote --all-branch
}
