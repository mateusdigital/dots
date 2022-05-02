test $SHELL_SH_LOADED && return;
SHELL_SH_LOADED=1;

##
## Single letter functions.
##

##------------------------------------------------------------------------------
_edit() {
    if [ $# -eq 0 ]; then
        $NVIM ".";   ## Edit current path...
    else
        $NVIM $args; ## Open with the given args...
    fi;
}

##------------------------------------------------------------------------------
_git() {
    if [ $# -eq 0 ]; then
        git s;      ## git status by default.
    else
        git $args;  ## Just pass the args...
    fi;
}

##------------------------------------------------------------------------------
_cd() {
    cd $@;
}


##------------------------------------------------------------------------------
_files() {
    ## Open the Filesystem Manager into a given path.
    ## If no path was given open the current dir.
    local target_path="$1";
    if [ -z "$target_path" ]; then
        target_path=".";
    fi;

    local $file_manager = "";

    if [ -z $bashy_IsMacOS ]; then
        $file_manager = "open";
    elif [ -z $bashy_IsGNU ]; then
        $file_manager = "vimfm";
    else
       bashy_msg -fatal  "No file manager was found - Aborting...";
       return 1;
    fi;

    $file_manager $target_path;
}


##------------------------------------------------------------------------------
_vm() {
    local value="$1";
    if [ -z $value; ]; then
        value="default";
    fi;

    cd "${VAGRANT_DIR}/${value}";

    vagrant up;
    vagrant ssh;
}


##------------------------------------------------------------------------------
function dots()
{
    if [ $# -eq 1 ] && [ $1 == "gui" ]; then
        gitui -d $HOME/.dots/ -w $HOME;
    else
        if [ $# -eq 0 ]; then
            git --git-dir=$HOME/.dots/ --work-tree=$HOME "s";
        else
            git --git-dir=$HOME/.dots/ --work-tree=$HOME $@;
        fi;
    fi;
}

dots config --local status.showUntrackedFiles no
dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore";


##------------------------------------------------------------------------------
function version()
{
    PROGRAM_NAME="dots";
    PROGRAM_VERSION="4.0.0";
    PROGRAM_AUTHOR="stdmatt - <stdmatt@pixelwizads.io>";
    PROGRAM_COPYRIGHT_OWNER="stdmatt";
    PROGRAM_COPYRIGHT_YEARS="2021, 2022";
    PROGRAM_DATE="30 Nov, 2021";
    PROGRAM_LICENSE="GPLv3";

    echo $(bash_join_by "\n" (
        "${PROGRAM_NAME} - ${PROGRAM_VERSION} - ${PROGRAM_AUTHOR}"
        "Copyright (c) ${PROGRAM_COPYRIGHT_YEARS} - ${PROGRAM_COPYRIGHT_OWNER}"
        "This is a free software (${PROGRAM_LICENSE}) - Share/Hack it"
        "Check http://stdmatt.com for more :)"
    ));
}


