## @todo(stdmatt): Make a function that join any numer of paths with a sane syntax...
##
## Constants
##
$POWERSHELL_TELEMETRY_OPTOUT = 0;

## General Paths...
$HOME_DIR        = "$env:USERPROFILE";
$DOWNLOADS_DIR   = "$HOME_DIR/Downloads";
$DOCUMENTS_DIR   = "$HOME_DIR/Documents";
$DESKTOP_DIR     = "$HOME_DIR/Desktop";
$JOURNAL_DIR     = "$HOME_DIR/Desktop/Journal";
$STDMATT_BIN_DIR = "$HOME_DIR/.stdmatt_bin"; ## My binaries that I don't wanna on system folder...
## Sync Paths...
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/windows_terminal.json";

$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$DOTS_DIR/src/win32/main.ps1";

$VIMRC_INSTALL_DIRPATH = "$HOME_DIR"
$VIMRC_SOURCE_FULLPATH = "$DOTS_DIR/extras/.vimrc";

$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Roaming/Code/User/keybindings.json";
$VSCODE_KEYBINDINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/keybindings.json";

## Binary aliases...
$FILE_MANAGER = "explorer.exe";
$YOUTUBE_DL_EXE_PATH = Join-Path -Path $STDMATT_BIN_DIR -ChildPath "youtube-dl.exe";


##
## Helper Functions (Private)
##
##------------------------------------------------------------------------------
function _string_is_null_or_whitespace()
{
    return [string]::IsNullOrWhiteSpace($args[0]);
}

##------------------------------------------------------------------------------
function _file_exists()
{
    return (Test-Path -Path $args[0] -PathType Leaf);
}

function _log_fatal_func()
{
    echo "$args";
}

##
## Files
##   Open the Filesystem Manager into a given path.
##   If no path was given open the current dir.
##
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function files()
{
    $target_path = $args[0];

    if($target_path -ne "."                           -or
       $target_path -ne ".."                          -or
       (_string_is_null_or_whitespace($target_path))  -or
       (_file_exists                 ($target_path)))
    {
        if ( $target_path -eq "" )  {
            $target_path=".";
        }

        & $FILE_MANAGER $target_path;
        return;
    }

    _log_fatal_func("Path($target_path) doesn't not exists - Aborting...");
}

##------------------------------------------------------------------------------
function create-shortcut()
{
    $src_path = $args[0];
    $dst_path = $args[1];

    if ( _string_is_null_or_whitespace($src_path) ) {
        _log_fatal_func("Missing source path - Aborting...");
        return;
    }
    if ( _string_is_null_or_whitespace($dst_path) ) {
        _log_fatal_func("Missing target path - Aborting...");
        return;
    }

    $src_path = (Resolve-Path $src_path).ToString();

    ## @todo(stdmatt): Check if the string ends with .lnk and if not add it - Dec 28, 2020
    $WshShell            = New-Object -ComObject WScript.Shell
    $Shortcut            = $WshShell.CreateShortcut($dst_path);
    $Shortcut.TargetPath = $src_path;
    $Shortcut.Save();
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
    rm $HOME_DIR/Documents/ProjectLiberty -Recurse
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
function me
{
    cd $ME_PATH;
    pwd
}

##------------------------------------------------------------------------------
function me-bin()
{
    cd $STDMATT_BIN_DIR;
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
    . $profile
}

##------------------------------------------------------------------------------
function edit-profile()
{
    code $profile
}

##
## Sync...
##
##------------------------------------------------------------------------------
function _copy_newer_file()
{
    ## @todo(stdmatt): Handle empty or invalid filenames... 1/12/2021, 11:59:06 AM
    $filename_1 = $args[0];
    $filename_2 = $args[1];

    $time_1 = (_get_file_Time_helper $filename_1);
    $time_2 = (_get_file_Time_helper $filename_2);

    if($time_1 -eq 0 -and $time_2 -eq 0) {
        ## @todo(stdmatt): Better error msgs... 1/13/2021, 5:54:37 PM
        return;
    }

    $src_filename = $filename_1;
    $dst_filename = $filename_2;

    if ($time_1 -lt $time_2) {
        $src_filename = $filename_2;
        $dst_filename = $filename_1;
    } else {
        $src_filename = $filename_1;
        $dst_filename = $filename_2;
    }

    _log_fatal_func("[sync-profile] Copying ($src_filename) to ($dst_filename)");
    Copy-Item $src_filename $dst_filename -Force;
}

##------------------------------------------------------------------------------
function sync-profile()
{
    ## Terminal / Profile
    _copy_newer_file $TERMINAL_SETTINGS_INSTALL_FULLPATH $TERMINAL_SETTINGS_SOURCE_FULLPATH;
    _copy_newer_file $PROFILE_INSTALL_FULLPATH           $PROFILE_SOURCE_FULLPATH;

    ## .vimrc
    $vimrc_fullpath     = _path_join($VIMRC_INSTALL_DIRPATH, ".vimrc");
    $ideavimrc_fullpath = _path_join($VIMRC_INSTALL_DIRPATH, ".ideavimrc");

    _copy_newer_file $vimrc_fullpath $VIMRC_SOURCE_FULLPATH;
    Copy-Item $vimrc_fullpath $ideavimrc_fullpath -Force;

    ## VSCode
    _copy_newer_file $VSCODE_KEYBINDINGS_INSTALL_FULLPATH $VSCODE_KEYBINDINGS_SOURCE_FULLPATH;
}


##
## Utils
##
##------------------------------------------------------------------------------
function journal()
{
    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = Get-Date -Format "yy_MM_dd";
    $journal_filename = "$JOURNAL_DIR" + "/" + $curr_date_str + ".txt";
    $today_filename   = "$JOURNAL_DIR" + "/" + "_today.txt";

    try {
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    ## @todo(stdmatt): Would be awesome to have the same-layout on vscode everytime.
    ## Check if it's possible to save a setup or pass command line options with this.
    ## Jan 14, 21
    code $JOURNAL_DIR;
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
#     test -z "$URL"                                              /
#         && echo "[youtube-dl-playlist] Empty url - Aborting..." /
#         return 1;

#     youtube-dl -o                                             /
#         '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' /
#         "$URL";
# }

# ##------------------------------------------------------------------------------
# function youtube-dl-music-playlist()
# {
#     local URL="$1";
#     test -z "$URL"                                              /
#         && echo "[youtube-dl-playlist] Empty url - Aborting..." /
#         return 1;

#     youtube-dl                                                /
#         --extract-audio --audio-format mp3                    /
#         -o                                                    /
#         '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' /
#         "$URL";
# }
