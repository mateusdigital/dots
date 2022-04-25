##
## Private Functions
##

##------------------------------------------------------------------------------
function install-brew-packages()
{
    param(
        [switch] $Server,
        [switch] $Worskstation,
        [switch] $All
    )

    _install_brew "core";

    if($All -or $Server) {
        _install_brew "server";
    }

    if($All -or $Workstation) {
        _install_brew "workstation";
        _install_brew "casks";
    }
}

##------------------------------------------------------------------------------
function update-software()
{
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
function _install_brew($mode)
{
    $os_name  = (sh_get_os_name);
    $filepath = "${HOME}/.config/${os_name}/brew_${mode}.txt";

    if(-not (sh_file_exists $filepath)) {
        sh_log "Ignoring $filepath";
        return;
    }

    sh_log "Installing brew ($mode):";
    (Get-Content $filepath).ForEach({
        $name = $_.Trim();
        if($name.Length -eq 0) {
            return;
        }

        if($mode -eq "casks") {
            brew install --cask $name;
        } else {
            brew install $name;
        }
    });
}

