FROM linux-emulation-base:22.04

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux

# other deps found
RUN apt update && apt install -y libcurl4-openssl-dev libpcap-dev liblzma-dev libgl1-mesa-dev libaio-dev libpulse-dev libsdl2-dev

# Latest Qt
ENV QT_VERSION=6.5.3
RUN pip install aqtinstall
RUN cd tmp &&\
    aqt install-qt linux desktop ${QT_VERSION} &&\
    rsync -a ${QT_VERSION}/gcc_64/ /usr/ &&\
    rm -rf /tmp/*
# Needed deps for Qt
RUN apt update && apt install -y libxkbcommon-x11-dev libxcb-*-dev
