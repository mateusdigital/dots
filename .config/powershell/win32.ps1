#
function install_fonts()
{
    if((sh_is_windows_or_wsl)) { 
        sh_log_fatal "Not running on Windows OS...";
        return;
    }

    ## Thanks to: Arkady Karasin - https://stackoverflow.com/a/61035940
    $FONTS       = 0x14;
    $COPYOPTIONS = (4 + 16);
    $OBJ_SHELL   = (New-Object -ComObject Shell.Application);

    $obj_folder = $OBJ_SHELL.Namespace($FONTS);
    
    $username        = (sh_get_user_name);
    $where_the_fonts_are_installed = "C:/Users/${username}/AppData/Local/Microsoft/Windows/Fonts"; 

    $fonts_folder = ${BIN_FODER}
    foreach($font_filename in Get-ChildItem -Path $fonts_folder -File) {
        $dest_path = "${where_the_fonts_are_installed}/${font_filename}";

        if(Test-Path -Path $dest_path) {
            echo "Font ${font} already installed";
        } else {
            echo "Installing ${font_filename}";

            $copy_flag = [String]::Format("{0:x}", $COPYOPTIONS);
            $obj_folder.CopyHere($font_filename.fullname, $copy_flag);
        }
    }
}
