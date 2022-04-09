##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

##
## Public Functions
##

##------------------------------------------------------------------------------
function journal()
{
    $JOURNAL_DIR       = "$HOME_DIR/Desktop/Journal";
    $JOURNAL_GIT_URL   = "https://gitlab.com/stdmatt-private/journal";
    $JOURNAL_FILE_EXT = ".info";

    ## @todo(stdmatt): Would be nice to actually make the function to write
    ## the header automatically with the start and end dates of the week - 3/15/2021, 10:27:14 AM
    $cultureInfo = [System.Globalization.CultureInfo]::CurrentCulture;
    $week_day    = $cultureInfo.Calendar.GetWeekOfYear(
        (Get-Date),
        $cultureInfo.DateTimeFormat.CalendarWeekRule,
        $cultureInfo.DateTimeFormat.FirstDayOfWeek
    )

    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = "week_" + $week_day;
    $journal_filename = "$JOURNAL_DIR" + "/" + $curr_date_str + $JOURNAL_FILE_EXT;

    try {
        (sh_mkdir $JOURNAL_DIR);
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    sh_push_dir $JOURNAL_DIR;
        nvim .
    sh_pop_dir;
}

##------------------------------------------------------------------------------
function sync-journal()
{
    if(!(sh_dir_exists $JOURNAL_DIR)) {
        git clone "https://gitlab.com/stdmatt-private/journal" "$JOURNAL_DIR";
        return;
    }

    sh_push_dir $JOURNAL_DIR;
        git add .

        $current_pc_name = hostname;
        $current_date    = date;
        $commit_msg      = "[sync-journal] ($current_pc_name) - ($current_date)";

        sh_log $commit_msg;
        git commit -m "$commit_msg";

        git pull;
        git push;
    sh_pop_dir
}
