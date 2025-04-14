#!/bin/bash

# Get the directory of the update script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fetch the latest updates from the GitHub repository
cd "$SCRIPT_DIR"
git pull origin main

# Re-run setup to ensure everything is up to date
bash "$SCRIPT_DIR/setup.sh"

echo "Strix OS has been updated to the latest version."
