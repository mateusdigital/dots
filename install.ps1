##
## Import
##
if(-not $env:SHLIB) { . "$HOME/.stdmatt/lib/shlib/shlib.ps1" }

##----------------------------------------------------------------------------##
## Constants                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$DOTS_DIR = (sh_get_script_dir);
$HOME_DIR = (sh_get_home_dir);

##------------------------------------------------------------------------------
$FONTS_INFO =  @{
    src = "$DOTS_DIR/extras/fonts";
    win = "$HOME_DIR/AppData/Local/Microsoft/Windows/Fonts";
    mac = "$HOME_DIR/Library/Fonts";
    gnu = "$HOME_DIR/.local/share/fonts";
}

$GIT_INFO = @{
    src = "$DOTS_DIR/extras/git";
    all = "$HOME_DIR";
}

$PWSH_PROFILE = @{
    src = "$DOTS_DIR/src/main.ps1";
    win = "$HOME_DIR/Documents/PowerShell/Microsoft.PowerShell_profile.ps1";
    all = "$HOME_DIR/.config/powershell/Microsoft.PowerShell_profile.ps1";
}

$TERM_INFO = @{
    src = "$DOTS_DIR/extras/terminal/alacritty.yml";
    win = "%APPDATA%\alacritty\alacritty.yml";
    all = "$HOME_DIR/.config/alacritty/alacritty.yml";
}

$VIM_INFO = @{
    src = "$DOTS_DIR/extras/vim/init.vim";
    win = "$HOME_DIR/AppData/Local/nvim/init.vim";
    all = "$HOME_DIR/.config/nvim/init.vim";
}


##----------------------------------------------------------------------------##
## Helper Functions                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _install_fonts()
{
    # $where_the_fonts_are_installed = "";
    # if($IsWindows) {
    #     $where_the_fonts_are_installed = $FONTS_WIN32_INSTALL_FULLPATH;
    # } elseif($IsMacOS) {
    #     $where_the_fonts_are_installed = $FONTS_MACOS_INSTALL_FULLPATH;
    # } else {
    #     ## @todo(stdmatt): _install_fonts_helper_unix should work in
    #     ## everything but windows... but i have no way to test it right now...
    #     $os_name = sh_get_os_name;
    #     sh_log_fatal "Installing fonts not implemented for OS: ($os_name)";
    #     return;
    # }

    # $folder_contents = (Get-ChildItem -Recurse -File -Path $FONTS_SOURCE_DIR);
    # foreach($font in $folder_contents) {
    #     $font_name     = (sh_basepath $font.FullName);
    #     $font_fullpath = "$where_the_fonts_are_installed/$font_name";

    #     if((sh_file_exists $font_fullpath)) {
    #         sh_log_verbose "Font ($font) already installed.";
    #         continue;
    #     }

    #     sh_log_verbose "Installing ($font)...";
    #     if($IsWindows) {
    #         ## @XXX(stdmatt): [macos_port] NOT TESTED on win32...
    #                  ## Thanks to:Arkady Karasin - https://stackoverflow.com/a/61035940
    #         $FONTS       = 0x14
    #         $COPYOPTIONS = 4 + 16;
    #         $OBJ_SHELL   = New-Object -ComObject Shell.Application;
    #         $OBJ_FOLDER  = $OBJ_SHELL.Namespace($FONTS);
    #         $COPY_FLAG   = [String]::Format("{0:x}", $COPYOPTIONS);

    #         $OBJ_FOLDER.CopyHere($font.fullname, $COPY_FLAG);
    #     }

    #     Copy-Item -Force $font.FullName $font_fullpath;
    # }

    # if(-not $IsWindows) {
    #     sh_log_verbose "Flushing fonts cache...";
    #     fc-cache -f $where_the_fonts_are_installed;
    # }

    # sh_log_verbose "Fonts were installed...";
}

##------------------------------------------------------------------------------
function _install_win32_hacks()
{
    if(-not $IsWindows) {
        sh_log_verbose "Not on Windows - Just ignoring...";
        return;
    }

    $BINARIES_SOURCE_DIR       = "$DOTS_DIR/extras/bin/win32";
    $BINARIES_INSTALL_FULLPATH = "$HOME_DIR/.stdmatt/bin";

    $null = (sh_mkdir $BINARIES_INSTALL_FULLPATH);

    $folder_contents = (Get-ChildItem -Path $BINARIES_SOURCE_DIR);
    foreach($filename in $folder_contents) {
        $filename = $filename.Name;
        $src_path = (sh_join_path $BINARIES_SOURCE_DIR       $filename);
        $dst_path = (sh_join_path $BINARIES_INSTALL_FULLPATH $filename);

        sh_log_verbose "Copying binary: ($src_path) to ($dst_path)";
        cp -R $src_path $dst_path;
    }
}

##------------------------------------------------------------------------------
function _install_macOS_hacks()
{
    if(-not $IsMacOS) {
        sh_log_verbose "Not on macOS - Just ignoring...";
        return;
    }

    # $macos_packages = @(
    #     "atool", "coreutils", "ed", "findutils", "gawk",
    #     "gnu-sed", "gnu-tar", "grep", "lynx", "make",
    #     "neovim", "node", "openssl", "pandoc", "python",
    #     "tree", "vifm"
    # );

    #disable special characters when holding keys
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # normal minimum is 15 (225 ms)
    defaults write -g             InitialKeyRepeat -float 5.0
    defaults write NSGlobalDomain InitialKeyRepeat -float 5.0

    # normal minimum is 2 (30 ms)
    defaults write -g             KeyRepeat -float 0.7
    defaults write NSGlobalDomain KeyRepeat -float 0.7
}


function _copy()
{
    $info = $args[0];
    $src  = $info.src;

    $os_name = (sh_get_os_name);
    $dst     = if($info[$os_name]) { $info[$os_name] } else { $info["all"]; }

    ## File...
    if((sh_file_exists $src)) {
        sh_log "Linking: ${src} -> ${dst}";

        sh_mkdir  (sh_basepath $dst);
        sh_mklink $src $dst;

        return;
    }

    sh_mkdir $dst;
    $filenames = (Get-ChildItem -Path $src -Force);
    foreach($item in $filenames) {
        $name = $item.Name;
        $full_src = "${src}/${name}";
        $full_dst = "${dst}/${name}";

        sh_log "Linking: ${full_src} -> ${full_dst}";
        sh_mklink $full_src $full_dst;
    }
}

_copy $GIT_INFO
_copy $PWSH_PROFILE
_copy $TERM_INFO
_copy $VIM_INFO
