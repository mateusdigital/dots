##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : url_to_pdf.sh                                                 ##
##  Project   : dots                                                          ##
##  Date      : Feb 19, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2019                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Downloads the webpage to a pdf file.                                    ##
##---------------------------------------------------------------------------~##

##---------------------------------------------------------------------------~##
## Functions                                                                  ##
##---------------------------------------------------------------------------~##
##------------------------------------------------------------------------------
url-to-pdf()
{
    local URL="$1";
    local output_path="$(basename "$URL").pdf";

    ##
    ## Log info.
    echo "URL : ${URL}";
    echo "FILE: ${output_path}";
    echo "Downloading...";

    echo "import pdfkit; pdfkit.from_url(\"${URL}\", \"${output_path}\")" | python - > /dev/null
    echo "Done...";
}

##------------------------------------------------------------------------------
open-article()
{
    local owncloud_path="$HOME/ownCloud/articles";
    mkdir -p "$owncloud_path";

    ##
    ## Declare the variables that we gonna need.
    ## Url to download.
    local URL="$1";

    ## Section that the pdf will be saved.
    local section="$2";
    test -z "$section" && \
        section="default_section";

    ## Cleaned up filename - without the .html extension.
    local file_name=$(basename "$URL" | \
        sed s@".htm"@""@g             | \
        sed s@".html"@""@g);

    ## Cleaned up site name - withou the http(s):// and with '.', '/' removed.
    local site_name=$(echo "$URL"  | \
        sed s@"http://www\."@""@g  | \
        sed s@"https://www\."@""@g | \
        sed s@"\/"@"_"@g           | \
        sed s@"\."@"_"@g);

    ## Filename of the output pdf.
    local final_file_name="${file_name}__${site_name}";

    ##
    ## Check if already have this article saved.
    ##   If we don't have save it!
    local found=$(find "$owncloud_path" -iname "$final_file_name");
    local output_path="$owncloud_path/$section/$final_file_name";
    if [ -z "$found" ]; then
        echo "not found";
        mkdir -p "$owncloud_path/$section";
        echo "import pdfkit; pdfkit.from_url(\"${URL}\", \"${output_path}\")" | python - > /dev/null
    else
        output_path="$found";
    fi;

    ## XXX(stdmatt): Only works for OSX right now...
    open "$output_path";
}
