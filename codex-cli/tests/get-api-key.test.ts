import { describe, it, expect, beforeEach, afterEach } from "vitest";

// SF> 2025-06-16 15:00 | Added tests for getApiKey fallback and provider-specific env var behavior.

const ORIGINAL_OPENAI_KEY = process.env["OPENAI_API_KEY"];
const ORIGINAL_ANTHROPIC_KEY = process.env["ANTHROPIC_API_KEY"];
const ORIGINAL_SOMECUSTOM_KEY = process.env["SOMECUSTOM_API_KEY"];

beforeEach(() => {
  delete process.env["OPENAI_API_KEY"];
  delete process.env["ANTHROPIC_API_KEY"];
  delete process.env["SOMECUSTOM_API_KEY"];
});

afterEach(() => {
  if (ORIGINAL_OPENAI_KEY !== undefined) {
    process.env["OPENAI_API_KEY"] = ORIGINAL_OPENAI_KEY;
  } else {
    delete process.env["OPENAI_API_KEY"];
  }
  if (ORIGINAL_ANTHROPIC_KEY !== undefined) {
    process.env["ANTHROPIC_API_KEY"] = ORIGINAL_ANTHROPIC_KEY;
  } else {
    delete process.env["ANTHROPIC_API_KEY"];
  }
  if (ORIGINAL_SOMECUSTOM_KEY !== undefined) {
    process.env["SOMECUSTOM_API_KEY"] = ORIGINAL_SOMECUSTOM_KEY;
  } else {
    delete process.env["SOMECUSTOM_API_KEY"];
  }
});

describe("getApiKey provider-specific behavior", () => {
  it("returns OPENAI_API_KEY for openai provider when only global key is set", async () => {
    process.env["OPENAI_API_KEY"] = "global-key";
    const { getApiKey } = await import("../src/utils/config.js");
    expect(getApiKey("openai")).toBe("global-key");
  });

  it("returns undefined for non-openai provider when only OPENAI_API_KEY is set", async () => {
    process.env["OPENAI_API_KEY"] = "global-key";
    const { getApiKey } = await import("../src/utils/config.js");
    expect(getApiKey("anthropic")).toBeUndefined();
  });

  it("returns provider-specific key for built-in provider and ignores global key", async () => {
    process.env["OPENAI_API_KEY"] = "global-key";
    process.env["ANTHROPIC_API_KEY"] = "anthropic-key";
    const { getApiKey } = await import("../src/utils/config.js");
    expect(getApiKey("anthropic")).toBe("anthropic-key");
  });
});