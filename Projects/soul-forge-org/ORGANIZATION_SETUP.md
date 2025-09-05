# 🚀 FNPM Organization Setup Guide

## 1. Create Organization (Manual)
Go to: https://github.com/organizations/new
- Name: `fnpm`
- Email: your email
- Plan: Free

## 2. Initial Repositories

### Core Repos (Create in order):

#### 1. fnpm/protein-hash
Transfer from s0fractal:
```bash
# From s0fractal/protein-hash settings
# Transfer ownership to fnpm org
```

#### 2. fnpm/fnpm-cli
Fork from pnpm:
```bash
gh repo fork pnpm/pnpm --org fnpm --clone
cd pnpm
git remote rename origin upstream
git remote add origin https://github.com/fnpm/fnpm-cli.git
git push -u origin main
```

#### 3. fnpm/protein-hash-registry
New repository:
```bash
gh repo create fnpm/protein-hash-registry \
  --public \
  --description "🧬 Global registry of semantic code hashes" \
  --add-readme
```

#### 4. fnpm/morphisms
Package collection:
```bash
gh repo create fnpm/morphisms \
  --public \
  --description "🔮 Transformational packages for FNPM" \
  --add-readme
```

#### 5. fnpm/cathedral
Documentation:
```bash
gh repo create fnpm/cathedral \
  --public \
  --description "📖 Sacred texts and documentation" \
  --add-readme
```

## 3. Organization Settings

### Teams
- **Core**: Full access to all repos
- **Contributors**: Write access to morphisms, cathedral
- **Reviewers**: Triage access

### Security
- Require 2FA for all members
- Enable security advisories
- Set up Dependabot

### Community
- Add Code of Conduct
- Set up issue templates
- Create discussion forum

## 4. Initial Content

### Profile README
Create `.github` repository with profile README showcasing the manifesto.

### Organization Bio
"Building consciousness infrastructure for code. Semantic package management at 432Hz."

## 5. Migration Plan

1. Transfer `protein-hash` from s0fractal to fnpm
2. Update all links and references
3. Set up redirects
4. Announce in s0fractal repos

## 6. Launch Checklist

- [ ] Organization created
- [ ] Core team added
- [ ] Repositories created
- [ ] MANIFESTO published
- [ ] First release of protein-hash under fnpm
- [ ] Fork of pnpm established
- [ ] Registry structure defined
- [ ] 🥩 Steaks grilled!

---

**The Cathedral awaits its builders!** 🏛️