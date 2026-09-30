#!/usr/bin/env bash
set -euo pipefail

require_env() {
  local name="$1"

  if [[ -z "${!name:-}" ]]; then
    echo "${name} is required." >&2
    exit 1
  fi
}

slugify() {
  tr "[:upper:]" "[:lower:]" |
    sed -E "s/[^a-z0-9]+/-/g; s/^-+//; s/-+$//"
}

for name in \
  COMMIT_SHA \
  DEPLOY_BRANCH \
  DEPLOYMENT_URL \
  GH_TOKEN \
  GITHUB_REPOSITORY \
  PREVIEW_NAME \
  PR_NUMBER; do
  require_env "${name}"
done

preview_slug="$(printf "%s" "${PREVIEW_NAME}" | slugify)"
if [[ -z "${preview_slug}" ]]; then
  echo "PREVIEW_NAME must contain at least one alphanumeric character." >&2
  exit 1
fi

comment_marker="<!-- ${preview_slug}-pages-preview -->"
comment_body="$(
  printf "%s\n%s preview deployed: %s\n\n- Branch: \`%s\`\n- Commit: \`%s\`\n" \
    "${comment_marker}" \
    "${PREVIEW_NAME}" \
    "${DEPLOYMENT_URL}" \
    "${DEPLOY_BRANCH}" \
    "${COMMIT_SHA}"
)"

comment_id="$(
  gh api "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
    --paginate \
    --jq '.[] | select(.user.login == "github-actions[bot]") | [.id, .body] | @tsv' |
    while IFS=$'\t' read -r id existing_body; do
      if [[ "${existing_body}" == *"${comment_marker}"* ]]; then
        echo "${id}"
      fi
    done |
    tail -n 1
)"

if [[ -n "${comment_id}" ]]; then
  gh api \
    --method PATCH \
    "repos/${GITHUB_REPOSITORY}/issues/comments/${comment_id}" \
    -f "body=${comment_body}" >/dev/null
else
  gh api \
    --method POST \
    "repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments" \
    -f "body=${comment_body}" >/dev/null
fi
