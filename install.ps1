##
## Constants
##
##------------------------------------------------------------------------------
## Script
$SCRIPT_FULLPATH = $MyInvocation.MyCommand.Path;
$SCRIPT_DIR      = (Split-Path "$SCRIPT_FULLPATH" -Parent);
$DOTS_FULLPATH   = (Join-Path $SCRIPT_DIR "src" "main.ps1");

##
## Install Profile
##
##------------------------------------------------------------------------------
echo "Installing profile...";

. $DOTS_FULLPATH;  ## Source the file.
install-profile    ## Let the install function handle everything...

echo "Done..."