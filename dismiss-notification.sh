#!/bin/bash
# Script to dismiss Privileges notification
# Silently dismisses the notification if it exists

ERROR_OUTPUT=$(osascript <<'EOF' 2>&1
tell application "System Events"
  tell process "NotificationCenter"
    try
      if (window "Notification Center" exists) then
        set mainGroup to first UI element of window "Notification Center"
        set notifGroup to first group of mainGroup
        set scrollArea to first UI element of notifGroup
        set scrollGroup to first group of scrollArea
        set closeAction to first action of scrollGroup whose name contains "Luk" or name contains "Close"
        perform closeAction
      end if
    end try
  end tell
end tell
EOF
)

# Check if there was an error
#if [ $? -ne 0 ] && [ -n "$ERROR_OUTPUT" ]; then
#    echo "Error dismissing notification: $ERROR_OUTPUT" >&2
#fi


