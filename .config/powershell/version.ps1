##------------------------------------------------------------------------------
function version()
{
    $PROGRAM_NAME            = "dots";
    $PROGRAM_VERSION         = "3.0.0";
    $PROGRAM_AUTHOR          = "stdmatt - <stdmatt@pixelwizads.io>";
    $PROGRAM_COPYRIGHT_OWNER = "stdmatt";
    $PROGRAM_COPYRIGHT_YEARS = "2021, 2022";
    $PROGRAM_DATE            = "30 Nov, 2021";
    $PROGRAM_LICENSE         = "GPLv3";

    sh_join_string "`n" `
        "${PROGRAM_NAME} - ${PROGRAM_VERSION} - ${PROGRAM_AUTHOR}",
        "Copyright (c) ${PROGRAM_COPYRIGHT_YEARS} - ${PROGRAM_COPYRIGHT_OWNER}",
        "This is a free software (${PROGRAM_LICENSE}) - Share/Hack it",
        "Check http://stdmatt.com for more :)";
}
