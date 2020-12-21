# Build the manager binary
FROM golang:1.13 as builder

WORKDIR /go/src/github.com/yboaron/cluster-hosted-net-services-operator

# Copy the go source
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a  -o bin/manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /

COPY --from=builder /go/src/github.com/yboaron/cluster-hosted-net-services-operator/bin/manager .
COPY --from=builder /go/src/github.com/yboaron/cluster-hosted-net-services-operator/manifests /manifests
COPY deploy/handler/role.yaml   /bindata/cluster-hosted/rbac/
COPY deploy/handler/role_binding.yaml   /bindata/cluster-hosted/rbac/
COPY deploy/handler/service_account.yaml   /bindata/cluster-hosted/rbac/
COPY deploy/openshift/scc.yaml             /bindata/cluster-hosted/rbac/
COPY deploy/handler/namespace.yaml   /bindata/cluster-hosted/namespace/
COPY deploy/handler/keepalived/config_template.yaml   /bindata/cluster-hosted/keepalived-configmap/
COPY deploy/handler/keepalived/daemonset.yaml   /bindata/cluster-hosted/keepalived-daemonset/
COPY deploy/handler/haproxy/config_template.yaml   /bindata/cluster-hosted/haproxy-configmap/
COPY deploy/handler/haproxy/daemonset.yaml   /bindata/cluster-hosted/haproxy-daemonset/
COPY deploy/handler/mdns/config_template.yaml   /bindata/cluster-hosted/mdns-configmap/
COPY deploy/handler/mdns/daemonset.yaml   /bindata/cluster-hosted/mdns-daemonset/
COPY deploy/handler/coredns/config_template.yaml   /bindata/cluster-hosted/coredns-configmap/
COPY deploy/handler/coredns/daemonset.yaml   /bindata/cluster-hosted/coredns-daemonset/

LABEL io.openshift.release.operator=true

USER nonroot:nonroot

ENTRYPOINT ["/manager"]
