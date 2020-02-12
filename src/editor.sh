##------------------------------------------------------------------------------
STDMATT_EDITORS="codium   \
                 vscodium \
                 code     \
                 vim      \
                 nano";

export EDITOR=vim;
export VISUAL=vim;

##------------------------------------------------------------------------------
function ed()
{
    for EDITOR in $STDMATT_EDITORS; do
        ## echo "Trying editor: $EDITOR";
        local EDITOR_PATH="$(pw_get_program_path $EDITOR)";
        if [ -n "$EDITOR_PATH" ]; then
            $EDITOR_PATH $@;
            return;
        fi;
    done;
}
