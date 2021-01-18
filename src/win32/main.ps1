## @todo(stdmatt): Make a function that join any numer of paths with a sane syntax...
## @todo(stdmatt): Make a way to install fotnts automatically.
##
## Constants
##
$POWERSHELL_TELEMETRY_OPTOUT = 0;


## General Paths...
$HOME_DIR        = "$env:USERPROFILE";
$DOWNLOADS_DIR   = "$HOME_DIR/Downloads";
$DOCUMENTS_DIR   = "$HOME_DIR/Documents";
$DESKTOP_DIR     = "$HOME_DIR/Desktop";
$STDMATT_BIN_DIR = "$HOME_DIR/.stdmatt_bin"; ## My binaries that I don't wanna on system folder...
$DOTS_DIR        = "$env:DOTS_DIR";
$PROJECTS_DIR    = "$DOCUMENTS_DIR/Projects/stdmatt";

## Sync Paths...
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/windows_terminal.json";

$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$DOTS_DIR/src/win32/main.ps1";

$VIMRC_INSTALL_DIR     = "$HOME_DIR"
$VIMRC_SOURCE_FULLPATH = "$DOTS_DIR/extras/.vimrc";

$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Roaming/Code/User/keybindings.json";
$VSCODE_KEYBINDINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/keybindings.json";

## Binary aliases...
$FILE_MANAGER = "explorer.exe";
$YOUTUBE_DL_EXE_PATH = Join-Path -Path $STDMATT_BIN_DIR -ChildPath "youtube-dl.exe";

## Journal things...
$JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
$JOURNAL_FILE_EXT = ".md";

##
## Helper Functions (Private)
##
##------------------------------------------------------------------------------
function _string_is_null_or_whitespace()
{
    return [string]::IsNullOrWhiteSpace($args[0]);
}

##------------------------------------------------------------------------------
function _string_contains()
{
    $haystack = $args[0];
    $needle   = $args[1];

    if((_string_is_null_or_whitespace $haystack)) {
        return $false;
    }
    if((_string_is_null_or_whitespace $needle)) {
        rerturn $false;
    }

    $index = $haystack.IndexOf($needle);
    if( $index -eq -1) {
        return $false;
    }

    return $true;
}


##------------------------------------------------------------------------------
function _file_exists()
{
    return (Test-Path -Path $args[0] -PathType Leaf);
}

##------------------------------------------------------------------------------
function _dir_exists()
{
    ## @todo(stdmatt): How to chack only for dirs???
    return (Test-Path -Path $args[0]);
}

##------------------------------------------------------------------------------
function _log_fatal_func()
{
    ## @todo(stdmatt): Make it print the caller function, and print [FATAL] - Jan 14, 21
    echo "$args";
}

##------------------------------------------------------------------------------
$INVALID_FILE_TIME = -1;
function _get_file_time()
{
    if((_file_exists($args[0]))) {
        return (Get-Item $args[0]).LastWriteTimeUtc.Ticks;
    }
    return $INVALID_FILE_TIME;
}

##------------------------------------------------------------------------------
function _path_join()
{
    $fullpath = "";
    for ($i = 0; $i -lt $args.Length; $i++) {
        $fullpath += $($args[$i]);
        if($i -ne ($args.Length -1)) {
            $fullpath = $fullpath + "/";
        }
    }
    return $fullpath;
}

##
## Files
##   Open the Filesystem Manager into a given path.
##   If no path was given open the current dir.
##
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
    ## @notice(stdmatt): All workstations at work use the same prefix.
    ## @todo(stdmatt): Try to find a way to make this more automatic an reliable - 1/15/2021, 10:51:57 AM
    $WORKSTATION_PREFIX = "KIV-WKS";
    $WORK_ME_PATH       = "D:/stdmatt";
    $HOME_ME_PATH       = "$PROJECTS_DIR";

    $pc_name = hostname;
    $dst_dir = $HOME_ME_PATH;
    if((_string_contains $pc_name $WORKSTATION_PREFIX)) {
        $dst_dir = $WORK_ME_PATH;
    }

    cd $dst_dir;
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
    $filename_1 = $args[0];
    $filename_2 = $args[1];

    $time_1 = (_get_file_time $filename_1);
    $time_2 = (_get_file_time $filename_2);

    if($time_1 -eq $INVALID_FILE_TIME -and $time_2 -eq $INVALID_FILE_TIME) {
        _log_fatal_func("Both paths are invalid...`n    Path 1: ($filename_1)`n    Path 2: ($filename_2)");
        return;
    }

    $old_filename = $filename_1;
    $new_filename = $filename_2;

    if ($time_1 -lt $time_2) {
        $old_filename = $filename_2;
        $new_filename = $filename_1;
    }

    _log_fatal_func("[sync-profile] Copying ($old_filename) to ($new_filename)");
    Copy-Item $old_filename $new_filename -Force;
}

##------------------------------------------------------------------------------
function sync-profile()
{
    ## Terminal / Profile
    _copy_newer_file $TERMINAL_SETTINGS_INSTALL_FULLPATH $TERMINAL_SETTINGS_SOURCE_FULLPATH;
    _copy_newer_file $PROFILE_INSTALL_FULLPATH           $PROFILE_SOURCE_FULLPATH;

    ## .vimrc
    $vimrc_fullpath     = (_path_join $VIMRC_INSTALL_DIR  ".vimrc");
    $ideavimrc_fullpath = (_path_join $VIMRC_INSTALL_DIR ".ideavimrc");
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
    $journal_filename = "$JOURNAL_DIR" + "/" + $curr_date_str + $JOURNAL_FILE_EXT;

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
function sync-journal()
{
    cd $JOURNAL_DIR;
    git add .

    $current_pc_name = hostname;
    $current_date    = date;
    $commit_msg      = "[sync-journal] ($current_pc_name) - ($current_date)";

    echo $commit_msg;
    git commit -m "$commit_msg";

    git pull
    git push
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

##------------------------------------------------------------------------------
function sync-all()
{
    sync-profile;
    sync-journal;
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

##------------------------------------------------------------------------------
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

##------------------------------------------------------------------------------
function cmake-build()
{
    $CMAKE_SCRIPT_FILENAME="CMakeLists.txt";
    $curr_dir = pwd;

    if(!(_file_exists $CMAKE_SCRIPT_FILENAME)) {
        _log_fatal_func "Current directory doesn't have a ($CMAKE_SCRIPT_FILENAME)";
        return;
    }

    ## @todo(stdmatt): Accept options:
    ##     - Path to cmake lists...
    ##     - Path to target dir....
    ##     - Build options...
    ## Jan 16, 21


    $BUILD_DIR = "build.win32";
    if(!(_dir_exists $BUILD_DIR)) {
        mkdir $BUILD_DIR;
    }

    # $CMAKE_BIN="$curr_dir/external/win32/cmake/bin/cmake.exe";
    cd $BUILD_DIR;
        cmake ..
    cd $curr_dir;
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
