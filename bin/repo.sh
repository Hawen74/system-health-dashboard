#!/bin/bash
#
# repo.sh - Workspace Navigation & Link Management
#
# DESCRIPTION:
#   Resolves the repository location, creates a ~/repo shortcut,
#   and navigates the shell to the repository root.
#
# ----------------------------------------------------------------------

REAL_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$REAL_PATH")
CURRENT_REPO_ROOT=$(dirname "$SCRIPT_DIR")

HOME_SHORTCUT="$HOME/repo"

echo "Refreshing Lab Shortcuts..."

if [ -L "$HOME_SHORTCUT" ]; then
    rm "$HOME_SHORTCUT"
elif [ -d "$HOME_SHORTCUT" ]; then
    echo "⚠️  Warning: Physical directory ~/repo already exists. Skipping link."
fi

ln -sf "$CURRENT_REPO_ROOT" "$HOME_SHORTCUT"

if [ -d "$CURRENT_REPO_ROOT" ]; then
    cd "$CURRENT_REPO_ROOT"
    export REPO_ROOT="$CURRENT_REPO_ROOT"
    # Add bin/ to PATH so scripts can be called by name
    if [[ ":$PATH:" != *":$CURRENT_REPO_ROOT/bin:"* ]]; then
        export PATH="$PATH:$CURRENT_REPO_ROOT/bin"
    fi
fi

echo "✅ Success: ~/repo updated. Current directory: $PWD"