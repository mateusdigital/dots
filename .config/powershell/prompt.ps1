$PROMPT_DEBUG = $false;
# $PROMPT_DEBUG = $true;

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
    $ps1 = (_ps1 $LASTEXITCODE);

    $v = $ps1.ForEach({$_.text});
    $v = (sh_join_string " " $v);
    $v = "$v`n:) ";

    return $v;
}

##------------------------------------------------------------------------------
function _ps1()
{
    ##
    ## History
    ##

    $status_last_exit = $args[0];

    $history = (Get-History);
    if($history.Count) {
        $last_history = $history[-1];

        $status_cmd       = $last_history.CommandLine.Trim();
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
    }

    $Gray         = (sh_ansi_color_hex "#808080");
    $Violet       = (sh_ansi_color_hex "#646695");
    $Blue         = (sh_ansi_color_hex "#569CD6");
    $DarkBlue     = (sh_ansi_color_hex "#223E55");
    $LightBlue    = (sh_ansi_color_hex "#9CDCFE");
    $Green        = (sh_ansi_color_hex "#6A9955");
    $BlueGreen    = (sh_ansi_color_hex "#4EC9B0");
    $LightGreen   = (sh_ansi_color_hex "#B5CEA8");
    $Red          = (sh_ansi_color_hex "#F44747");
    $Orange       = (sh_ansi_color_hex "#CE9178");
    $LightRed     = (sh_ansi_color_hex "#D16969");
    $YellowOrange = (sh_ansi_color_hex "#D7BA7D");
    $Yellow       = (sh_ansi_color_hex "#DCDCAA");
    $Pink         = (sh_ansi_color_hex "#C586C0");
    $Silver       = (sh_ansi_color_hex "#C0C0C0");
    $reset        = (sh_ansi_color     "0");

    return @(
        @{
            text = if($cwd) {
                $os_icon = if($IsMacOS)   { "" }
                       elseif($IsLinux)   { "" }
                       elseif($IsWindows) { "" };

                "${Pink}${os_icon} ${Silver}(${cwd})";
            }
        },
        @{
            text = if($git) {
                $v = "$git_local_Branch ";
                $v += if($true -and $git_suno_added) {
                    "${Green} $git_suno_added "
                }
                $v += if($true -and $git_suno_edited) {
                    "${YellowOrange} $git_suno_edited "
                }
                $v += if($true -and $git_suno_deleted) {
                    "${LightRed} $git_suno_deleted "
                }

                $v = $v.Trim();
               "${Blue} ${Silver}(${v}${Silver})";
            }
        },
        @{
            text = if($git_tag) {
                "${Violet} ${Silver}($git_tag)"
            }
        },
        @{
            text = if($git) {
                $v = "";
                $v += if($git_remote_push) { "${Green}${Silver}$git_remote_push " }
                $v += if($git_remote_pull) { "${Red}${Silver}$git_remote_pull " }
                $v = $v.Trim();

                if($v) {
                    "${LightBlue} $Silver($v)";
                }
            }
        },
        @{
            text = if($history) {
                $v = "";

                if($status_last_exit -ne 0 -and $status_last_exit -ne 128) {
                    $v += "${LightRed} ($status_last_exit){ ${Silver}${status_cmd}${LightRed} } "
                }

                if($status_duration -ne 0) {
                    $c =     if($status_duration -lt 300) { $LightGreen }
                         elseif($status_duration -lt 600) { $Yellow     }
                           else                           { $LightRed   }
                    $v += "${c} ${Silver}($status_duration) "
                }

                $v.Trim();
            }
        }
    )
}

##------------------------------------------------------------------------------
if($PROMPT_DEBUG) {
    . "$HOME/.stdmatt/lib/shlib/shlib.ps1"
    . "$HOME/.stdmatt/lib/rainbow/rainbow.ps1"
    . "$HOME/.config/powershell/git.ps1"

    _make_prompt;
}
