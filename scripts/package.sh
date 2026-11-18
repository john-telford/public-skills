#!/usr/bin/env bash
# Validate every skill under skills/ and zip each into dist/<name>.skill
# (the upload format for claude.ai). dist/ is gitignored: .skill files are
# build output and ship as GitHub release assets, so they never drift from source.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
rm -rf dist && mkdir dist

fail=0
for dir in skills/*/; do
  name="$(basename "$dir")"
  file="$dir/SKILL.md"
  [[ -f "$file" ]] || { echo "✗ $name: missing SKILL.md"; fail=1; continue; }

  # Frontmatter is the block between the first two '---' lines.
  fm="$(awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1{print}' "$file")"
  fm_name="$(sed -n 's/^name:[[:space:]]*//p' <<<"$fm")"
  desc="$(sed -n 's/^description:[[:space:]]*//p' <<<"$fm")"

  # Rules from the Agent Skills spec (agentskills.io/specification).
  [[ "$fm_name" == "$name" ]] || { echo "✗ $name: frontmatter name '$fm_name' must match directory"; fail=1; }
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#name} -le 64 ]] || { echo "✗ $name: name must be lowercase a-z0-9 and single hyphens, max 64"; fail=1; }
  [[ -n "$desc" && ${#desc} -le 1024 ]] || { echo "✗ $name: description must be 1-1024 chars (is ${#desc})"; fail=1; }
  grep -q "\"./skills/$name\"" .claude-plugin/marketplace.json || { echo "✗ $name: not listed in .claude-plugin/marketplace.json"; fail=1; }

  (cd skills && zip -qr "../dist/$name.skill" "$name" -x '*.DS_Store')
  echo "✓ $name → dist/$name.skill (description ${#desc}/1024 chars, $(wc -l <"$file" | tr -d ' ') lines)"
done

exit $fail
