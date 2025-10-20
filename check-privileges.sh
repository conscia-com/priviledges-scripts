#!/bin/bash

# Script to check current privilege status using PrivilegesCLI
# Based on SAP macOS-enterprise-privileges

# Path to Privileges CLI
PRIVILEGES_CLI="/Applications/Privileges.app/Contents/MacOS/PrivilegesCLI"

# Check if Privileges.app is installed
if [[ ! -f "$PRIVILEGES_CLI" ]]; then
    echo "Error: Privileges.app is not installed at /Applications/Privileges.app"
    echo "Please install Privileges first: https://github.com/SAP/macOS-enterprise-privileges"
    exit 1
fi

# Check current status
echo "Checking privilege status..."
"$PRIVILEGES_CLI" --status

# Get detailed user info
echo ""
echo "Current user: $(whoami)"
if groups $(whoami) | grep -q '\badmin\b'; then
    echo "User is currently in the admin group ✓"
else
    echo "User is NOT in the admin group"
fi

