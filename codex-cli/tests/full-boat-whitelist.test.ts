import { describe, expect, it } from "vitest";

// We import the helper via relative path since it's internal to handle-exec-command.
// eslint-disable-next-line import/no-relative-packages
import { extractFirstOffendingHost as extractFn } from "../src/utils/agent/handle-exec-command.js";

describe("full-boat whitelist helper", () => {
  it("returns null when host is allowed", () => {
    const host = extractFn(["curl", "https://github.com"], ["github.com"]);
    expect(host).toBeNull();
  });

  it("returns offending host when not allowed", () => {
    const host = extractFn(["curl", "https://example.com"], ["github.com"]);
    expect(host).toBe("example.com");
  });
});
