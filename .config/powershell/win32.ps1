## 
. "${HOME}/.lib/shlib/shlib.ps1";
. "${HOME}/.config/powershell/directories.ps1";
. "${HOME}/.config/powershell/path.ps1";


##
## Functions
##

function install_fonts()
{
    if(-not $IsWindows) { 
        sh_log_fatal "Not running on Windows OS...";
        return;
    }

    $username        = (sh_get_user_name);
    $where_the_fonts_are_installed = "C:/Users/${username}/AppData/Local/Microsoft/Windows/Fonts"; 
   
    echo "Installing fonts at: ";
    echo "  $where_the_fonts_are_installed";

    $fonts_folder = "${DOTS_BIN_DIR}/dots/fonts";
    (sh_push_dir $fonts_folder);

    $FONTS_OBJ = (New-Object -ComObject Shell.Application).Namespace(0x14);
    foreach($item in (Get-ChildItem -Recurse "*.ttf")) {
        $filename    = $item.Name;
        $target_path = "${where_the_fonts_are_installed}/${filename}";

        if((sh_file_exists "$target_path")) { 
            echo "Font: ($filename) is already installed!";
        } else { 
            echo "Font: (${filename}) is installing!";
            $FONTS_OBJ.CopyHere($item.FullName);
            Copy-Item $item.FullName $target_path;
        }
    }

    sh_pop_dir;
}