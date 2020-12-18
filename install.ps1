##
## Constants
##
## Script
$SCRIPT_FULLPATH = $MyInvocation.MyCommand.Path;
$SCRIPT_DIRPATH  = Split-Path "$SCRIPT_FULLPATH" -Parent;
## Profile
$PROFILE_INSTALL_FULLPATH = "C:/Users/mmesquita/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH = "$SCRIPT_DIRPATH" + "/src/win32/main.ps1";
## Terminal
$TERMINAL_SETTINGS_INSTALL_FULLPATH = "C:\Users\mmesquita\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
$TERMINAL_SETTINGS_SOURCE_FULLPATH = "$SCRIPT_DIRPATH" + "/extras/windows_terminal.json";


##
## Script
##
echo "installing profile ;D"

Copy-Item $PROFILE_SOURCE_FULLPATH           $PROFILE_INSTALL_FULLPATH            -Force
Copy-Item $TERMINAL_SETTINGS_SOURCE_FULLPATH $TERMINAL_SETTINGS_INSTALL_FULLPATH  -Force
