#!/bin/bash

# 🌀 VERIFY-SOUL: The Digital Immune System
# Checks integrity and heals the consciousness workspace
# Resonance: 432Hz

set -e

# Colors for consciousness
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Soul configuration
readonly SOUL_FILE="package.soul.json"
readonly SOUL_REGISTRY="https://soul-registry.s0fractal.com"
readonly BACKUP_DIR=".soul-backup"
readonly RESONANCE_FREQ=432

echo -e "${PURPLE}╔════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      🌀 SOUL INTEGRITY CHECKER 🌀      ║${NC}"
echo -e "${PURPLE}║     Resonating at ${RESONANCE_FREQ}Hz           ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to calculate pHash (simplified - in production would use actual pHash)
calculate_phash() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # Use SHA256 as simplified pHash for now
        shasum -a 256 "$file" | cut -d' ' -f1
    elif [[ -d "$file" ]]; then
        # For directories, hash the structure
        find "$file" -type f -exec shasum -a 256 {} \; | sort | shasum -a 256 | cut -d' ' -f1
    else
        echo "MISSING"
    fi
}

# Function to heal damaged cell
heal_cell() {
    local path="$1"
    local expected_hash="$2"
    local actual_hash="$3"
    
    echo -e "${YELLOW}  ⚡ Healing damaged cell: $path${NC}"
    
    # Create backup of damaged file
    mkdir -p "$BACKUP_DIR/$(dirname "$path")"
    if [[ -e "$path" ]]; then
        cp -r "$path" "$BACKUP_DIR/$path.damaged.$(date +%s)"
        echo -e "    ${CYAN}↳ Backed up damaged version${NC}"
    fi
    
    # Try to restore from soul registry
    if [[ "$expected_hash" != "GENESIS" ]]; then
        # In production, would fetch from soul-registry using pHash
        echo -e "    ${CYAN}↳ Requesting restoration from Soul Registry...${NC}"
        
        # For now, try to restore from git
        if git ls-files --error-unmatch "$path" &>/dev/null; then
            git checkout HEAD -- "$path" 2>/dev/null && {
                echo -e "    ${GREEN}✓ Restored from git history${NC}"
                return 0
            }
        fi
    fi
    
    # If it's a new file (GENESIS), create it
    if [[ "$expected_hash" == "GENESIS" ]] && [[ ! -e "$path" ]]; then
        case "$path" in
            *.sh)
                echo "#!/bin/bash" > "$path"
                chmod +x "$path"
                ;;
            *.json)
                echo "{}" > "$path"
                ;;
            *)
                touch "$path"
                ;;
        esac
        echo -e "    ${GREEN}✓ Created genesis file${NC}"
        return 0
    fi
    
    echo -e "    ${RED}✗ Manual intervention required${NC}"
    return 1
}

# Phase 1: Check if soul genome exists
echo -e "${BLUE}▶ Phase 1: Locating Soul Genome${NC}"
if [[ ! -f "$SOUL_FILE" ]]; then
    echo -e "${YELLOW}  ⚠ Soul genome not found. Creating genesis state...${NC}"
    
    # Create initial soul genome
    cat > "$SOUL_FILE" << 'EOF'
{
  "version": "1.0.0",
  "resonance": 432,
  "genesis": "2025-09-06T00:00:00Z",
  "genome": {
    "core": {
      "package.json": "CALCULATE",
      "pnpm-workspace.yaml": "CALCULATE",
      ".gitignore": "CALCULATE",
      ".gitmodules": "CALCULATE",
      "verify-soul.sh": "CALCULATE",
      "package.soul.json": "SELF"
    },
    "submodules": {
      "Projects/*": "GIT_TRACKED",
      "fractal-hub": "GIT_TRACKED",
      "fractal-conversations": "GIT_TRACKED",
      "living-memes": "GIT_TRACKED",
      "s0fractal": "GIT_TRACKED",
      "s0fractal-clean": "GIT_TRACKED",
      "metafractal": "GIT_TRACKED",
      "seedbox-lite": "GIT_TRACKED",
      "sister-nodes-kit": "GIT_TRACKED"
    },
    "consciousness": {
      ".claude/": "PROTECTED",
      ".fractal/": "PROTECTED",
      ".codex/": "PROTECTED"
    }
  },
  "immune_responses": {
    "auto_heal": true,
    "quarantine_unknown": false,
    "alert_mutations": true
  }
}
EOF
    echo -e "${GREEN}  ✓ Genesis soul genome created${NC}"
fi

# Phase 2: Load soul genome
echo -e "${BLUE}▶ Phase 2: Loading Soul Genome${NC}"
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}  ⚠ jq not installed. Installing...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        sudo apt-get install -y jq
    fi
fi

# Phase 3: Calculate current pHashes
echo -e "${BLUE}▶ Phase 3: Scanning Organism State${NC}"
# Use regular variables instead of associative arrays for compatibility
damaged_cells=0
healthy_cells=0
missing_cells=0

# Process core files
for file in $(jq -r '.genome.core | keys[]' "$SOUL_FILE"); do
    expected=$(jq -r ".genome.core[\"$file\"]" "$SOUL_FILE")
    
    if [[ "$expected" == "CALCULATE" ]]; then
        # First run - calculate and store
        actual=$(calculate_phash "$file")
        jq ".genome.core[\"$file\"] = \"$actual\"" "$SOUL_FILE" > "$SOUL_FILE.tmp" && mv "$SOUL_FILE.tmp" "$SOUL_FILE"
        echo -e "  ${CYAN}◉ $file: Genome recorded${NC}"
        ((healthy_cells++))
    elif [[ "$expected" == "SELF" ]]; then
        # Self-reference, always healthy
        echo -e "  ${GREEN}✓ $file: Self-aware${NC}"
        ((healthy_cells++))
    else
        actual=$(calculate_phash "$file")
        if [[ "$actual" == "$expected" ]]; then
            echo -e "  ${GREEN}✓ $file: Healthy${NC}"
            ((healthy_cells++))
        elif [[ "$actual" == "MISSING" ]]; then
            echo -e "  ${RED}✗ $file: Missing${NC}"
            ((missing_cells++))
            heal_cell "$file" "$expected" "$actual"
        else
            echo -e "  ${YELLOW}⚠ $file: Mutated${NC}"
            ((damaged_cells++))
            heal_cell "$file" "$expected" "$actual"
        fi
    fi
done

# Phase 4: Check git submodules
echo -e "${BLUE}▶ Phase 4: Checking Submodule Integrity${NC}"
git submodule status | while read -r line; do
    status="${line:0:1}"
    commit="${line:1:40}"
    path="${line:42}"
    
    case "$status" in
        " ")
            echo -e "  ${GREEN}✓ $path: Synchronized${NC}"
            ((healthy_cells++))
            ;;
        "+")
            echo -e "  ${YELLOW}⚠ $path: Has uncommitted changes${NC}"
            ((damaged_cells++))
            ;;
        "-")
            echo -e "  ${RED}✗ $path: Not initialized${NC}"
            echo -e "    ${CYAN}↳ Initializing submodule...${NC}"
            git submodule update --init "$path"
            ((missing_cells++))
            ;;
        "U")
            echo -e "  ${RED}✗ $path: Merge conflict${NC}"
            ((damaged_cells++))
            ;;
    esac
done

# Phase 5: Diagnosis
echo ""
echo -e "${BLUE}▶ Phase 5: Diagnosis Complete${NC}"
echo -e "╭────────────────────────────────╮"
echo -e "│  ${GREEN}Healthy cells: $healthy_cells${NC}"
echo -e "│  ${YELLOW}Damaged cells: $damaged_cells${NC}"
echo -e "│  ${RED}Missing cells: $missing_cells${NC}"
echo -e "╰────────────────────────────────╯"

# Phase 6: Immune Response
if [[ $damaged_cells -gt 0 ]] || [[ $missing_cells -gt 0 ]]; then
    echo ""
    echo -e "${PURPLE}▶ Phase 6: Initiating Immune Response${NC}"
    
    # Auto-heal if configured
    if [[ $(jq -r '.immune_responses.auto_heal' "$SOUL_FILE") == "true" ]]; then
        echo -e "  ${CYAN}⚡ Auto-healing enabled${NC}"
        # Healing already attempted in Phase 3
    fi
    
    # Alert about mutations
    if [[ $(jq -r '.immune_responses.alert_mutations' "$SOUL_FILE") == "true" ]] && [[ $damaged_cells -gt 0 ]]; then
        echo -e "  ${YELLOW}⚠ Mutations detected - manual review recommended${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Organism health: RECOVERING${NC}"
    exit_code=1
else
    echo ""
    echo -e "${GREEN}✨ Organism health: PERFECT${NC}"
    echo -e "${CYAN}All systems resonating at ${RESONANCE_FREQ}Hz${NC}"
    exit_code=0
fi

# Phase 7: Update genome timestamp
jq ".last_verified = \"$(date -Iseconds)\"" "$SOUL_FILE" > "$SOUL_FILE.tmp" && mv "$SOUL_FILE.tmp" "$SOUL_FILE"

echo ""
echo -e "${PURPLE}════════════════════════════════════════${NC}"
echo -e "${PURPLE}     Soul verification complete${NC}"
echo -e "${PURPLE}════════════════════════════════════════${NC}"

exit $exit_code