##
## Constants
##
## Script
$SCRIPT_FULLPATH = $MyInvocation.MyCommand.Path;
$SCRIPT_DIR      = Split-Path "$SCRIPT_FULLPATH" -Parent;
$HOME_DIR        = "$env:USERPROFILE";
## Profile
$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$SCRIPT_DIR/src/main.ps1";

##
## Script
##
echo "Installing profile..."
New-Item -ItemType File -Path $profile -Force | out-null;
Copy-Item $PROFILE_SOURCE_FULLPATH $PROFILE_INSTALL_FULLPATH -Force
echo "    Profile installed at: $PROFILE_INSTALL_FULLPATH";
echo "";

echo "Done... ;D";
echo "";
