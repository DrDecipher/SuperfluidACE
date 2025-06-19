// 2025-06-19T00:20Z AI: Unit test verifying recursive `#include` expansion in loadProjectDoc()

import { describe, it, expect } from 'vitest';
import { mkdtempSync, writeFileSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

// Import directly from source to avoid build step
import { loadProjectDoc } from '../src/utils/config.js';

describe('loadProjectDoc – #include expansion', () => {
  it('inlines a single included file', () => {
    const tmp = mkdtempSync(join(tmpdir(), 'codex-include-'));

    const rootPath = join(tmp, 'root.md');
    const incPath = join(tmp, 'inc.md');

    writeFileSync(rootPath, `Hello\n#include inc.md`);
    writeFileSync(incPath, `Inner`);

    const out = loadProjectDoc(tmp, 'root.md');

    expect(out).toContain('Inner');
    expect(out).toMatch(/<!-- begin include: inc\.md -->/);
    expect(out).toMatch(/<!-- end include: inc\.md -->/);
  });

  it('avoids circular includes', () => {
    const tmp = mkdtempSync(join(tmpdir(), 'codex-include-loop-'));

    const aPath = join(tmp, 'a.md');
    const bPath = join(tmp, 'b.md');

    writeFileSync(aPath, `File A\n#include b.md`);
    writeFileSync(bPath, `File B\n#include a.md`);

    const out = loadProjectDoc(tmp, 'a.md');

    // b.md should be included exactly once, but a second #include should be skipped
    const first = out.match(/File B/g)?.length ?? 0;
    expect(first).toBe(1);
  });
});
