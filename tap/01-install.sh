#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/utils.sh"

SUPPLYCHAIN_SCRIPTS_DIR=$SCRIPT_DIR/supplychains

info "01-create-gitops-secret.sh"
"$SUPPLYCHAIN_SCRIPTS_DIR"/01-create-gitops-secret.sh

info "02-patch-service-account.sh"
"$SUPPLYCHAIN_SCRIPTS_DIR"/02-patch-service-account.sh

success "DONE"