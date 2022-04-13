##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

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
$THEME_PS_READLINE = @{
    Command            = "#DCDCAA";
    Comment            = "#608B4E";
    ContinuationPrompt = "#FF00FF";
    Default            = "#D4D4D4";
    Emphasis           = "#CE9178";
    Error              = "#F44747";
    InlinePrediction   = "#808080";
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

function print_theme($theme)
{
    foreach($key in $theme.Keys) {
        $value = $theme[$key];
        $color = (sh_make_ansi_hex_color -fg $value)
        $reset = (sh_make_ansi 0);

        echo "${key}: ${color}$value${reset}";
    }
}
