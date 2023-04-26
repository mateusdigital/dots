#!/usr/bin/env bash
readonly SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Get the app name from user input
read -p "Enter app name: " app_name

npx create-next-app $app_name
cd $app_name

mkdir pages/static
touch pages/static/example.js

export default Example" > pages/static/example.js
npm run build
mkdir out
npm run export -- -o out

echo "New Next.js app created successfully!"
