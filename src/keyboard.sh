##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/stdmatt/shellscripts_utils/main.sh


##----------------------------------------------------------------------------##
## Helper Functions                                                           ##
##----------------------------------------------------------------------------##
_dots_set_function_keys_state()
{
    ## @NOTICE(stdmatt): Today we just have this for OSX...
    if [ "$(pw_os_get_simple_name)" != "$(PW_OS_OSX)" ]; then
        return;
    fi;

    local STATE="$1";
    defaults write -g com.apple.keyboard.fnState -boolean $STATE;

    ## @NOTICE(stdmatt): OSX takes some time to apply the settings
    ## So we are faking the delayed output to make the UX more pleasant...
    sleep 0.5;
    test "$STATE" == "true"                          \
        && echo "Function keys are now F1-F12..."    \
        || echo "Function keys are now \"media\"...";
}


##----------------------------------------------------------------------------##
## Public Functions                                                           ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
keyboard-enable-function-keys()
{
    _dots_set_function_keys_state "false";
}

##------------------------------------------------------------------------------
keyboard-disable-function-keys()
{
    _dots_set_function_keys_state "true";
}

