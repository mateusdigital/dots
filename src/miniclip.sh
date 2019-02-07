##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : miniclip.sh                                                   ##
##  Project   : dots                                                          ##
##  Date      : Oct 08, 2017                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Some stuff that makes my life easy when I'm at Miniclip Portugal.       ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Aliaes                                                                     ##
##----------------------------------------------------------------------------##
# ##------------------------------------------------------------------------------
# ## 8BPE
# alias mpt_8bpe_build="BUILD_ENV=Staging sh build.sh emscripten && npm run debug";
# alias mpt_8bpe_clean="BUILD_ENV=Staging sh build.sh clean";
# alias mpt_8bpe_run="npm run server"


# ##------------------------------------------------------------------------------
# ## PACIO
# alias mpt_pacio_start_maestro="gosh maestro && make seixas_console";
# alias mpt_pacio_start_core="gosh core && npm run serve";


##----------------------------------------------------------------------------##
## 8 Ball Pool Mobile                                                         ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_mpt_8bpm_build()
{
    ## improve(stdmatt): Go the target directory???
    local platform="$1";
    local mode="$2";
    local install="$3";

    sh build.sh "$platform" "$mode" "$install";
}

##------------------------------------------------------------------------------
mpt_8bpm_build_android()
{
    local mode="debug";
    test -n "$1" && mode="$1";

    _mpt_8bpm_build "android" "$mode" "install";
}

##------------------------------------------------------------------------------
mpt_8bpm_build_mac()
{
    local mode="debug";
    test -n "$1" && mode="$1";

    _mpt_8bpm_build "mac" "$mode";
}

##------------------------------------------------------------------------------
mpt_8bpm_build_emscripten()
{
    local mode="debug";
    test -n "$1" && mode="$1";

    _mpt_8bpm_build "emscripten" "$mode";
}
