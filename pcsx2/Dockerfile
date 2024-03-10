FROM linux-emulation-base:23.04

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux

# add latest cmake
RUN cd /tmp && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.27.3/cmake-3.27.3-linux-x86_64.sh &&\
    bash cmake-*.sh --skip-license --prefix=/usr &&\
    rm -rf /tmp/*

# other deps found
RUN apt update && apt install -y libcurl4-openssl-dev libpcap-dev liblzma-dev libgl1-mesa-dev libaio-dev libpulse-dev libsdl2-dev libzstd-dev liblz4-dev libwebp-dev

# Latest Qt
ENV QT_VERSION=6.6.2
RUN pip install aqtinstall --break-system-packages
RUN cd tmp &&\
    aqt install-qt linux desktop ${QT_VERSION} &&\
    rsync -a ${QT_VERSION}/gcc_64/ /usr/ &&\
    rm -rf /tmp/*
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev

