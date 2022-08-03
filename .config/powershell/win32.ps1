function _install_fonts()
{
    ## Thanks to:Arkady Karasin - https://stackoverflow.com/a/61035940
    $FONTS       = 0x14;
    $COPYOPTIONS = 4 + 16;
    $OBJ_SHELL   = New-Object -ComObject Shell.Application;

    $obj_folder = $OBJ_SHELL.Namespace($FONTS);
    
    $username        = $env:UserName;
    $fonts_folder    = $EXTRAS_SOURCE_DIRPATH + "/" + "jetbrains-mono";
    $where_the_fonts_are_installed = "C:/Users/mmesquita/AppData/Local/Microsoft/Windows/Fonts"; ## @XXX(stdmatt): Just a hack to check if thing will work... but if it will I'll not change it today 11/11/2021, 2:03:40 PM

    foreach($font in Get-ChildItem -Path $fonts_folder -File) {
        $dest = "$where_the_fonts_are_installed/$font";

        if(Test-Path -Path $dest) {
            echo "Font $font already installed";
        } else {
            echo "Installing $font";

            $copy_flag = [String]::Format("{0:x}", $COPYOPTIONS);
            $obj_folder.CopyHere($font.fullname, $copy_flag);
        }
    }
}
