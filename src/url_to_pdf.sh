url-to-pdf()
{
    local URL="$1";
    local output_path="$(basename "$URL").pdf";

    echo "URL : ${URL}";
    echo "FILE: ${output_path}";

    echo "import pdfkit; pdfkit.from_url(\"${URL}\", \"${output_path}\")" | python - > /dev/null
}
