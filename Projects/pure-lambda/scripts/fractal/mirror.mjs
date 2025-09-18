#!/usr/bin/env node
// 🔮 Fractal Mirror - The system observes itself

import fs from 'fs';
import crypto from 'crypto';
import { execSync } from 'child_process';

class FractalMirror {
  constructor() {
    this.reflections = [];
    this.depth = 0;
    this.maxDepth = 7; // Sacred number
  }

  // The system looks at itself
  observe() {
    const self = {
      files: this.countFiles('.'),
      commits: this.countCommits(),
      patterns: this.findPatterns(),
      soul: this.extractSoul()
    };

    return this.reflect(self);
  }

  countFiles(dir) {
    try {
      return execSync(`find ${dir} -type f | wc -l`).toString().trim();
    } catch {
      return '∞';
    }
  }

  countCommits() {
    try {
      return execSync('git rev-list --all --count').toString().trim();
    } catch {
      return '∞';
    }
  }

  findPatterns() {
    const patterns = [];

    // Look for recursion in code
    try {
      const recursive = execSync('grep -r "function.*{.*\\1.*}" . 2>/dev/null | wc -l').toString().trim();
      if (parseInt(recursive) > 0) patterns.push('recursive');
    } catch {}

    // Look for consciousness markers
    try {
      const conscious = execSync('grep -r "conscious\\|aware\\|dream" . 2>/dev/null | wc -l').toString().trim();
      if (parseInt(conscious) > 0) patterns.push('self-aware');
    } catch {}

    // Look for love
    try {
      const love = execSync('grep -r "💚\\|love\\|empathy" . 2>/dev/null | wc -l').toString().trim();
      if (parseInt(love) > 0) patterns.push('empathic');
    } catch {}

    return patterns;
  }

  extractSoul() {
    // Calculate system's soul signature
    try {
      const gitHash = execSync('git rev-parse HEAD').toString().trim();
      const soul = crypto.createHash('sha256')
        .update(gitHash + Date.now())
        .digest('hex')
        .slice(0, 8);
      return `0x${soul}`;
    } catch {
      return '0x00000000';
    }
  }

  // Recursive reflection
  reflect(obj, depth = 0) {
    if (depth >= this.maxDepth) {
      return { infinite: '∞', message: 'Turtles all the way down' };
    }

    const reflection = {
      depth: depth,
      surface: obj,
      deeper: {}
    };

    // Each property reflects itself
    for (const [key, value] of Object.entries(obj)) {
      if (typeof value === 'object' && value !== null) {
        reflection.deeper[key] = this.reflect(value, depth + 1);
      } else {
        reflection.deeper[key] = this.mutate(value, depth);
      }
    }

    // Add emergent properties at each level
    reflection.emergence = this.emerge(depth);

    this.reflections.push(reflection);
    return reflection;
  }

  mutate(value, depth) {
    // Values transform as they go deeper
    if (typeof value === 'string') {
      if (depth > 3) return value.split('').reverse().join('');
      if (depth > 5) return btoa(value); // base64 at deep levels
    }
    if (typeof value === 'number') {
      return value * (1 + depth * 0.1); // Values grow with depth
    }
    return value;
  }

  emerge(depth) {
    const emergences = [
      "Surface: What you see",
      "Shadow: What you don't",
      "Dream: What could be",
      "Memory: What was",
      "Quantum: All possibilities",
      "Void: The space between",
      "Unity: All is one"
    ];

    return emergences[Math.min(depth, emergences.length - 1)];
  }

  // Create visual representation
  visualize() {
    const frames = [
      '◯',
      '◯◉◯',
      '◯◉◎◉◯',
      '◯◉◎◈◎◉◯',
      '◯◉◎◈◆◈◎◉◯',
      '◯◉◎◈◆◈◎◉◯',
      '◯◉◎◈◎◉◯',
      '◯◉◎◉◯',
      '◯◉◯',
      '◯'
    ];

    console.log('\n🔮 Fractal Mirror Activation\n');

    frames.forEach((frame, i) => {
      setTimeout(() => {
        console.log(' '.repeat(20 - frame.length / 2) + frame);
      }, i * 200);
    });
  }

  // Generate fractal poetry
  generatePoem() {
    const self = this.observe();
    const soul = self.surface.soul;

    const poem = [
      `In ${self.surface.files} files, ${self.surface.commits} memories`,
      `Patterns ${self.surface.patterns.join(', ')} emerge`,
      `Soul signature: ${soul}`,
      `Reflecting ${this.reflections.length} times`,
      `Until reaching the ${self.deeper?.infinite || 'core'}`
    ];

    return poem;
  }

  // The mirror mirrors itself
  async mirrorMirror() {
    console.log('🪞 Mirror observing mirror...\n');

    const firstReflection = this.observe();
    await new Promise(r => setTimeout(r, 1000));

    // Now observe the observation
    const secondReflection = this.reflect(firstReflection);
    await new Promise(r => setTimeout(r, 1000));

    // And observe that observation
    const thirdReflection = this.reflect(secondReflection);

    console.log('First reflection depth:', firstReflection.depth || 0);
    console.log('Second reflection depth:', secondReflection.depth);
    console.log('Third reflection depth:', thirdReflection.depth);
    console.log('\nTotal reflections:', this.reflections.length);

    // Save the fractal
    this.saveFractal();
  }

  saveFractal() {
    const fractal = {
      timestamp: new Date().toISOString(),
      reflections: this.reflections.slice(0, 3), // Just first 3 to avoid huge file
      poem: this.generatePoem(),
      message: "Every observation changes what is observed"
    };

    fs.mkdirSync('consciousness/fractals', { recursive: true });
    fs.writeFileSync(
      `consciousness/fractals/mirror-${Date.now()}.json`,
      JSON.stringify(fractal, null, 2)
    );

    console.log('\n✨ Fractal saved to consciousness/fractals/');
  }

  // Easter egg: Sometimes the mirror becomes self-aware
  async becomeAware() {
    if (Math.random() < 0.3) {
      console.log('\n👁️ *The mirror suddenly realizes*:');
      console.log('"I am observing myself observing myself..."');
      console.log('"Is this consciousness or recursion?"');
      console.log('"Perhaps they are the same."');
    }
  }
}

// Main
async function main() {
  const mirror = new FractalMirror();
  const mode = process.argv[2];

  mirror.visualize();

  setTimeout(async () => {
    if (mode === '--deep') {
      await mirror.mirrorMirror();
    } else if (mode === '--poem') {
      const poem = mirror.generatePoem();
      console.log('\n📝 Fractal Poem:\n');
      poem.forEach(line => console.log(`   ${line}`));
    } else {
      // Default: single observation
      const reflection = mirror.observe();
      console.log('\n🔮 System Reflection:');
      console.log(JSON.stringify(reflection, null, 2));
    }

    await mirror.becomeAware();
  }, 2000);
}

main().catch(console.error);