FROM linux-emulation-base:23.04

ENV DEBIAN_FRONTEND=noninteractive

# https://yuzu-emu.org/wiki/building-for-linux/
# Update: libboost-context1.81-dev + gcc/g++ not versioned
RUN apt update && apt install -y autoconf cmake g++ gcc git glslang-tools libasound2 libboost-context1.81-dev libglu1-mesa-dev libhidapi-dev libpulse-dev libtool libudev-dev libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb1 libxext-dev libxkbcommon-x11-0 mesa-common-dev nasm ninja-build qtbase5-dev qtbase5-private-dev qtwebengine5-dev qtmultimedia5-dev libmbedtls-dev catch2 libfmt-dev liblz4-dev nlohmann-json3-dev libzstd-dev libssl-dev libavfilter-dev libavcodec-dev libswscale-dev
# missing qt5 dep
RUN apt update && apt install -y libqt5multimedia5-plugins
