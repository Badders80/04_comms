# 04_comms — pipelines live in .agents/skills/

default:
    @just --list

# Push investor update HTML to Gmail drafts (gws)
push-draft html subject:
    ./scripts/push_investor_update_draft.sh "{{html}}" "{{subject}}"

# Deploy update assets to 02_website + Vercel prod
deploy-update slug *extra:
    ./scripts/deploy_investor_update_assets.sh "{{slug}}" {{extra}}