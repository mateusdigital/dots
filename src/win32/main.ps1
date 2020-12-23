$POWERSHELL_TELEMETRY_OPTOUT = 0;
$DOTS_PATH = "D:/stdmatt/dots"; ## @todo(stdmatt): Make the installation set this var.... Dec 22, 2020

##
## Files
##   Open the Filesystem Manager into a given path.
##   If no path was given open the current dir.
##
##------------------------------------------------------------------------------
$FILE_MANAGER = "explorer.exe";

##------------------------------------------------------------------------------
function files()
{
    $target_path = $args[0];
    if ( $target_path -eq "" )  {
        $target_path=".";
    }

    & $FILE_MANAGER $target_path;
}


##
## Ubisoft
##
##------------------------------------------------------------------------------
function lty
{
    cd  E:/mmesquita_KIV-WKS-PR536_9193
    pwd
}

##------------------------------------------------------------------------------
function clean-game-profile()
{
    rm C:\Users\mmesquita\Documents\ProjectLiberty -Recurse
}

##------------------------------------------------------------------------------
function edit-game-ini()
{
    code --new-window E:/mmesquita_KIV-WKS-PR536_9193/bin/scimitar.ini
}

##------------------------------------------------------------------------------
function ack
{
    cd  E:/mmesquita_ack
    pwd
}


##
## Paths
##
##------------------------------------------------------------------------------
$STDMATT_BIN_FOLDER_NAME = ".stdmatt_bin";
$STDMATT_BIN_PATH        = Join-Path -Path $env:USERPROFILE -ChildPath $STDMATT_BIN_FOLDER_NAME;

##------------------------------------------------------------------------------
function me
{
    cd  D:/stdmatt
    pwd
}

##------------------------------------------------------------------------------
function me-bin()
{
    cd $STDMATT_BIN_PATH;
    pwd;
}


##
## Profile
##
##------------------------------------------------------------------------------
function edit-profile()
{
    code $profile
}

##------------------------------------------------------------------------------
function reload-profile()
{
    & $profile
}

## Sync...
##------------------------------------------------------------------------------
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "C:\Users\mmesquita\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH = "$DOTS_PATH" + "/extras/windows_terminal.json";

$PROFILE_INSTALL_FULLPATH = "C:/Users/mmesquita/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH = "$DOTS_PATH" + "/src/win32/main.ps1";

##------------------------------------------------------------------------------
function _copy_newer_file()
{
    $filename_1 = $args[0];
    $filename_2 = $args[1];
    $time_1 = (Get-Item $filename_1).LastWriteTime;
    $time_2 = (Get-Item $filename_2).LastWriteTime;

    $src_filename = $filename_1;
    $dst_filename = $filename_2;

    if ($time_1 -lt $time_2) {
        $src_filename = $filename_2;
        $dst_filename = $filename_1;
    } else {
        $src_filename = $filename_1;
        $dst_filename = $filename_2;
    }

    echo "[sync-profile] Copying ($src_filename) to ($dst_filename)";
    Copy-Item $src_filename $dst_filename -Force;
}

##------------------------------------------------------------------------------
function sync-profile()
{
    _copy_newer_file $TERMINAL_SETTINGS_INSTALL_FULLPATH $TERMINAL_SETTINGS_SOURCE_FULLPATH
    _copy_newer_file $PROFILE_INSTALL_FULLPATH           $PROFILE_SOURCE_FULLPATH
}


##
## Utils
##
##------------------------------------------------------------------------------
$JOURNAL_PATH       = "C:/Users/mmesquita/Desktop/Journal";
$GAMES_TO_MAKE_PATH = "D:/stdmatt/games_to_make";

##------------------------------------------------------------------------------
function journal()
{
    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = Get-Date -Format "yy_MM_dd";
    $journal_filename = "$JOURNAL_PATH" + "/" + $curr_date_str + ".txt";
    $today_filename   = "$JOURNAL_PATH" + "/" + "_today.txt";

    try {
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    code $JOURNAL_PATH;
}

##------------------------------------------------------------------------------
function games-to-make()
{
    code $GAMES_TO_MAKE_PATH;
}

##
## Shell
##
##------------------------------------------------------------------------------
function global:prompt
{
    $curr_path = pwd;
    return "$curr_path `n:) "
}


##
## youtube-dl
##
##------------------------------------------------------------------------------
$YOUTUBE_DL_EXE_PATH = Join-Path -Path $STDMATT_BIN_PATH -ChildPath "youtube-dl.exe";

function _ensure_youtube_dl()
{
    if( -not(Test-Path -Path $YOUTUBE_DL_EXE_PATH) ) {
        echo "[youtube-dl-mp3] Could not find youtube-dl at ($YOUTUBE_DL_EXE_PATH)- Aborting...";
        return 0;
    }
    return 1;
}

function youtube-dl-mp3()
{
    if(-not(_ensure_youtube_dl)) {
        return;
    }


    $URL = $args[0];
    if([string]::IsNullOrWhiteSpace($URL)) {
        echo "[youtube-dl-mp3] Empty url - Aborting...";
        return;
    }

    & $YOUTUBE_DL_EXE_PATH --no-playlist --extract-audio --audio-format mp3 $URL;
}


# ##------------------------------------------------------------------------------
# function youtube-dl-playlist()
# {
#     local URL="$1";
#     test -z "$URL"                                              \
#         && echo "[youtube-dl-playlist] Empty url - Aborting..." \
#         return 1;

#     youtube-dl -o                                             \
#         '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
#         "$URL";
# }

# ##------------------------------------------------------------------------------
# function youtube-dl-music-playlist()
# {
#     local URL="$1";
#     test -z "$URL"                                              \
#         && echo "[youtube-dl-playlist] Empty url - Aborting..." \
#         return 1;

#     youtube-dl                                                \
#         --extract-audio --audio-format mp3                    \
#         -o                                                    \
#         '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
#         "$URL";
# }
