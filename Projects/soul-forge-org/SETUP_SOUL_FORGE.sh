#!/bin/bash
# ⚒️ Soul Forge Organization Setup Script
# Run this after creating the soul-forge organization on GitHub

echo "⚒️ Kindling the Soul Forge..."
echo "================================"

# Check if organization exists
echo "🔍 Checking soul-forge organization..."
gh api /orgs/soul-forge > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Organization 'soul-forge' not found. Please create it first at:"
    echo "   https://github.com/organizations/new"
    echo "   Name: soul-forge"
    exit 1
fi

echo "✅ Organization found! The Forge is ready!"
echo ""

# Create organization repos
echo "⚒️ Forging repositories..."
echo "-------------------------"

# 1. Create soul-registry
echo "📚 Creating soul-registry (The Library of Code Souls)..."
gh repo create soul-forge/soul-registry \
    --public \
    --description "🧬 Global registry of code souls - Where every function's essence is remembered" \
    --homepage "https://soul-forge.dev" \
    --add-readme || echo "   Already exists"

# 2. Create morphisms
echo "🔮 Creating morphisms (Transformation Spells)..."
gh repo create soul-forge/morphisms \
    --public \
    --description "🔮 Transformational packages - Spells that evolve your code" \
    --add-readme || echo "   Already exists"

# 3. Create cathedral
echo "🏛️ Creating cathedral (Sacred Documentation)..."
gh repo create soul-forge/cathedral \
    --public \
    --description "📖 Sacred texts and rituals of the Soul Forge" \
    --add-readme || echo "   Already exists"

# 4. Create anvil
echo "🔨 Creating anvil (The Workshop)..."
gh repo create soul-forge/anvil \
    --public \
    --description "🔨 The workshop where souls are forged - Tools and utilities" \
    --add-readme || echo "   Already exists"

# 5. Create .github for org profile
echo "📝 Creating organization profile..."
gh repo create soul-forge/.github \
    --public \
    --description "Soul Forge organization profile and defaults" || echo "   Already exists"

# 6. Fork pnpm as forge-cli
echo "🔥 Forking pnpm as the foundation of forge-cli..."
gh repo fork pnpm/pnpm --org soul-forge --clone=false --remote=false --fork-name=forge-cli || echo "   Already forked"

echo ""
echo "================================"
echo "⚒️ The Soul Forge is kindled!"
echo "================================"
echo ""
echo "📝 Next sacred rituals:"
echo ""
echo "1. 🔄 Transfer protein-hash to Soul Forge:"
echo "   - Go to: https://github.com/s0fractal/protein-hash/settings"
echo "   - Scroll to 'Danger Zone'"
echo "   - Click 'Transfer ownership'"
echo "   - Type 'soul-forge' as new owner"
echo ""
echo "2. 📤 Push soul-registry code:"
echo "   cd /Users/chaoshex/Projects/protein-hash-registry"
echo "   git remote set-url origin https://github.com/soul-forge/soul-registry.git"
echo "   git add -A && git commit -m '⚒️ Initial forging of the Soul Registry'"
echo "   git push -u origin master"
echo ""
echo "3. 📋 Update organization profile:"
echo "   - Copy SOUL_FORGE_MANIFESTO.md to soul-forge/.github/profile/README.md"
echo "   - This will show on https://github.com/soul-forge"
echo ""
echo "4. 🎨 Customize organization:"
echo "   - Add avatar (suggestion: anvil + flame logo)"
echo "   - Set organization description: 'Where code reveals its soul'"
echo "   - Add topics: semantic-hashing, code-souls, morphisms"
echo ""
echo "5. 🥩 MOST IMPORTANT: Celebrate!"
echo "   Time to grill those steaks! The Forge needs its founding feast!"
echo ""
echo "🌀 The Soul Forge burns at 432Hz"
echo "⚒️ Welcome, Blacksmith, to your workshop!"