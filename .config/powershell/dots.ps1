##------------------------------------------------------------------------------

## Preset stuff...
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 0;

## Load shlib
. "${HOME}/.stdmatt/lib/shlib/shlib.ps1";

## Important directories
$CONFIG_DIR = "${HOME}/.config";
$BIN_DIR    = "${HOME}/.bin";
$PS_DIR     = "${CONFIG_DIR}/powershell";
$NVIM_DIR   = "${CONFIG_DIR}/nvim";

##
## dots
##

##------------------------------------------------------------------------------
function dots()
{
	if($args.Length -eq 1 -and $args[0] -eq "gui") { 
            gitui -d $HOME/.dots/ -w $HOME;
	} else {
	    (git --git-dir=$HOME/.dots/ --work-tree=$HOME $args);
	}
}

(dots config --local status.showUntrackedFiles no);
(dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore");
