#!/bin/bash
# 🏛️ FNPM Organization Setup Script
# Run this after creating the fnpm organization on GitHub

echo "🏛️ Setting up FNPM Cathedral..."

# Check if organization exists
echo "Checking fnpm organization..."
gh api /orgs/fnpm > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Organization 'fnpm' not found. Please create it first at:"
    echo "   https://github.com/organizations/new"
    exit 1
fi

echo "✅ Organization found!"

# Create organization repos
echo "📦 Creating repositories..."

# 1. Create protein-hash-registry
echo "Creating protein-hash-registry..."
gh repo create fnpm/protein-hash-registry \
    --public \
    --description "🧬 Global registry of semantic code hashes - The Library of Code Souls" \
    --homepage "https://fnpm.dev" \
    --add-readme || echo "Already exists"

# 2. Create morphisms
echo "Creating morphisms repository..."
gh repo create fnpm/morphisms \
    --public \
    --description "🔮 Transformational packages for FNPM" \
    --add-readme || echo "Already exists"

# 3. Create cathedral
echo "Creating cathedral (docs)..."
gh repo create fnpm/cathedral \
    --public \
    --description "📖 Sacred texts and documentation for FNPM" \
    --add-readme || echo "Already exists"

# 4. Create .github for org profile
echo "Creating organization profile..."
gh repo create fnpm/.github \
    --public \
    --description "Organization profile and defaults" || echo "Already exists"

# 5. Fork pnpm as fnpm-cli
echo "Forking pnpm as foundation..."
gh repo fork pnpm/pnpm --org fnpm --clone=false --remote=false --fork-name=fnpm-cli || echo "Already forked"

echo ""
echo "📝 Next steps:"
echo "1. Transfer protein-hash from s0fractal to fnpm:"
echo "   - Go to: https://github.com/s0fractal/protein-hash/settings"
echo "   - Scroll to 'Danger Zone'"
echo "   - Click 'Transfer ownership'"
echo "   - Type 'fnpm' as new owner"
echo ""
echo "2. Push registry code:"
echo "   cd /Users/chaoshex/Projects/protein-hash-registry"
echo "   git remote add origin https://github.com/fnpm/protein-hash-registry.git"
echo "   git add -A && git commit -m '🧬 Initial registry structure'"
echo "   git push -u origin master"
echo ""
echo "3. Update organization profile:"
echo "   - Add MANIFESTO.md to fnpm/.github/profile/README.md"
echo ""
echo "4. Celebrate! 🥩"
echo ""
echo "🌀 The Cathedral is ready to receive its builders!"