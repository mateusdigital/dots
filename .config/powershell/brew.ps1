
function install-brew-packages()
{
    param(
        [switch] $Server,
        [switch] $Worskstation,
        [switch] $All
    )

    if($All) {
        $Server       = $true;
        $Worskstation = $true;
    };

    ##
    ## Stuff that is installed in all computers.
    ##

    @(
        "atool",
        "curl",
        "coreutils",
        "diffutils",
        "ed",
        "findutils",
        "fzf",
        "git",
        "exa",
        "fd",
        "gawk",
        "grep",
        "libtool",
        "lynx",
        "neovim-qt",
        "ripgrep",
        "tree",
        "vifm",
        "wget"
    ).ForEach({
        $name = $_.Trim();
        brew install $name;
    });


    ##
    ## core + stuff that is installed on server computers.
    ##

    if($Server) {
        $server_setup = @(
            ## Empty...
        ).ForEach({
            $name = $_.Trim();
            brew install $name;
        });
    }


    ##
    ## core + stuff that is installed in my workstations.
    ##

    if($Worskstation) {
        @(
            "automake",
            "cmake",
            "git-gui",
            "gnu-sed",
            "gnu-tar",
            "gource",
            "gtk+3",
            "librsvg",
            "make",
            "ninja",
            "openssl@3",
            "pandoc",
            "peco",
            "rust",
            "rustup-init",
            "yarn",
            "youtube-dl"
        ).ForEach({
            $name = $_.Trim();
            brew install $name;
        });

        ##
        @(
            "alacritty",
            "amethyst",
            "vlc",
            "powershell",
            "transmission"
        ).ForEach({
            $name = $_.Trim();
            brew cask $name;
        });
    }
}
