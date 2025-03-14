FROM linux-emulation-base:23.04

ENV DEBIAN_FRONTEND=noninteractive

# https://git.citron-emu.org/Citron/Citron/wiki/Building-For-Linux
RUN apt update && \
apt-get -y install autoconf cmake g++-11 gcc-11 git glslang-tools libasound2 libboost-context-dev libglu1-mesa-dev libhidapi-dev libpulse-dev libtool libudev-dev \
libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb1 libxext-dev libxkbcommon-x11-0 mesa-common-dev nasm ninja-build \
qtbase5-dev qtbase5-private-dev qtwebengine5-dev qtmultimedia5-dev libmbedtls-dev catch2 libfmt-dev liblz4-dev nlohmann-json3-dev libzstd-dev libssl-dev libavfilter-dev libavcodec-dev libswscale-dev
# needed for vcpkg
RUN apt update && apt-get -y install curl zip unzip tar

# Latest Qt
ENV QT_VERSION=6.8.2
RUN pip install --break-system-packages aqtinstall
RUN cd tmp &&\
    aqt install-qt linux desktop ${QT_VERSION} --modules qtmultimedia &&\
    rsync -a ${QT_VERSION}/gcc_64/ /usr/ &&\
    rm -rf /tmp/*
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev libgstreamer-plugins-base*
