
##
## Public Functions
##

##------------------------------------------------------------------------------
function global:prompt
{
   return _make_prompt;
}


##
## Private Functions
##

##------------------------------------------------------------------------------
function _make_prompt()
{
    $cwd = (Get-Location).Path;
    $prompt       = ":)";
    $os_name      = (sh_get_os_name);

    return (sh_join_string "" @(
        $(sh_ansi_hex_color ""             "FF00FF"), ## actually is fg
        (sh_ansi_hex_color "$cwd" "000000"  "FF00FF"),
        $(sh_ansi_hex_color ""             "FF00FF"), ## actually is fg
    ))
}

function _make_git()
{
    $branch_name = (git-get-branch-name);
    if(-not $branch_name) {
        return "";
    }

    ##
    ## Branch
    ##

    $branch = " $branch_name";

    ##
    ## Collect status info
    ##

    $suno = "";

    $A = 0; $M = 0; $D = 0;
    foreach($line in (git status -suno)) {
        $line = $line.Trim();
        if($line[0] -eq "A") { $A += 1; }
        if($line[0] -eq "M") { $M += 1; }
        if($line[0] -eq "D") { $D += 1; }
    }

    $suno += if($A) { "都${A} " };
    $suno += if($M) { " ${M} " };
    $suno += if($D) { "逸${D} " };

    ##
    ## Ahead / Behind
    ##

    $names = (git branch --all | grep "macos_port");
    if($names.Count -eq 2) {
        ## @notice(git): git in my setup always give the output of
        ##   branch/name
        ##   remotes/origin/branch/name
        ## But I don't know if this origin is some convetion that might
        ## change and break the script - Which I assume that is, because
        ## when you add upstream it becomes another "remote"
        ##
        ## Well, I need to study it more, but no matter what this will
        ## bulletproof it anyways
        ##
        ##      - stdmatt - 22-03-19 at 22:34
        $names = $names.Remove($branc_name);
        $remote_clean_name = $names[0];

        $result = (git rev-list --left-right --count ${branch_name}...${remote_clean_name})

        $result = $result.Trim();
    }

    ##
    ## Tags
    ##
    $tag  = (git describe --tags (git rev-list --tags --max-count=1) 2> $null);
    $git_line = "${branch} ${suno}";
}
