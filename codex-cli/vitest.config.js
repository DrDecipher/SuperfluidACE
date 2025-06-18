// SF> 2025-06-16 15:25 | JavaScript Vitest config, bypass TypeScript config bundling errors.
import { defineConfig } from "vitest/config";

// SF> 2025-06-16 15:25 | Set test environment to Node and disable threads for sandbox compatibility.
export default defineConfig({
  test: {
    threads: false,
    environment: "node",
  },
});