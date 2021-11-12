## @todo(stdmatt): Make a function that join any numer of paths with a sane syntax...
## @todo(stdmatt): Make a way to install fotnts automatically.
##
## Constants
##
$POWERSHELL_TELEMETRY_OPTOUT = 0;

## @TODO(stdmatt): Check if we want vi keybindings...
Set-PSReadLineOption -EditMode Vi

## General Paths...
$HOME_DIR        = "$env:USERPROFILE";
$DOWNLOADS_DIR   = "$HOME_DIR/Downloads";
$DOCUMENTS_DIR   = "$HOME_DIR/Documents";
$DESKTOP_DIR     = "$HOME_DIR/Desktop";
$STDMATT_BIN_DIR = "$HOME_DIR/.stdmatt_bin"; ## My binaries that I don't wanna on system folder...
$DOTS_DIR        = "E:\Projects\personal\dots";
$PROJECTS_DIR    = "$DOCUMENTS_DIR/Projects/stdmatt";

## @todo(stdmatt): Find a better way to specify those paths... Feb 15, 2021
$LTY_DIR = "D:/LTY";
$ACK_DIR = "D:/ACK";

$WORKSTATION_PREFIX = "KIV-WKS";
$WORK_ME_PATH       = "E:/stdmatt";
$HOME_ME_PATH       = "$PROJECTS_DIR";

## Sync Paths...
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/windows_terminal.json";

$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$DOTS_DIR/src/main.ps1";

$VIMRC_INSTALL_DIR     = "$HOME_DIR"
$VIMRC_SOURCE_FULLPATH = "$DOTS_DIR/extras/.vimrc";

$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Roaming/Code/User/keybindings.json";
$VSCODE_KEYBINDINGS_SOURCE_FULLPATH  = "$DOTS_DIR/extras/keybindings.json";

$GIT_IGNORE_INSTALL_FULLPATH = "$HOME_DIR/.gitignore";
$GIT_IGNORE_SOURCE_FULLPATH  = "$DOTS_DIR/extras/.gitignore";

## Binary aliases...
$FILE_MANAGER        = "explorer.exe";
$YOUTUBE_DL_EXE_PATH = Join-Path -Path $STDMATT_BIN_DIR -ChildPath "youtube-dl.exe";

## Journal things...
$JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
$JOURNAL_GIT_URL   = "https://gitlab.com/stdmatt-private/journal";

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
        return $false;
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
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }
    return (Test-Path -Path $args[0] -PathType Leaf);
}

##------------------------------------------------------------------------------
function _dir_exists()
{
    ## @todo(stdmatt): How to chack only for dirs???
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }

    return (Test-Path -Path $args[0]);
}

##------------------------------------------------------------------------------
function _log_fatal()
{
    ## @todo(stdmatt): Make it print the caller function, and print [FATAL] - Jan 14, 21
    echo "$args";
}

##------------------------------------------------------------------------------
function _log()
{
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
## Colors things...
##
##------------------------------------------------------------------------------
$_C_ESC   = [Char]27
$_C_RESET = [Char]0;
$_C_RED    = 31;
$_C_GREEN  = 32;
$_C_YELLOW = 33;
$_C_PURPLE = 35;
$_C_CYAN   = 36;
$_C_BLUE   = 36;


##------------------------------------------------------------------------------
function _color($color)
{
    $input = "";
    foreach($item in $args) {
        $input = $input + $item;
    }

    $start = "$_C_ESC[" + $color    + "m" + $input;
    $end   = "$_C_ESC[" + $_C_RESET + "m";

    $value = $start + $end;
    return $value;
}

##------------------------------------------------------------------------------
function _blue  () { return (_color $_C_BLUE   $args); }
function _green () { return (_color $_C_GREEN  $args); }
function _yellow() { return (_color $_C_YELLOW $args); }
function _red   () { return (_color $_C_RED    $args); }

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

    _log_fatal("Path($target_path) doesn't not exists - Aborting...");
}

##------------------------------------------------------------------------------
function create-shortcut()
{
    $src_path = $args[0];
    $dst_path = $args[1];

    if ( _string_is_null_or_whitespace($src_path) ) {
        _log_fatal("Missing source path - Aborting...");
        return;
    }
    if ( _string/cm/_is_null_or_whitespace($dst_path) ) {
        _log_fatal("Missing target path - Aborting...");
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
    cd $LTY_DIR;
    pwd
}

##------------------------------------------------------------------------------
function ack
{
    cd $ACK_DIR;
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
    code --new-window $LTY_DIR/bin/scimitar.ini
}



##
## Paths
##
##------------------------------------------------------------------------------
function me
{
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


##
## Sync...
##
##------------------------------------------------------------------------------
function _copy_newer_file()
{
    $fs_file   = $args[0];
    $repo_file = $args[1];

    $fs_time   = (_get_file_time $fs_file);
    $repo_time = (_get_file_time $repo_file);

    $INDENT="....";
    $NL="`n";

    if($fs_time -eq $INVALID_FILE_TIME -and $repo_time -eq $INVALID_FILE_TIME) {
        _log_fatal "Both paths are invalid..." $NL `
                   "$INDENT FS   : ($fs_file)" $NL `
                   "$INDENT Repo : ($repo_file)" ;
        return;
    }

    if($(Get-FileHash $fs_file).hash -eq $(Get-FileHash $repo_file).hash) {
#        _log "[sync-profile] Files are equal!"      $NL `
#             "$INDENT FS   : ($(_yellow $fs_file))" $NL `
#             "$INDENT Repo : ($(_yellow $repo_file))" ;
        return;
    }

    $from_filename = "";
    $to_filename   = "";
    if($fs_time -gt $repo_time) {
        $from_filename = $fs_file;
        $to_filename   = $repo_file;

        _log "[sync-profile] Syncing FS -> Repo"    $NL `
             "$INDENT FS   : ($(_green $fs_file))" $NL `
             "$INDENT REPO : ($(_blue  $repo_file))" ;
    }
    elseif ($fs_time -lt $repo_time) {
        $from_filename = $repo_file;
        $to_filename   = $fs_file;

        _log "[sync-profile] Syncing Repo -> FS"     $NL `
             "$INDENT Repo : ($(_green $repo_file))" $NL `
             "$INDENT FS   : ($(_blue  $fs_file))"   ;
    }

   Copy-Item $from_filename $to_filename -Force;
}



##------------------------------------------------------------------------------
function sync-profile()
{
    ## Terminal / Profile
    _copy_newer_file $TERMINAL_SETTINGS_INSTALL_FULLPATH $TERMINAL_SETTINGS_SOURCE_FULLPATH;
    _copy_newer_file $PROFILE_INSTALL_FULLPATH           $PROFILE_SOURCE_FULLPATH;
    _copy_newer_file $GIT_IGNORE_INSTALL_FULLPATH        $GIT_IGNORE_SOURCE_FULLPATH;

    ## .vimrc
    $vimrc_fullpath     = (_path_join $VIMRC_INSTALL_DIR  ".vimrc");
    $ideavimrc_fullpath = (_path_join $VIMRC_INSTALL_DIR "_ideavimrc");

    _copy_newer_file $vimrc_fullpath $VIMRC_SOURCE_FULLPATH;
    Copy-Item $vimrc_fullpath $ideavimrc_fullpath -Force;

    ## VSCode
    _copy_newer_file $VSCODE_KEYBINDINGS_INSTALL_FULLPATH $VSCODE_KEYBINDINGS_SOURCE_FULLPATH;
}

##------------------------------------------------------------------------------
function sync-journal()
{
    if(!(_dir_exists $JOURNAL_DIR)) {
        git clone "https://gitlab.com/stdmatt-private/journal" "$JOURNAL_DIR";
        return;
    }

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

##------------------------------------------------------------------------------
function sync-dots()
{
    if(!(_dir_exists $DOTS_DIR)) {
        "DOTS_DIR doesn't exits...";
        return;
    }

    cd $DOTS_DIR;
    git add .

    $current_pc_name = hostname;
    $current_date    = date;
    $commit_msg      = "[sync-dots] ($current_pc_name) - ($current_date)";

    echo $commit_msg;
    git commit -m "$commit_msg";

    git pull
    git push

    & ./install.ps1
}

##------------------------------------------------------------------------------
function sync-all()
{
    sync-profile;
    sync-journal;
    sync-dots;
}


##
## Utils
##
##------------------------------------------------------------------------------
function journal()
{
    $is_git_dirty = (git -c $JOURNAL_DIR status -suno);
    if($is_git_dirty.Length -ne 0) {
        sync-journal;
    }

    ## @todo(stdmatt): Would be nice to actually make the function to write
    ## the header automatically with the start and end dates of the week - 3/15/2021, 10:27:14 AM
    $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture;
    $week_day    = $cultureInfo.Calendar.GetWeekOfYear(
        (Get-Date),
        $cultureInfo.DateTimeFormat.CalendarWeekRule,
        $cultureInfo.DateTimeFormat.FirstDayOfWeek
    )

    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = "week_" + $week_day;
    $journal_filename = "$JOURNAL_DIR" + "/" + $curr_date_str + $JOURNAL_FILE_EXT;

    try {
        mkdir -Force $JOURNAL_DIR;
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    ## @todo(stdmatt): Would be awesome to have the same-layout on vscode everytime.
    ## Check if it's possible to save a setup or pass command line options with this.
    ## Jan 14, 21
    code $JOURNAL_DIR;
}

##
## Shell
##
##------------------------------------------------------------------------------
function _random_prompt_color($arg)
{
    $value = Get-Random -Maximum 4;
    if($value -eq 0) {
        $arg = _yellow $arg;
    } elseif($value -eq 1) {
        $arg = _green $arg;
    } elseif($value -eq 2) {
        $arg = _blue $arg;
    } else {
        $arg = _red $arg;
    }

    return $arg;
}

##------------------------------------------------------------------------------
function global:prompt
{
    $curr_path = pwd;
    $prompt    = ":)";
    $color_type = 2;

    if($color_type -eq 0) {       ## Just the path...
        $curr_path = _random_prompt_color "$curr_path";
    } elseif($color_type -eq 1) { ## Just the :)
        $prompt= _random_prompt_color "$prompt";
    } elseif($color_type -eq 2) { ## Both...
        $curr_path = _random_prompt_color "$curr_path";
        $prompt= _random_prompt_color "$prompt";
    }

    return "[$curr_path] `n$prompt ";
}

## @notice(stdmatt): This is pretty cool - It makes the cd to behave like
## the bash one that i can cd - and it goes to the OLDPWD.
## I mean, this thing is neat, probably PS has some sort of this like that
## but honestly, not in the kinda mood to start to look to all the crap
## microsoft documentation. But had quite fun time doing this silly thing!
## Kinda the first thing that I write in my standing desk here in kyiv.
## I mean, this is pretty cool, just could imagine when I get my new keychron!
## March 12, 2021!!
$global:OLDPWD="";
function _stdmatt_cd()
{
    $target_path = $args[0];

    if($target_path -eq "") {
        $target_path = "$HOME_DIR";
    }
    if($target_path -eq "-") {
        $target_path=$global:OLDPWD;
    }

    $global:OLDPWD =  [string](Get-Location);
    Set-Location $target_path; ## Needs to be the Powershell builtin or infinity recursion
}

Remove-Item -Path Alias:cd

Set-Alias -Name cd    -Value _stdmatt_cd                                 -Force -Option AllScope
Set-Alias -name rm    -Value C:\Users\stdmatt\.stdmatt_bin\ark_rm.exe    -Force -Option AllScope
Set-Alias -name touch -Value C:\Users\stdmatt\.stdmatt_bin\ark_touch.exe -Force -Option AllScope

##
## http server
##
##------------------------------------------------------------------------------
function http-server()
{
    python3 -m http.server $args[1];
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
function cmake-gen()
{
    $CMAKE_SCRIPT_FILENAME="CMakeLists.txt";
    $curr_dir = pwd;

    if(!(_file_exists $CMAKE_SCRIPT_FILENAME)) {
        _log_fatal "Current directory doesn't have a ($CMAKE_SCRIPT_FILENAME)";
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
        cmake .. $args
    cd $curr_dir;
}

##------------------------------------------------------------------------------
function cmake-build()
{
    cmake-gen;

    $build_dir = "build.win32";
    $curr_dir  = pwd;

    if(!(_dir_exists $build_dir)) {
        _log_fatal "Build dir is not found: ($build_dir)";
        return;
    }

    cd $build_dir;
        cmake --build . --target ALL_BUILD $args
    cd $curr_dir;
}
