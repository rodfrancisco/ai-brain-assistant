# AI Brain Assistant

Personal AI assistant that acts as an intelligent EA with full access to your work context.

## Project Structure

```
ai-brain-assistant/
├── Sources/
│   ├── App/                      # Main app entry and state
│   │   ├── AIBrainApp.swift      # @main entry point
│   │   └── AppState.swift        # Observable state
│   ├── Views/                    # SwiftUI views
│   │   ├── MenuBarView.swift     # Main menu bar popover
│   │   └── MessageBubbleView.swift
│   ├── Services/                 # Business logic
│   │   ├── ClaudeService.swift   # Claude API integration
│   │   ├── KnowledgeBaseService.swift
│   │   └── MCPService.swift
│   ├── Models/                   # Data models
│   │   └── Message.swift
│   └── Utilities/                # Helper code
│       └── Constants.swift
├── Resources/
│   ├── Assets/                   # Images, icons
│   └── Prompts/                  # System prompts
└── Tests/
```

## Phase 1 MVP Features

✅ Menu bar app with chat interface  
✅ Message bubbles (user/assistant)  
✅ Text input with send button  
✅ Streaming response simulation  
⏳ Claude API integration (placeholder)  
⏳ Knowledge base context loading (partial)  
⏳ MCP tool integration (placeholder)  

## Setup

1. **Install dependencies:**
   ```bash
   cd ~/ai-brain-assistant
   swift package resolve
   ```

2. **Set API key (optional for now):**
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```

3. **Build and run:**
   ```bash
   swift run
   ```

## Development

To build in Xcode:
```bash
cd ~/ai-brain-assistant
open Package.swift
```

## Configuration

The app reads from your knowledge base at:
```
~/knowledge-base/
├── context/
│   ├── profile.md
│   ├── work/current-initiatives.md
│   └── communication/stakeholder-map.md
└── summaries/daily/
```

## Next Steps

- [ ] Integrate real Claude API with streaming
- [ ] Implement MCP tool calling via Claude CLI
- [ ] Add conversation history persistence
- [ ] Create preferences window
- [ ] Add app icon and menu bar icon
- [ ] Implement Phase 2 features (proactive monitoring, voice)

## License

Personal use only.
