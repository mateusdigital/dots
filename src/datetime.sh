SECONDS_DAY=$(( 60 * 60 * 24 ));
SECONDS_WEEK=$(( SECONDS_DAY * 7 ));
SECONDS_MONTH=$(( SECONDS_DAY * 24 ));
SECONDS_YEAR=$(( SECONDS_DAY * 365 ));

##------------------------------------------------------------------------------
utc-seconds()
{
    ## @todo(stdmatt): This will not work on OSX for sure...
    date -u "+%s"
}