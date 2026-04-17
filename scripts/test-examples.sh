#!/usr/bin/env bash
# Runs `terraform init -backend=false`, `terraform validate`, and
# (optionally) `terraform plan -refresh=false` against every example under
# ./examples.
#
# No Azure subscription, credentials, or apply is required for the default
# validate-only mode. Passing `--with-plan` attempts a plan as well, which
# requires working Azure credentials for any example that uses data sources
# (e.g. custom_source_image).
#
# Usage:
#   scripts/test-examples.sh              # validate every example (default)
#   scripts/test-examples.sh --with-plan  # also run `terraform plan`

set -euo pipefail

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
EXAMPLES_DIR="$REPO_ROOT/examples"

WITH_PLAN=0
for arg in "$@"; do
  case "$arg" in
    --with-plan) WITH_PLAN=1 ;;
    -h|--help)
      sed -n '2,14p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

failures=()

for example in "$EXAMPLES_DIR"/*/; do
  name="$(basename "$example")"
  echo
  echo "=========================================="
  echo "Example: $name"
  echo "=========================================="

  (
    cd "$example"
    rm -rf .terraform .terraform.lock.hcl
    terraform init -backend=false -upgrade -input=false -no-color >/dev/null
    terraform validate -no-color
    if [[ "$WITH_PLAN" -eq 1 ]]; then
      if [[ -f terraform.tfvars ]]; then
        terraform plan -refresh=false -input=false -no-color -out=/dev/null
      else
        echo "Skipping plan for $name — no terraform.tfvars present"
      fi
    fi
  ) || failures+=("$name")
done

echo
if [[ "${#failures[@]}" -gt 0 ]]; then
  echo "FAILED examples: ${failures[*]}" >&2
  exit 1
fi

echo "All examples validated successfully."
