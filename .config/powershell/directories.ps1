##
## Important directories
##

##------------------------------------------------------------------------------
$BIN_DIR    = "${HOME}/.bin";             ## The location of our custom binaries - It'll be 1st on PATH.
$LIB_DIR    = "${HOME}/.lib";             ## The location of our custom libraries. 
$CONFIG_DIR = "${HOME}/.config";          ## General configuration site.
$PS_DIR     = "${CONFIG_DIR}/powershell"; ## Powershell scripts site.
$SHLIB_DIR  = "${LIB_DIR}/shlib";         ## Location of shlib.
$TEMP_DIR   =  if($IsWindows) { $env:TEMP } else { "/tmp" };
