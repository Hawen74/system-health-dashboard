#!/bin/bash
#
# install-tools.sh - System Package & Bootstrap Initializer
#
# DESCRIPTION:
#   Installs core Linux utilities required for the health-check script
#   and sets initial permissions for setup scripts.
#
# USAGE:
#   ./.devcontainer/install-tools.sh
#
# ----------------------------------------------------------------------

set -e

echo "--- 🛠️  Starting Post-Create Tool Installation ---"

install_packages() {
    echo "📦 Updating package lists and installing utilities..."
    sudo apt-get update
    sudo apt-get install -y \
        git \
        vim \
        tree \
        procps \
        bc
}

bootstrap_permissions() {
    echo "🔑 Bootstrapping script permissions..."
    chmod +x ./bin/repo.sh
    chmod +x ./.devcontainer/setup-env.sh
}

install_packages
bootstrap_permissions

echo "--- ✅ Tool Installation Complete ---"