#!/bin/bash

# Strix OS Package Manager Core
# This script handles the core package management functionality

# Locations
STRIX_ROOT=~/strix-os
DB_DIR=$STRIX_ROOT/.strix_db
MODULES_DIR=$STRIX_ROOT/modules
INSTALLED_DB=$DB_DIR/installed.list
LOCK_FILE=$DB_DIR/manager.lock

# Initialize database if it doesn't exist
function init_db() {
    mkdir -p $DB_DIR
    touch $INSTALLED_DB
}

# Lock the manager to prevent concurrent operations
function lock_manager() {
    if [ -f "$LOCK_FILE" ]; then
        echo "Another strix manager operation is in progress. Please try again later."
        exit 1
    fi
    touch $LOCK_FILE
}

# Unlock the manager
function unlock_manager() {
    if [ -f "$LOCK_FILE" ]; then
        rm $LOCK_FILE
    fi
}

# Register a module as installed
function register_module() {
    MODULE=$1
    init_db
    lock_manager
    
    # Check if module is already registered
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        echo "Module $MODULE is already registered."
    else
        echo "$MODULE" >> $INSTALLED_DB
        echo "Module $MODULE registered successfully."
    fi
    
    unlock_manager
}

# Unregister a module (mark as uninstalled)
function unregister_module() {
    MODULE=$1
    init_db
    lock_manager
    
    # Check if module is registered
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        grep -v "^$MODULE$" $INSTALLED_DB > $INSTALLED_DB.tmp
        mv $INSTALLED_DB.tmp $INSTALLED_DB
        echo "Module $MODULE unregistered successfully."
    else
        echo "Module $MODULE is not registered."
    fi
    
    unlock_manager
}

# Check module installation status
function module_status() {
    MODULE=$1
    init_db
    
    # Check if module exists
    if [ ! -d "$MODULES_DIR/$MODULE" ]; then
        echo "Module $MODULE not found in repository."
        return
    fi
    
    # Check if module is installed
    if grep -q "^$MODULE$" $INSTALLED_DB; then
        echo "Module $MODULE is installed."
    else
        echo "Module $MODULE is available but not installed."
    fi
    
    # Display module information if available
    if [ -f "$MODULES_DIR/$MODULE/info.txt" ]; then
        echo "--- Module Information ---"
        cat "$MODULES_DIR/$MODULE/info.txt"
    fi
}

# List all installed modules
function list_installed() {
    init_db
    echo "Installed modules:"
    cat $INSTALLED_DB
}

# Check for module dependencies
function check_dependencies() {
    MODULE=$1
    DEP_FILE="$MODULES_DIR/$MODULE/dependencies.txt"
    
    if [ -f "$DEP_FILE" ]; then
        echo "Checking dependencies for $MODULE..."
        while read -r dep; do
            if ! grep -q "^$dep$" $INSTALLED_DB; then
                echo "Dependency $dep is required but not installed."
                echo "Install it using: strix install $dep"
            fi
        done < "$DEP_FILE"
    fi
}

# Command actions
case "$1" in
    register)
        if [ -z "$2" ]; then
            echo "Please specify a module to register."
        else
            register_module $2
        fi
        ;;
    unregister)
        if [ -z "$2" ]; then
            echo "Please specify a module to unregister."
        else
            unregister_module $2
        fi
        ;;
    status)
        if [ -z "$2" ]; then
            echo "Please specify a module to check status."
        else
            module_status $2
        fi
        ;;
    list-installed)
        list_installed
        ;;
    check-deps)
        if [ -z "$2" ]; then
            echo "Please specify a module to check dependencies."
        else
            check_dependencies $2
        fi
        ;;
    *)
        echo "Usage: strix-manager.sh {register|unregister|status|list-installed|check-deps} <module>"
        ;;
esac
