ARG UBUNTU_VERSION="null"
FROM docker.io/ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_NAME="null"
ARG CLANG_VERSION="null"

RUN apt update && apt install -y wget rsync

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key > \
    /etc/apt/trusted.gpg.d/apt.llvm.org.asc
RUN echo "deb http://apt.llvm.org/${UBUNTU_NAME}/ llvm-toolchain-${UBUNTU_NAME}-${CLANG_VERSION} main" >> \
    /etc/apt/sources.list
RUN apt update && apt install -y clang-${CLANG_VERSION}
ENV CC clang-${CLANG_VERSION}
ENV CXX clang++-${CLANG_VERSION}

# https://appimage-builder.readthedocs.io/en/latest/intro/install.html#manual-installation
RUN apt update && apt install -y file binutils coreutils desktop-file-utils fakeroot fuse libgdk-pixbuf2.0-dev patchelf python3-pip python3-setuptools squashfs-tools strace util-linux zsync
# needed by linuxdeploy
RUN apt update && apt install -y file

RUN cd /usr/bin && \
    wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage &&\
    wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
    wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod +x *AppImage

RUN cd /usr/bin &&\
    wget https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gstreamer/master/linuxdeploy-plugin-gstreamer.sh &&\
    chmod +x *.sh

RUN apt update && apt install -y git cmake build-essential ninja-build imagemagick

# add some tools to help debug containers
RUN apt update && apt install -y ncdu apt-file strace
RUN apt-file update
