# Terrform with terraform-libvirt-provider

A terraform image with the [terraform-libvirt-provider](https://github.com/dmacvicar/terraform-provider-libvirt) pre-installed for interacting with KVM/libvirt hosts.

This is provided ontop of the [debian:buster](https://hub.docker.com/_/debian/) official image.

## Image

Uses a multi-stage build to get the terraform binary and build the terraform-provider-libvirt binary.

It installs a `mkisofs` wrapper because the provider requires this for building cloud-init ISOs.

## Building

```
docker-compose build
```

## Usage

The docker-compose file mounts the current working dir into the assumed `/opt/project` working directory. This can be configured via the docker-compose `volumes` field.

```
docker-compose run --rm terraform <command>
```

e.g.

```
docker-compose run --rm terraform plan -out tf.plan
```

## SSH

It is likely you will need to mount your SSH private key into the container, if using `qemu+ssh://` schema as well as potentially re-configure SSH to ignore known hosts file etc

```
# ssh_config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

```
# docker-compose.yaml
  volumes:
    - .:/opt/project
    - ~/terraform_rsa:/root/.ssh/id_rsa:ro
    - ./ssh_config:/root/.ssh/config:ro
```

