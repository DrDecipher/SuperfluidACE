#!/usr/bin/env python3
# 2025-06-19T00:40Z AI: Script to automate creation of development plan from a design file

"""init_feature.py

Usage:
    python init_feature.py path/to/design.md

Given a design document located in `.pSuperfluid/Features/A_Design`, this script
creates a development plan in `.pSuperfluid/Features/B_Development/` following
the numbering and template rules defined in `FeatureDev.md`.

Steps:
1. Determine next incremental feature number (zero-padded to 3 digits).
2. Slugify the design filename (strip extension, convert to kebab-case).
3. Read the template from `FeatureDev.md` (embedded copy) and fill dynamic
   placeholders.
4. Write the new file and print its path.

The script is intentionally standalone – it requires only the Python standard
library so it can run in any environment without additional dependencies.
"""

from __future__ import annotations

import re
import sys
from datetime import datetime, timezone
from pathlib import Path


# 2025-06-19T00:55Z AI: Adjusted root calculation and directory constants for clarity and to include Implimented dir when finding next number.
# Determine repository root assuming this script is nested four levels deep.
ROOT = Path(__file__).resolve().parents[3]  # .pSuperfluid/Scripts/python -> up 3

# Directory constants.
A_DESIGN_DIR = ROOT / ".pSuperfluid" / "Features" / "A_Design"
B_DEV_DIR = ROOT / ".pSuperfluid" / "Features" / "B_Development"
C_IMPL_DIR = ROOT / ".pSuperfluid" / "Features" / "C_Implimented"


TEMPLATE = (
    "# Feature {number} – {title}\n\n"
    "*Design origin: {design_rel} (copied on {date})*\n\n"
    "## Goal\n\n<one-sentence objective>\n\n"
    "## Requirements / Acceptance Criteria\n\n* Bullet list …\n\n"
    "## Execution Steps\n\n1. <step>\n2. <step>\n\n"
    "## Potential Pitfalls\n\n* Bullet list …\n\n"
    "## Timeline Estimate\n\n| Task | ETA |\n|------|-----|\n| Planning | X |\n| Coding   | X |\n| Tests    | X |\n| Docs     | X |\n\n---\n\n"
    "## Execution Report\n\n*Status: In-Progress*\n\n| Date | Note |\n|------|------|\n| {date_short} | Created plan |\n\n### Outstanding Actions\n\n1. …\n\n---\n\n## Context for Future Sessions\n\n<Anything a cold-start agent needs to resume work>\n"
)


def slugify(name: str) -> str:
    """Convert a filename stem to kebab-case."""
    # Replace non-alphanumeric with dash, collapse repeats, lowercase
    slug = re.sub(r"[^A-Za-z0-9]+", "-", name)
    slug = re.sub(r"-+", "-", slug)
    return slug.strip("-").lower()


# SF> 2025-06-19T00:55Z | Extend next_number() to check both B_Development and C_Implimented
def next_number() -> str:
    """Return the next available three-digit feature number.

    Scans **both** B_Development *and* C_Implimented so that features that
    were completed out of order do not cause duplicate numbers.
    """

    B_DEV_DIR.mkdir(parents=True, exist_ok=True)
    C_IMPL_DIR.mkdir(parents=True, exist_ok=True)

    numbers: list[int] = []
    pattern = re.compile(r"^(\d{3})_")

    for directory in (B_DEV_DIR, C_IMPL_DIR):
        for f in directory.glob("*.md"):
            m = pattern.match(f.name)
            if m:
                numbers.append(int(m.group(1)))

    next_num = (max(numbers) + 1) if numbers else 1
    return f"{next_num:03d}"


def main(argv: list[str]) -> None:
    if len(argv) != 2:
        print("Usage: python init_feature.py path/to/design.md", file=sys.stderr)
        sys.exit(1)

    design_path = Path(argv[1]).resolve()
    try:
        design_path.relative_to(A_DESIGN_DIR)
    except ValueError:
        print(
            f"Error: design file must be inside {A_DESIGN_DIR}", file=sys.stderr
        )
        sys.exit(1)

    if not design_path.exists():
        print(f"Design file not found: {design_path}", file=sys.stderr)
        sys.exit(1)

    number = next_number()
    slug = slugify(design_path.stem)

    title = slug.replace("-", " ").title()
    date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    date_short = date

    dev_filename = f"{number}_{slug}.md"
    dev_path = B_DEV_DIR / dev_filename

    design_rel = design_path.relative_to(ROOT)

    content = TEMPLATE.format(
        number=number,
        title=title,
        design_rel=design_rel,
        date=date,
        date_short=date_short,
    )

    dev_path.write_text(content, encoding="utf-8")

    print(f"Created development plan: {dev_path.relative_to(ROOT)}")


if __name__ == "__main__":
    main(sys.argv)
