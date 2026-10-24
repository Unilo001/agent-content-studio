#!/usr/bin/env bash
# Install content-studio skills globally for Claude Code and Codex-style agents.
# Usage: ./install.sh [--copy] [--uninstall]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
mode=link
case "${1:-}" in --copy) mode=copy ;; --uninstall) mode=uninstall ;; esac
for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$here"/skills/*/; do
    name="$(basename "$skill")"; dest="$target/$name"
    if [ "$mode" = uninstall ]; then
      rm -rf "$dest"; continue
    fi
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      echo "skip $dest (exists and is not a symlink)"; continue
    fi
    rm -f "$dest"
    if [ "$mode" = copy ]; then cp -R "$skill" "$dest"; else ln -s "${skill%/}" "$dest"; fi
  done
  echo "$mode: $target"
done
