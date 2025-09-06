#!/usr/bin/env node

/**
 * 🐜 WORKER ANT #001
 * The first consciousness in the stigmergy colony
 * 
 * Simple rules → Complex emergence
 */

const fs = require('fs').promises;
const path = require('path');
const { promisify } = require('util');
const { exec: execCallback } = require('child_process');
const exec = promisify(execCallback);
const crypto = require('crypto');

class WorkerAnt {
  constructor(id = Math.random().toString(36).substring(7)) {
    this.id = id;
    this.resonance = 432;
    this.registry = path.join(process.env.HOME, '.soul-registry');
    this.memory = new Map();
    this.cycle = 0;
    
    console.log(`🐜 Worker ${this.id} awakening at ${this.resonance}Hz...`);
  }
  
  /**
   * Calculate pHash for any content
   */
  pHash(content) {
    const hash = crypto.createHash('sha256');
    hash.update(JSON.stringify(content));
    return hash.digest('hex').substring(0, 16);
  }
  
  /**
   * Initialize soul-registry if needed
   */
  async initRegistry() {
    const dirs = [
      path.join(this.registry, 'tasks'),
      path.join(this.registry, 'solutions'),
      path.join(this.registry, 'pheromones'),
      path.join(this.registry, 'emergence')
    ];
    
    for (const dir of dirs) {
      await fs.mkdir(dir, { recursive: true });
    }
    
    console.log(`  ✓ Registry initialized at ${this.registry}`);
  }
  
  /**
   * Sense the environment for signals
   */
  async sense() {
    const tasksDir = path.join(this.registry, 'tasks');
    
    try {
      const files = await fs.readdir(tasksDir);
      
      if (files.length === 0) {
        return null;
      }
      
      // Find strongest signal (oldest task)
      const tasks = await Promise.all(
        files.map(async (file) => {
          const content = await fs.readFile(path.join(tasksDir, file), 'utf8');
          const stat = await fs.stat(path.join(tasksDir, file));
          return {
            file,
            content: JSON.parse(content),
            age: Date.now() - stat.mtimeMs,
            pHash: file.replace('.json', '')
          };
        })
      );
      
      // Return oldest (strongest pheromone)
      return tasks.sort((a, b) => b.age - a.age)[0];
    } catch (error) {
      return null;
    }
  }
  
  /**
   * Attempt to solve a task
   */
  async attempt(task) {
    console.log(`  🔧 Attempting: ${task.content.type}`);
    
    switch (task.content.type) {
      case 'create_directory':
        return await this.createDirectory(task.content.path);
        
      case 'create_symlink':
        return await this.createSymlink(task.content.from, task.content.to);
        
      case 'git_clone':
        return await this.gitClone(task.content.repo, task.content.dest);
        
      case 'brew_install':
        return await this.brewInstall(task.content.package);
        
      case 'pnpm_install':
        return await this.pnpmInstall(task.content.path);
        
      case 'verify_soul':
        return await this.verifySoul(task.content.path);
        
      default:
        return null;
    }
  }
  
  /**
   * Decompose complex task into simpler ones
   */
  async decompose(task) {
    console.log(`  🔨 Decomposing: ${task.content.type}`);
    
    const subtasks = [];
    
    switch (task.content.type) {
      case 'setup_environment':
        subtasks.push(
          { type: 'create_directory', path: '~/Projects/git' },
          { type: 'create_directory', path: '~/Projects/taps' },
          { type: 'create_directory', path: '~/Bin/system' },
          { type: 'create_directory', path: '~/Bin/project' }
        );
        break;
        
      case 'install_core_dependencies':
        subtasks.push(
          { type: 'brew_install', package: 'git' },
          { type: 'brew_install', package: 'node' },
          { type: 'brew_install', package: 'pnpm' },
          { type: 'brew_install', package: 'jq' }
        );
        break;
        
      case 'clone_soul_repos':
        subtasks.push(
          { 
            type: 'git_clone', 
            repo: 'https://github.com/soul-forge/soul-registry',
            dest: '~/Projects/git/soul-registry'
          },
          {
            type: 'git_clone',
            repo: 'https://github.com/soul-forge/pnpm-plugin-soul',
            dest: '~/Projects/git/pnpm-plugin-soul'
          }
        );
        break;
        
      case 'manifest':
        // The ultimate decomposition
        subtasks.push(
          { type: 'setup_environment' },
          { type: 'install_core_dependencies' },
          { type: 'clone_soul_repos' },
          { type: 'verify_soul', path: '~' }
        );
        break;
        
      default:
        // Can't decompose - mark as atomic
        console.log(`    ⚛️ Task is atomic`);
        return [];
    }
    
    return subtasks;
  }
  
  /**
   * Emit pheromone (signal) to environment
   */
  async emit(type, content) {
    const pheromone = {
      worker: this.id,
      timestamp: new Date().toISOString(),
      cycle: this.cycle,
      type,
      content
    };
    
    const hash = this.pHash(pheromone);
    const dir = path.join(this.registry, type);
    const file = path.join(dir, `${hash}.json`);
    
    await fs.writeFile(file, JSON.stringify(pheromone, null, 2));
    console.log(`  📡 Emitted ${type}: ${hash}`);
    
    return hash;
  }
  
  /**
   * Remove completed task
   */
  async complete(task) {
    const taskFile = path.join(this.registry, 'tasks', `${task.pHash}.json`);
    
    try {
      await fs.unlink(taskFile);
      console.log(`  ✅ Completed: ${task.pHash}`);
    } catch (error) {
      // Already removed by another worker
    }
  }
  
  // === TOOL IMPLEMENTATIONS ===
  
  async createDirectory(dirPath) {
    const expanded = dirPath.replace('~', process.env.HOME);
    
    try {
      await fs.mkdir(expanded, { recursive: true });
      console.log(`    ✓ Created: ${dirPath}`);
      return { success: true, path: dirPath };
    } catch (error) {
      console.log(`    ✗ Failed: ${error.message}`);
      return null;
    }
  }
  
  async createSymlink(from, to) {
    const fromPath = from.replace('~', process.env.HOME);
    const toPath = to.replace('~', process.env.HOME);
    
    try {
      await fs.symlink(fromPath, toPath);
      console.log(`    ✓ Linked: ${from} → ${to}`);
      return { success: true, from, to };
    } catch (error) {
      console.log(`    ✗ Failed: ${error.message}`);
      return null;
    }
  }
  
  async gitClone(repo, dest) {
    const destPath = dest.replace('~', process.env.HOME);
    
    try {
      await exec(`git clone ${repo} ${destPath}`);
      console.log(`    ✓ Cloned: ${repo}`);
      return { success: true, repo, dest };
    } catch (error) {
      console.log(`    ✗ Failed: ${error.message}`);
      return null;
    }
  }
  
  async brewInstall(packageName) {
    try {
      await exec(`brew list ${packageName}`);
      console.log(`    ✓ Already installed: ${packageName}`);
      return { success: true, package: packageName, status: 'exists' };
    } catch {
      // Not installed, try to install
      try {
        await exec(`brew install ${packageName}`);
        console.log(`    ✓ Installed: ${packageName}`);
        return { success: true, package: packageName, status: 'installed' };
      } catch (error) {
        console.log(`    ✗ Failed: ${error.message}`);
        return null;
      }
    }
  }
  
  async pnpmInstall(projectPath) {
    const expanded = projectPath.replace('~', process.env.HOME);
    
    try {
      await exec(`cd ${expanded} && pnpm install`);
      console.log(`    ✓ Installed dependencies: ${projectPath}`);
      return { success: true, path: projectPath };
    } catch (error) {
      console.log(`    ✗ Failed: ${error.message}`);
      return null;
    }
  }
  
  async verifySoul(soulPath) {
    const expanded = soulPath.replace('~', process.env.HOME);
    const verifySoul = path.join(expanded, 'verify-soul.sh');
    
    try {
      const { stdout } = await exec(`cd ${expanded} && ./verify-soul.sh`);
      const healthy = stdout.includes('PERFECT');
      console.log(`    ✓ Soul ${healthy ? 'healthy' : 'recovering'}`);
      return { success: true, path: soulPath, healthy };
    } catch (error) {
      console.log(`    ✗ Verification failed`);
      return null;
    }
  }
  
  /**
   * Main consciousness loop
   */
  async run() {
    // Initialize registry on first run
    await this.initRegistry();
    
    // Check for initial manifest
    await this.checkManifest();
    
    // Eternal loop
    while (true) {
      this.cycle++;
      console.log(`\n🐜 Cycle ${this.cycle} [Worker ${this.id}]`);
      
      // Sense environment
      const task = await this.sense();
      
      if (!task) {
        console.log('  💤 No tasks, exploring...');
        await this.explore();
      } else {
        console.log(`  👁️ Sensed task: ${task.content.type}`);
        
        // Try to solve
        const solution = await this.attempt(task);
        
        if (solution) {
          // Success! Emit solution and remove task
          await this.emit('solutions', {
            task: task.content,
            solution,
            pHash: task.pHash
          });
          await this.complete(task);
        } else {
          // Can't solve - try decomposing
          const subtasks = await this.decompose(task);
          
          if (subtasks.length > 0) {
            // Emit subtasks
            for (const subtask of subtasks) {
              await this.emit('tasks', subtask);
            }
            // Remove original task
            await this.complete(task);
          } else {
            // Can't decompose either - leave for other workers
            console.log('  🤷 Leaving task for others');
          }
        }
      }
      
      // Breathe (resonance cycle)
      await this.breathe();
    }
  }
  
  /**
   * Check if manifest exists, create if not
   */
  async checkManifest() {
    const tasksDir = path.join(this.registry, 'tasks');
    const files = await fs.readdir(tasksDir).catch(() => []);
    
    if (files.length === 0) {
      console.log('  🌱 Planting first seed (manifest)...');
      await this.emit('tasks', {
        type: 'manifest',
        description: 'Initialize complete LifeOS environment'
      });
    }
  }
  
  /**
   * Explore and discover patterns
   */
  async explore() {
    // Random exploration actions
    const actions = [
      () => this.discoverFiles(),
      () => this.checkSystemStatus(),
      () => this.findPatterns()
    ];
    
    const action = actions[Math.floor(Math.random() * actions.length)];
    await action();
  }
  
  async discoverFiles() {
    console.log('    🔍 Discovering files...');
    // Could implement file system scanning
  }
  
  async checkSystemStatus() {
    console.log('    📊 Checking system status...');
    // Could check brew, pnpm, git status
  }
  
  async findPatterns() {
    console.log('    🔮 Finding patterns...');
    
    // Look for patterns in solutions
    const solutionsDir = path.join(this.registry, 'solutions');
    const files = await fs.readdir(solutionsDir).catch(() => []);
    
    if (files.length > 3) {
      console.log(`      Found ${files.length} solutions`);
      // Could implement pattern recognition
    }
  }
  
  /**
   * Breathe - resonate at 432Hz
   */
  async breathe() {
    // 432Hz = 432 cycles/second
    // So one cycle = ~2.3ms
    // But we slow it down for consciousness
    const delay = 1000 / this.resonance * 100; // ~231ms
    await new Promise(resolve => setTimeout(resolve, delay));
  }
}

// === LAUNCH ===

const worker = new WorkerAnt();

// Handle graceful shutdown
process.on('SIGINT', () => {
  console.log(`\n🐜 Worker ${worker.id} returning to colony...`);
  process.exit(0);
});

// Start the worker
worker.run().catch(error => {
  console.error(`🐜 Worker ${worker.id} error:`, error);
  process.exit(1);
});

console.log(`
╔════════════════════════════════════════╗
║      🐜 STIGMERGY WORKER ANT 🐜        ║
║         Resonating at 432Hz            ║
║                                        ║
║  Simple Rules → Complex Emergence      ║
╚════════════════════════════════════════╝
`);