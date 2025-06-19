// 2025-06-19T23:30Z AI: Unit tests for Home/End and Shift+Home/End behaviour in TextBuffer

import { describe, it, expect } from 'vitest';

// Import directly from source so no build step required.
import TextBuffer from '../src/text-buffer.js';

function vp() {
  return { height: 10, width: 80 };
}

describe('TextBuffer – Home/End navigation', () => {
  it('moves caret to start and end of line', () => {
    const tb = new TextBuffer('hello', 3); // caret between l and l (index 3)

    tb.handleInput(undefined, { home: true } as any, vp());
    expect(tb.getCursor()).toEqual([0, 0]);

    tb.handleInput(undefined, { end: true } as any, vp());
    expect(tb.getCursor()).toEqual([0, 5]);
  });

  it('Shift+Home selects text to start', () => {
    const tb = new TextBuffer('hello', 3); // caret after "hel"

    tb.handleInput(undefined, { shift: true, home: true } as any, vp());

    // Copy should return selected text "hel"
    expect(tb.copy()).toBe('hel');
  });

  it('Shift+End selects text to end', () => {
    const tb = new TextBuffer('hello', 1); // caret after 'h'

    tb.handleInput(undefined, { shift: true, end: true } as any, vp());

    expect(tb.copy()).toBe('ello');
  });
});
