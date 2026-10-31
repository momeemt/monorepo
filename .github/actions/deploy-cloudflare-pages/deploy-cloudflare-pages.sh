#!/usr/bin/env bash
set -euo pipefail

require_env() {
  local name="$1"

  if [[ -z "${!name:-}" ]]; then
    echo "${name} is required." >&2
    exit 1
  fi
}

for name in \
  CLOUDFLARE_ACCOUNT_ID \
  CLOUDFLARE_API_TOKEN \
  GITHUB_OUTPUT \
  PAGES_DIRECTORY \
  PAGES_DOMAIN \
  PAGES_PROJECT_NAME \
  RUNNER_TEMP; do
  require_env "${name}"
done

if [[ ! -d "${PAGES_DIRECTORY}" ]]; then
  echo "PAGES_DIRECTORY does not exist or is not a directory: ${PAGES_DIRECTORY}" >&2
  exit 1
fi

deploy_branch="${GITHUB_HEAD_REF:-${GITHUB_REF_NAME:-}}"
if [[ -z "${deploy_branch}" ]]; then
  echo "GITHUB_HEAD_REF or GITHUB_REF_NAME is required." >&2
  exit 1
fi

deploy_log="${RUNNER_TEMP}/wrangler-pages-deploy-${PAGES_PROJECT_NAME}.log"

npx --yes wrangler@4 pages deploy "${PAGES_DIRECTORY}" \
  --project-name "${PAGES_PROJECT_NAME}" \
  --branch "${deploy_branch}" \
  2>&1 | tee "${deploy_log}"

deployment_url="$(
  (grep -Eo "https://[^[:space:]]+" "${deploy_log}" || true) |
    awk -v domain="${PAGES_DOMAIN}" 'index($0, "pages.dev") || index($0, domain)' |
    tail -n 1
)"
if [[ -z "${deployment_url}" ]]; then
  echo "Failed to extract Cloudflare Pages deployment URL." >&2
  exit 1
fi

{
  echo "deploy_branch=${deploy_branch}"
  echo "deployment_url=${deployment_url}"
} >>"${GITHUB_OUTPUT}"
