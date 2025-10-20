#!/bin/bash

# Script to remove admin privileges using PrivilegesCLI
# Based on SAP macOS-enterprise-privileges

# Path to Privileges CLI
PRIVILEGES_CLI="/Applications/Privileges.app/Contents/MacOS/PrivilegesCLI"

# Check if Privileges.app is installed
if [[ ! -f "$PRIVILEGES_CLI" ]]; then
    echo "Error: Privileges.app is not installed at /Applications/Privileges.app"
    echo "Please install Privileges first: https://github.com/SAP/macOS-enterprise-privileges"
    exit 1
fi

# Remove admin privileges
echo "Removing administrator privileges..."
"$PRIVILEGES_CLI" --remove

# Check the result
if [[ $? -eq 0 ]]; then
    echo "✓ Administrator privileges removed successfully"

    # Dismiss notification after 3 seconds
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    (sleep 3 && "$SCRIPT_DIR/dismiss-notification.sh") &

    # Show current status
    echo ""
    echo "Current privilege status:"
    "$PRIVILEGES_CLI" --status
else
    echo "✗ Failed to remove administrator privileges"
    exit 1
fi

