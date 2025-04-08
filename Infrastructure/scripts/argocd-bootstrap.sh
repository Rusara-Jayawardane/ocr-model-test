#!/bin/bash
set -euo pipefail

# navigate to the root of the repository
cd "$(dirname "$0")/../.."

GITOPS_PATH="Infrastructure/gitops"

helm repo add argo-cd https://argoproj.github.io/argo-helm
helm dependency update "$GITOPS_PATH/charts/argo-cd"

helm upgrade -i argo-cd "$GITOPS_PATH/charts/argo-cd" --namespace argo-cd --create-namespace --wait

helm template "$GITOPS_PATH/apps/" --show-only "templates/project.yaml" | kubectl apply -f - --wait
helm template "$GITOPS_PATH/apps/" --show-only "templates/parent-app.yaml" | kubectl apply -f - --wait
