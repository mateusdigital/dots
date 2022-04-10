$PROMPT_DEBUG = $false;


##
## Public Functions
##

##------------------------------------------------------------------------------
function global:prompt
{
    if($PROMPT_DEBUG) {
        return "$ "
    } else {
        return _make_prompt;
    }
}

##------------------------------------------------------------------------------
function _make_prompt()
{
    $ps1 = (_ps1);

    $v = $ps1.ForEach({$_.text});
    $v = (sh_join_string " | " $v);
    $v = "$v`n:) ";

    return $v;
}

##------------------------------------------------------------------------------
function _ps1()
{
    ##
    ## History
    ##

    $history = (Get-History);
    if($history.Count) {
        $last_history = $history[-1];

        $status_cmd       = $last_history.CommandLine.Trim();
        $status_last_exit = (sh_value_or_default $args[0] 0);
        $status_duration  = $last_history.Duration.TotalMilliseconds;
    } else {
        $history = $null;
    }

    ##
    ## Cwd
    ##

    $cwd = (Get-Location).Path;

    ##
    ## Git
    ##

    $git = (git status -sbu 2> /dev/null);
    if($git) {
        ## make array...
        if($git -is [string]) {
            $git = @($git);
        }

        ## Branch Names
        $line_comps = $git[0].Replace("]", "").Replace("[", "").Split(" ")[1..1000]
        $branches   = $line_comps[0].Trim().Split("...");

        $git_local_branch  = $branches[0].Trim();
        $git_remote_branch = if($branches.Count -gt 1) { $branches[1].Trim() };

        ## Ahead / Behind
        $git_remote_push = 0;
        $git_remote_pull = 0;

        for($i = 1; $i -lt $line_comps.Count; $i += 1) {
            $comp = $line_comps[$i];
            if($comp -eq "ahead") {
                $i += 1;
                $git_remote_push = [int]$line_comps[$i];
            } elseif($comp -eq "behind") {
                $i += 1;
                $git_remote_pull = [int]$line_comps[$i];
            }
        }

        ## Suno
        $git_suno_added     = 0;
        $git_suno_deleted   = 0;
        $git_suno_edited    = 0;
        $git_suno_untracked = 0;

        for($i = 1; $i -lt $git.Count; $i += 1) {
            $line = $git[$i].Trim();
            if($line[0] -eq "A") { $git_suno_added     += 1; }
            if($line[0] -eq "D") { $git_suno_deleted   += 1; }
            if($line[0] -eq "M") { $git_suno_edited    += 1; }
            if($line[0] -eq "?") { $git_suno_untracked += 1; }
        }

        ## Tag
        $git_tag = (git describe --tags --abbrev=0);
        $git_remote_push = 1;
        $git_remote_pull = 1;
    }


    return @(
        @{
            text = " ($cwd)";
        },
        @{
            text = if($git) {
                $v = "$git_local_Branch ";
                $v += if($git_suno_added) {
                    " $git_suno_added "
                }
                $v += if($git_suno_edited) {
                    " $git_suno_edited "
                }
                $v += if($git_suno_deleted) {
                    " $git_suno_deleted "
                }

                $v = $v.Trim();
                " ($v)";
            }
        },
        @{
            text = if($git_tag) {
                " ($git_tag)"
            }
        },
        @{
            text = if($git) {
                $v = "";
                $v += if($git_remote_push) { "$git_remote_push " }
                $v += if($git_remote_pull) { "$git_remote_pull " }
                $v = $v.Trim();

                if($v) {
                    " ($v)";
                }
            }
        },
        @{
            text = if($history) {
                $v = "";
                if($status_last_exit -ne 0) {
                    $v += " ($status_last_exit) "
                }
                if($status_duration -ne 0) {
                    $v += " ($status_duration) "
                }

                $v.Trim();
            }
        }
    )
}

##------------------------------------------------------------------------------
if($PROMPT_DEBUG) {
    . "$HOME/.stdmatt/lib/shlib/shlib.ps1"
    . "$HOME/.config/powershell/git.ps1"

    _make_prompt;
}

##------------------------------------------------------------------------------
(sh_log_verbose (sh_get_script_filename))
