ifeq (/,${HOME})
GOLANGCI_LINT_CACHE=/tmp/golangci-lint-cache/
else
GOLANGCI_LINT_CACHE=${HOME}/.cache/golangci-lint
endif

CLUSTER_CLIENT ?= oc
CONTROLLER_GEN ?= go run vendor/sigs.k8s.io/controller-tools/cmd/controller-gen/main.go
KUSTOMIZE ?= go run sigs.k8s.io/kustomize/kustomize/v3
CRD_OPTIONS="crd:trivialVersions=true,crdVersions=v1"
GOLANGCI_LINT ?= GOLANGCI_LINT_CACHE=$(GOLANGCI_LINT_CACHE) go run vendor/github.com/golangci/golangci-lint/cmd/golangci-lint/main.go
MANIFEST_PROFILE ?= default
TMP_DIR := $(shell mktemp -d -t manifests-$(date +%Y-%m-%d-%H-%M-%S)-XXXXXXXXXX)
IMAGE_BUILDER ?= podman

# Image URL to use all building/pushing image targets
IMG ?= quay.io/yboaron/cluster-hosted-net-services-operator:latest

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
	mv $(TMP_DIR)/v1_namespace_cluster-hosted-net-services-operator.yaml manifests/0000_91_cluster-hosted-net-services-operator_00_namespace.yaml
	mv $(TMP_DIR)/v1_serviceaccount_cluster-hosted-net-services-operator.yaml manifests/0000_91_cluster-hosted-net-services-operator_03_serviceaccount.yaml
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
generate: 
		go generate -x ./...
		$(CONTROLLER_GEN) $(CRD_OPTIONS) rbac:roleName=cluster-hosted-net-services-operator webhook paths=./... output:crd:artifacts:config=config/crd/bases
		sed -i '/^    controller-gen.kubebuilder.io\/version: (devel)/d' config/crd/bases/*
		$(CONTROLLER_GEN) object:headerFile=./hack/boilerplate.go.txt paths="./..."
		#$(GOLANGCI_LINT) run --fix

# Build the docker image
image-build: test
	$(IMAGE_BUILDER) build . -t ${IMG}

image-push: 
	$(IMAGE_BUILDER)  push  ${IMG} 

# Run go lint against code
.PHONY: lint
lint:
	$(GOLANGCI_LINT) run

vendor: 
	go mod tidy
	go mod vendor
	go mod verify
