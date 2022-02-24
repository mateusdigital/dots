##----------------------------------------------------------------------------##
## Configure powershell stuff...                                              ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:DOTS_IS_VERSBOSE            = 1;


##----------------------------------------------------------------------------##
## Info                                                                       ##
##----------------------------------------------------------------------------##
$PROGRAM_NAME            = "dots";
$PROGRAM_VERSION         = "3.0.0";
$PROGRAM_AUTHOR          = "stdmatt - <stdmatt@pixelwizads.io>";
$PROGRAM_COPYRIGHT_OWNER = "stdmatt";
$PROGRAM_COPYRIGHT_YEARS = "2021, 2022";
$PROGRAM_DATE            = "30 Nov, 2021";
$PROGRAM_LICENSE         = "GPLv3";


##----------------------------------------------------------------------------##
## Library Code                                                               ##
##----------------------------------------------------------------------------##

##
## Private Functions
##

##------------------------------------------------------------------------------
function _sh_check_wsl()
{
    if($IsLinux) {
        $result = (uname -a);
        $index  = $result.IndexOf("WSL2");
        if($index -eq -1) {
            return $false;
        }
        return $true;
    }
    return $false;
}

##------------------------------------------------------------------------------
function _sh_fwd_slash()
{
    return $args[0].Replace("\", "/");
}


##
## Public Function
##

##------------------------------------------------------------------------------
function sh_dirpath()
{
    $arg   = $args[0];
    $final = (Split-Path $arg -Parent);

    return $final;
}

##------------------------------------------------------------------------------
function sh_get_home_dir()
{
    if ($HOME -eq "") {
        return "$env:USERPROFILE"
    }

    return $HOME;
}

##------------------------------------------------------------------------------
function sh_get_os_name()
{
    if($sh_IsWsl) {
        return "WSL";
    } elseif($IsWindows) {
        return "Win32";
    } elseif($IsLinux) {
        return "GNU";
    } elseif($IsMacOS) {
        return "mac";
    }
    return "unsupported";
}

##------------------------------------------------------------------------------
function sh_get_script_dir()
{
    return (sh_dirpath $MyInvocation.InvocationName);
}

##------------------------------------------------------------------------------
function sh_get_script_path()
{
    return $MyInvocation.PSCommandPath;
}

##------------------------------------------------------------------------------
function sh_file_exists()
{
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }
    return (Test-Path -Path $args[0] -PathType Leaf);
}

##------------------------------------------------------------------------------
function sh_dir_exists()
{
    if(_string_is_null_or_whitespace($args[0])) {
        return $false;
    }

    return (Test-Path -Path $args[0] -PathType Container);
}

##------------------------------------------------------------------------------
function sh_join_path()
{
    ## @XXX(stdmatt): [Optimize] - 08 Feb, 2022
    $fullpath = $args[0];
    for($i = 1; $i -lt $args.Length; $i += 1) {
        $item     = $args[$i]
        $fullpath = (Join-Path $fullpath $item);
    }
    return (_sh_fwd_slash $fullpath);
}

##------------------------------------------------------------------------------
function sh_mkdir()
{
    $path_to_create = $args[0];
    $null = (New-Item -ItemType directory -Path $path_to_create -Force);
}

##------------------------------------------------------------------------------
function sh_to_os_path()
{
    $path = $args[0];
    if($args.Length -eq 0) {
        return "";
    }

    $new_path              = $path;
    $looks_like_win32_path = ($path -match "([a-z]|[A-Z]):(\\|/)");
    if($looks_like_win32_path) {
        if($sh_IsWsl) {
            $new_path = (wslpath -u $path);
        }
    } else {
        if($IsWindows) {
            $new_path = (wslpath -m $path);
        }
    }

    return $new_path;
}

## Colors
$SH_HEX_RED   = "#FF0000";
$SH_HEX_GREEN = "#00FF00";
$SH_HEX_BLUE  = "#0000FF";

$SH_HEX_CYAN    = "#00FFFF";
$SH_HEX_YELLOW  = "#FFFF00";
$SH_HEX_MAGENTA = "#FF00FF";

$SH_HEX_BLACK      = "#000000";
$SH_HEX_GRAY       = "#808080";
$SH_HEX_LIGHT_GRAY = "#D4D4D3";
$SH_HEX_WHITE      = "#FFFFFF";

##------------------------------------------------------------------------------
function sh_rgb_to_ansi($r, $g, $b, $str)
{
    $esc = [char]27;
    return "$esc[38;2;$r;$g;${b}m$str$esc[0m";
}

##------------------------------------------------------------------------------
function sh_hex_to_ansi($hex, $str)
{
    $esc = [char]27;

    $r = [uint32]("#" + $hex[1] + $hex[2]);
    $g = [uint32]("#" + $hex[3] + $hex[4]);
    $b = [uint32]("#" + $hex[5] + $hex[6]);

    return "$esc[38;2;$r;$g;${b}m$str$esc[0m";
}

##------------------------------------------------------------------------------
function sh_ansi($color, $str)
{
    ## @todo(stdmatt): Implement....
    return $str;
}


##
## Globals
##

##------------------------------------------------------------------------------
$sh_IsWsl  = (_sh_check_wsl);
$sh_OSName = (sh_get_os_name);


##----------------------------------------------------------------------------##
## PSReadLine                                                                 ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _on_vi_mode_change
{
    if ($args[0] -eq 'Command') {
        Write-Host -NoNewLine "`e[1 q"
    } else {
        Write-Host -NoNewLine "`e[5 q"
    }
}

##------------------------------------------------------------------------------
## Settings just for the pwsh.
if($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption            `
        -ViModeIndicator     Script `
        -ViModeChangeHandler $Function:_on_vi_mode_change;
}

##------------------------------------------------------------------------------
Set-PSReadLineOption -EditMode Vi;

## Directly from:
##   https://github.com/tomasiser/vim-code-dark
$_ps_color_black         = "#1E1E1E";  ##
$_ps_color_gray          = "#808080";  ## #include
$_ps_color_white         = "#D4D4D4";  ## normal text
$_ps_color_light_blue    = "#9CDCFE";  ## my_variable
$_ps_color_blue          = "#569CD6";  ## public static void
$_ps_color_blue_green    = "#4EC9B0";  ## Class_Type
$_ps_color_green         = "#608B4E";  ## /* comment */
$_ps_color_light_yellow  = "#B5CEA8";  ## 3.14f
$_ps_color_yellow        = "#DCDCAA";  ## my_function()
$_ps_color_yellow_orange = "#D7BA7D";  ## #selector
$_ps_color_orange        = "#CE9178";  ## "string"
$_ps_color_light_red     = "#D16969";  ## /[a-Z]/
$_ps_color_red           = "#F44747";  ## error message
$_ps_color_pink          = "#C586C0";  ## else if

Set-PSReadLineOption -Colors @{
    Default            = $_ps_color_white
    Command            = $_ps_color_yellow
    ContinuationPrompt = "#FF00FF"
    Number             = $_ps_color_light_yellow
    Member             = $_ps_color_white
    Operator           = $_ps_color_white
    Type               = $_ps_color_light_blue
    Parameter          = $_ps_color_pink
    String             = $_ps_color_orange
    Variable           = $_ps_color_light_blue
}


##----------------------------------------------------------------------------##
## Constants                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
## Other
$WORKSTATION_PREFIX = "KIV-WKS"; ## My workstation prefix, so I can know that I'm working computer...
$IS_WORK_COMPUTER   = (hostname).Contains($WORKSTATION_PREFIX);

##------------------------------------------------------------------------------
## General Paths...
$HOME_DIR        = (sh_get_home_dir);
$DOWNLOADS_DIR   = (sh_join_path "$HOME_DIR" "Downloads");
$DOCUMENTS_DIR   = (sh_join_path "$HOME_DIR" "Documents");
$DESKTOP_DIR     = (sh_join_path "$HOME_DIR" "Desktop");
$STDMATT_BIN_DIR = (sh_join_path "$HOME_DIR" ".stdmatt/bin"); ## My binaries that I don't wanna on system folder...
$PROJECTS_DIR    = (sh_join_path "$HOME_DIR" "Projects");

## Dealing with workstation, needs to adjust some paths...
if($IS_WORK_COMPUTER) {
    $PROJECTS_DIR = sh_to_os_path("E:/Projects");
}

$DOTS_DIR = "$PROJECTS_DIR/stdmatt/personal/dots";

##------------------------------------------------------------------------------
## Sync Paths...
##  Fonts
$FONTS_SOURCE_DIR       = "$DOTS_DIR/extras/fonts";
$FONTS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Local/Microsoft/Windows/Fonts";## @XXX(stdmatt): Just a hack to check if thing will work... but if it will I'll not change it today 11/11/2021, 2:03:40 PM
##  GIT
$GIT_SOURCE_DIR              = "$DOTS_DIR/extras/git";
$GIT_IGNORE_INSTALL_FULLPATH = "$HOME_DIR/.gitignore";
##  Powershell Profile
$PROFILE_SOURCE_DIR                  = "$DOTS_DIR/src";
$PWSH_WIN32_PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/PowerShell/Microsoft.PowerShell_profile.ps1";        ## pwsh profile in Windows.
$PWSH_UNIX_PROFILE_INSTALL_FULLPATH  = "$HOME_DIR/.config/powershell/Microsoft.PowerShell_profile.ps1";          ## pwsh profile in Unix.
$WINDOWS_PROFILE_INSTALL_FULLPATH    = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"; ## Default Windows Powershell.
## Terminal
$TERMINAL_SOURCE_DIR                      = "$DOTS_DIR/extras/terminal";
$TERMINAL_WIN32_SETTINGS_INSTALL_FULLPATH = "%APPDATA%\alacritty\alacritty.yml"
$TERMINAL_UNIX_SETTINGS_INSTALL_FULLPATH  = "$HOME_DIR/.config/alacritty/alacritty.yml"
##  Vim
$VIM_SOURCE_DIR                     = "$DOTS_DIR/extras/vim";
$VIMRC_INSTALL_FULLPATH             = "$HOME_DIR/.vimrc";
$NEOVIM_WIN32_INIT_INSTALL_FULLPATH = "$HOME_DIR/AppData/Local/nvim/init.vim";
$NEOVIM_UNIX_INIT_INSTALL_FULLPATH  = "$HOME_DIR/.config/nvim/init.vim";
##  VsCode
$VSCODE_SOURCE_DIR                   = "$DOTS_DIR/extras/vscode";
$VSCODE_KEYBINDINGS_INSTALL_FULLPATH = "$HOME_DIR/AppData/Roaming/Code/User/keybindings.json";
$VSCODE_SETTINGS_INSTALL_FULLPATH    = "$HOME_DIR/AppData/Roaming/Code/User/settings.json";
$VSCODE_SNIPPETS_INSTALL_FULLPATH    = "$HOME_DIR/AppData/Roaming/Code/User/snippets/stdmatt_snippets.code-snippets";
##  Binaries
$BINARIES_SOURCE_DIR       = "$DOTS_DIR/extras/bin/win32";
$BINARIES_INSTALL_FULLPATH = "$STDMATT_BIN_DIR";

##------------------------------------------------------------------------------
## Journal things...
$JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
$JOURNAL_GIT_URL   = "https://gitlab.com/stdmatt-private/journal";
$JOURNAL_FILE_EXT = ".info";


##----------------------------------------------------------------------------##
## Helper Functions                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _string_is_null_or_whitespace()
{
    return [string]::IsNullOrWhiteSpace($args[0]);
}


##------------------------------------------------------------------------------
function _basepath()
{
    $arg = $args[0];
    $arg = $arg.Replace("\", "/");
    if ((_string_is_null_or_whitespace $arg)) {
        return "";
    }

    return $arg.Split("/")[-1];
}

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

    $output =  sh_hex_to_ansi $SH_HEX_RED  "[FATAL]";
    $output += sh_hex_to_ansi $SH_HEX_GRAY "[$function_name] ";
    $output += $args;

    Write-Output $output;
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

    $output  = sh_hex_to_ansi $SH_HEX_GRAY "[$function_name] ";
    $output += $args;

    Write-Output $output;
}

##------------------------------------------------------------------------------
$INVALID_FILE_TIME = -1;
function _get_file_time()
{
    $filename      = $args[0];
    $is_valid_file = sh_file_exists($filename);

    if($is_valid_file) {
        $file_info  = (Get-Item -Force $filename);
        $file_ticks = $file_info.LastAccessTimeUtc.Ticks;
        return $file_ticks;
    }
    return $INVALID_FILE_TIME;
}

##------------------------------------------------------------------------------
function _copy_newer_file()
{
    $INDENT = "   ";
    $NL     = "`n";

    $repo_file    = $args[0];
    $fs_file      = $args[1];

    ## Repo file info.
    $repo_exists = (sh_file_exists "$repo_file");
    $repo_hash   = $null;
    $repo_time   = 0;
    if($repo_exists) {
        $repo_hash = $(Get-FileHash $repo_file).hash;
        $repo_time = (_get_file_time $repo_file);
    }

    ## Fs file info.
    $fs_exists = (sh_file_exists "$fs_file");
    $fs_hash   = $null;
    $fs_time   = 0;
    if($fs_exists) {
        $fs_hash = $(Get-FileHash $fs_file).hash;
        $fs_time = (_get_file_time $fs_file);
    }

    if(-not $repo_exists -and -not $fs_exists) {
        _log_fatal "Both paths are invalid..." $NL `
                "$INDENT FS   : ($fs_file)"    $NL `
                "$INDENT Repo : ($repo_file)"  ;
        return;
    }

    ## Files are equal...
    if($repo_hash -eq $fs_hash) {
        $sync_to = $null;
    } elseif($fs_time -gt $repo_time) {
        $sync_to = "repo";
    } elseif($repo_time -gt $fs_time) {
        $sync_to = "fs";
    }

    ## Copy if needed..
    if($sync_to -eq "fs") {
        $colored_repo = (sh_hex_to_ansi $SH_HEX_GREEN  $repo_file);
        $colored_fs   = (sh_hex_to_ansi $SH_HEX_YELLOW $fs_file);

        _log "Syncing Repo -> FS"             $NL `
             "$INDENT Repo : ($colored_repo)" $NL `
             "$INDENT FS   : ($colored_fs)"       ;

        $fs_dir_path = (sh_dirpath $fs_file);
        $null        = (sh_mkdir   $fs_dir_path);

        Copy-Item $repo_file $fs_file -Force;
    }
    elseif($sync_to -eq "repo") {
        $colored_repo = (sh_hex_to_ansi $SH_HEX_YELLOW $repo_file);
        $colored_fs   = (sh_hex_to_ansi $SH_HEX_FS     $fs_file);

        _log "Syncing FS -> Repo"             $NL `
             "$INDENT FS   : ($colored_fs)"   $NL `
             "$INDENT Repo : ($colored_repo)" ;

        Copy-Item $fs_file $repo_file -Force;
    }
    else {
        $colored_repo = (sh_hex_to_ansi $SH_HEX_BLUE $repo_file);
        $colored_fs   = (sh_hex_to_ansi $SH_HEX_BLUE $fs_file);

        _log_verbose "Files are equal..."     $NL `
             "$INDENT FS   : ($colored_fs)"   $NL `
             "$INDENT Repo : ($colored_repo)" ;
    }
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

    Write-Output $value;
}

##----------------------------------------------------------------------------##
## Profile                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function edit-profile()
{
    nvim                                     `
        $profile                             `
        $TERMINAL_SETTINGS_INSTALL_FULLPATH  `
        $VSCODE_KEYBINDINGS_INSTALL_FULLPATH `
        $VSCODE_SETTINGS_INSTALL_FULLPATH    `
        $VSCODE_SNIPPETS_INSTALL_FULLPATH;

    install-profile;
}

##------------------------------------------------------------------------------
function reload-profile()
{
    & $profile
}


##----------------------------------------------------------------------------##
## Sync...                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function sync-journal()
{
    if(!(sh_dir_exists $JOURNAL_DIR)) {
        git clone "https://gitlab.com/stdmatt-private/journal" "$JOURNAL_DIR";
        return;
    }

    cd $JOURNAL_DIR;
    git add .

    $current_pc_name = hostname;
    $current_date    = date;
    $commit_msg      = "[sync-journal] ($current_pc_name) - ($current_date)";

    _log $commit_msg;
    git commit -m "$commit_msg";

    git pull
    git push
}

##------------------------------------------------------------------------------
function sync-dots()
{
    _log "REFACTOR!!!"
    # if(!(sh_dir_exists $DOTS_DIR)) {
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
    sync-dots;
    sync-journal;
    git-config;
    install-all;

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
        (sh_mkdir $JOURNAL_DIR);
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    _stdmatt_cd $JOURNAL_DIR;
    nvim .
    _stdmatt_cd "-";
}


##----------------------------------------------------------------------------##
## Git                                                                        ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function git-config()
{
    _log_verbose "Configuring git...";

    git config --global user.name         "stdmatt";
    git config --global user.email        "stdmatt@pixelwizards.io";
    git config --global core.excludesfile "~/.gitignore";            ## Set the gitignore globaly...
    git config --global core.editor       "nvim";                    ## Set nvim as default editor...
    git config --global core.autocrlf     false;
    git config --global core.filemode     false;

    _log_verbose "Done... ;D";
}

##------------------------------------------------------------------------------
function git-first-date-of()
{
    $filename = $args[0];
    if(-not (sh_file_exists($filename))) {
        _log_fatal "Missing ($filename)";
        return;
    }

    $date_format = "%d %b, %Y";
    $lines       = (git log --diff-filter=A --follow --format=%ad  --date=format:$date_format --reverse -- "${filename}");
    Write-Output $lines;
}

##------------------------------------------------------------------------------
function git-get-repo-url()
{
    $remote = (git remote -v); # | head -1 | expand -t1 | cut -d" " -f2;
    if($remote.GetType().Name -eq "Object[]") {
        $remote = $remote[0]
    }

    $components = $remote.Replace("`t", " ").Split(" ");
    $url        = $components[1];

    Write-Output $url;
}

##----------------------------------------------------------------------------##
## Install                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function install-all()
{
    install-profile;
    install-binaries;
    install-fonts;

}

$env:PATH = $env:PATH + ":" + "/Users/stdmatt/.stdmatt/bin";
echo $env:PATH;


##------------------------------------------------------------------------------
function install-profile()
{
    ## @notice(stdmatt): [Copy vs Link] - 08 Feb, 2022
    ##   We have the following scenario:
    ##     - Multiple platforms to support
    ##       (Win32, WSL, GNU, etc...)
    ##     - Multiple locations for the same file
    ##       pwsh loads in different place, nvim as well, etc...
    ##   So the approach that we are using are:
    ##     - We have one authorative file.
    ##       This file is a copy from / to the repo.
    ##     - All other "copies" of this file are actually hardlinks
    ##       to the authorative one. This way we can edit just in one place
    ##       and have only one point of sync.
    ##   Example:
    ##      copy /repo/important_file.ps1  -> /filesystem/import_file.ps1 (Authorative)
    ##      link /filesytem/import_file.ps -> /filesystem/another/file2.ps1 (Hardlink)
    ##      ...
    ##      link /filesytem/import_file.ps -> /filesystem/another/fileN.ps1 (Hardlink)

    ## Git
    _copy_newer_file "$GIT_SOURCE_DIR/.gitignore" "$GIT_IGNORE_INSTALL_FULLPATH";

    ## Profile
    if($IsWindows) {
        _copy_newer_file "$PROFILE_SOURCE_DIR/main.ps1"        $PWSH_WIN32_PROFILE_INSTALL_FULLPATH;
        create-link       $PWSH_WIN32_PROFILE_INSTALL_FULLPATH $WINDOWS_PROFILE_INSTALL_FULLPATH;
    } else {
        _copy_newer_file "$PROFILE_SOURCE_DIR/main.ps1" $PWSH_UNIX_PROFILE_INSTALL_FULLPATH;
    }

    ## Terminal
    if($IsWindows) {
        _copy_newer_file "$TERMINAL_SOURCE_DIR/alacritty.yml" "$TERMINAL_WIN32_SETTINGS_INSTALL_FULLPATH";
    } else {
        _copy_newer_file "$TERMINAL_SOURCE_DIR/alacritty.yml" "$TERMINAL_UNIX_SETTINGS_INSTALL_FULLPATH";
    }

    ## Vim
    _copy_newer_file "$VIM_SOURCE_DIR/.vimrc"   "$VIMRC_INSTALL_FULLPATH";

    if($IsWindows) {
        _copy_newer_file "$VIM_SOURCE_DIR/init.vim"          $NEOVIM_WIN32_INIT_INSTALL_FULLPATH;
        create-link      $NEOVIM_WIN32_INIT_INSTALL_FULLPATH $NEOVIM_UNIX_INIT_INSTALL_FULLPATH;
        ## @todo(stdmatt): Add the install of vim-plug...
    } else {
        _copy_newer_file "$VIM_SOURCE_DIR/init.vim"          $NEOVIM_UNIX_INIT_INSTALL_FULLPATH;
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';
    }

    if($IsWindows) {
        ## VSCode
        _copy_newer_file "$VSCODE_SOURCE_DIR/keybindings.json" "$VSCODE_KEYBINDINGS_INSTALL_FULLPATH";
        _copy_newer_file "$VSCODE_SOURCE_DIR/settings.json"    "$VSCODE_SETTINGS_INSTALL_FULLPATH";
        _copy_newer_file "$VSCODE_SOURCE_DIR/snippets.json"    "$VSCODE_SNIPPETS_INSTALL_FULLPATH";
    }
}

##------------------------------------------------------------------------------
function install-binaries()
{
    if(-not $IsWindows) {
        _log_verbose "Not on Windows - Just ignoring...";
        return;
    }

    $null = (sh_mkdir $BINARIES_INSTALL_FULLPATH);

    $folder_contents = (Get-ChildItem -Path $BINARIES_SOURCE_DIR);
    foreach($filename in $folder_contents) {
        $filename = $filename.Name;
        $src_path = (sh_join_path $BINARIES_SOURCE_DIR       $filename);
        $dst_path = (sh_join_path $BINARIES_INSTALL_FULLPATH $filename);

        _log_verbose "Copying binary: ($src_path) to ($dst_path)";
        cp -R $src_path $dst_path;
    }
}

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

    $folder_contents = Get-ChildItem -Path $fonts_folder -File
    foreach($font in $folder_contents) {
        $dest = _basepath $font.FullName;
        $dest = "$where_the_fonts_are_installed/$dst";

        if(Test-Path -Path $dest) {
            _log_verbose "Font ($font) already installed.";
        } else {
            _log_verbose "Installing ($font).";

            $copy_flag = [String]::Format("{0:x}", $COPYOPTIONS);
            $obj_folder.CopyHere($font.fullname, $copy_flag);
        }
    }
}


##----------------------------------------------------------------------------##
## Shell                                                                      ##
##----------------------------------------------------------------------------##
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
            $git_line = "${git_branch}-${git_tag}";
        } else {
            $git_line = "${git_branch}";
        }

        $git_line = ":[$git_line]";
    }

    $curr_path    = (Get-Location).Path;
    $prompt       = ":)";
    $color_index  = (Get-Date -UFormat "%M") % 4;                    ## Makes the color cycle withing minutes
    $os_name      = (sh_rgb_to_ansi 0x62 0x62 0x62 ":[${sh_OSName}]"); ## Dark gray
    $git_line     = (sh_rgb_to_ansi 0x62 0x62 0x62 "${git_line}"     ); ## Dark gray
    $prompt       = (sh_rgb_to_ansi 0x9E 0x9E 0x9E "$prompt"         ); ## Light gray
    $colored_path = "";

    if($color_index -eq 0) {
        $hex = $_ps_color_blue;
    } elseif($color_index -eq 1) {
        $hex = $_ps_color_pink;
    } elseif($color_index -eq 2) {
        $hex = $_ps_color_blue_green;
    } else {
        $hex = $_ps_color_yellow_orange;
    }

    $colored_path  = (sh_hex_to_ansi $hex $curr_path);
    $output        = "${colored_path}${os_name}${git_line}`n${prompt} ";

    return $output;
}

##------------------------------------------------------------------------------
function global:prompt
{
    return _make_git_prompt;
}


##----------------------------------------------------------------------------##
## Aliases                                                                    ##
##----------------------------------------------------------------------------##
## cd
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

##------------------------------------------------------------------------------
Remove-Item -Path Alias:cd
Set-Alias -Name cd -Value _stdmatt_cd -Force -Option AllScope

##------------------------------------------------------------------------------
function files()
{
    ## Open the Filesystem Manager into a given path.
    ## If no path was given open the current dir.
    $target_path = $args[0];
    if ($target_path -eq "") {
        $target_path=".";
    }

    $file_manager = (_host_get_file_manager);
    if($file_manager -eq "") {
        _log_fatal("No file manager was found - Aborting...");
        return;
    }
    
    if(-not (sh_dir_exists $target_path)) { 
        _log_fatal("Invalid path - Aborting...");
        return;
    }

    & $file_manager $target_path;
    return;
}

##------------------------------------------------------------------------------
function _host_get_file_manager()
{
    if($IsWindows) {
        return "explorer.exe";
    } elseif($IsLinux) {
        ## @todo(stdmatt): [File explorer on Linux] - 08 Feb, 2022
        ## Perhaps check with uname if we are under wsl and if so just
        ## open the explorer, otherwise open the deault for linux...

        ## @???(stdmatt): [$IsWSL] - 08 Feb, 2022
        ## Should we create something like the IsWindows and IsLinux to
        ## check if we are under WSL??
        return "explorer.exe";
    } elseif($IsMacOS) { 
        return "open";
    }
    else {
        return "";
    }
}

##------------------------------------------------------------------------------
function create-link()
{
    $src_path = $args[0];
    $dst_path = $args[1];

    if ( _string_is_null_or_whitespace($src_path) ) {
        _log_fatal("Missing source path - Aborting...");
        return;
    }

    ## @todo(stdmatt): Should we check errors???
    $null = (New-Item -ItemType HardLink -Target $src_path -Path $dst_path -Force);
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
    if ( _string_is_null_or_whitespace($dst_path) ) {
        _log_fatal("Missing target path - Aborting...");
        return;
    }

    $src_path = (Resolve-Path $src_path).ToString();

    ## @todo(stdmatt): Check if thestring ends with .lnk and if not add it - Dec 28, 2020
    $WshShell            = New-Object -ComObject WScript.Shell
    $Shortcut            = $WshShell.CreateShortcut($dst_path);
    $Shortcut.TargetPath = $src_path;
    $Shortcut.Save();
}


## vim
##------------------------------------------------------------------------------
## Remove-Alias -Path Alias:nv -Force -Option AllScope
Set-Alias -Name vi  -Value nvim.exe -Force -Option AllScope
Set-Alias -Name vim -Value nvim.exe -Force -Option AllScope
Set-Alias -Name nv  -Value nvim.exe -Force -Option AllScope


## kill
##------------------------------------------------------------------------------
function kill-process()
{
    $process_name = $args[0];
    $line         = (ps | grep $process_name);

    if($line.Length -eq 0) {
        _log_fatal "No process with name: (${process_name})";
        return;
    } elseif($line.Length -gt 1 -and $line.GetType().FullName -ne "System.String") {
        ## @todo(stdmatt): [Pretty Print] 09 Dec, 2021 at 00:58:30
        ## Print each process in a different line.
        _log_fatal "More than one process were found: (`n${line}`n)";
        return;
    }

    $comps_dirty = $line.Split(" ");
    $comps_clean = @();

    for($i = 0; $i -lt $comps_dirty.Length; $i += 1) {
        $comp = $comps_dirty[$i];
        if($comp.Length -eq 0) {
            continue;
        }
        $comps_clean += $comp;
    }

    $PROCESS_ID_INDEX_IN_PS_OUTPUT = 4;
    $process_id                    = $comps_clean[$PROCESS_ID_INDEX_IN_PS_OUTPUT];

    _log "Killing proccess: ($process_name id: ${process_id})";
    kill $process_id -Force
}

##------------------------------------------------------------------------------
function kill-for-anvil()
{
    kill-process guild
    kill-process hoard
    kill-process Phoenix.Module
    kill-process Phoenix.Studio
}

## rm
##------------------------------------------------------------------------------
function nuke-dir()
{
    $path_to_remove = $args[0];
    if($path_to_remove -eq "") {
        _log_fatal "No directory path was given";
        return;
    }

    $dir_is_valid = sh_dir_exists $path_to_remove;
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


##----------------------------------------------------------------------------##
## Greeting                                                                   ##
##----------------------------------------------------------------------------##
install-profile
