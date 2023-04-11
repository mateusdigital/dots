
$username = ($env:UserName);
$target_dir = "C:/Users/${username}/AppData/Local/Microsoft/Windows/Fonts";

echo "Installing fonts at: ";
echo "  $target_dir";

function install_font()
{
    $font_path   = $args[0];
    $filename    = (Split-Path -Leaf "$font_path");
    $target_path = "${target_dir}/${filename}";

    if((Test-Path -Path "$target_path")) {
        echo "Font: ($filename) is already installed!";
    } else {
        echo "Font: (${filename}) is installing!";

        $FONTS_OBJ = (New-Object -ComObject Shell.Application).Namespace(0x14);
        $FONTS_OBJ.CopyHere($font_path);

        Copy-Item "$font_path" "$target_path";
    }
}


if($args.Length -gt 1) {
    install_font $args
} else {
    foreach($item in (Get-ChildItem -Recurse "*.ttf")) {
        install_font "$item";
    }
}
