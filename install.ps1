##
## Constants
##
## Script
$SCRIPT_FULLPATH = $MyInvocation.MyCommand.Path;
$SCRIPT_DIR      = Split-Path "$SCRIPT_FULLPATH" -Parent;
$HOME_DIR        = "$env:USERPROFILE";
## Profile
$PROFILE_INSTALL_FULLPATH = "$HOME_DIR/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
$PROFILE_SOURCE_FULLPATH  = "$SCRIPT_DIR/src/win32/main.ps1";

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

# Your script here
##
## Script
##
echo "Installing profile..."
New-Item -ItemType File -Path $profile -Force | out-null;
Copy-Item $PROFILE_SOURCE_FULLPATH $PROFILE_INSTALL_FULLPATH -Force
echo "    Profile installed at: $PROFILE_INSTALL_FULLPATH";
echo "";

##
## Add the things to PATH
## thanks to: https://codingbee.net/powershell/powershell-make-a-permanent-change-to-the-path-environment-variable
$old_path = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path;
if( $old_path.IndexOf("DOTS_DIR") -eq -1 ) {
    echo "Setting DOTS_DIR path variable...";
    $DOTS_DIR = "$SCRIPT_DIR";
    $new_path = "$old_path;$DOTS_DIR";
    echo "   New path: $new_path";
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $new_path;
    echo "";
}

echo "Done... ;D";
echo "";
Write-Host -NoNewline -Object "Press any key continue...";
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
