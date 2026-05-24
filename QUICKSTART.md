# Quick Start Guide

## ✅ Project Setup Complete!

Your AI Brain Assistant Swift project is now created and compiles successfully.

## Project Location

```
~/ai-brain-assistant/
```

## What's Built

✅ **Menu bar app structure** - SwiftUI app with MenuBarExtra  
✅ **Chat interface** - Message bubbles, input field, streaming simulation  
✅ **Service architecture** - ClaudeService, KnowledgeBaseService, MCPService  
✅ **Knowledge base integration** - Reads from ~/knowledge-base/  
✅ **Dependencies** - KeyboardShortcuts package for Phase 2  

## Run the App

### Option 1: Command Line
```bash
cd ~/ai-brain-assistant
swift run
```

### Option 2: Xcode (Recommended)
```bash
cd ~/ai-brain-assistant
open Package.swift
```
Then press `⌘R` to run.

## Current Status: Phase 1 MVP (Partial)

### ✅ Working
- Menu bar icon appears (brain emoji)
- Chat interface with message bubbles
- Text input and send button
- Simulated streaming responses (placeholder)
- Knowledge base path configured

### ⏳ TODO for Full Phase 1
1. **Claude API Integration**
   - Replace placeholder streaming in `ClaudeService.swift`
   - Add API key management (Keychain)
   - Implement real streaming responses

2. **MCP Tool Calling**
   - Implement `MCPService.invokeTool()` to call Claude CLI
   - Parse tool results and pass back to Claude
   - Test with Slack and Calendar tools

3. **Conversation History**
   - Persist messages to local database
   - Load history on app start
   - Implement conversation management

4. **Quick Reference Sections**
   - Add "Urgent Items" collapsible section
   - Add "Upcoming Meetings" section
   - Parse from today's start-day summary

5. **App Icon & Polish**
   - Create proper app icon (brain.png)
   - Add menu bar icon template
   - Error handling improvements

## Test the UI

When you run the app:

1. **Look for the brain emoji** in your menu bar (top-right)
2. **Click it** to open the chat popover
3. **Type a message** like "What should I focus on today?"
4. **See the placeholder response** stream in word-by-word

The response will be a demo message explaining what the app will do once Claude API is integrated.

## Next Development Steps

### 1. Add API Key (Optional for now)
```bash
# Add to your shell profile (~/.zshrc)
export ANTHROPIC_API_KEY="sk-ant-..."
```

### 2. Implement Claude API Integration
Edit `Sources/Services/ClaudeService.swift`:
- Replace AsyncStream placeholder with real Claude API call
- Use `https://api.anthropic.com/v1/messages` endpoint
- Implement streaming via Server-Sent Events

### 3. Test with Real Knowledge Base
The app already tries to read from:
```
~/knowledge-base/context/profile.md
~/knowledge-base/context/work/current-initiatives.md
~/knowledge-base/context/communication/stakeholder-map.md
```

Make sure these files exist and have content.

### 4. Implement MCP Tool Calling
Edit `Sources/Services/MCPService.swift`:
- Invoke Claude CLI: `/Users/rfrancisco/.local/bin/claude mcp call <tool> --params <json>`
- Parse stdout JSON response
- Return results to Claude API

## Architecture Overview

```
AIBrainApp.swift (entry point)
    ↓
AppState.swift (observable state)
    ├── messages: [Message]
    ├── isStreaming: Bool
    └── services:
        ├── ClaudeService (API calls)
        ├── KnowledgeBaseService (read context files)
        └── MCPService (invoke tools)
    ↓
MenuBarView.swift (UI)
    ├── ChatView (message list)
    ├── MessageBubbleView (individual messages)
    └── InputView (text field + send button)
```

## Troubleshooting

### App doesn't appear in menu bar
- Make sure you're running on macOS 14+
- Check Console.app for errors
- Try `swift run` from terminal to see output

### Build errors
```bash
cd ~/ai-brain-assistant
swift package clean
swift build
```

### Knowledge base files not found
Check paths in `Sources/Utilities/Constants.swift` match your setup.

## Resources

- **Plan:** `/Users/rfrancisco/.claude/plans/dreamy-fluttering-moon.md`
- **Knowledge Base:** `/Users/rfrancisco/knowledge-base/`
- **Claude API Docs:** https://docs.anthropic.com/claude/reference/messages-streaming

---

**Ready to code!** Open the project in Xcode and start implementing Phase 1 features.
