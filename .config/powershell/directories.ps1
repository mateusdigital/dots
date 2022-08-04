##
## Important directories
##

##------------------------------------------------------------------------------
$DOTS_BIN_DIR    = "${HOME}/.bin";             ## The location of our custom binaries - It'll be 1st on PATH.

$DOTS_LIB_DIR    = "${HOME}/.lib";             ## The location of our custom libraries. 
$DOTS_SHLIB_DIR  = "${DOTS_LIB_DIR}/shlib";    ## Location of shlib.

$DOTS_CONFIG_DIR = "${HOME}/.config";               ## General configuration site.
$DOTS_PS_DIR     = "${DOTS_CONFIG_DIR}/powershell"; ## Powershell scripts site.

$DOTS_TEMP_DIR   =  if($IsWindows) { $env:TEMP } else { "/tmp" };
