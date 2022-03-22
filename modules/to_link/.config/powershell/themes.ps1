
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
    Emphasis           = "#FF00FF";
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

$DEFAULT_THEME = @{
    background = "#1E1E1E";
}

$PROMPT_THEME = @{
    cwd = @{
        icon = " ";
        fg   = "#C586C0";
        bg   = $DEFAULT_THEME.background;
    }

    status = @{
        bg = $DEFAULT_THEME.background;

        cmd_icon = " ";
        cmd_fg   = "#569CD6";

        last_exit_icon       = "";
        last_exit_fg_success = "#B5CEA8";
        last_exit_fg_failure = "#D16969";

        duration_icon = " ";
        duration_fg_fast   = "#B5CEA8";
        duration_fg_medium = "#D7BA7D";
        duration_fg_slow   = "#D16969";
    }
};
