FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/cluster-nfd-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-nfd-operator/cluster-nfd-operator /usr/bin/

RUN mkdir -p /opt/nfd
COPY assets /opt/nfd

RUN useradd cluster-nfd-operator
USER cluster-nfd-operator
ENTRYPOINT ["/usr/bin/cluster-nfd-operator"]
LABEL io.k8s.display-name="OpenShift cluster-nfd-operator" \
      io.k8s.description="This is a component of OpenShift and manages the node feature discovery." \
      io.openshift.release.operator=true
