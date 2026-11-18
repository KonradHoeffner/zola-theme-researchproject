#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
link="$root/template/themes/researchproject"

mkdir -p "$root/template/themes"

if [ -e "$link" ] && [ ! -L "$link" ]; then
  echo "error: $link exists and is not a symlink" >&2
  echo "remove it before running this script" >&2
  exit 1
fi

ln -sfn ../.. "$link"
echo "linked $link -> ../.."
