##
## Imports
##

##------------------------------------------------------------------------------
Import-Module PSFzf


##
## Private Functions
##

##------------------------------------------------------------------------------
## "#1E1E1E"  ##
## "#808080"  ## #include
## "#D4D4D4"  ## normal text
## "#9CDCFE"  ## my_variable
## "#569CD6"  ## public static void
## "#4EC9B0"  ## Class_Type
## "#608B4E"  ## /* comment */
## "#B5CEA8"  ## 3.14f
## "#DCDCAA"  ## my_function()
## "#D7BA7D"  ## #selector
## "#CE9178"  ## "string"
## "#D16969"  ## /[a-Z]/
## "#F44747"  ## error message
## "#C586C0"  ## else if


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
## PSReadline
##

##------------------------------------------------------------------------------
Set-PSReadLineOption                                  `
    -ViModeIndicator     Script                       `
    -ViModeChangeHandler $Function:_on_vi_mode_change `
    -EditMode            Vi                           `
    -HistoryNoDuplicates                              `
    -PredictionSource    HistoryAndPlugin             `
    -PredictionViewStyle ListView                     `
    -Colors              @{
        Command            = "#DCDCAA";
        Comment            = "#608B4E";
        ContinuationPrompt = "#FF00FF";
        Default            = "#D4D4D4";
        Emphasis           = "#CE9178";
        Error              = "#F44747";
        InlinePrediction   = "#808080";
        ListPrediction     = "#808080";
        Keyword            = "#C586C0";
        Member             = "#D4D4D4";
        Number             = "#B5CEA8";
        Operator           = "#D4D4D4";
        Parameter          = "#C586C0";
        Selection          = "#FF00FF";
        String             = "#CE9178";
        Type               = "#569CD6";
        Variable           = "#9CDCFE";
    };


##
## PSFZF
##

##------------------------------------------------------------------------------
Set-PsFzfOption                             `
    -PSReadlineChordProvider 'Ctrl+t'       `
    -PSReadlineChordReverseHistory 'Ctrl+r'

## @todo(stdmatt): Is this tab something that we want?
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion; }
