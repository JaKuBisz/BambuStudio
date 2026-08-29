#!/bin/bash
# OpenStudio First Run helper
# ---------------------------
# OpenStudio is distributed unsigned (this fork has no Apple Developer ID
# certificate), so macOS Gatekeeper blocks the first launch with
# "OpenStudio cannot be opened" / "the app is damaged".
#
# Double-clicking THIS file once removes the quarantine flag from the
# installed app and launches it. Afterwards OpenStudio behaves like any
# normal app: double-click, Spotlight, Dock.
#
# If macOS blocks this helper itself, right-click it and choose "Open" once.

set -e

APP="/Applications/OpenStudio.app"

if [ ! -d "$APP" ]; then
    # Not installed yet — offer to copy it from the dmg window this file
    # lives in (the script sits next to OpenStudio.app in the dmg).
    DMG_APP="$(cd "$(dirname "$0")" && pwd)/OpenStudio.app"
    if [ -d "$DMG_APP" ]; then
        echo "Copying OpenStudio.app to /Applications ..."
        cp -R "$DMG_APP" /Applications/
    else
        echo "OpenStudio.app was not found in /Applications."
        echo "Drag OpenStudio.app onto the Applications folder first,"
        echo "then double-click this file again."
        read -r -p "Press Return to close..."
        exit 1
    fi
fi

# Remove only the quarantine attribute (leave everything else untouched).
xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true

echo "Done. Launching OpenStudio ..."
open "$APP"
