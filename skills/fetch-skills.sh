#!/usr/bin/env bash
# Reconstruct the exact 8-skill pack the Local AI was given.
# All upstream content is MIT-licensed and belongs to its authors (see README.md).
# Nothing is vendored in this repo; this script fetches it at the pinned commits.
set -euo pipefail
DEST="${1:-./gamedev-pack}"
mkdir -p "$DEST" && cd "$DEST"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

fetch() { # repo commit upstream_path skill_name
  local repo="$1" commit="$2" path="$3" name="$4"
  echo "==> $name  ($repo @ ${commit:0:8})"
  if [ ! -d "$TMP/$(basename "$repo")" ]; then
    git -C "$TMP" clone --quiet --filter=blob:none --no-checkout "$repo" 2>/dev/null
  fi
  local d="$TMP/$(basename "$repo")"
  git -C "$d" checkout --quiet "$commit" -- "$path" 2>/dev/null || {
    git -C "$d" fetch --quiet origin "$commit"; git -C "$d" checkout --quiet "$commit" -- "$path"; }
  mkdir -p "$name"; cp -R "$d/$path/." "$name/"
  # keep the upstream licence alongside the content
  git -C "$d" checkout --quiet "$commit" -- LICENSE 2>/dev/null && cp "$d/LICENSE" "$name/LICENSE.upstream" || true
}

MAJID=https://github.com/majidmanzarpour/threejs-game-skills
MC=7221c1f4a6d2ae189a4d85d058d24f3228499d46

fetch https://github.com/github/awesome-copilot f11a4e441c5ff061b4f8ae37952be8c602e4034e skills/game-engine   game-engine
fetch https://github.com/Jeffallan/claude-skills 882ef55e377dbf9a4dbe496bb41ac6ccd0e555cf skills/game-developer game-developer
for s in threejs-gameplay-systems threejs-game-ui-designer threejs-aaa-graphics-builder \
         threejs-debug-profiler threejs-qa-release threejs-game-director; do
  fetch "$MAJID" "$MC" "skills/$s" "$s"
done

echo
echo "Done -> $DEST"
echo "Verify against skills_manifest.json (skill_content_sha256) if you need byte-level assurance."
echo "NOT fetched, on purpose (external generation APIs, would break local-only):"
echo "  threejs-3d-generator  threejs-image-generator  threejs-audio-generator"
