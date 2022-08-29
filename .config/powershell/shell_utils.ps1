
##
## Single letter functions.
##

##------------------------------------------------------------------------------
function e() ## edit
{
    if($args.Count -eq 0) {
        & $NVIM ".";   ## Edit current path...
    } else {
        & $NVIM $args; ## Open with the given args...
    }
}

##------------------------------------------------------------------------------
function g() ## git
{
    if($args.Length -eq 0) {
        git s;      ## git status by default.
    } else {
        git $args;  ## Just pass the args...
    }
}

##------------------------------------------------------------------------------
$global:OLDPWD="";
function cd($target_path = "") ## cd
{
    ## @notice(stdmatt): This is pretty cool - It makes the cd to behave like
    ## the bash one that i can cd - and it goes to the OLDPWD.
    ## I mean, this thing is neat, probably PS has some sort of this like that
    ## but honestly, not in the kinda mood to start to look to all the crap
    ## microsoft documentation. But had quite fun time doing this silly thing!
    ## Kinda the first thing that I write in my standing desk here in kyiv.
    ## I mean, this is pretty cool, just could imagine when I get my new keychron!
    ## March 12, 2021!!

    ## @notice(stdmatt): This can be done just by calling sh_pushd and popd...
    ## maybe one day I'll move it - 22-04-08 @ guaruja
    if($target_path -eq "") {
        $target_path = "${HOME}";
    }

    if($target_path -eq "-") {
        $target_path = $global:OLDPWD;
    }

    $global:OLDPWD = [string](Get-Location);
    Set-Location $target_path; ## Needs to be the Powershell builtin or infinity recursion
}

##------------------------------------------------------------------------------
function l() ## ls
{
    ls $args;
}


##------------------------------------------------------------------------------
function f() { files $arsg; }
function files()
{
    ## Open the Filesystem Manager into a given path.
    ## If no path was given open the current dir.
    $target_path = $args[0];
    if ($target_path -eq "") {
        $target_path=".";
    }

    $file_manager = "";
    if($IsWindows -or (sh_is_wsl)) {
        $file_manager = "explorer.exe";
    } elseif($IsMacOS) {
        $file_manager = "open";
    }
    ## @todo(stdmatt): Add for linux someday... at 2022-03-04, 15:54

    if($file_manager -eq "") {
        sh_log_fatal("No file manager was found - Aborting...");
        return;
    }

    if(-not (sh_dir_exists $target_path)) {
        sh_log_fatal("Invalid path - Aborting...");
        return;
    }

    & $file_manager $target_path;
    return;
}


##
## kill
##
## @XXX(kill): Must change to Get-Process and refactor....
##------------------------------------------------------------------------------
function kill-process()
{
    $process_name = $args[0];
    $result       = (ps x | grep $process_name);
    if($result -is [string]) {
        if($line.Length -eq 0) {
            sh_log_fatal "No process with name: (${process_name})";
            return;
        }

        $result = @() + $result; ## Make it be an array...
    }

    foreach($line in $result) {
        $line = $line.Trim();

        $components = $line.Split(" ");
        $process_id = $components[0];

        sh_log "Killing proccess: (${process_name}) id: (${process_id})";
        kill $process_id -Force
    }
}


