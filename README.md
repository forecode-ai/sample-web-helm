# sample-web-helm

Part of the ForeCode test estate. Not a real product.

A Node web app, built as a container image and deployed to Kubernetes with Helm: to `staging` on every change to `main`
and on a schedule, and to `production` when run manually (the `production` environment needs an approval).

Deploys are simulated: `.github/simulate.sh` makes the deploy tools print what they would do. Set the repository
variable `LIVE_DEPLOYS` to `true` only if real infrastructure exists.
