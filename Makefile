include .env
$(eval export $(shell sed -ne 's/ *#.*$$//; /./ s/=.*$$// p' .env))

SHELL=/bin/bash

kubeconfig:
	if [ -z ${KUBECONFIG} ]; then echo "KUBECONFIG is unset"; exit 1; else echo "KUBECONFIG is set to '$(KUBECONFIG)'"; fi

install: kubeconfig
	{ \
	set -e ;\
	./tap/02-deploy.sh ;\
	}