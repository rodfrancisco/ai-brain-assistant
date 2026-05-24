#!/bin/bash

# Restart AI Brain Assistant (ensures only one instance)

cd "$(dirname "$0")"

echo "🧠 Restarting AI Brain Assistant..."

# Kill any existing instances
pkill -f AIBrainAssistant
sleep 1

# Clean up any stale lock files
rm -f /tmp/aibrain-assistant.lock

# Build (if needed)
echo "Building..."
swift build --quiet

# Run in background
echo "Starting..."
swift run &

sleep 2

# Verify it's running
if pgrep -f AIBrainAssistant > /dev/null; then
    echo "✅ AI Brain Assistant is now running"
    echo "   Look for the 🧠 icon in your menu bar"
else
    echo "❌ Failed to start. Check for errors above."
fi
