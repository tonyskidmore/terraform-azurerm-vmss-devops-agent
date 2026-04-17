#!/usr/bin/env bash
# Runs integration tests that apply real Azure + Azure DevOps resources and
# destroy them.
#
# Each test under tests/integration/ provisions supporting network, an Azure
# DevOps project, an AzureRM service connection, then a VMSS and an elastic
# pool in your currently configured subscription + organisation. Assertions
# run, then `terraform test` destroys the resources on teardown.
#
# Requires:
#   - Terraform >= 1.10
#   - Azure credentials: ARM_SUBSCRIPTION_ID plus SP env vars (or `az login`)
#   - Azure DevOps credentials:
#       AZDO_ORG_SERVICE_URL        (https://dev.azure.com/<org>)
#       AZDO_PERSONAL_ACCESS_TOKEN
#   - SP credentials for the AzureRM service connection:
#       TF_VAR_serviceprincipalid
#       TF_VAR_serviceprincipalkey
#       TF_VAR_azurerm_spn_tenantid
#       TF_VAR_azurerm_subscription_id
#
# Usage:
#   scripts/test-integration.sh                # run every integration test (prompts)
#   scripts/test-integration.sh admin_password # run one test
#   scripts/test-integration.sh --yes          # skip the confirmation prompt
#   scripts/test-integration.sh --verbose      # show full plan/state per run
#
# See tests/integration/README.md for what's covered and how to clean up a
# failed run.

set -euo pipefail

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$REPO_ROOT"

YES=0
VERBOSE=0
FILTER=""
for arg in "$@"; do
  case "$arg" in
    --yes|-y) YES=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    -h|--help)
      sed -n '2,27p' "$0"
      exit 0
      ;;
    -*)
      echo "Unknown flag: $arg" >&2
      exit 2
      ;;
    *)
      if [[ -n "$FILTER" ]]; then
        echo "Multiple filter arguments not supported." >&2
        exit 2
      fi
      FILTER="$arg"
      ;;
  esac
done

TEST_DIR="tests/integration"

if [[ ! -d "$TEST_DIR" ]]; then
  echo "$TEST_DIR not found — nothing to run." >&2
  exit 0
fi

# Validate Azure DevOps credentials.
missing=()
[[ -z "${AZDO_ORG_SERVICE_URL:-}"        ]] && missing+=("AZDO_ORG_SERVICE_URL")
[[ -z "${AZDO_PERSONAL_ACCESS_TOKEN:-}"  ]] && missing+=("AZDO_PERSONAL_ACCESS_TOKEN")
[[ -z "${TF_VAR_serviceprincipalid:-}"   ]] && missing+=("TF_VAR_serviceprincipalid")
[[ -z "${TF_VAR_serviceprincipalkey:-}"  ]] && missing+=("TF_VAR_serviceprincipalkey")
[[ -z "${TF_VAR_azurerm_spn_tenantid:-}" ]] && missing+=("TF_VAR_azurerm_spn_tenantid")
[[ -z "${TF_VAR_azurerm_subscription_id:-}" ]] && missing+=("TF_VAR_azurerm_subscription_id")

if (( ${#missing[@]} > 0 )); then
  echo "Missing required environment variables:" >&2
  for v in "${missing[@]}"; do echo "  - $v" >&2; done
  echo >&2
  echo "See tests/integration/README.md for details." >&2
  exit 2
fi

# Confirm Azure credentials.
if [[ -z "${ARM_SUBSCRIPTION_ID:-}" ]]; then
  if ! command -v az >/dev/null 2>&1 || ! az account show >/dev/null 2>&1; then
    echo "No Azure credentials detected: set ARM_SUBSCRIPTION_ID or run 'az login'." >&2
    exit 2
  fi
  ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
  export ARM_SUBSCRIPTION_ID
fi

SUB_NAME=""
if command -v az >/dev/null 2>&1; then
  SUB_NAME="$(az account show --query name -o tsv 2>/dev/null || true)"
fi

cat >&2 <<EOF

============================================================================
WARNING: Integration tests CREATE and DESTROY real Azure + ADO resources.

  Subscription: ${ARM_SUBSCRIPTION_ID}${SUB_NAME:+  (${SUB_NAME})}
  ADO org:      ${AZDO_ORG_SERVICE_URL}

Each test provisions a resource group, vnet, ADO project, AzureRM service
connection, VMSS, and elastic pool. Expect a few minutes per test.

If a test is interrupted mid-apply, clean up manually — see
tests/integration/README.md for commands.
============================================================================

EOF

if [[ "$YES" -ne 1 ]]; then
  read -r -p "Proceed? [y/N] " response
  case "$response" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 0 ;;
  esac
fi

# Persistent provider plugin cache outside .terraform/. This sidesteps a
# Terraform 1.12–1.14 bug in `terraform test` where running multiple
# .tftest.hcl files in one invocation can prematurely garbage-collect
# provider binaries between teardowns, causing destroys to fail with
# "could not read package directory: open .terraform/providers/...".
# With a plugin cache dir set, Terraform symlinks providers from the
# cache into each .terraform/providers/ on demand instead of relying on
# the .terraform-local copies surviving across runs.
if [[ -z "${TF_PLUGIN_CACHE_DIR:-}" ]]; then
  TF_PLUGIN_CACHE_DIR="${REPO_ROOT}/.terraform-plugin-cache"
  export TF_PLUGIN_CACHE_DIR
fi
mkdir -p "$TF_PLUGIN_CACHE_DIR"

# Resolve the test files we'll run.
test_files=()
if [[ -n "$FILTER" ]]; then
  file="$TEST_DIR/${FILTER}.tftest.hcl"
  if [[ ! -f "$file" ]]; then
    echo "No integration test found matching '$FILTER' (looked for $file)." >&2
    echo "Available tests:" >&2
    for f in "$TEST_DIR"/*.tftest.hcl; do
      [[ -e "$f" ]] || continue
      echo "  $(basename "$f" .tftest.hcl)" >&2
    done
    exit 2
  fi
  test_files+=("$file")
else
  for f in "$TEST_DIR"/*.tftest.hcl; do
    [[ -e "$f" ]] || continue
    test_files+=("$f")
  done
  if (( ${#test_files[@]} == 0 )); then
    echo "No .tftest.hcl files found under $TEST_DIR." >&2
    exit 0
  fi
fi

# Fresh init that also resolves the example modules referenced by the test
# files' `module { source = "./examples/..." }` blocks. The `-test-directory`
# flag (Terraform 1.6+) tells init to install those modules too.
rm -rf .terraform .terraform.lock.hcl
terraform init -test-directory="$TEST_DIR" -upgrade -input=false

verbose_args=()
if [[ "$VERBOSE" -eq 1 ]]; then
  verbose_args+=("-verbose")
fi

# Run each test file as its own `terraform test` invocation so a teardown
# failure in one file cannot taint state for the others. This also avoids
# the cross-file provider-cache races mentioned above.
overall_rc=0
failed=()
for tf in "${test_files[@]}"; do
  name="$(basename "$tf" .tftest.hcl)"
  echo
  echo "==> terraform test -test-directory=$TEST_DIR -filter=$tf ${verbose_args[*]}"
  if ! terraform test -test-directory="$TEST_DIR" -filter="$tf" "${verbose_args[@]}"; then
    overall_rc=1
    failed+=("$name")
  fi
done

echo
if (( overall_rc != 0 )); then
  echo "FAILED tests: ${failed[*]}" >&2
fi
exit "$overall_rc"
