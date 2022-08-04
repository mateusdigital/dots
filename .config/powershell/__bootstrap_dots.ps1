$DOTS_BARE_PATH = "${HOME}/.dots_bare"; ## @NOTICE: THE SAME AS IN dots_function.ps1
$DOTS_REPO_URL  = "https://gitlab.com/mateus-earth-personal/dots.git";
$FORCE_INSTALL  = $false;

echo "Bootstraping dots...";
echo "  it will be installed at: ${DOTS_BARE_PATH}";

##
## New installation???
##

if((Test-Path $DOTS_BARE_PATH) -and (-not $FORCE_INSTALL)) { 
    echo "  Already installed...";
    return;
}


##
## Ensure Git...
##

echo "Checking git..."
if($IsWindows) { 
    where.exe git;
    if(-not $?) { 
        winget install --id Git.Git -e --source winget
    }
} else {
    $which_git = (which git);
    if($which_git.Count -eq 0) { 
        if($IsLinux) { 
            sudo apt-get update  -y;
            sudo apt-get upgrade -y;
            sudo apt-get install git;
        } elseif($IsMacOS) { 
            brew install git;
        }
    }
}

echo "Clonning dots...";
git clone $DOTS_REPO_URL --bare "$DOTS_BARE_PATH";
echo "Syncing up...";
git --git-dir="${DOTS_BARE_PATH}" --work-tree="${HOME}" checkout --force;
echo "Done..."


##
## Ensure dependencies 
##
 
##------------------------------------------------------------------------------
$has_shlib       = (Test-Path "${SHLIB_DIR}/shlib.ps1");
$has_ps_readline = (Get-InstalledModule).Name.Contains("PSReadLine");
$has_ps_fzf      = (Get-InstalledModule).Name.Contains("PSFzf");

echo "Installing dependecies...";
if($FORCE_INSTALL -or (-not $has_shlib)) { 
    echo "  Installing shlib...";
    if(-not (Test-Path "${TEMP_DIR}/shlib")) {
        git clone "https://gitlab.com/mateus-earth-libs/pwsh/shlib" "${TEMP_DIR}/shlib";
    }
    
    & "${TEMP_DIR}/shlib/install.ps1";
}

if($FORCE_INSTALL -or (-not $has_ps_readline)) { 
    echo "  Installing PSReadline...";
    Install-Module PSReadLine -AllowPrerelease -Force;
}

if($FORCE_INSTALL -or (-not $has_ps_fzf)) {
    echo "  Installing PSFzf...";

    if(-not (Test-Path "${HOME}/.fzf")) {
        git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf";
    }

    $false | & "${HOME}/.fzf/install" --xdg; ## We don't want to install nothing extra...
    
    echo "    Installing module...";
    Install-Module -Name PSFzf;
}
echo "Done..."