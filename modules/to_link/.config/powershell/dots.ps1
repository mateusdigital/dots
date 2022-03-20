
## Preset stuff...
$env:POWERSHELL_TELEMETRY_OPTOUT = 1;
$env:SHLIB_IS_VERSBOSE           = 1;

## Load shlib
. "${HOME}/.stdmatt/lib/shlib/shlib.ps1"; ## @todo: Bulletproof this path...


## Load everything under the dots dir...
$DOTS = (sh_get_script_dir);
foreach($item in (Get-Items $DOTS)) {
    if($item -ne "dots.ps1") {
        . $DOTS/$item;
    }
}

