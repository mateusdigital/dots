##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

. "$HOME_DIR/.config/powershell/themes.ps1"

##------------------------------------------------------------------------------
function _on_vi_mode_change
{
    if ($args[0] -eq 'Command') {
        Write-Host -NoNewLine "`e[1 q";
    } else {
        Write-Host -NoNewLine "`e[5 q";
    }
}


##
## Public
##

Set-PSReadLineOption                                  `
    -ViModeIndicator     Script                       `
    -ViModeChangeHandler $Function:_on_vi_mode_change `
    -EditMode            Vi                           `
    -PredictionSource    History                      `
    -Colors              $THEME_PS_READLINE;
