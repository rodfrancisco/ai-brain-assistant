# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI Brain Assistant is a macOS menu bar app that acts as a personal AI assistant with full access to the user's work context. Built with SwiftUI and Swift Package Manager, it integrates with Claude API (via Salesforce Bedrock) and loads comprehensive context from a knowledge base to provide intelligent, context-aware assistance.

## Technology Stack

- **Language:** Swift 5.9+
- **Platform:** macOS 14+
- **UI Framework:** SwiftUI with MenuBarExtra
- **Package Manager:** Swift Package Manager
- **Dependencies:** KeyboardShortcuts (for future keyboard shortcut support)
- **API:** Claude Sonnet 4.5 via Salesforce Bedrock Gateway

## Architecture

### Core Components

The app follows a clean separation between UI, services, and models:

**App Layer** (`Sources/App/`)
- `AIBrainApp.swift` - Main entry point with `@main` attribute
- `AppState.swift` - Observable state management (messages, streaming state, services)

**Services Layer** (`Sources/Services/`)
- `ClaudeService.swift` - Claude API integration with streaming support
  - Manages conversation history
  - Builds system prompts with knowledge base context
  - Handles Bedrock API calls with proper authentication
- `KnowledgeBaseService.swift` - Loads context files from `~/knowledge-base/`
  - Profile, current initiatives, stakeholder map
  - Tone of voice, technical domains
  - Daily summaries (start-day-YYYY-MM-DD.md)
- `MCPService.swift` - Placeholder for MCP tool calling (not yet implemented)

**Views Layer** (`Sources/Views/`)
- `MenuBarView.swift` - Main chat interface in menu bar popover
- `MessageBubbleView.swift` - Individual message rendering

**Models Layer** (`Sources/Models/`)
- `Message.swift` - Message data model (role, content, streaming state)

### Key Design Patterns

1. **Streaming Responses:** Uses Swift `AsyncStream` to stream Claude API responses word-by-word
2. **Knowledge Base Context:** Every conversation loads 6+ context files (~40KB) to provide personalized responses
3. **Conversation History:** Maintains in-memory conversation history for multi-turn conversations
4. **Bedrock Authentication:** Uses Salesforce internal gateway with certificate-based auth (no API key needed)

### Authentication & Network

**Salesforce Internal Only:**
- Endpoint: `https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/v1/messages`
- Model: `us.anthropic.claude-sonnet-4-5-20250929-v1:0`
- Auth Token: Hardcoded in `ClaudeService.swift` (line 36)
- Requires: Salesforce VPN or network connection

## Common Development Tasks

### Building and Running

```bash
# Build the project
swift build

# Run the app
swift run

# Or run with convenience script
./restart-app.sh

# Open in Xcode
open Package.swift
```

### Testing

```bash
# Run all tests
swift test

# Run specific test
swift test --filter AIBrainAssistantTests.testExample
```

### Key File Locations

**Knowledge Base Context Files** (external to repo):
- `~/knowledge-base/context/profile.md` - User profile
- `~/knowledge-base/context/work/current-initiatives.md` - Active projects
- `~/knowledge-base/context/communication/stakeholder-map.md` - Stakeholders
- `~/knowledge-base/context/tone-of-voice.md` - Communication style
- `~/knowledge-base/context/work/technical-domains.md` - Technical expertise
- `~/knowledge-base/summaries/daily/start-day-YYYY-MM-DD.md` - Daily summary

**System Prompt Template:**
- `Resources/Prompts/system-prompt.md` - Reference template (actual prompt built in `ClaudeService.buildSystemPrompt()`)

## Development Guidelines

### When Modifying ClaudeService

- Conversation history is maintained in `conversationHistory` array
- System prompt is rebuilt on every message (includes fresh knowledge base context)
- Streaming uses Server-Sent Events (SSE) format: `data: {...}\n\n`
- Handle both `content_block_delta` events (text chunks) and `[DONE]` message
- Connection timeout is 30 seconds, resource timeout is 5 minutes

### When Adding New Context Sources

1. Add loading method to `KnowledgeBaseService`
2. Call from `ClaudeService.buildSystemPrompt()`
3. Include in system prompt with clear section header
4. Update `KNOWLEDGE_BASE_CONTEXT.md` documentation

### When Working with UI

- `AppState` is `@MainActor` - all UI updates must be on main actor
- Use `@Published` properties for reactive updates
- Streaming messages have `isStreaming: true` flag
- Cancel previous task before starting new message

### Error Handling

- Network errors surface in UI as error messages
- Always check for Salesforce VPN connection
- Provide actionable error messages (e.g., "Check VPN connection")
- Timeout errors suggest network connectivity issues

## Current Implementation Status

### ✅ Implemented (Phase 1 Partial)
- Menu bar app with chat interface
- Claude API integration with streaming
- Knowledge base context loading (6 context files)
- Conversation history management
- Message bubble UI with user/assistant roles

### ⏳ TODO (Phase 1 Remaining)
- MCP tool calling (Slack, Calendar integration)
- Conversation persistence across app restarts
- App icon and proper menu bar icon
- Preferences window
- Quick reference sections (urgent items, upcoming meetings)

### 📋 Future (Phase 2+)
- Proactive monitoring
- Voice interface
- Notifications
- Keyboard shortcuts (KeyboardShortcuts package already added)

## Important Notes

- This app requires Salesforce network/VPN - will not work on public internet
- Auth token is hardcoded (not ideal but matches Claude Code setup)
- Knowledge base path is `~/knowledge-base/` - not configurable yet
- No conversation persistence yet - history lost on app restart
- Streaming responses are real-time but can timeout after 30s (connection) or 5m (resource)
