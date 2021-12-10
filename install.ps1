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

$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/PowerShell/Microsoft.PowerShell_profile.ps1";
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
echo $file_data | Out-File -Encoding utf8 $PROFILE_INSTALL_FULLPATH;
echo "    Profile installed at: $PROFILE_INSTALL_FULLPATH";
echo "";
