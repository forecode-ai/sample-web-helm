# Simulated deploys for the ForeCode test estate. Source it before deploy commands:
#
#   source .github/simulate.sh
#   helm upgrade --install web ./chart ...
#
# The workflow keeps real deploy commands, so ForeCode detects them exactly as it would in a customer's pipeline,
# but while SIMULATE is "true" (the default) the deploy tools only print what they would do. Nothing is deployed and
# no cloud credentials are needed.
#
# SIMULATE_FAIL_EVERY=N makes every Nth run (by GITHUB_RUN_NUMBER) fail its deploy, to give a pipeline a known change
# failure rate. 0 (the default) never fails.

SIMULATE="${SIMULATE:-true}"
SIMULATE_FAIL_EVERY="${SIMULATE_FAIL_EVERY:-0}"

_simulated() {
  echo "[simulated] $*"
}

# Deploy tools can fail on purpose (SIMULATE_FAIL_EVERY); building and publishing artifacts never do.
_simulated_deploy() {
  _simulated "$@"
  if [ "$SIMULATE_FAIL_EVERY" -gt 0 ] && [ $(( ${GITHUB_RUN_NUMBER:-1} % SIMULATE_FAIL_EVERY )) -eq 0 ]; then
    echo "::error::simulated deploy failure (run ${GITHUB_RUN_NUMBER:-1}, every ${SIMULATE_FAIL_EVERY}th run fails)"
    return 1
  fi
}

if [ "$SIMULATE" = "true" ]; then
  helm() { _simulated_deploy helm "$@"; }
  kubectl() { _simulated_deploy kubectl "$@"; }
  aws() { _simulated_deploy aws "$@"; }
  sam() { _simulated_deploy sam "$@"; }
  ssh() { _simulated_deploy ssh "$@"; }
  scp() { _simulated scp "$@"; }
  docker() {
    case "$1" in
      push|login) _simulated docker "$@" ;;
      *) command docker "$@" ;;
    esac
  }
  npm() {
    case "$1" in
      publish) _simulated npm "$@" ;;
      *) command npm "$@" ;;
    esac
  }
  terraform() {
    case "$1" in
      plan) _simulated terraform "$@" ;;
      apply|destroy|import) _simulated_deploy terraform "$@" ;;
      init) command terraform init -backend=false "${@:2}" ;;
      *) command terraform "$@" ;;
    esac
  }
  echo "Deploys are simulated (SIMULATE=true): deploy tools print instead of acting."
fi
