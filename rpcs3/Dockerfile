FROM linux-emulation-base:25.04

# https://github.com/RPCS3/rpcs3/blob/master/BUILDING.md
RUN apt update && apt install -y build-essential libasound2-dev libpulse-dev libopenal-dev libglew-dev zlib1g-dev libedit-dev libvulkan-dev libudev-dev git libevdev-dev libsdl2-2.0-0 libsdl2-dev libjack-dev libsndio-dev
# other deps
RUN apt update && apt install -y libyaml-cpp-dev libcurl4-openssl-dev

# add latest cmake
RUN cd /tmp && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.31.6/cmake-3.31.6-linux-x86_64.sh &&\
    bash cmake-*.sh --skip-license --prefix=/usr &&\
    rm -rf /tmp/*

# add latest SDL
RUN cd /tmp && \
    wget -q https://github.com/libsdl-org/SDL/releases/download/release-3.4.2/SDL3-3.4.2.tar.gz && \
    tar xzvf *.tar.gz && \
    cd SDL3-3.4.2 && cmake . -DSDL_X11_XTEST=OFF && make install -j $(nproc) && \
    rm -rf /tmp/*

# Latest Qt
ENV QT_VERSION=6.10.0
RUN pip install --break-system-packages aqtinstall
RUN cd tmp &&\
    aqt install-qt linux desktop ${QT_VERSION} --modules qtmultimedia &&\
    rsync -a ${QT_VERSION}/gcc_64/ /usr/ &&\
    rm -rf /tmp/*
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev libgstreamer-plugins-base*
