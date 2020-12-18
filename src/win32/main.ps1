
##
## Files
##   Open the Filesystem Manager into a given path.
##   If no path was given open the current dir.
##
##------------------------------------------------------------------------------
$FILE_MANAGER = "explorer.exe";

##------------------------------------------------------------------------------
function files()
{
    $target_path = $args[0];
    if ( $target_path -eq "" )  {
        $target_path=".";
    }

    & $FILE_MANAGER $target_path;
}


##
## Paths
##
##------------------------------------------------------------------------------
function lty
{
    cd  E:/mmesquita_KIV-WKS-PR536_9193
    pwd
}

##------------------------------------------------------------------------------
function ack
{
    cd  E:/mmesquita_ack
    pwd
}

##------------------------------------------------------------------------------
function me
{
    cd  D:/stdmatt
    pwd
}


##
## Profile
##
##------------------------------------------------------------------------------
function edit-profile()
{
    code $profile
}

##------------------------------------------------------------------------------
function reload-profile()
{
    & $profile
}


##
## Utils
##
##------------------------------------------------------------------------------
$JOURNAL_PATH = "C:/Users/mmesquita/Desktop/Journal";

##------------------------------------------------------------------------------
function journal()
{
    ## This creates a new file with the date as filename if it doesn't exists...
    $curr_date_str    = Get-Date -Format "yy_MM_dd";
    $journal_filename = "$JOURNAL_PATH" + "/" + $curr_date_str + ".txt";
    $today_filename   = "$JOURNAL_PATH" + "/" + "_today.txt";

    try {
        New-Item -Path "$journal_filename" -ItemType File -ea stop
    } catch {
    }

    code $JOURNAL_PATH;
}


##
## Shell
##
##------------------------------------------------------------------------------
function global:prompt
{
    $curr_path = pwd;
    return "$curr_path `n:) "
}
