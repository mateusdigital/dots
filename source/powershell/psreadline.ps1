##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))


##
## Imports
##

Import-Module PSFzf
. "$HOME_DIR/.config/powershell/themes.ps1"

##
## Private Functions
##

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

##------------------------------------------------------------------------------
Set-PSReadLineOption                                  `
    -ViModeIndicator     Script                       `
    -ViModeChangeHandler $Function:_on_vi_mode_change `
    -EditMode            Vi                           `
    -HistoryNoDuplicates                              `
    -PredictionSource    HistoryAndPlugin             `
    -PredictionViewStyle ListView                     `
    -Colors              $THEME_PS_READLINE;

##------------------------------------------------------------------------------
Set-PsFzfOption                             `
    -PSReadlineChordProvider 'Ctrl+t'       `
    -PSReadlineChordReverseHistory 'Ctrl+r'

## @todo(stdmatt): Is this tab something that we want?
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion; }
