#!/usr/bin/env node
// SF> 2025-06-16 15:40 | Script for manual testing of getApiKey behavior as ES module.
import { getApiKey } from '../src/utils/config.js';

// Test case 1: only OPENAI_API_KEY set
delete process.env.OPENAI_API_KEY;
delete process.env.ANTHROPIC_API_KEY;
process.env.OPENAI_API_KEY = 'globalKey';
console.log('TEST1 openai:', getApiKey('openai')); // expected 'globalKey'

// Test case 2: only ANTHROPIC_API_KEY set
delete process.env.OPENAI_API_KEY;
process.env.ANTHROPIC_API_KEY = 'anthKey';
console.log('TEST2 anthropic:', getApiKey('anthropic')); // expected 'anthKey'

// Test case 3: only OPENAI_API_KEY set, check anthropic fallback
delete process.env.ANTHROPIC_API_KEY;
process.env.OPENAI_API_KEY = 'globalKey';
console.log('TEST3 anthropic fallback:', getApiKey('anthropic')); // expected undefined