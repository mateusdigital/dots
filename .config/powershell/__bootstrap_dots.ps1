$DOTS_BARE_PATH = "${HOME}/.dots_bare"; ## @NOTICE: THE SAME AS IN dots_function.ps1
$DOTS_REPO_URL  = "https://gitlab.com/mateus-earth-personal/dots.git";
$FORCE_INSTALL  = $false;

echo "Bootstraping dots...";
echo "  it will be installed at: ${DOTS_BARE_PATH}";


## New installation???
if((Test-Path $DOTS_BARE_PATH) -and (-not $FORCE_INSTALL)) { 
    echo "  Already installed...";
    return;
}


## Ensure Git...
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

echo "done..."