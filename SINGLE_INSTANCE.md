# Single Instance Management

Your AI Brain Assistant now ensures only one instance runs at a time.

## How It Works

**Lock File System:**
- Creates a lock file at `/tmp/aibrain-assistant.lock` with the process ID
- Before starting, checks if another instance is already running
- If a running instance exists, the new one exits immediately
- If a stale lock file exists (process died), it's cleaned up automatically

**Signal Handlers:**
- Catches SIGTERM and SIGINT (Ctrl+C)
- Cleans up lock file on exit

## Usage

### Method 1: Restart Script (Recommended)

```bash
cd ~/ai-brain-assistant
./restart-app.sh
```

This script:
1. Kills any existing instances
2. Cleans up stale lock files
3. Builds the app (if needed)
4. Starts a fresh single instance
5. Verifies it's running

### Method 2: Manual

```bash
# Kill existing instances
pkill -f AIBrainAssistant

# Clean up lock file
rm -f /tmp/aibrain-assistant.lock

# Start fresh
cd ~/ai-brain-assistant
swift run &
```

### Method 3: Double-Click Protection

If you accidentally run `swift run` multiple times, the second instance will automatically detect the first one and exit with:

```
AI Brain Assistant is already running (PID: 12345)
```

## Troubleshooting

### "Already running" but no menu bar icon visible

The lock file may be stale. Clean it up:

```bash
rm -f /tmp/aibrain-assistant.lock
cd ~/ai-brain-assistant
./restart-app.sh
```

### Multiple icons still appear

Kill all instances and restart cleanly:

```bash
pkill -f AIBrainAssistant
rm -f /tmp/aibrain-assistant.lock
cd ~/ai-brain-assistant
./restart-app.sh
```

### Check if it's running

```bash
ps aux | grep AIBrainAssistant | grep -v grep
```

Should show exactly **one** process.

## Auto-Start on Login (Optional)

To make the app start automatically when you log in:

### Option 1: Add to Login Items (GUI)

1. Open **System Settings** → **General** → **Login Items**
2. Click the **+** button under "Open at Login"
3. Navigate to the built app:
   ```
   ~/ai-brain-assistant/.build/arm64-apple-macosx/debug/AIBrainAssistant
   ```
4. Add it

### Option 2: LaunchAgent (Advanced)

Create `~/Library/LaunchAgents/com.aibrain.assistant.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.aibrain.assistant</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/rfrancisco/ai-brain-assistant/.build/arm64-apple-macosx/debug/AIBrainAssistant</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>/tmp/aibrain-assistant.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/aibrain-assistant.log</string>
</dict>
</plist>
```

Then:

```bash
launchctl load ~/Library/LaunchAgents/com.aibrain.assistant.plist
```

To unload:

```bash
launchctl unload ~/Library/LaunchAgents/com.aibrain.assistant.plist
```

## Lock File Details

- **Location:** `/tmp/aibrain-assistant.lock`
- **Contents:** Process ID (PID) of the running instance
- **Cleaned up:** Automatically on normal exit or SIGTERM/SIGINT
- **Stale detection:** If PID doesn't exist, lock file is ignored

## Quick Reference

```bash
# Start/restart cleanly
./restart-app.sh

# Check if running
ps aux | grep AIBrainAssistant | grep -v grep

# Kill all instances
pkill -f AIBrainAssistant

# Clean up lock file
rm -f /tmp/aibrain-assistant.lock
```

---

**From now on, use `./restart-app.sh` whenever you want to ensure a clean single instance is running.**
