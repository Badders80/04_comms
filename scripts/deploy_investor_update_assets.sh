#!/usr/bin/env bash
# Commit public/updates assets + email HTML and deploy to production (Vercel).
set -euo pipefail

REPO="/home/evo/evo_01/02_website"
SLUG="${1:?Usage: deploy_investor_update_assets.sh <slug> [extra-asset.jpg ...]}"

shift
EXTRA=("$@")

cd "$REPO"

ADD_LIST=(
  "public/updates/${SLUG}.html"
  "public/updates/${SLUG}_email.html"
  "public/updates/evolution-stables-wordmark-muted-grey.jpg"
  "public/updates/EvolutionStables-Mono-White.png"
  "public/updates/AB_Signiture.png"
)
for f in "${EXTRA[@]}"; do
  ADD_LIST+=("public/updates/${f}")
done

for path in "${ADD_LIST[@]}"; do
  if [[ -f "$path" ]]; then
    git add "$path"
  else
    echo "Skip missing: $path"
  fi
done

if git diff --cached --quiet; then
  echo "Nothing to commit."
else
  git commit -m "deploy: investor update ${SLUG} assets"
  git push origin main
fi

echo "Deploying to Vercel production ..."
npx vercel --prod --yes

HERO=""
for f in "${EXTRA[@]}"; do
  if [[ "$f" == *.jpg || "$f" == *.png || "$f" == *.webp ]]; then
    HERO="$f"
    break
  fi
done

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/verify_investor_update_assets.sh" "$HERO"