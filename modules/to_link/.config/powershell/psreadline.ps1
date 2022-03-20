
##
## Private Functions
##

##------------------------------------------------------------------------------
function _configure_PSReadLine()
{
    $_ps_color_black         = "#1E1E1E";  ##
    $_ps_color_gray          = "#808080";  ## #include
    $_ps_color_white         = "#D4D4D4";  ## normal text
    $_ps_color_light_blue    = "#9CDCFE";  ## my_variable
    $_ps_color_blue          = "#569CD6";  ## public static void
    $_ps_color_blue_green    = "#4EC9B0";  ## Class_Type
    $_ps_color_green         = "#608B4E";  ## /* comment */
    $_ps_color_light_yellow  = "#B5CEA8";  ## 3.14f
    $_ps_color_yellow        = "#DCDCAA";  ## my_function()
    $_ps_color_yellow_orange = "#D7BA7D";  ## #selector
    $_ps_color_orange        = "#CE9178";  ## "string"
    $_ps_color_light_red     = "#D16969";  ## /[a-Z]/
    $_ps_color_red           = "#F44747";  ## error message
    $_ps_color_pink          = "#C586C0";  ## else if

    Set-PSReadLineOption                                  `
        -ViModeIndicator     Script                       `
        -ViModeChangeHandler $Function:_on_vi_mode_change `
        -EditMode            Vi                           `
        -PredictionSource    History                      `
        -Colors              @{
            Default            = $_ps_color_white
            Comment            = $_ps_color_green
            Command            = $_ps_color_yellow
            Keyword            = $_ps_color_pink
            ContinuationPrompt = "#FF00FF"
            Number             = $_ps_color_light_yellow
            Member             = $_ps_color_white
            Operator           = $_ps_color_white
            Type               = $_ps_color_light_blue
            Parameter          = $_ps_color_pink
            String             = $_ps_color_orange
            Variable           = $_ps_color_light_blue
        }
}

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
_configure_PSReadLine;
