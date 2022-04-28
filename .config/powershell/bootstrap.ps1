

##
## Public Functions
##

##------------------------------------------------------------------------------
function install-brew-packages()
{
    param(
        [switch] $Core,
        [switch] $Server,
        [switch] $Work,
        [switch] $All, 
        [switch] $Verbose
    )
    
    $is_verbose = if($Verbose) { "-Verbose" };

    if($All -or $Core) {
        _install_brew "core" $is_verbose;
    }

    if($All -or $Server) {
        _install_brew "server" $is_verbose;
    }

    if($All -or $Work) {
        _install_brew "workstation" $is_verbose;
        _install_brew "casks"       $is_verbose;
    }
}

##------------------------------------------------------------------------------
function update-software()
{
    sh_log -bg "yellow" -fg "black" "This will probably shutdown the computer...";
    if(-not (sh_ask_confirm "Are you sure to continue?")) {
        sh_log -fg "yellow" "Aborting...";
        return;
    }

    if($IsMacOS) {
        ## Mac
        sudo softwareupdate -i -a;
        ## Brew
        brew update;
        brew upgrade;
        brew cleanup;
        ## NPM
        npm install npm -g;
        npm update      -g;
    }
    else {
        sh_log "To implement.."
    }
}

##
## Helper Functions
##

##------------------------------------------------------------------------------
function _install_brew()
{
    param(
        $mode,
        [switch]$Verbose
    );
    
    $os_name    = (sh_get_os_name);
    $filepath   = "${HOME}/.config/${os_name}/brew/brew_${mode}.txt";
    $is_verbose = if($Verbose) { "--verbose" } else { "" };

    if(-not (sh_file_exists $filepath)) {
        sh_log "Ignoring (${filepath})";
        return;
    }

    sh_log "Installing brew ($mode):";

    $brew_formulas = (brew list --formula -1).Split(" ");
    ##$brew_casks    = (brew list --casks   -1);
    

    (Get-Content $filepath).ForEach({
        $name = $_.Trim();
        if($name.Length -eq 0) {
            return;
        }
        
        foreach($formula in $brew_formulas) { 
            if($name -eq $formula.Trim()) { 
                sh_log -fg "yellow" "Formula already installed: ($name)";
                return;
            }
        }
             
        sh_log -fg "blue" "Installing formula: ($name)";

        if($mode -eq "casks") {
            brew install --cask $name $is_verbose;
        } else {
            brew install $name $is_verbose;
        }
    });
}

##------------------------------------------------------------------------------
function update-software()
{
    sh_log -bg "yellow" -fg "black" "This will probably shutdown the computer...";
    if(-not (sh_ask_confirm "Are you sure to continue?")) {
        sh_log -fg "yellow" "Aborting...";
        return;
    }

    if($IsMacOS) {
        ## Mac
        sudo softwareupdate -i -a;
        ## Brew
        brew update;
        brew upgrade;
        brew cleanup;
        ## NPM
        npm install npm -g;
        npm update      -g;
    }
    else {
        sh_log "To implement.."
    }
}
