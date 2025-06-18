import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { scaffoldFeature } from "../src/cli.js"; // Import compiled JS output to avoid TS path issues
import fs from "fs";
import os from "os";
import path from "path";

// SF> 2025-06-14 14:05 | Added tests for the new feature scaffolding workflow.

function createTempRepo(): {
  cwd: string;
  cleanup: () => void;
} {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "codex-wizard-test-"));
  // Basic repo skeleton
  fs.mkdirSync(path.join(dir, ".Superfluid", "Logs"), { recursive: true });
  fs.writeFileSync(path.join(dir, ".Superfluid", "Logs", "changeLog.md"), "", "utf8");
  fs.writeFileSync(path.join(dir, "agents.md"), "# Test Agents\n", "utf8");

  const cleanup = () => {
    fs.rmSync(dir, { recursive: true, force: true });
  };

  return { cwd: dir, cleanup };
}

describe("Feature wizard scaffolding", () => {
  let sandbox: ReturnType<typeof createTempRepo>;

  beforeEach(() => {
    sandbox = createTempRepo();
  });

  afterEach(() => {
    sandbox.cleanup();
  });

  it("creates the expected feature files and updates agents.md", () => {
    const featureName = "MyCoolFeature";
    const description = "Demo description";

    scaffoldFeature(featureName, description, sandbox.cwd);

    const base = path.join(
      sandbox.cwd,
      ".Superfluid",
      "Features",
      featureName,
    );

    const expectedFiles = [
      `${featureName}_Context.md`,
      `${featureName}_Plan.md`,
      `${featureName}_Log.md`,
      `${featureName}_Learn.md`,
    ];

    expectedFiles.forEach((file) => {
      const fp = path.join(base, file);
      expect(fs.existsSync(fp)).toBe(true);
      // Basic sanity check for content length > 0
      expect(fs.readFileSync(fp, "utf8").length).toBeGreaterThan(0);
    });

    // agents.md should now reference ActiveFeature line
    const agents = fs.readFileSync(path.join(sandbox.cwd, "agents.md"), "utf8");
    expect(agents.includes(`ActiveFeature: ${featureName}`)).toBe(true);

    // changeLog should include scaffold entry
    const changeLog = fs.readFileSync(
      path.join(sandbox.cwd, ".Superfluid", "Logs", "changeLog.md"),
      "utf8",
    );
    expect(changeLog.includes("scaffoldFeature()")).toBe(true);
  });
});
