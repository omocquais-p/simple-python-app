#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/../utils.sh"

info "Adding the git-github-ssh secret into the default Service Account"

kubectl get serviceaccount default -o yaml

kubectl annotate --overwrite ns apps param.nsp.tap/supply_chain_service_account.secrets='["registries-credentials", "git-github-ssh"]'
kubectl annotate --overwrite ns apps param.nsp.tap/delivery_service_account.secrets='["registries-credentials", "git-github-ssh"]'

kubectl get serviceaccount default -o yaml

success "Service Account has been successfully updated with the git-github-ssh secret"