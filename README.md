# eBPF for Docker Desktop on macOS

eBPF and its compiler bcc need access to some parts of the kernel and its headers to work. This image shows how you can do that with Docker Desktop for mac's linuxkit host VM.

This fork installs `bpftool` which is helpful when writing and debugging eBPF programs.

## Build the image

Done quite simply with:

`docker build -t ebpf-for-mac .`

## Run the image

It needs to run as privileged, and depending on what you want to do, having access to the host's PID namespace is pretty useful too.

```
docker run -it --rm \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/localtime:/etc/localtime:ro \
  --pid=host \
  --net=host \
  ebpf-for-mac
```

Note: /lib/modules probably doesn't exist on your mac host, so Docker will map the volume in from the linuxkit host VM.

## Maintenance

Docker published their for-desktop kernel's [on Docker hub](https://hub.docker.com/r/docker/for-desktop-kernel/tags?page=1&ordering=last_updated) you may need to update the Dockerfile for the latest kernel that matches your linuxkit host VM. To do this:

1. Run `uname -r` and you should get something like `5.10.104-linuxkit`
2. Filter the [Docker hub image tags](https://hub.docker.com/r/docker/for-desktop-kernel/tags?page=1&ordering=last_updated&name=5.10.104) by the kernel version number (eg. 5.10.104)
3. Replace the image tag in the first line of the `Dockerfile` with the tag you found for your kernel
4. Build and play!
