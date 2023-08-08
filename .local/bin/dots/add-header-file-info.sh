#!/bin/bash

## export GIT_TO_USE=""; add-header-file-info.sh

readonly fullpath="$1";
readonly directory=$(dirname "$fullpath");
readonly filename=$(basename "$fullpath");
readonly extension="${fullpath##*.}"

echo "fullpath: $fullpath";
echo "directory: $directory";
echo "filename: $filename";
echo "extension: $extension";

if [ -z "$GIT_TO_USE" ]; then
    GIT_TO_USE="git";
fi

echo "using git: $GIT_TO_USE";
$GIT_TO_USE -C "$directory" rev-parse --is-inside-work-tree;
exit;

if $GIT_TO_USE -C "$directory" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Getting information from git...";

  remote_url=$($GIT_TO_USE  -C "$directory" remote get-url origin);
  project_name=$(basename "$remote_url" .git);

  creation_date=$($GIT_TO_USE -C "$directory" log --diff-filter=A --format="%aI" -- "$filename" | tail -n 1);
  creation_date=$(date -d "$creation_date" "+%Y-%m-%d")

  creation_year=$(date -d "$creation_date" "+%Y")
else
  echo "Getting information from filesystem...";

  project_name=$(basename "$directory");

  if [ -n "$(uname -a | grep -i "Linux")" ]; then
    creation_date=$(stat -c %w "$fullpath");
    creation_date=$(date -d "$creation_date" "+%Y-%m-%d");
  else
    creation_date=$(stat -f %SB -t %F "$fullpath");
    creation_date=$(date -j -f "%b %d %T %Y" "$creation_date" "+%Y-%m-%d");

    creation_year=$(date -j -f "%b %d %T %Y" "$creation_date" "+%Y");
  fi
fi

readonly current_year=$(date "+%Y");
readonly delta=$((current_year - creation_year));

echo "current_year: $current_year";
echo "delta:        $delta";

if [ "$delta" -eq "$current_year" ] || [ "$delta" -eq 0 ]; then
  copyright="mateus.digital - $current_year";
elif [ "$delta" -lt 3 ]; then
  copyright="mateus.digital - $creation_year, $current_year";
else
  copyright="mateus.digital - $creation_year - $current_year";
fi

case "$extension" in
    cpp)
        comment_start="//"; comment_end="//"; ;;
    sh)
        comment_start="##"; comment_end="##"; ;;
    html)
        comment_start="<!-- "; comment_end=" -->"; ;;
esac



echo "File Name: $filename"
echo "Project Name: $project_name"
echo "Comments : $comment_start $comment_end";
# Template text
template="~---------------------------------------------------------------------------
                               *       +
                         '                  |
                     ()    .-.,=\"\`\`\"=.    - o -
                           '=/_       \     |
                        *   |  '=._    |
                             \     \`=./\`,        '
                          .   '=.__.=' \`='      *
                 +                         +
                      O      *        '       .

  File      : \$filename
  Project   : \$project
  Date      : \$date
  License   : GPLv3
  Author    : mateus.digital <hello@mateus.digital>
  Copyright : \$copyright

  Description :


---------------------------------------------------------------------------~"

output="${template/\$filename/$filename}"
output="${output/\$project/$project_name}"
output="${output/\$date/$creation_date}"
output="${output/\$copyright/$copyright}"

formatted_output=""
while IFS= read -r line; do
  formatted_line=$(printf "%-76s" "$line")
  echo "${comment_start}${formatted_line}${comment_end}"
done <<< "$output"
