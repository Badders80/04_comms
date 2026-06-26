#!/usr/bin/env bash
# Post a social package (poster + caption) to X as @EvolutionStable.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage:"
  echo "  push_x_post.sh --package <dir> [--dry-run]"
  echo "  push_x_post.sh <image.png> <caption.txt> [--dry-run]"
  exit 1
}

DRY_RUN=()
if [[ "${@: -1}" == "--dry-run" ]]; then
  DRY_RUN=(--dry-run)
  set -- "${@:1:$#-1}"
fi

if [[ $# -eq 0 ]]; then
  usage
fi

if [[ "$1" == "--package" ]]; then
  PACKAGE="${2:?Package directory required}"
  python3 "$SCRIPT_DIR/push_x_post.py" --package "$PACKAGE" "${DRY_RUN[@]}"
elif [[ $# -eq 2 ]]; then
  python3 "$SCRIPT_DIR/push_x_post.py" "$1" "$2" "${DRY_RUN[@]}"
else
  usage
fi