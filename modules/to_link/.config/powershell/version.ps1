##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))

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

    $value = [string]::Format(
"{0} - {1} - {2}                                      `
Copyright (c) {3} - {4}                               `
This is a free software ({5}) - Share/Hack it         `
Check http://stdmatt.com for more :)",
        $PROGRAM_NAME,
        $PROGRAM_VERSION,
        $PROGRAM_AUTHOR,
        $PROGRAM_COPYRIGHT_YEARS,
        $PROGRAM_COPYRIGHT_OWNER,
        $PROGRAM_LICENSE
    );

    sh_writeline $value;
}
