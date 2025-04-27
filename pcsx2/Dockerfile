FROM linux-emulation-base:24.04

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux

# add latest cmake
RUN cd /tmp && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.27.3/cmake-3.27.3-linux-x86_64.sh &&\
    bash cmake-*.sh --skip-license --prefix=/usr &&\
    rm -rf /tmp/*

RUN apt update && apt install -y curl unzip

# ./.github/workflows/scripts/linux/install-packages-qt.sh
RUN apt update && apt install -y build-essential\
 g++\
 git\
 cmake\
 ccache\
 ninja-build\
 patchelf\
 libfuse2\
 libglib2.0-dev\
 libfontconfig1-dev\
 libharfbuzz-dev\
 libjpeg-dev\
 liblz4-dev\
 libpng-dev\
 libfreetype-dev\
 libinput-dev\
 libwebp-dev\
 libxcb-*-dev\
 libxkbcommon-dev\
 libxkbcommon-x11-dev\
 libxrender-dev\
 libwayland-dev\
 libgl1-mesa-dev\
 libegl-dev\
 libegl1-mesa-dev\
 libgl1-mesa-dev\
 libssl-dev

RUN apt update && apt install -y extra-cmake-modules\
 libaio-dev\
 libasound2-dev\
 libbz2-dev\
 libcurl4-openssl-dev\
 libdbus-1-dev\
 libegl1-mesa-dev\
 libgl1-mesa-dev\
 libgtk-3-dev\
 libharfbuzz-dev\
 libjpeg-dev\
 libpcap0.8-dev\
 libpng-dev\
 libpulse-dev\
 librsvg2-dev\
 libsamplerate0-dev\
 libudev-dev\
 libx11-xcb-dev\
 libavcodec-dev\
 libavformat-dev\
 libavutil-dev\
 libswresample-dev\
 libswscale-dev\
 pkg-config\
 zlib1g-dev

