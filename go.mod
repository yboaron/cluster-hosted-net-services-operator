module github.com/yboaron/cluster-hosted-net-services-operator

go 1.13

require (
	github.com/go-bindata/go-bindata v3.1.2+incompatible
	github.com/go-logr/logr v0.3.0
	github.com/go-logr/zapr v0.2.0 // indirect
	github.com/golangci/golangci-lint v1.33.0
	github.com/onsi/ginkgo v1.14.2
	github.com/onsi/gomega v1.10.4
	github.com/openshift/api v0.0.0-20201214114959-164a2fb63b5f
	github.com/openshift/client-go v0.0.0-20201214125552-e615e336eb49
	github.com/openshift/cluster-network-operator v0.0.0-00010101000000-000000000000
	github.com/openshift/library-go v0.0.0-20201215165635-4ee79b1caed5
	github.com/pkg/errors v0.9.1
	k8s.io/api v0.20.0
	k8s.io/apimachinery v0.20.1
	k8s.io/client-go v0.20.0
	sigs.k8s.io/controller-runtime v0.6.3
	sigs.k8s.io/controller-tools v0.4.1
	sigs.k8s.io/kustomize/kustomize/v3 v3.9.0
)

replace (
	github.com/openshift/cluster-network-operator => github.com/openshift/cluster-network-operator v0.0.0-20201105033330-1ee0aaf1bdb8

	sigs.k8s.io/kustomize/kustomize/v3 => sigs.k8s.io/kustomize/kustomize/v3 v3.8.5
)
