# SPDX-License-Identifier: BSD-3-Clause
# Copyright (c) 2021, Ampere Computing LLC

FROM docker.io/ubuntu:18.04

RUN apt-get update -q && \
    apt-get install -y --no-install-recommends sudo
RUN adduser --disabled-password --gecos '' openocd && \
    adduser openocd sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER openocd
RUN sudo apt-get update -q && \
    sudo apt-get install -y --no-install-recommends \
    libftdi-dev \
    git \
    libtool \
    automake \
    texinfo \
    pkg-config \
    libusb-1.0.0-dev \
    vim \
    net-tools \
    usbutils \
    libpython2.7 \
    python2.7-minimal \
    gdb \
    ddd \
    telnet \
    libcapstone-dev

COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/bin/aarch64-none-elf-gdb /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/bin/aarch64-none-elf-gdb-add-index /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/include/gdb/ /usr/include/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/share/doc/gdb/ /usr/share/doc/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/share/gdb/ /usr/share/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/share/info/gdb.info /usr/share/info/

COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gdb /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gdb-add-index /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/include/gdb/ /usr/include/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/share/doc/gdb/ /usr/share/doc/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/share/gdb/ /usr/share/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/share/info/gdb.info /usr/share/info/

COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/bin/arm-none-eabi-gdb /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/bin/arm-none-eabi-gdb-add-index /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/include/gdb/ /usr/include/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/share/doc/gdb/ /usr/share/doc/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/share/gdb/ /usr/share/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-eabi/share/info/gdb.info /usr/share/info/

COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-gdb /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-gdb-add-index /usr/bin/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/include/gdb/ /usr/include/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/share/doc/gdb/ /usr/share/doc/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/share/gdb/ /usr/share/gdb/
COPY gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/share/info/gdb.info /usr/share/info/

COPY --chown=openocd:openocd openocd /home/openocd/openocd
WORKDIR /home/openocd/openocd
RUN mv README.AMPERE .. 2>/dev/null || true
RUN ./bootstrap
RUN ./configure --enable-jtag_dpi --enable-ftdi --enable-ft2232_ftd2xx --with-capstone
RUN make
RUN sudo make install
RUN rm -rf .git
WORKDIR /home/openocd

EXPOSE 3333 3334 3335 3336 3337 3338 4444 4445 5555 5556 6666