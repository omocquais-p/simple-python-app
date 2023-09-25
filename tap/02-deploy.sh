#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/utils.sh"

PROJECT_ROOT_DIR="$SCRIPT_DIR/.."

info "Deploying the workload"
tanzu apps workload apply -f "$PROJECT_ROOT_DIR"/config/workload.yaml --yes

success "Workload deployed"