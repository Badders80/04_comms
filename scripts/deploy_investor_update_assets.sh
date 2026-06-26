#!/usr/bin/env bash
# Commit public/updates assets + email HTML and deploy to production (Vercel).
set -euo pipefail

REPO="/home/evo/evo_01/02_website"
SLUG="${1:?Usage: deploy_investor_update_assets.sh <slug> [extra-asset.jpg ...]}"

shift
EXTRA=("$@")

cd "$REPO"

git add \
  "public/updates/${SLUG}_email.html" \
  "public/updates/evolution-stables-logo-header.jpg" \
  "public/updates/EvolutionStables-Mono-White.png" \
  public/updates/AB_Signiture.png

for f in "${EXTRA[@]}"; do
  git add "public/updates/${f}"
done

if git diff --cached --quiet; then
  echo "Nothing to commit."
else
  git commit -m "deploy: investor update ${SLUG} assets"
  git push origin main
fi

echo "Deploying to Vercel production ..."
vercel --prod --yes

HERO=""
for f in "${EXTRA[@]}"; do
  if [[ "$f" == *.jpg || "$f" == *.png || "$f" == *.webp ]]; then
    HERO="$f"
    break
  fi
done

"/home/evo/evo_01/04_comms/scripts/verify_investor_update_assets.sh" "$HERO"