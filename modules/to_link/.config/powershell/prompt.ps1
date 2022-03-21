# . "$HOME/.stdmatt/lib/shlib/shlib.ps1"
## . "$HOME/.config/powershell/git.ps1"

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


    $git = _make_git;
    return (sh_join_string "" @(
        $(sh_ansi_hex_color ""             "FF00FF"), ## actually is fg
        (sh_ansi_hex_color "$git" "000000"  "FF00FF"),
        $(sh_ansi_hex_color ""             "FF00FF")  ## actually is fg
    ))
}

function _make_git()
{
    $git_result = (git status -sb 2> /dev/null);
    if(-not $?) {
        return;
    }

    $names  = $git_result[0].Replace("#", "").Replace("...", ";").Split(";");
    $local  = $names[0].Trim();
    $remote = $names[1].Trim();

    ##
    ## Branch
    ##

    $local_str = " $local";

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

    $suno += if($A) { "都 ${A} " };
    $suno += if($M) { " ${M} " };
    $suno += if($D) { "逸 ${D} " };

    $suno = $suno.Trim();

    ##
    ## Ahead / Behind
    ##

    $ahead_behind = "";
    if($remote) {
        $git_result = (git rev-list --left-right --count ${local}...${remote});
        if($?) {
            $split  =  $git_result.Split("`t");
            $ahead  = $split[0];
            $behind = $split[1];

            $ahead_behind = "摒 $ahead/$behind";
        }
    }

    ##
    ## Tags
    ##
    $tag  = (git describe --tags (git rev-list --tags --max-count=1) 2> $null);

    return "${local} ${suno} ${ahead_behind}";
}
