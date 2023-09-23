FROM linux-emulation-base:22.04

# https://github.com/RPCS3/rpcs3/blob/master/BUILDING.md
RUN apt update && apt install -y build-essential libasound2-dev libpulse-dev libopenal-dev libglew-dev zlib1g-dev libedit-dev libvulkan-dev libudev-dev git libevdev-dev libsdl2-2.0-0 libsdl2-dev libjack-dev libsndio-dev
# other deps
RUN apt update && apt install -y libyaml-cpp-dev

# add latest cmake
RUN cd /tmp && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.27.3/cmake-3.27.3-linux-x86_64.sh &&\
    bash cmake-*.sh --skip-license --prefix=/usr &&\
    rm -rf /tmp/*

# Latest Qt (6.5.2)
RUN pip install aqtinstall
RUN aqt install-qt linux desktop 6.5.2 --modules all && mv 6.5.2 /opt/qt-6.5.2/
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev libgstreamer-plugins-base*
