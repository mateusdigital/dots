
##----------------------------------------------------------------------------##
## Hacks for Mingw                                                            ##
##----------------------------------------------------------------------------##
if [ "$(pw_os_get_simple_name)" == "$(PW_OS_OSX)" ]; then
    echo "Doing OSX hacks..";

    ## @notice(stdmatt): Coreutils on OSX
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi;
