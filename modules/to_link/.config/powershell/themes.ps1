
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
    foreground = "#D4D4D4";

    normal = @{
        black   = "#1E1E1E"
        red     = "#D16969"
        green   = "#608B4E"
        yellow  = "#D7BA7D"
        blue    = "#569CD6"
        magenta = "#C586C0"
        cyan    = "#9CDCFE"
        white   = "#D4D4D4"
    };

    bright = @{
        black   = '#000000'
        red     = '#FF0000'
        green   = '#00FF00'
        yellow  = '#FFFF00'
        blue    = '#0000FF'
        magenta = '#FF00FF'
        cyan    = '#00FFFF'
        white   = '#FFFFFF'
    };
}

$PROMPT_THEME = @{
    div = @{
        icon = " • ";
        fg   = "#808080";
        bg   = $DEFAULT_THEME.background;
    };

    cwd = @{
        icon       = " ";
        icon_color = $DEFAULT_THEME.normal.magenta;
        text_color = $DEFAULT_THEME.foreground;
    }

    git = @{
        local_icon         = " ";
        local_icon_color   = $DEFAULT_THEME.normal.blue;
        add_icon           = " ";
        add_icon_color     =  $DEFAULT_THEME.normal.green;
        delete_icon        = " ";
        delete_icon_color  = $DEFAULT_THEME.normal.red;
        modify_icon        = " ";
        modify_icon_color  = $DEFAULT_THEME.normal.yellow;
        untrack_icon       = "";
        untrack_icon_color = $DEFAULT_THEME.normal.white;
        remote_icon        = " ";
        remote_icon_color  = $DEFAULT_THEME.normal.cyan;
        push_icon          = "";
        push_icon_color    = $DEFAULT_THEME.normal.green;
        pull_icon          = "";
        pull_icon_color    = $DEFAULT_THEME.normal.red;
        tag_icon           = " ";
        tag_icon_color     = "#FF00FF";
    }

    status = @{
        bg = $DEFAULT_THEME.background;

        cmd_icon = " ";
        cmd_fg   = $DEFAULT_THEME.normal.cyan;

        last_exit_icon       = " ";
        last_exit_fg_success = $DEFAULT_THEME.normal.green;
        last_exit_fg_failure = $DEFAULT_THEME.normal.red;

        duration_icon = " ";
        duration_fg_fast   = "#B5CEA8"; ## $DEFAULT_THEME.normal.green;
        duration_fg_medium = "#D7BA7D"; ## $DEFAULT_THEME.normal.yellow;
        duration_fg_slow   = "#D16969"  ## $DEFAULT_THEME.normal.red;
    }
};
