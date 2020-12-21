FROM golang:1.15.6-buster as builder
ENV CGO_ENABLED="1"
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN echo "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com buster main" > /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update
RUN apt-get install -y terraform=0.14.3
#RUN apt-get install libvirt-clients libvirt-daemon-system
RUN apt-get install -y --no-install-recommends libvirt-dev
RUN git clone https://github.com/dmacvicar/terraform-provider-libvirt.git src/github.com/dmacvicar/terraform-provider-libvirt
#RUN cd src/github.com/dmacvicar/terraform-provider-libvirt && make
RUN cd src/github.com/dmacvicar/terraform-provider-libvirt && git checkout "v0.6.3" && make

FROM hashicorp/terraform

WORKDIR /opt/project
COPY --from=builder /go/src/github.com/dmacvicar/terraform-provider-libvirt/terraform-provider-libvirt /root/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64/


