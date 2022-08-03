##
## Configure dots function
##

##------------------------------------------------------------------------------
function dots()
{
    ## @notice: [How dots are structure and mindset]
    ##
    ## We use a git bare repository with the work tree on $HOME.
    ## This means that with an addition of a custom gitignore 
    ## to avoid the noise, we can have all the files auto managed 
    ## by git itself, not needing for us to mess with syslinks and such.
    ##
    ## But in return we have a very long line to type everytime to make 
    ## git understand the repo's structure, even worse other tools doesn't 
    ## quite like the way that it's set by default (requiring a lot of typing as well.)
    ##
    ## So this function works as and entry point that actually makes the 
    ## needed hacks and forwards the maximum to the tools.
    ##
    ## For now we are just handling:
    ##   git, gitui

    $GIT_BARE_DIR = "${HOME/.dots_bare}";
    $GIT_WORK_DIR = "${HOME}";

    ## usage: dots gui -> Don't use the graphical one, but preserve the muscle memory.
    if($args.Length -eq 1 -and $args[0] -eq "gui") {
        gitui -d ${GIT_BARE_DIR} -w ${GIT_WORK_DIR};
    } 
    ## usage: dots <any-git-option> : It's still git!!
    ##        dots                  : We gonna use the alias:s as default when nothing is given.
    else {
        $args_ = (sh_value_or_default $args "s")
        git --git-dir=${GIT_BARE_DIR} --work-tree=${GIT_WORK_DIR} $args_;
    }
}

(dots config --local status.showUntrackedFiles no);                        ## Reduce noise.
(dots config --local core.excludesfile "${HOME}/.config/.dots_gitignore"); ## Custom gitignore.
