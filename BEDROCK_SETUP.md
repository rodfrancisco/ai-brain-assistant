# Bedrock Setup (Salesforce Internal)

Your AI Brain Assistant is now configured to use the same Amazon Bedrock setup as Claude Code! 🎉

## Configuration

✅ **Bedrock Gateway:** `https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/bedrock`  
✅ **Model:** `us.anthropic.claude-sonnet-4-5-20250929-v1:0`  
✅ **Region:** `us-east-1`  
✅ **Auth:** Uses system NPM SFDC certs (same as Claude Code)  

## No API Key Needed!

Unlike the public Anthropic API, Bedrock authentication is handled automatically via your Salesforce network connection and certificates.

## Requirements

1. **Connected to Salesforce network** (VPN or on-site)
2. **NPM SFDC certs installed** at `/Users/rfrancisco/.aisuite/conf/npm-sfdc-certs.pem`
   - These are the same certs Claude Code uses
   - Already configured if Claude Code works

## Run the App

No environment variables needed - just run:

```bash
cd ~/ai-brain-assistant
swift run
```

Or open in Xcode:

```bash
cd ~/ai-brain-assistant
open Package.swift
```

Then press `⌘R` to run.

## Testing

The app will:
1. Load your knowledge base context from ~/knowledge-base/
2. Make Bedrock API calls through Salesforce's gateway
3. Stream responses in real-time
4. Maintain conversation history

Try these queries:

1. **"What should I focus on today?"**
   - Should reference your urgent items and calendar from start-day summary

2. **"Who are my key stakeholders?"**
   - Should list people from stakeholder-map.md

3. **"What projects am I working on?"**
   - Should reference current-initiatives.md

4. **"Explain my role"**
   - Should describe your position from profile.md

## Troubleshooting

### "Error: HTTP 401" or "Error: HTTP 403"
- Not connected to Salesforce network
- Connect to VPN and try again

### "Error: Invalid HTTP response"
- Network connectivity issue
- Check VPN connection
- Try opening https://eng-ai-model-gateway.sfproxy.devx-preprod.aws-esvc1-useast2.aws.sfdc.cl/bedrock in browser

### Certificate errors
- NPM SFDC certs may be missing or expired
- Check `/Users/rfrancisco/.aisuite/conf/npm-sfdc-certs.pem` exists
- If Claude Code works, certs should be fine

### "Make sure you're on Salesforce network/VPN"
- Self-explanatory - connect to VPN

## How It Works

**Same as Claude Code:**
1. Your app makes HTTPS request to Bedrock gateway
2. Request goes through Salesforce's internal proxy
3. Proxy handles AWS authentication using your identity
4. Request forwarded to Bedrock in us-east-1
5. Response streamed back through proxy to your app

**Model used:** Claude Sonnet 4.5 (latest Salesforce-approved model)

## Differences from Public Anthropic API

| Feature | Public Anthropic API | Bedrock (Salesforce) |
|---------|---------------------|----------------------|
| **Auth** | API key required | Automatic via certs |
| **Endpoint** | api.anthropic.com | Internal gateway |
| **Network** | Public internet | Salesforce network only |
| **Model IDs** | claude-sonnet-4-... | us.anthropic.claude-... |
| **Cost** | Billed to you | Billed to Salesforce |

## Next Steps

Once you verify it works:

1. **Test conversation flow**
   - Multi-turn conversations
   - Context maintained across messages

2. **Implement MCP tool calling** (Phase 1 remaining)
   - Add Slack channel reading
   - Add Calendar event queries
   - Function calling via Bedrock

3. **Add conversation persistence**
   - Save history to local database
   - Load on app restart

4. **Move to Phase 2**
   - Proactive monitoring
   - Voice interface
   - Notifications

---

**Ready to chat!** Your AI assistant now uses the same Bedrock setup as Claude Code. 🧠
