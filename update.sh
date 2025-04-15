#!/bin/bash

# Get the directory of the update script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_URL="https://github.com/theaathish/strix-os.git"
BRANCH="main"

echo "Updating Strix OS..."

# Check if this is a git repository
if [ -d "$SCRIPT_DIR/.git" ]; then
    # It's a git repository, try to update
    echo "Existing repository found. Updating from GitHub..."
    cd "$SCRIPT_DIR"
    
    # Check if remote origin is accessible
    if git ls-remote --exit-code $REPO_URL &>/dev/null; then
        # Try to pull updates
        if git pull origin $BRANCH; then
            echo "Repository updated successfully."
        else
            echo "Error: Could not update the repository."
            echo "Will attempt to re-clone..."
            
            # Backup the .strix_db directory if it exists
            if [ -d "$SCRIPT_DIR/.strix_db" ]; then
                cp -r "$SCRIPT_DIR/.strix_db" /tmp/strix_db_backup
            fi
            
            # Re-clone the repository to a temporary location
            echo "Re-cloning the repository..."
            TMP_DIR=$(mktemp -d)
            if git clone --depth 1 -b $BRANCH $REPO_URL "$TMP_DIR"; then
                # Copy everything except .git from the new clone
                find "$TMP_DIR" -mindepth 1 -maxdepth 1 ! -name ".git" -exec cp -r {} "$SCRIPT_DIR" \;
                
                # Restore the backed-up database
                if [ -d /tmp/strix_db_backup ]; then
                    cp -r /tmp/strix_db_backup "$SCRIPT_DIR/.strix_db"
                    rm -rf /tmp/strix_db_backup
                fi
                
                echo "Repository restored from a fresh clone."
            else
                echo "Error: Failed to clone the repository."
                if [ -d /tmp/strix_db_backup ]; then
                    rm -rf /tmp/strix_db_backup
                fi
                exit 1
            fi
            
            # Clean up
            rm -rf "$TMP_DIR"
        fi
    else
        echo "Warning: Cannot connect to GitHub. Continuing with local files."
    fi
else
    # Not a git repository, clone it
    echo "No git repository found. Cloning from GitHub..."
    
    # Backup the current directory content except .git
    TMP_BACKUP=$(mktemp -d)
    find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 ! -name ".git" -exec cp -r {} "$TMP_BACKUP" \;
    
    # Clone the repository
    cd "$(dirname "$SCRIPT_DIR")"
    if git clone --depth 1 -b $BRANCH $REPO_URL "$(basename "$SCRIPT_DIR")_tmp"; then
        # If clone was successful, move the .git directory
        mv "$(basename "$SCRIPT_DIR")_tmp/.git" "$SCRIPT_DIR/"
        rm -rf "$(basename "$SCRIPT_DIR")_tmp"
        
        # Restore user data from backup
        if [ -d "$TMP_BACKUP/.strix_db" ]; then
            cp -r "$TMP_BACKUP/.strix_db" "$SCRIPT_DIR/"
        fi
        
        echo "Repository cloned successfully."
    else
        echo "Error: Failed to clone the repository."
        # Restore backup
        cp -r "$TMP_BACKUP"/* "$SCRIPT_DIR/"
        echo "Restored original files."
    fi
    
    # Clean up
    rm -rf "$TMP_BACKUP"
fi

# Make scripts executable
find "$SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;

# Re-run setup to ensure everything is up to date
if [ -f "$SCRIPT_DIR/setup.sh" ]; then
    bash "$SCRIPT_DIR/setup.sh"
else
    echo "Error: setup.sh not found. Update may be incomplete."
    exit 1
fi

echo "Strix OS has been updated to the latest version."
