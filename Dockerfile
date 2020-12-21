# Builder for libvirt-provider and terraform
FROM golang:1.15.6-buster as builder
ENV CGO_ENABLED="1"
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN echo "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com buster main" > /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends terraform=0.14.3
RUN apt-get install -y --no-install-recommends libvirt-dev=5.0.0-4+deb10u1
RUN git clone https://github.com/dmacvicar/terraform-provider-libvirt.git src/github.com/dmacvicar/terraform-provider-libvirt
RUN cd src/github.com/dmacvicar/terraform-provider-libvirt && git checkout "v0.6.3" && make
RUN ls -latr /usr/bin/terraform

# Main image
FROM debian:buster
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		ssh=1:7.9p1-10+deb10u2 \
		libvirt-clients=5.0.0-4+deb10u1 && \
	apt-get clean && \
        rm -rf /var/cache/apt/lists

COPY --from=builder /usr/bin/terraform /usr/bin/terraform
COPY --from=builder /go/src/github.com/dmacvicar/terraform-provider-libvirt/terraform-provider-libvirt /root/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64/

WORKDIR /opt/project

ENTRYPOINT ["/usr/bin/terraform"]

