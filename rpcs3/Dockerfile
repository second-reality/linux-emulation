FROM linux-emulation-base:23.04

# https://github.com/RPCS3/rpcs3/blob/master/BUILDING.md
RUN apt update && apt install -y build-essential libasound2-dev libpulse-dev libopenal-dev libglew-dev zlib1g-dev libedit-dev libvulkan-dev libudev-dev git libevdev-dev libsdl2-2.0-0 libsdl2-dev libjack-dev libsndio-dev
# other deps
RUN apt update && apt install -y libyaml-cpp-dev libcurl4-openssl-dev

# add latest cmake
RUN cd /tmp && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.31.6/cmake-3.31.6-linux-x86_64.sh &&\
    bash cmake-*.sh --skip-license --prefix=/usr &&\
    rm -rf /tmp/*

# Latest Qt
ENV QT_VERSION=6.8.0
RUN pip install --break-system-packages aqtinstall
RUN cd tmp &&\
    aqt install-qt linux desktop ${QT_VERSION} --modules qtmultimedia &&\
    rsync -a ${QT_VERSION}/gcc_64/ /usr/ &&\
    rm -rf /tmp/*
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev libgstreamer-plugins-base*
