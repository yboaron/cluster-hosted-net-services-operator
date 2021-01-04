CLUSTER_CLIENT ?= oc
# Current Operator version
VERSION ?= 0.0.1
# Default bundle image tag
BUNDLE_IMG ?= controller-bundle:$(VERSION)
# Options for 'bundle-build'
ifneq ($(origin CHANNELS), undefined)
BUNDLE_CHANNELS := --channels=$(CHANNELS)
endif
ifneq ($(origin DEFAULT_CHANNEL), undefined)
BUNDLE_DEFAULT_CHANNEL := --default-channel=$(DEFAULT_CHANNEL)
endif
BUNDLE_METADATA_OPTS ?= $(BUNDLE_CHANNELS) $(BUNDLE_DEFAULT_CHANNEL)

CRD_OPTIONS="crd:trivialVersions=true,crdVersions=v1"
MANIFEST_PROFILE ?= default
TMP_DIR := $(shell mktemp -d -t manifests-$(date +%Y-%m-%d-%H-%M-%S)-XXXXXXXXXX)

# Image URL to use all building/pushing image targets
IMG ?= quay.io/yboaron/cluster-hosted-net-services-operator:latest

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

all: manager

# Run tests
ENVTEST_ASSETS_DIR = $(shell pwd)/testbin
test: generate fmt vet manifests
	mkdir -p $(ENVTEST_ASSETS_DIR)
	test -f $(ENVTEST_ASSETS_DIR)/setup-envtest.sh || curl -sSLo $(ENVTEST_ASSETS_DIR)/setup-envtest.sh https://raw.githubusercontent.com/kubernetes-sigs/controller-runtime/v0.6.3/hack/setup-envtest.sh
	source $(ENVTEST_ASSETS_DIR)/setup-envtest.sh; fetch_envtest_tools $(ENVTEST_ASSETS_DIR); setup_envtest_env $(ENVTEST_ASSETS_DIR); go test ./... -coverprofile cover.out

# Build manager binary
manager: generate fmt vet
	go build -o bin/manager main.go

# Run against the configured Kubernetes cluster in ~/.kube/config
run: generate fmt vet manifests
	go run ./main.go

# Install CRDs into a cluster
install: manifests kustomize
	$(KUSTOMIZE) build config/crd | $(CLUSTER_CLIENT) apply -f -

# Uninstall CRDs from a cluster
uninstall: manifests kustomize
	$(KUSTOMIZE) build config/crd | $(CLUSTER_CLIENT) delete -f -

# Run go fmt against code
fmt:
	go fmt ./...

# Run go vet against code
vet:
	go vet ./...

RBAC_LIST = rbac.authorization.k8s.io_v1_clusterrolebinding_cluster-hosted-net-services-operator.yaml \
	rbac.authorization.k8s.io_v1_clusterrole_cluster-hosted-net-services-operator.yaml \
	rbac.authorization.k8s.io_v1_rolebinding_cluster-hosted-net-services-operator.yaml \
	rbac.authorization.k8s.io_v1_role_cluster-hosted-net-services-operator.yaml

# Deploy controller in the configured Kubernetes cluster in ~/.kube/config
deploy: manifests kustomize
	ls -v manifests/*.yaml
	cd config/cluster-hosted-net-services-operator && $(KUSTOMIZE) edit set image controller=${IMG}
	ls -v manifests/*.yaml
	for i in `ls -v manifests/*.yaml`; do $(CLUSTER_CLIENT) apply -f  $$i; done;	


# Generate manifests e.g. CRD, RBAC etc.
manifests: generate
	cd  config/cluster-hosted-net-services-operator && $(KUSTOMIZE) edit set image controller=${IMG}
	$(KUSTOMIZE) build config/profiles/$(MANIFEST_PROFILE) -o $(TMP_DIR)/
	ls $(TMP_DIR)

	# now rename/join the output files into the files we expect
	mv $(TMP_DIR)/~g_v1_namespace_*.yaml manifests/0000_91_cluster-hosted-net-services-operator_00_namespace.yaml
	mv $(TMP_DIR)/~g_v1_serviceaccount_*.yaml manifests/0000_91_cluster-hosted-net-services-operator_03_serviceaccount.yaml
	echo '---' >> manifests/0000_91_cluster-hosted-net-services-operator_03_serviceaccount.yaml
	cat $(TMP_DIR)/security.openshift.io_v1_securitycontextconstraints_cluster-hosted-handler.yaml >> manifests/0000_91_cluster-hosted-net-services-operator_03_serviceaccount.yaml
	mv $(TMP_DIR)/apiextensions.k8s.io_v1_customresourcedefinition_configs.cluster-hosted-net-services.openshift.io.yaml  manifests/0000_91_cluster-hosted-net-services-operator_02_configs.crd.yaml
	mv $(TMP_DIR)/apps_v1_deployment_cluster-hosted-net-services-operator.yaml  manifests/0000_91_cluster-hosted-net-services-operator_05_deployment.yaml
	rm -f manifests/0000_91_cluster-hosted-net-services-operator_04_rbac.yaml
	for rbac in $(RBAC_LIST) ; do \
	cat $(TMP_DIR)/$${rbac} >> manifests/0000_91_cluster-hosted-net-services-operator_04_rbac.yaml ;\
	echo '---' >> manifests/0000_91_cluster-hosted-net-services-operator_04_rbac.yaml ;\
	done
	rm -rf $(TMP_DIR)

# Generate code
generate: controller-gen
		go generate -x ./...
		$(CONTROLLER_GEN) $(CRD_OPTIONS) rbac:roleName=cluster-hosted-net-services-operator webhook paths=./... output:crd:artifacts:config=config/crd/bases
		sed -i '/^    controller-gen.kubebuilder.io\/version: (devel)/d' config/crd/bases/*
		$(CONTROLLER_GEN) object:headerFile=./hack/boilerplate.go.txt paths="./..."



# Build the docker image
docker-build: test
	docker build . -t ${IMG}

podman-build: 
	podman  build . -t ${IMG}

podman-push: 
	podman  push  ${IMG} 

# Push the docker image
docker-push:
	docker push ${IMG}

# find or download controller-gen
# download controller-gen if necessary
controller-gen:
ifeq (, $(shell which controller-gen))
	@{ \
	set -e ;\
	CONTROLLER_GEN_TMP_DIR=$$(mktemp -d) ;\
	cd $$CONTROLLER_GEN_TMP_DIR ;\
	go mod init tmp ;\
	go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.3.0 ;\
	rm -rf $$CONTROLLER_GEN_TMP_DIR ;\
	}
CONTROLLER_GEN=$(GOBIN)/controller-gen
else
CONTROLLER_GEN=$(shell which controller-gen)
endif

kustomize:
ifeq (, $(shell which kustomize))
	@{ \
	set -e ;\
	KUSTOMIZE_GEN_TMP_DIR=$$(mktemp -d) ;\
	cd $$KUSTOMIZE_GEN_TMP_DIR ;\
	go mod init tmp ;\
	go get sigs.k8s.io/kustomize/kustomize/v3@v3.5.4 ;\
	rm -rf $$KUSTOMIZE_GEN_TMP_DIR ;\
	}
KUSTOMIZE=$(GOBIN)/kustomize
else
KUSTOMIZE=$(shell which kustomize)
endif

# Generate bundle manifests and metadata, then validate generated files.
.PHONY: bundle
bundle: manifests
	operator-sdk generate kustomize manifests -q
	cd config/manager && $(KUSTOMIZE) edit set image controller=$(IMG)
	$(KUSTOMIZE) build config/manifests | operator-sdk generate bundle -q --overwrite --version $(VERSION) $(BUNDLE_METADATA_OPTS)
	operator-sdk bundle validate ./bundle

# Build the bundle image.
.PHONY: bundle-build
bundle-build:
	docker build -f bundle.Dockerfile -t $(BUNDLE_IMG) .
