#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && cd .. && pwd)"
source "$SCRIPT_DIR/utils.sh"

info "kubectl get httpproxy tap-gui -n tap-gui"
TAP_GUI_URL=$(kubectl get httpproxy tap-gui -n tap-gui -o yaml | yq '.spec.virtualhost.fqdn' | tr -d '\n')
info "TAP GUI URL: https://$TAP_GUI_URL"
