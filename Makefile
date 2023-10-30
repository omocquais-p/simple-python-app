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

build-image:
	{ \
	set -e ;\
	pack build demo-python-app --builder paketobuildpacks/builder-jammy-base ;\
	}


claims: kubeconfig
	{ \
	set -e ;\
	tanzu service class-claim create postgres-1 --class postgresql-unmanaged ;\
	kubectl wait --for=condition=ready ClassClaim/postgres-1 --timeout=5m ;\
	}


setup-supplychains: kubeconfig
	{ \
	set -e ;\
	./tap/01-install.sh ;\
	}

# TAP - cleanup claims
claims-delete: kubeconfig
	{ \
	set -e ;\
	tanzu service class-claim delete postgres-1 --yes ;\
	}

workload-deploy: kubeconfig claims
	{ \
	set -e ;\
	./tap/02-deploy.sh ;\
	}

# TAP - Undeploy demo-spring-boot workload
workload-undeploy: kubeconfig claims-delete
	{ \
	set -e ;\
	tanzu apps workload delete demo-python-app --yes ;\
	}


print-tap-gui-url: kubeconfig
	{ \
	set -e ;\
	./tap/helpers/print-tap-gui-url.sh  ;\
	}