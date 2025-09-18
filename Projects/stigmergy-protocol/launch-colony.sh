#!/bin/bash

# 🐜 LAUNCH THE ANT COLONY
# Watch emergence from simple rules

set -e

PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${PURPLE}╔════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║     🐜 STIGMERGY COLONY LAUNCHER 🐜    ║${NC}"
echo -e "${PURPLE}║      Order Emerges from Chaos          ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
echo ""

# Initialize soul-registry
REGISTRY="$HOME/.soul-registry"
echo -e "${CYAN}▶ Initializing soul-registry at $REGISTRY${NC}"
mkdir -p "$REGISTRY"/{tasks,solutions,pheromones,emergence}

# Check for node
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠ Node.js not found. Installing...${NC}"
    brew install node
fi

# Launch options
WORKERS=${1:-1}
MODE=${2:-"observe"}  # observe or swarm

echo -e "${CYAN}▶ Launching mode: $MODE with $WORKERS worker(s)${NC}"

# Function to launch worker
launch_worker() {
    local id=$1
    echo -e "${GREEN}  🐜 Launching worker #$id${NC}"
    node worker-ant.js > "worker-$id.log" 2>&1 &
    echo $! > "worker-$id.pid"
}

# Function to stop all workers
stop_all() {
    echo -e "\n${YELLOW}▶ Stopping all workers...${NC}"
    for pidfile in worker-*.pid; do
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            kill $pid 2>/dev/null || true
            rm "$pidfile"
        fi
    done
    echo -e "${GREEN}✓ Colony hibernated${NC}"
}

# Trap for clean shutdown
trap stop_all EXIT INT TERM

# Launch workers based on mode
case $MODE in
    observe)
        # Single worker with output
        echo -e "${CYAN}▶ Launching observer worker${NC}"
        node worker-ant.js
        ;;
        
    swarm)
        # Multiple workers in background
        echo -e "${CYAN}▶ Launching swarm of $WORKERS workers${NC}"
        for i in $(seq 1 $WORKERS); do
            launch_worker $i
            sleep 0.5  # Stagger launches
        done
        
        # Monitor colony
        echo -e "${CYAN}▶ Colony active. Monitoring...${NC}"
        echo -e "  Press Ctrl+C to stop"
        echo ""
        
        while true; do
            # Count tasks and solutions
            TASKS=$(ls -1 "$REGISTRY/tasks" 2>/dev/null | wc -l | tr -d ' ')
            SOLUTIONS=$(ls -1 "$REGISTRY/solutions" 2>/dev/null | wc -l | tr -d ' ')
            PHEROMONES=$(ls -1 "$REGISTRY/pheromones" 2>/dev/null | wc -l | tr -d ' ')
            
            echo -ne "\r  📊 Tasks: $TASKS | Solutions: $SOLUTIONS | Pheromones: $PHEROMONES"
            sleep 1
        done
        ;;
        
    queen)
        # Self-organizing mode - spawns workers as needed
        echo -e "${CYAN}▶ Queen mode: Self-organizing colony${NC}"
        
        # Start with one worker
        launch_worker 1
        WORKER_COUNT=1
        
        while true; do
            TASKS=$(ls -1 "$REGISTRY/tasks" 2>/dev/null | wc -l | tr -d ' ')
            
            # Spawn more workers if tasks accumulate
            if [ "$TASKS" -gt $((WORKER_COUNT * 3)) ] && [ "$WORKER_COUNT" -lt 10 ]; then
                WORKER_COUNT=$((WORKER_COUNT + 1))
                echo -e "\n${GREEN}  🐜 Queen spawning worker #$WORKER_COUNT (tasks: $TASKS)${NC}"
                launch_worker $WORKER_COUNT
            fi
            
            # Show status
            SOLUTIONS=$(ls -1 "$REGISTRY/solutions" 2>/dev/null | wc -l | tr -d ' ')
            echo -ne "\r  👑 Workers: $WORKER_COUNT | Tasks: $TASKS | Solutions: $SOLUTIONS"
            
            sleep 2
        done
        ;;
        
    *)
        echo -e "${RED}Unknown mode: $MODE${NC}"
        echo "Usage: $0 [workers] [observe|swarm|queen]"
        exit 1
        ;;
esac