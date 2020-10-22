##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : youtube.sh                                                    ##
##  Project   : dots                                                          ##
##  Date      : Oct 22, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018, 2019                                          ##
##                                                                            ##
##  Description :                                                             ##
##    Stuff to make the youtube-dl easier to use.                             ##
##---------------------------------------------------------------------------~##

##---------------------------------------------------------------------------~##
## Functions                                                                  ##
##---------------------------------------------------------------------------~##
youtube-dl-mp3()
{
    local URL="$1";
    test -z "$URL"                                         \
        && echo "[youtube-dl-mp3] Empty url - Aborting..." \
        return 1;

    youtube-dl --no-playlist --extract-audio --audio-format mp3 "$URL";
}

##------------------------------------------------------------------------------
youtube-dl-playlist()
{
    local URL="$1";
    test -z "$URL"                                              \
        && echo "[youtube-dl-playlist] Empty url - Aborting..." \
        return 1;

    youtube-dl -o                                             \
        '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL";
}

##------------------------------------------------------------------------------
youtube-dl-music-playlist()
{
    local URL="$1";
    test -z "$URL"                                              \
        && echo "[youtube-dl-playlist] Empty url - Aborting..." \
        return 1;

    youtube-dl                                                \
        --extract-audio --audio-format mp3                    \
        -o                                                    \
        '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL";
}


##------------------------------------------------------------------------------
youtube-dl-channel()
{
    local URL="$1";
    test -z "$URL"                                             \
        && echo "[youtube-dl-channel] Empty url - Aborting..." \
        return 1;

    youtube-dl -o                                                          \
        '%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL"
}
