##----------------------------------------------------------------------------##
## Import                                                                     ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
. "$HOME/.stdmatt/lib/shlib/shlib.ps1"
. "$HOME/.stdmatt/lib/shlib/rbow.ps1"

##----------------------------------------------------------------------------##
## Helper Functions                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
function _install_fonts()
{
    $FONTS_INFO =  @{
        src = "$DOTS_DIR/data/fonts";
        win = "$HOME_DIR/AppData/Local/Microsoft/Windows/Fonts";
        mac = "$HOME_DIR/Library/Fonts";
        gnu = "$HOME_DIR/.local/share/fonts";
    }

    $os_name                       = (sh_get_os_name);
    $where_the_fonts_are_installed = $FONTS_INFO[$os_name];
    $any_font_was_installed        = $false;

    $folder_contents = (Get-ChildItem -Recurse -File -Path $FONTS_INFO.src);
    foreach($font in $folder_contents) {
        $font_name     = (sh_basepath $font.FullName);
        $font_fullpath = "$where_the_fonts_are_installed/$font_name";

        if((sh_file_exists $font_fullpath)) {
            sh_log_verbose "Font ($font) already installed.";
            continue;
        }

        sh_log_verbose "Installing ($font)...";
        if($IsWindows) {
            ## @XXX(stdmatt): [macos_port] NOT TESTED on win32...
            ## Thanks to:Arkady Karasin - https://stackoverflow.com/a/61035940
            $FONTS       = 0x14
            $COPYOPTIONS = (4 + 16);
            $OBJ_SHELL   = New-Object -ComObject Shell.Application;
            $OBJ_FOLDER  = $OBJ_SHELL.Namespace($FONTS);
            $COPY_FLAG   = [String]::Format("{0:x}", $COPYOPTIONS);

            $OBJ_FOLDER.CopyHere($font.fullname, $COPY_FLAG);
        }

        Copy-Item -Force -Verbose $font.FullName $font_fullpath;
        $any_font_was_installed = $true;
    }

    if(-not $IsWindows -and $any_font_was_installed) {
        sh_log_verbose "Flushing fonts cache...";
        fc-cache -f $where_the_fonts_are_installed;
    }

    sh_log_verbose "Fonts were installed...";
}

##----------------------------------------------------------------------------##
## Entry Point                                                                ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
$os_name    = (sh_get_os_name);
$script_dir = (sh_get_script_dir);
$dst_path = $HOME; ## @xxx(win32): $HOME on win32....


##
## Link: this way we can edit in both places...
##

rbow_log "[\action]Linking files...";
$src_path = "${script_dir}/modules/to_link";
$files    = (Get-ChildItem -Recurse -Force -Attributes Normal $src_path);
foreach($src_file in $files) {
    $dst_dir  = $src_file.DirectoryName.Replace($src_path, $dst_path);
    $dst_file = sh_join_path ${dst_dir} $src_file.Name;

    $log_file = $src_file.FullName.Replace($src_path, "").Trim("/");
    rbow_log "[\path1]${log_file}" "->" "[\path2]${dst_file}";

    sh_mkdir  $dst_dir;
    sh_mklink $src_file $dst_file;
}
rbow_log "[\done]Done...";

##
## Copy: Honestly don't care about the getting nothing from there...
##

rbow_log "[\action]Copying files...";
$src_path = "${script_dir}/modules/to_copy/*";
Copy-Item -Force -Path "$src_path" -Destination $dst_path;
rbow_log "[\done]Done...";
