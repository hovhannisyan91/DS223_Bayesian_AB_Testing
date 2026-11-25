#!/usr/bin/env bash
set -euo pipefail

# Resolve the tutorial directory so this script also works from the repo root.
tutorial_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$tutorial_dir"

# Prefer the project's installation; activation is not required.
if [[ -x "$tutorial_dir/.venv/bin/quarto" ]]; then
  quarto_command=("$tutorial_dir/.venv/bin/quarto")
elif command -v quarto >/dev/null 2>&1; then
  quarto_command=(quarto)
elif command -v uv >/dev/null 2>&1; then
  quarto_command=(uv run quarto)
else
  echo "Quarto was not found. Install Quarto or use uv to install the tutorial dependencies." >&2
  exit 1
fi

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  exec "${quarto_command[@]}" preview "$@"
fi

# Build the entire website before serving it, including all linked tutorials.
exec "${quarto_command[@]}" preview --render all "$@"

