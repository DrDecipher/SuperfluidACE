// Note that "../package.json" is marked external in build.mjs. This ensures
// that the contents of package.json will always be read at runtime, which is
// preferable so we do not have to make a temporary change to package.json in
// the source tree to update the version number in the code.
import pkg from "../package.json" with { type: "json" };
import { execSync } from "child_process";

// Read the version from package.json, falling back to the latest Git tag
// if package.json still has the placeholder version.
let version = (pkg).version;
if (version.startsWith("0.0.0")) {
  try {
    const tag = execSync("git describe --abbrev=0 --tags", { encoding: "utf8" }).trim();
    version = tag.startsWith("v") ? tag.slice(1) : tag;
  } catch {
    // leave placeholder if Git command fails
  }
}
export const CLI_VERSION = version;

