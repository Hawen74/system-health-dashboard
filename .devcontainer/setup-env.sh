#!/bin/bash
#
# setup-env.sh - Environment Tethering & Permission Sync
#
# DESCRIPTION:
#   Tethers the repository to ~/.bashrc and ensures all scripts
#   in bin/ are executable. Safe to run multiple times.
#
# USAGE:
#   ./.devcontainer/setup-env.sh
#
# ----------------------------------------------------------------------

REPO_DIR=$(pwd)

echo "--- 🛰️  Configuring Lab Workspace ---"

tether_bashrc() {
    local tether_block
    tether_block=$(cat <<EOF
# --- Health Dashboard Env Setup (Added $(date +'%Y-%m-%d')) ---
export REPO_ROOT="$REPO_DIR"
if [ -d "\$REPO_ROOT" ]; then
    export PATH="\$PATH:\$REPO_ROOT/bin"
    [ -f "\$REPO_ROOT/.bashrc" ] && . "\$REPO_ROOT/.bashrc"
fi
# -------------------------------------------------------
EOF
)

    if [ -f ~/.profile ] && ! grep -q "source ~/.bashrc" ~/.profile; then
        echo -e "\nif [ -n \"\$BASH_VERSION\" ]; then\n    [ -f ~/.bashrc ] && . ~/.bashrc\nfi" >> ~/.profile
    fi

    if ! grep -q "REPO_ROOT=\"$REPO_DIR\"" ~/.bashrc; then
        echo "$tether_block" >> ~/.bashrc
        echo "✅ Success: Repository tethered to ~/.bashrc"
    else
        echo "ℹ️  System: ~/.bashrc is already configured."
    fi
}

sync_bin_permissions() {
    echo "🔧 Synchronizing script permissions..."
    if [ -d "$REPO_DIR/bin" ]; then
        chmod ug+x "$REPO_DIR/bin/"*.sh
        echo "✅ Success: All scripts in bin/ are now executable."
    else
        echo "⚠️  Warning: bin/ directory not found."
    fi
}

tether_bashrc
sync_bin_permissions

echo "--- ✅ Workspace Setup Complete ---"