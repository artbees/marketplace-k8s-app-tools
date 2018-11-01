ifndef __TESTING_MAKEFILE__

__TESTING_MAKEFILE__ := included

# TODO: Move testing targets in top-level Makefile to here and include
# this file in top-level Makefile.

include common.Makefile
include gcloud.Makefile
include marketplace.Makefile

TEST_ID := $(shell cat /dev/urandom | tr -dc 'a-z0-9' | head -c 8)

.testing/marketplace/deployer/helm_tiller_onbuild:
	mkdir -p $@

.testing/marketplace/deployer/helm_tiller_onbuild/helm-dependency-build: \
		.build/marketplace/deployer/helm_tiller_onbuild \
		.build/marketplace/dev \
		.build/var/MARKETPLACE_TOOLS_TAG \
		.build/var/REGISTRY \
		$(shell find testing/marketplace/deployer_helm_tiller_base/onbuild/helm-dependency-build -type f) \
		testing.Makefile \
		| .testing/marketplace/deployer/helm_tiller_onbuild
	$(call print_target)
	TEST_ID=$(TEST_ID) \
	REGISTRY=$(REGISTRY) \
	MARKETPLACE_TOOLS_TAG=$(MARKETPLACE_TOOLS_TAG) \
	  ./testing/marketplace/deployer_helm_tiller_base/onbuild/helm-dependency-build/run_test
	@touch "$@"


.testing/marketplace/deployer/helm_tiller_onbuild/standard: \
		.build/marketplace/deployer/helm_tiller_onbuild \
		.build/marketplace/dev \
		.build/var/MARKETPLACE_TOOLS_TAG \
		.build/var/REGISTRY \
		$(shell find testing/marketplace/deployer_helm_tiller_base/onbuild/standard -type f) \
		testing.Makefile \
		| .testing/marketplace/deployer/helm_tiller_onbuild
	$(call print_target)
	TEST_ID=$(TEST_ID) \
	REGISTRY=$(REGISTRY) \
	MARKETPLACE_TOOLS_TAG=$(MARKETPLACE_TOOLS_TAG) \
	  ./testing/marketplace/deployer_helm_tiller_base/onbuild/standard/run_test
	@touch "$@"


.PHONY: testing/marketplace/deployer/helm_tiller_onbuild
testing/marketplace/deployer/helm_tiller_onbuild: \
		.testing/marketplace/deployer/helm_tiller_onbuild/helm-dependency-build \
		.testing/marketplace/deployer/helm_tiller_onbuild/standard


.testing/marketplace/deployer/envsubst:
	mkdir -p $@

.testing/marketplace/deployer/envsubst/standard: \
		.build/marketplace/deployer/envsubst \
		.build/marketplace/dev \
		.build/var/MARKETPLACE_TOOLS_TAG \
		.build/var/REGISTRY \
		$(shell find testing/marketplace/deployer_envsubst_base/standard -type f) \
		testing.Makefile \
		| .testing/marketplace/deployer/envsubst
	$(call print_target)
	TEST_ID=$(TEST_ID) \
	REGISTRY=$(REGISTRY) \
	MARKETPLACE_TOOLS_TAG=$(MARKETPLACE_TOOLS_TAG) \
	  ./testing/marketplace/deployer_envsubst_base/standard/run_test
	@touch "$@"

.PHONY: testing/marketplace/deployer/envsubst
testing/marketplace/deployer/envsubst: \
		.testing/marketplace/deployer/envsubst/standard


.PHONY: testing/all
testing/all: \
		testing/marketplace/deployer/envsubst \
		testing/marketplace/deployer/helm_tiller_onbuild


endif
