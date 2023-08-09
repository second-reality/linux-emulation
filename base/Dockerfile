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

RUN apt update && apt install -y libfuse2 file gpg
RUN cd /usr/bin && \
    wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage &&\
    wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
    wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod +x *AppImage

RUN apt update && apt install -y git cmake build-essential ninja-build imagemagick
