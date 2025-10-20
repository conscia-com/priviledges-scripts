# Privileges Automation Scripts

These scripts automate the management of administrator privileges on macOS using
the [SAP Privileges](https://github.com/SAP/macOS-enterprise-privileges) app.

## Prerequisites

1. Install Privileges.app from: https://github.com/SAP/macOS-enterprise-privileges/releases
2. Place the app in `/Applications/Privileges.app`

## Permission requirements

If you want the script to remove the MacOS notification automatically you need to allow the terminal take actions on
your behalf. DO THIS WITH CAUTION! You will be prompted to allow this the first time you run the script.

## Scripts

### get-privileges.sh

Requests administrator privileges for the current user.

```bash
./get-privileges.sh [reason]
```

**Arguments:**

- `reason` (optional): Reason for requesting privileges. Defaults to "Update software" if not provided.

**Examples:**

```bash
# Use default reason "Update software"
./get-privileges.sh

# Provide a custom reason
./get-privileges.sh "Installing new packages"
./get-privileges.sh "System maintenance"
```

**Features:**

- Automatically dismisses the Privileges notification after 3 seconds
- Shows current privilege status after granting access
- Returns exit code 0 on success, 1 on failure

### remove-privileges.sh

Removes administrator privileges from the current user.

```bash
./remove-privileges.sh
```

**Features:**

- Automatically dismisses the Privileges notification after 3 seconds
- Shows current privilege status after removing access
- Returns exit code 0 on success, 1 on failure

### check-privileges.sh

Checks the current privilege status of the user.

```bash
./check-privileges.sh
```

**Features:**

- Shows PrivilegesCLI status output
- Displays current username
- Indicates whether user is currently in the admin group

## Making Scripts Executable

Before running the scripts, make them executable:

```bash
chmod +x get-privileges.sh
chmod +x remove-privileges.sh
chmod +x check-privileges.sh
```

## Links

- Documentation: https://github.com/SAP/macOS-enterprise-privileges/wiki/Managing-Privileges
- GitHub: https://github.com/SAP/macOS-enterprise-privileges
  #!/bin/bash

## TL;DR:

### PrivilegesCLI Command Reference

Based on the official documentation, the PrivilegesCLI supports:

- `--add` or `-a`: Add user to admin group
- `--remove` or `-r`: Remove user from admin group
- `--status`: Check current privilege status
- `--version`: Show version information
- `--reason "text"`: Provide a reason for requesting privileges (if ReasonRequired is enabled)

### Configuration Options

The behavior of Privileges can be controlled via configuration profiles. Key settings include:

- **ExpirationInterval**: Set timeout for admin privileges
- **RequireAuthentication**: Require password/Touch ID to get admin rights
- **AllowCLIBiometricAuthentication**: Allow biometric auth in CLI
- **ReasonRequired**: Require users to provide a reason
- **AllowPrivilegeRenewal**: Allow renewing expiring privileges
- **RenewalCustomAction**: Custom script to run when privileges are about to expire

### Custom Renewal Script Example

Here's an example from the documentation for a custom renewal action that shows a dialog:

```bash
#!/bin/bash

privilegesPath="/Applications/Privileges.app"

buttonPressed=$(/usr/bin/osascript << EOF
tell application "System Events"
try
activate
display dialog "Your administrator privileges are about to expire. Do you want to renew them?" with \
icon (get first file of folder "${privilegesPath%%/}/Contents/Resources" whose name extension is "icns") \
buttons {"Cancel", "Renew"} default button 2 giving up after 60
return (button returned of the result)
end try
end tell
EOF
)

if [[ "$buttonPressed" = "Renew" ]]; then
   "${privilegesPath%%/}/Contents/MacOS/PrivilegesCLI" -a
fi

exit 0
```

### Path to Privileges CLI

`PRIVILEGES_CLI="/Applications/Privileges.app/Contents/MacOS/PrivilegesCLI"`

### Check if Privileges.app is installed

```
if [[ ! -f "$PRIVILEGES_CLI" ]]; then
    echo "Error: Privileges.app is not installed at /Applications/Privileges.app"
    echo "Please install Privileges first: https://github.com/SAP/macOS-enterprise-privileges"
    exit 1
fi
```

### Request admin privileges

```
echo "Requesting administrator privileges..."
"$PRIVILEGES_CLI" --add
```

### Check the result

```
if [[ $? -eq 0 ]]; then
    echo "✓ Administrator privileges granted successfully"
    
    # Show current status
    echo ""
    echo "Current privilege status:"
    "$PRIVILEGES_CLI" --status
else
    echo "✗ Failed to obtain administrator privileges"
    exit 1
fi
```


