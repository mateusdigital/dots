##------------------------------------------------------------------------------
utc-seconds()
{
    ## @todo(stdmatt): This will not work on OSX for sure...
    date -u "+%s"
}