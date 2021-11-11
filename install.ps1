##
## Constants
##
##------------------------------------------------------------------------------
## Script
$SCRIPT_FULLPATH = $MyInvocation.MyCommand.Path;
$SCRIPT_DIR      = Split-Path "$SCRIPT_FULLPATH" -Parent;
$HOME_DIR        = "$env:USERPROFILE";
##------------------------------------------------------------------------------
## Profile
$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$SCRIPT_DIR/src/main.ps1";
## Extras
$EXTRAS_SOURCE_DIRPATH = "$SCRIPT_DIR/extras";

##
##  Install DOTS_DIR_HACK
##
## @todo(stdmatt): For some reason that escapes me now dots on powershell
## needs an env variable called DOTS_DIR, but on windows it's super annoying
## to actually add to the PATH on script mode. So as a hacky way to achieve
## the same thing is to pre process the file to install and change the
## contents of the variable to the actual dots_dir (the repo - i.e. this directory)
##
## So instead of copying the file via the file manager we are opening
## changing the string, and writting to the final destionation.
##
## stdmatt - 10/13/2021, 11:46:17 AM
$file_data = Get-Content $PROFILE_SOURCE_FULLPATH
$file_data = $file_data.Replace(
    "__DOTS_DIR_TO_REPLACE_IN_AN_UGLY_HACK__",
    "$SCRIPT_DIR"
);

##
## Install Profile
##
##------------------------------------------------------------------------------
echo "Installing profile...";
New-Item -ItemType File -Path $profile -Force | out-null;
# Copy-Item $PROFILE_SOURCE_FULLPATH $PROFILE_INSTALL_FULLPATH -Force
echo $file_data | Out-File $PROFILE_INSTALL_FULLPATH;
echo "    Profile installed at: $PROFILE_INSTALL_FULLPATH";
echo "";

##
## Configure Git
##
##------------------------------------------------------------------------------
echo "Configuring git...";
git config --global user.name         "stdmatt";
git config --global user.email        "stdmatt@pixelwizards.io";
git config --global core.excludesfile "$HOME_DIR/.gitignore";

echo "Done... ;D";
echo "";


##
## Install fonts...
##
##------------------------------------------------------------------------------
function _install_fonts()
{
    ## Thanks to:Arkady Karasin - https://stackoverflow.com/a/61035940
    $FONTS = 0x14
    $COPYOPTIONS = 4 + 16;
    $OBJ_SHELL = New-Object -ComObject Shell.Application;

    $obj_folder = $OBJ_SHELL.Namespace($FONTS);

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
_install_fonts;
