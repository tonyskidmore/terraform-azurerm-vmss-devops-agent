#!/usr/bin/env bash
# Top-level local test runner. Runs, in order:
#   1. `terraform fmt -check -recursive` across the whole repo
#   2. `terraform validate` at the module root
#   3. `terraform test` (native .tftest.hcl unit tests under tests/)
#   4. `scripts/test-examples.sh` — init + validate every example
#
# None of these steps require Azure credentials.
#
# Pass arguments through to test-examples.sh, e.g.:
#   scripts/test.sh --with-plan

set -euo pipefail

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$REPO_ROOT"

echo "==> terraform fmt -check -recursive"
terraform fmt -check -recursive

echo
echo "==> terraform init + validate (module root)"
rm -rf .terraform .terraform.lock.hcl
terraform init -backend=false -upgrade -input=false -no-color >/dev/null
terraform validate -no-color

echo
echo "==> terraform test (tests/*.tftest.hcl)"
if compgen -G "tests/*.tftest.hcl" > /dev/null; then
  terraform test
else
  echo "No .tftest.hcl files found under tests/; skipping."
fi

echo
echo "==> examples"
"$REPO_ROOT/scripts/test-examples.sh" "$@"
