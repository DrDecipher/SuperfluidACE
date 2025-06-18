// Note that "../package.json" is marked external in build.mjs. This ensures
// that the contents of package.json will always be read at runtime, which is
// preferable so we do not have to make a temporary change to package.json in
// the source tree to update the version number in the code.
import pkg from "../package.json" with { type: "json" };
import { execSync } from "node:child_process";

// SF> 2025-06-18 16:05 | Augment dev version: show latest release tag and current commit hash for clarity.

let version: string = (pkg as { version: string }).version; // SF> 2025-06-18 16:05 | Base version from package.json.

if (version === "0.0.0-dev") {
  // Find most recent SemVer-looking string in last 50 commit messages.
  try {
    const log = execSync("git log -n 50 --pretty=%s", {
      stdio: ["ignore", "pipe", "ignore"],
    })
      .toString()
      .split("\n");

    for (const msg of log) {
      const m = msg.match(/\b(\d+\.\d+\.\d+)\b/);
      if (m) {
        version += ` (based on ${m[1]}`;
        break;
      }
    }
  } catch {
    // Ignore if git unavailable.
  }

  // Append short commit hash for unique identification.
  try {
    const hash = execSync("git rev-parse --short HEAD", {
      stdio: ["ignore", "pipe", "ignore"],
    })
      .toString()
      .trim();
    version += version.includes("based on") ? `, +${hash})` : ` (+${hash})`;
  } catch {
    // Ignore.
  }
}

export const CLI_VERSION: string = version;
