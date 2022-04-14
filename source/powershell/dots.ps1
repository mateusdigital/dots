
##
## Preset stuff...
##

$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 0;

##
## Load shlib
##

$HOME_DIR = if ($HOME -eq "") { "$env:USERPROFILE" } else { $HOME };
. "${HOME_DIR}/.stdmatt/lib/shlib/shlib.ps1";


##
## ALIAS
##

$DOTS_DIR   = (sh_get_script_dir);
$CONFIG_DIR = "${HOME_DIR}/.config";
$PS_DIR     = "${CONFIG}/powershell";
$NV_DIR     = "${CONFIG}/nvim";


##
## Load everything under the dots dir...
##

foreach($item in (Get-ChildItem $DOTS_DIR)) {
    $name = $item.Name;
    if($name -eq "dots.ps1"                          -or `
       $name -eq "Microsoft.PowerShell_profile.ps1"  -or `
       $name -eq "Microsoft.VSCode_profile.ps1")
    {
        continue;
    }

    sh_log_verbose "Loading: $name";
    . $item.FullName;
}
