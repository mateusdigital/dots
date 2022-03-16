##------------------------------------------------------------------------------
gauthors-top()
{
    git shortlog -s -n;
}

##------------------------------------------------------------------------------
gwhoami()
{
    local USER_NAME="$(git config user.name)";
    local USER_EMAIL=$(git config user.email);
    echo "$USER_NAME <$USER_EMAIL>"
}

##------------------------------------------------------------------------------
gbranch()
{
    git branch;
}

##------------------------------------------------------------------------------
gbranch-all()
{
    git branch --all;
}

##------------------------------------------------------------------------------
gbranch-curr()
{
    git rev-parse --abbrev-ref HEAD;
}

##------------------------------------------------------------------------------
gbranch-delete()
{
    ## todo(stdmatt): Add way to get the command line arguments and
    ##    get if user passed a --remote flag, meaning that we want to
    ##    remove the remote branch as well.
    local TARGET_BRANCH="$1";

    ## Empty branch...
    test -z "$TARGET_BRANCH" && \
        echo "Empty branch name - Ignoring..." && \
        return 0;

    ## Same branch...
    test "$(gbranch-curr)" == "$TARGET_BRANCH" && \
        echo "Trying to delete the current branch - Ignoring..." && \
        return 0;

    ## Invalid branch...
    local RESULT=$(git rev-parse --verify "$TARGET_BRANCH" 2> /dev/null);
    test -z "$RESULT" && \
        echo "Invalid branch name - Ignoring..." && \
        return 0;

    ## Here we have a valid branch that we can delete...
    ##   Passing '-d' instead of '-D' prevents us to making silly things.
    git branch -d "$TARGET_BRANCH";
}

##------------------------------------------------------------------------------
gcommit()
{
    local msg="$@";
    if [ -n "$msg" ]; then
        echo "Committing with msg: ($msg)";
        git commit -m "$msg";
    else
        git commit;
    fi;
}

##------------------------------------------------------------------------------
glog() ## Thanks to: https://stackoverflow.com/a/9074343
{
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
}

##------------------------------------------------------------------------------
gsub-uir()
{
    git submodule update --init --recursive;
}

##------------------------------------------------------------------------------
gpush-curr()
{
    local CURRENT_BRANCH="$(gbranch-curr)";
    git push --tags origin "$CURRENT_BRANCH";
    local RET=$?;

    return $RET;
}

##------------------------------------------------------------------------------
gpull-curr()
{
    local CURRENT_BRANCH="$(gbranch-curr)";
    git pull origin "$CURRENT_BRANCH";
    local RET=$?;

    return $RET;
}

##------------------------------------------------------------------------------
gfetch()
{
    git fetch --tags;
}

##------------------------------------------------------------------------------
gstatus()
{
   git status;
}


##----------------------------------------------------------------------------##
## Repository                                                                 ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
greset()
{
    git reset --hard;
}

##------------------------------------------------------------------------------
grepo-root()
{
    git rev-parse --show-toplevel
}

##------------------------------------------------------------------------------
grepo-url()
{
    git remote -v | head -1 | expand -t1 | cut -d" " -f2;
}

##------------------------------------------------------------------------------
grepo-add-origin()
{
    local URL="$1";
    if [ -z "$URL" ]; then
        echo "[grepo-add-origin] URL can't be empty.";
        return 1;
    fi;

    git remote add origin "$URL";
}

##------------------------------------------------------------------------------
grepo-set-origin()
{
    local URL="$1";
    if [ -z "$URL" ]; then
        echo "[grepo-set-origin] URL can't be empty.";
        return 1;
    fi;

    git remote set-url origin "$URL";
}

##------------------------------------------------------------------------------
git-creation-time-of()
{
    local FILENAME="$1";
    test -z "$FILENAME" && echo "[git-creation-time-of] URL can't be empty." && return 1;

    git log --follow --format=%aD --reverse -- $FILENAME | head -1
}
