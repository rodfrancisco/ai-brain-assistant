#!/bin/bash

# Run AI Brain Assistant with Anthropic API key

# Check if API key is already set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "⚠️  ANTHROPIC_API_KEY not set in environment"
    echo ""
    echo "To run with Claude API, you need to set your API key."
    echo ""
    echo "Option 1: Set in this session"
    echo "  export ANTHROPIC_API_KEY='your-key-here'"
    echo "  ./run-with-api.sh"
    echo ""
    echo "Option 2: Add to your ~/.zshrc (permanent)"
    echo "  echo 'export ANTHROPIC_API_KEY=\"your-key-here\"' >> ~/.zshrc"
    echo "  source ~/.zshrc"
    echo ""
    echo "Option 3: Run without API (placeholder mode)"
    echo "  swift run"
    echo ""
    exit 1
fi

echo "✓ API key found"
echo "✓ Building and running AI Brain Assistant..."
echo ""

cd "$(dirname "$0")"
swift run
