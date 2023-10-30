#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/../utils.sh"

SSH_FOLDER=~/.ssh

SSH_PRIVATE_KEY=$(cat $SSH_FOLDER/id_rsa)
SSH_IDENTITY=$(cat $SSH_FOLDER/id_rsa)
SSH_IDENTITY_PUB=$(cat $SSH_FOLDER/id_rsa.pub)
SSH_KNOWN_HOSTS=$(cat $SSH_FOLDER/known_hosts)
NAMESPACE=apps

info "Deploying git-github-ssh secret in namespace: $NAMESPACE"

ytt -f "$SCRIPT_DIR"/secret-template.yaml --data-value namespace="$NAMESPACE" --data-value sshprivatekey="$SSH_PRIVATE_KEY" --data-value identity="$SSH_IDENTITY"  --data-value identitypub="$SSH_IDENTITY_PUB" --data-value knownhosts="$SSH_KNOWN_HOSTS" | kubectl apply -f-

success "git-github-ssh secret deployed in namespace: $NAMESPACE"