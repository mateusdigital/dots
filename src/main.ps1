﻿##----------------------------------------------------------------------------##
## Configure powershell stuff...                                              ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:DOTS_IS_VERSBOSE            = 0;
Set-PSReadLineOption -EditMode Emacs;


##----------------------------------------------------------------------------##
## Constants                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
## Info
##----------------------------------------------------------------------------##
## Info                                                                       ##
##----------------------------------------------------------------------------##
$PROGRAM_NAME            = "dots";
$PROGRAM_VERSION         = "2.1.0";
$PROGRAM_AUTHOR          = "stdmatt - <stdmatt@pixelwizads.io>";
$PROGRAM_COPYRIGHT_OWNER = "stdmatt";
$PROGRAM_COPYRIGHT_YEARS = "2021";
$PROGRAM_DATE            = "30 Nov, 2021";
$PROGRAM_LICENSE         = "GPLv3";

##------------------------------------------------------------------------------
## Other
$WORKSTATION_PREFIX = "KIV-WKS"; ## My workstation prefix, so I can know that I'm working computer...
##------------------------------------------------------------------------------
## Binary aliases...
$FILE_MANAGER = "explorer.exe";
##------------------------------------------------------------------------------
## General Paths...
$HOME_DIR        = "$env:USERPROFILE";
$DOWNLOADS_DIR   = "$HOME_DIR/Downloads";
$DOCUMENTS_DIR   = "$HOME_DIR/Documents";
$DESKTOP_DIR     = "$HOME_DIR/Desktop";
$STDMATT_BIN_DIR = "$HOME_DIR/.stdmatt_bin";    ## My binaries that I don't wanna on system folder...
$DOTS_DIR        = "E:/Projects/personal/dots"; ## @todo(stdmatt): Find a way to remove hardcode...
$PROJECTS_DIR    = "$DOCUMENTS_DIR/Projects/stdmatt";

## Dealing with workstation, needs to ajudst some paths...
if((hostname).Contains($WORKSTATION_PREFIX)) {
    $PROJECTS_DIR = "E:/Projects";
}
##------------------------------------------------------------------------------
## Sync Paths...
$FONTS_SOURCE_DIR    = "$DOTS_DIR/extras/fonts";
$GIT_SOURCE_DIR      = "$DOTS_DIR/extras/git";
$TERMINAL_SOURCE_DIR = "$DOTS_DIR/extras/terminal";
$PROFILE_SOURCE_DIR  = "$DOTS_DIR/src";
$VIM_SOURCE_DIR      = "$DOTS_DIR/extras/vim";
$VSCODE_SOURCE_DIR   = "$DOTS_DIR/extras/vscode";
$BINARIES_SOURCE_DIR = "$DOTS_DIR/extras/bin/win32";

$FONTS_INSTALL_FULLPATH              = "$HOME_DIR/AppData/Local/Microsoft/Windows/Fonts";## @XXX(stdmatt): Just a hack to check if thing will work... but if it will I'll not change it today 11/11/2021, 2:03:40 PM
$GIT_IGNORE_INSTALL_FULLPATH         = "$HOME_DIR/.gitignore";
$PROFILE_INSTALL_FULLPATH            = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1";
$TERMINAL_SETTINGS_INSTALL_FULLPATH  = "$HOME_DIR/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json";
$VIMRC_INSTALL_FULLPATH              = "$HOME_DIR/.vimrc";
$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Roaming/Code/User/keybindings.json";
$VSCODE_SETTINGS_INSTALL_FULLPATH    = "$HOME_DIR/AppData/Roaming/Code/User/settings.json";
$BINARIES_INSTALL_FULLPATH           = "$STDMATT_BIN_DIR";
##------------------------------------------------------------------------------
## Journal things...
$JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
$JOURNAL_GIT_URL   = "https://gitlab.com/stdmatt-private/journal";
$JOURNAL_FILE_EXT = ".md";

##----------------------------------------------------------------------------##
## Colors things...                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$_C_ESC     = [Char]27
$_C_RESET   = [Char]0;
## Normal
$_C_BLACK   = 30;
$_C_RED     = 31;
$_C_GREEN   = 32;
$_C_BLUE    = 34;
$_C_MAGENTA = 35;
$_C_CYAN    = 36;
$_C_WHITE   = 37;
## Bright
$_C_BRIGHT_BLACK   = 90;
$_C_BRIGHT_RED     = 91;
$_C_BRIGHT_GREEN   = 92;
$_C_BRIGHT_BLUE    = 94;
$_C_BRIGHT_MAGENTA = 95;
$_C_BRIGHT_CYAN    = 96;
$_C_BRIGHT_WHITE   = 97;

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
function _debug_color_values()
{
    for($i = 0; $i -lt 300; $i += 1)
    {
        $output = _color $i "Value: $i"
        echo $output;
    }
}


##------------------------------------------------------------------------------
function rgb($r, $g, $b, $str)
{
    $esc = [char]27;
    return "$esc[38;2;$r;$g;${b}m$str$esc[0m";
};

##------------------------------------------------------------------------------
function _blue  () { return (_color $_C_BLUE         $args); }
function _green () { return (_color $_C_GREEN        $args); }
function _yellow() { return (_color $_C_YELLOW       $args); }
function _red   () { return (_color $_C_RED          $args); }
function _gray  () { return (_color $_C_BRIGHT_BLACK $args); }

##----------------------------------------------------------------------------##
## Helper Functions                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _string_is_null_or_whitespace()
{
    return [string]::IsNullOrWhiteSpace($args[0]);
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
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }

    return (Test-Path -Path $args[0] -PathType Container);
}

    # Set-PSBreakpoint -Script $MyInvocation.PSCommandPath -Line 104

##------------------------------------------------------------------------------
function _log_get_call_function_name()
{
    $callstack = Get-PSCallStack;
    foreach($command in $callstack) {
        $function_name = $command.FunctionName;
        if($function_name.StartsWith("_")) {
            continue;
        }
        return $function_name;

    }
    return $function_name;
}

##------------------------------------------------------------------------------
function _log_fatal()
{
    $function_name = _log_get_call_function_name;

    $output =  _red  "[FATAL]";
    $output += _gray "[$function_name] ";
    $output += $args;

    echo $output;
}

##------------------------------------------------------------------------------
function _log_verbose()
{
    if($env:DOTS_IS_VERSBOSE -eq 1) {
        _log "$args";
    }
}

##------------------------------------------------------------------------------
function _log()
{
    $function_name = _log_get_call_function_name;

    $output  = _gray "[$function_name] ";
    $output += $args;

    echo $output;
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

##------------------------------------------------------------------------------
function show_version()
{
    $value = [string]::Format(
"{0} - {1} - {2}                                      `
Copyright (c) {3} - {4}                               `
This is a free software ({5}) - Share/Hack it         `
Check http://stdmatt.com for more :)",
        $PROGRAM_NAME,
        $PROGRAM_VERSION,
        $PROGRAM_AUTHOR,
        $PROGRAM_COPYRIGHT_YEARS,
        $PROGRAM_COPYRIGHT_OWNER,
        $PROGRAM_LICENSE
    );
    echo $value;
}

##----------------------------------------------------------------------------##
## Files                                                                      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
##   Open the Filesystem Manager into a given path.
##   If no path was given open the current dir.
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


##----------------------------------------------------------------------------##
## Profile                                                                    ##
##----------------------------------------------------------------------------##
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


##----------------------------------------------------------------------------##
## Sync...                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _copy_newer_file()
{
    $INDENT="   "
    $NL="`n";

    $repo_file    = $args[0];
    $fs_file      = $args[1];
    $sync_to      = $null;

    ## Check if there's any file missing, if so just copy it...
    $fs_exists   = _file_exists "$fs_file";
    $repo_exists = _file_exists "$repo_file";
    if($fs_exists -xor $repo_exists) {
        if($repo_exists) {
            $sync_to = "fs";
        } else {
            $sync_to = "repo";
        }
    }

    ## Check which file is newer...
    if($(Get-FileHash $fs_file).hash -eq $(Get-FileHash $repo_file).hash) {
        $sync_to = $null;
    } else {
        $fs_time   = (_get_file_time $fs_file  );
        $repo_time = (_get_file_time $repo_file);

        if($fs_time -eq $INVALID_FILE_TIME -and $repo_time -eq $INVALID_FILE_TIME) {
            _log_fatal "Both paths are invalid..." $NL `
                    "$INDENT FS   : ($fs_file)" $NL `
                    "$INDENT Repo : ($repo_file)" ;
            return;
        }
        if($fs_time -gt $repo_time) {
            $sync_to = "repo";
        } elseif($repo_time -gt $fs_time) {
            $sync_to = "fs";
        } else {
            $sync_to = $null;
        }
    }

    ## Copy if needed..
    if($sync_to -eq "fs") {
        _log "Syncing Repo -> FS"      $NL `
             "$INDENT Repo : ($(_green  $repo_file))" $NL `
             "$INDENT FS   : ($(_yellow $fs_file))"       ;

        Copy-Item $repo_file $fs_file -Force;
    } elseif($sync_to -eq "repo") {
        _log "Syncing FS -> Repo"      $NL `
             "$INDENT FS   : ($(_green  $fs_file))"   $NL `
             "$INDENT Repo : ($(_yellow $repo_file))"     ;

        Copy-Item $fs_file $repo_file -Force;
    } else {
        _log "Files are equal..."     $NL `
             "$INDENT FS   : ($(_green $fs_file))"   $NL `
             "$INDENT Repo : ($(_green $repo_file))"     ;
    }
}

##------------------------------------------------------------------------------
function sync-extras()
{
    ## Git
    _copy_newer_file                 `
        "$GIT_SOURCE_DIR/.gitignore" `
        "$GIT_IGNORE_INSTALL_FULLPATH";

    ## Profile
    _copy_newer_file                   `
        "$PROFILE_SOURCE_DIR/main.ps1" `
        "$PROFILE_INSTALL_FULLPATH";

    ## Terminal
    _copy_newer_file                                 `
        "$TERMINAL_SOURCE_DIR/windows_terminal.json" `
        "$TERMINAL_SETTINGS_INSTALL_FULLPATH";

    ## Vim
    _copy_newer_file             `
        "$VIM_SOURCE_DIR/.vimrc" `
        "$VIMRC_INSTALL_FULLPATH";

    ## VSCode - Keybindings
    _copy_newer_file                          `
        "$VSCODE_SOURCE_DIR/keybindings.json" `
        "$VSCODE_KEYBINDINGS_INSTALL_FULLPATH";

    ## VSCode - Settings
    _copy_newer_file                       `
        "$VSCODE_SOURCE_DIR/settings.json" `
        "$VSCODE_SETTINGS_INSTALL_FULLPATH";
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
    echo "REFACTOR!!!"
    # if(!(_dir_exists $DOTS_DIR)) {
    #     "DOTS_DIR doesn't exits...";
    #     return;
    # }

    # cd $DOTS_DIR;
    # git add .

    # $current_pc_name = hostname;
    # $current_date    = date;
    # $commit_msg      = "[sync-dots] ($current_pc_name) - ($current_date)";

    # echo $commit_msg;
    # git commit -m "$commit_msg";

    # git pull
    # git push

    # & ./install.ps1
}

##------------------------------------------------------------------------------
function sync-all()
{
    ## dots functions...
    sync-extras;
    sync-dots;
    sync-journal;

    config-git;

    install-fonts;
    install-binaries;

    ## External stuff...
    repochecker --all $PROJECTS_DIR;
}


##----------------------------------------------------------------------------##
## Utils                                                                      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function journal()
{
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


##----------------------------------------------------------------------------##
## Git                                                                        ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function config-git()
{
    _log_verbose "Configuring git...";
    git config --global user.name         "stdmatt";
    git config --global user.email        "stdmatt@pixelwizards.io";
    git config --global core.excludesfile "$HOME_DIR/.gitignore"; ## Set the gitignore globaly...
    git config --global core.editor       "code --wait"           ## Set vscode as default editor...
    _log_verbose "Done... ;D";
}

##------------------------------------------------------------------------------
function git_commit_version()
{
    $changelog_filename = "CHANGELOG.txt";
    if(-not (_file_exists($changelog_filename))) {
        _log_fatal "Missing ($changelog_filename)";
        return;
    }

    ## @XXXXXXX(stdmatt): This is so super fragile for now....
    $file_data = Get-Content $changelog_filename;
    $curr_version_line_index = -1;
    $prev_version_line_index = -1;

    for(($i = 0); $i -lt $file_data.Length; $i++) {
        $line = $file_data[$i];
        if($line.StartsWith("//")) {
            if($curr_version_line_index -eq -1) {
                continue;
            } else {
                $prev_version_line_index = $i
                break;
            }
        }

        if($line.StartsWith("v")) {
            if($curr_version_line_index -eq -1) {
                $curr_version_line_index = $i;
            }
        }
    }

    ## Grab the version number...
    $version = $file_data[$curr_version_line_index];
    $version = $version.Split(" ")[0];

    ## Grab the commit message...
    $commit_body = "";
    for($i = ($curr_version_line_index + 1); $i -lt $prev_version_line_index; $i++)
    {
        $line = $file_data[$i].Trim(" ");
        $commit_body += $line + "`n";
    }
    $commit_body = $commit_body.Trim();

    ## Make the full msg...
    $commit_msg  = "[NEW_VERSION] $version" + "`n";
    $commit_msg += "`n";
    $commit_msg += "$commit_body";

    $date      = (Get-Date -UFormat "%H_%M_%S");
    $salt      = (Get-Random);
    $temp_path = "${env:Temp}/${date}_${salt}.txt";

    ## Create the commit.
    echo "$commit_msg" | Out-File  -Encoding utf8 "$temp_path";
    git commit -F $temp_path;

    ## Create the tag.
    git tag $version;
}

##----------------------------------------------------------------------------##
## Binaries                                                                   ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function install-binaries()
{
    echo $BINARIES_SOURCE_DIR;
    foreach($filename in Get-ChildItem -Path $BINARIES_SOURCE_DIR -File) {
        $src_path = "$BINARIES_SOURCE_DIR/$filename";
        $dst_path = "$BINARIES_INSTALL_FULLPATH/$filename";
        _log_verbose "Copying binary: ($filename) to ($dst_path)";
        cp $src_path $dst_path;
    }

}

##----------------------------------------------------------------------------##
## Fonts                                                                      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function install-fonts()
{
    ## Thanks to:Arkady Karasin - https://stackoverflow.com/a/61035940
    $FONTS       = 0x14
    $COPYOPTIONS = 4 + 16;
    $OBJ_SHELL   = New-Object -ComObject Shell.Application;

    $obj_folder = $OBJ_SHELL.Namespace($FONTS);

    $fonts_folder                  = "$FONTS_SOURCE_DIR/jetbrains-mono";
    $where_the_fonts_are_installed = "$FONTS_INSTALL_FULLPATH";

    foreach($font in Get-ChildItem -Path $fonts_folder -File) {
        $dest = "$where_the_fonts_are_installed/$font";
        if(Test-Path -Path $dest) {
            _log_verbose "Font ($font) already installed";
        } else {
            _log_verbose "Installing ($font)";

            $copy_flag = [String]::Format("{0:x}", $COPYOPTIONS);
            $obj_folder.CopyHere($font.fullname, $copy_flag);
        }
    }
}


##----------------------------------------------------------------------------##
## Shell                                                                      ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _random_prompt_color($color, $arg)
{
    if($color-eq 0) {
        $arg = _yellow $arg;
    } elseif($color -eq 1) {
        $arg = _green $arg;
    } elseif($color -eq 2) {
        $arg = _blue $arg;
    } else {
        $arg = _red $arg;
    }

    return $arg;
}

##------------------------------------------------------------------------------
function _make_git_prompt()
{
    $git_line = (git branch 2> $null);
    if($git_line) {
        $git_branch = $git_line.Split("*")[1].Trim();
        ## @todo(stdmatt): 30 Nov, 2021 at 12:40:48
        ## Check how we want the PS1 to display git info...
        # $user_name  = (git config user.name);
        # $user_email = (git config user.email);
        $git_tag    = (git describe --tags (git rev-list --tags --max-count=1) 2> $null);

        if($git_tag) {
            $git_line = "${git_branch}:${git_tag}";
        } else {
            $git_line = "${git_branch}";
        }
        $git_line = " [${git_line}]";
    }

    $curr_path   = pwd;
    $prompt      = ":)";
    $color_index = (Get-Date -UFormat "%M") % 4;

    $prompt    = rgb 0x9E 0x9E 0x9E $prompt;
    $git_line  = rgb 0x62 0x62 0x62 $git_line;
    $curr_path =_random_prompt_color $color_index "$curr_path";

    return "${curr_path}${git_line}`n${prompt} ";
}


##------------------------------------------------------------------------------
function global:prompt
{
    return _make_git_prompt;
}

##----------------------------------------------------------------------------##
## Aliases                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
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

## cd
##------------------------------------------------------------------------------
Remove-Item -Path Alias:cd
Set-Alias -Name cd -Value _stdmatt_cd -Force -Option AllScope

## rm
##------------------------------------------------------------------------------
function nuke_dir()
{
    $path_to_remove = $args[0];
    if($path_to_remove -eq "") {
        _log_fatal "No directory path was given";
        return;
    }

    $dir_is_valid = _dir_exists $path_to_remove;
    if(-not $dir_is_valid) {
        _log_fatal "Path isn't a valid directory...";
        return;
    }

    rm -Recurse -Force $path_to_remove;
}

# Set-Alias -name rm    -Value C:\Users\stdmatt\.stdmatt_bin\ark_rm.exe    -Force -Option AllScope
# Set-Alias -name touch -Value C:\Users\stdmatt\.stdmatt_bin\ark_touch.exe -Force -Option AllScope

##----------------------------------------------------------------------------##
## HTTP Server                                                                ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function http-server()
{
    python3 -m http.server $args[1];
}

config-git
