test $ENVIRONMENT_SH_LOADED && return;
ENVIRONMENT_SH_LOADED=1;

##
## Important directories
##

##------------------------------------------------------------------------------
export BIN_DIR="${HOME}/.local/bin";
export CONFIG_DIR="${HOME}/.config";
export VAGRANT_DIR="${HOME}/.vagrant";
export NVIM_DIR="${CONFIG_DIR}/nvim";

[ -z "$TMPDIR" ] && TMPDIR=/tmp;
export TMPDIR;

##
## Shell
##

##------------------------------------------------------------------------------
export TERM="xterm-256color" ## getting proper colors

## History
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "

## Editor / Pager
export EDITOR=nvim;
export VISUAL=nvim;
export PAGER=less;

## Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


##
## PATH
##

##------------------------------------------------------------------------------
if [ $bashy_IsGNU ]; then
    PATH_COMPONENTS=(
        ## My stuff...
        "${HOME}/.local/bin"
        "${HOME}/.fzf/bin"
        ## Normal stuff...
        "/home/linuxbrew/.linuxbrew/bin"
        "/usr/local/bin"
        ## OS Stuff....
        "/usr/local/sbin"
        "/usr/local/bin"
        "/usr/sbin"
        "/usr/bin"
        "/sbin"
        "/bin"
    );
elif [ $bashy_IsMacOS ]; then
    PATH_COMPONENTS=(
        ## My stuff...
        "${HOME}/.local/bin",
        "${HOME}/.fzf/bin",
        "${HOME}/.cargo/bin"
        ## @notice(gnu-tools): Add all the gnu tools to the path
        ## so we can use them in mac without prefixing with g.
        ##    find /usr/local/Cellar -iname "*gnubin" | sort
        "/usr/local/Cellar/coreutils/9.0_1/libexec/gnubin",
        "/usr/local/Cellar/ed/1.18/libexec/gnubin",
        "/usr/local/Cellar/findutils/4.9.0/libexec/gnubin",
        "/usr/local/Cellar/gawk/5.1.1/libexec/gnubin",
        "/usr/local/Cellar/gnu-sed/4.8/libexec/gnubin",
        "/usr/local/Cellar/gnu-tar/1.34/libexec/gnubin",
        "/usr/local/Cellar/grep/3.7/libexec/gnubin",
        "/usr/local/Cellar/libtool/2.4.6_4/libexec/gnubin",
        "/usr/local/Cellar/make/4.3/libexec/gnubin",
        ## OS Stuff....
        "/opt/X11/bin",
        "/usr/local/opt/curl/bin",
        "/usr/local/sbin"
        "/usr/local/bin"
        "/usr/sbin"
        "/usr/bin"
        "/sbin"
        "/bin"
    );
fi;

PATH=$(bashy_join_by ":" ${PATH_COMPONENTS[@]})
