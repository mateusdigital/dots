##
## Constants
#3
$POWERSHELL_TELEMETRY_OPTOUT = 0;
$DOTS_PATH = "D:/stdmatt/dots"; ## @todo(stdmatt): Make the installation set this var.... Dec 22, 2020


$DESKTOP_DIR = "C:/Users/mmesquita/Desktop";


##
## Helper Functions (Private)
##
##------------------------------------------------------------------------------
function _string_is_null_or_whitespace()
{
    return [string]::IsNullOrWhiteSpace($args[0]);
}



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

##------------------------------------------------------------------------------
function create-shortcut()
{
    $src_path = $args[0];
    $dst_path = $args[1];

    if ( _string_is_null_or_whitespace($src_path) ) {
        echo "[$MyInvocation.MyCommand] Missing source path - Aborting...";
        return;
    }
    if ( _string_is_null_or_whitespace($dst_path) ) {
        echo "[$MyInvocation.MyCommand] Missing target path - Aborting...";
        return;
    }

    $src_path = (Resolve-Path $src_path).ToString();

    ## @todo(stdmatt): Check if the string ends with .lnk and if not add it - Dec 28, 2020
    $WshShell            = New-Object -ComObject WScript.Shell
    $Shortcut            = $WshShell.CreateShortcut($dst_path);
    $Shortcut.TargetPath = $src_path;
    $Shortcut.Save()
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

##------------------------------------------------------------------------------
function edit-profile()
{
    code $profile
}


## Sync...
##------------------------------------------------------------------------------
## @todo(stdamtt): Remove hardcoded paths - Dec 30, 2020
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "C:\Users\mmesquita\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH = "$DOTS_PATH" + "/extras/windows_terminal.json";

$PROFILE_INSTALL_FULLPATH = "C:/Users/mmesquita/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH = "$DOTS_PATH" + "/src/win32/main.ps1";

$VIMRC_INSTALL_DIRPATH = "C:/Users/mmesquita"
$VIMRC_SOURCE_FULLPATH = "$DOTS_PATH" + "/extras/.vimrc";

$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "C:\Users\mmesquita\AppData\Roaming\Code\User\keybindings.json";
$VSCODE_KEYBINDINGS_SOURCE_FULLPATH  = "$DOTS_PATH" + "/extras/keybindings.json";


##------------------------------------------------------------------------------
## @todo(stdmatt): Inline this function into sync-profile since
## it's not meant to be used to anymore else - Dec 30, 2020
function _copy_newer_file()
{
    ## @todo(stdmatt): Handle empty or invalid filenames... 1/12/2021, 11:59:06 AM
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
    ## Terminal / Profile
    _copy_newer_file $TERMINAL_SETTINGS_INSTALL_FULLPATH $TERMINAL_SETTINGS_SOURCE_FULLPATH;
    _copy_newer_file $PROFILE_INSTALL_FULLPATH           $PROFILE_SOURCE_FULLPATH;

    ## .vimrc
    $vimrc_fullpath     = Join-Path $VIMRC_INSTALL_DIRPATH  -ChildPath ".vimrc";
    $ideavimrc_fullpath = Join-Path $VIMRC_INSTALL_DIRPATH  -ChildPath ".ideavimrc";

    _copy_newer_file $vimrc_fullpath $VIMRC_SOURCE_FULLPATH;
    Copy-Item $vimrc_fullpath $ideavimrc_fullpath -Force;

    ## VSCode
    _copy_newer_file $VSCODE_KEYBINDINGS_INSTALL_FULLPATH $VSCODE_KEYBINDINGS_SOURCE_FULLPATH;
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
