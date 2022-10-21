FROM docker/for-desktop-kernel:5.10.104-ad41e9402fa6e51d2635fb92e4cb6b90107caa25 AS ksrc

FROM ubuntu:latest

RUN apt-get update
RUN apt install -y kmod python3-bpfcc xz-utils cmake gcc clang \
      zlib1g-dev libelf-dev libbfd-dev libcap-dev libbpf-dev \
      gettext

WORKDIR /

# Copy over headers
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

WORKDIR /root

# Compile bpftool
COPY --from=ksrc /linux.tar.xz .
RUN tar xf linux.tar.xz && rm linux.tar.xz
WORKDIR /root/linux/tools/bpf/bpftool
RUN make && mv bpftool /usr/local/bin

WORKDIR /root
COPY hello_world.py .

CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
