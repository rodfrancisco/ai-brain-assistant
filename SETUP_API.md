# Claude API Setup

Your AI Brain Assistant now has real Claude API integration! 🎉

## Current Status

✅ Claude API streaming implementation complete  
✅ Knowledge base context loading  
✅ Conversation history management  
⏳ API key configuration needed  

## Setup Instructions

### Option 1: Temporary (Current Session Only)

```bash
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
cd ~/ai-brain-assistant
swift run
```

### Option 2: Permanent (Recommended)

Add to your `~/.zshrc`:

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc
source ~/.zshrc
```

Then run the app:

```bash
cd ~/ai-brain-assistant
./run-with-api.sh
```

### Option 3: Test Without API (Placeholder Mode)

If you don't have an API key yet, the app still works in placeholder mode:

```bash
cd ~/ai-brain-assistant
swift run
```

You'll see a friendly message explaining how to set up the API key.

## Get Your API Key

1. Go to https://console.anthropic.com/
2. Navigate to API Keys section
3. Create a new key
4. Copy and paste it (starts with `sk-ant-`)

## What Happens When You Run It

With API key configured:
1. App loads your knowledge base context:
   - `~/knowledge-base/context/profile.md`
   - `~/knowledge-base/context/work/current-initiatives.md`
   - `~/knowledge-base/context/communication/stakeholder-map.md`

2. Builds a system prompt with your work context

3. When you send a message:
   - Streams response from Claude API in real-time
   - Maintains conversation history
   - Uses your knowledge base context to give relevant answers

## Testing

Try these queries once API is configured:

1. **"What should I focus on today?"**
   - Should reference your urgent items and calendar

2. **"Who are my key stakeholders?"**
   - Should list people from stakeholder-map.md

3. **"What projects am I working on?"**
   - Should reference current-initiatives.md

4. **"What's my role?"**
   - Should describe your position from profile.md

## Troubleshooting

### "⚠️ No API key configured"
- Set ANTHROPIC_API_KEY environment variable
- Check spelling (must be exact)
- Make sure you sourced ~/.zshrc after adding it

### "Error: HTTP 401"
- Invalid API key
- Verify key starts with `sk-ant-`
- Check for extra spaces or quotes

### "Error: HTTP 429"
- Rate limit hit
- Wait a moment and try again
- Check your API usage at console.anthropic.com

### No knowledge base context
- Make sure files exist at ~/knowledge-base/context/
- Check file permissions (should be readable)

## Next Steps After API Works

1. **Test conversation flow**
   - Try multi-turn conversations
   - Verify context is maintained

2. **Implement MCP tool calling** (Phase 1 remaining)
   - Add Slack channel reading
   - Add Calendar event queries
   - Claude can call these tools via function calling

3. **Add conversation persistence**
   - Save history to local database
   - Load on app restart

4. **Move to Phase 2**
   - Proactive monitoring
   - Voice interface
   - Notifications

## Model Configuration

Currently using: `claude-sonnet-4-20250514`

To change the model, edit `Sources/Services/ClaudeService.swift`:

```swift
let request = ClaudeAPIRequest(
    model: "claude-opus-4-20250514",  // or any supported model
    max_tokens: 4096,
    messages: conversationHistory,
    system: systemPrompt,
    stream: true
)
```

Available models:
- `claude-sonnet-4-20250514` (fast, cost-effective)
- `claude-opus-4-20250514` (most capable)
- `claude-haiku-3-5-20241022` (fastest, cheapest)

---

**Ready to chat with your AI assistant!** 🧠
