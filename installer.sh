#!/bin/bash

echo "Installing JobCounter Auto-Refresher..."

# 1. Create hidden working directory
mkdir -p ~/.jobcounter

# 2. Get the current directory path safely handling spaces
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_PATH="$PROJECT_DIR/JobCounter.xcodeproj"

# 3. Create the refresh execution script
cat << 'EOF' > ~/.jobcounter/refresh_jobcounter.sh
#!/bin/bash
PROJECT_PATH="REPLACE_WITH_PROJECT_PATH"
SCHEME="JobCounter"
APP_DESTINATION="/Applications/JobCounter.app"

echo "[$(date)] Starting JobCounter auto-refresh build..." >> ~/.jobcounter/refresh.log

# Ensure Xcode command line tools path is active
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

xcodebuild -project "$PROJECT_PATH" \
           -scheme "$SCHEME" \
           -configuration Release \
           -derivedDataPath ~/.jobcounter/DerivedData \
           -allowProvisioningUpdates \
           build >> ~/.jobcounter/refresh.log 2>&1

BUILT_APP=$(find ~/.jobcounter/DerivedData -name "JobCounter.app" | head -n 1)

if [ -n "$BUILT_APP" ] && [ -d "$BUILT_APP" ]; then
    rm -rf "$APP_DESTINATION"
    cp -R "$BUILT_APP" "$APP_DESTINATION"
    xattr -cr "$APP_DESTINATION"
    killall NotificationCenter 2>/dev/null || true
    echo "[$(date)] JobCounter successfully re-signed and updated!" >> ~/.jobcounter/refresh.log
else
    echo "[$(date)] Build failed. Check logs above." >> ~/.jobcounter/refresh.log
fi
EOF

# Inject the real project path using @ as a delimiter to prevent path slash/space errors
sed -i '' "s@REPLACE_WITH_PROJECT_PATH@$PROJECT_PATH@g" ~/.jobcounter/refresh_jobcounter.sh
chmod +x ~/.jobcounter/refresh_jobcounter.sh

# 4. Create and load the launchd agent
PLIST_PATH="$HOME/Library/LaunchAgents/com.jobcounter.refresh.plist"

cat << EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jobcounter.refresh</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$HOME/.jobcounter/refresh_jobcounter.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>432000</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Unload previous agent and load new one
launchctl unload "$PLIST_PATH" 2>/dev/null
launchctl load "$PLIST_PATH"

echo "Done! JobCounter will now auto-refresh every 5 days in the background."