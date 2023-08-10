FROM linux-emulation-base:22.04

# https://github.com/RPCS3/rpcs3/blob/master/BUILDING.md
RUN apt update && apt install -y build-essential libasound2-dev libpulse-dev libopenal-dev libglew-dev zlib1g-dev libedit-dev libvulkan-dev libudev-dev git libevdev-dev libsdl2-2.0-0 libsdl2-dev libjack-dev libsndio-dev
# add qt6
RUN apt update && apt install -y qt6-base-dev libqt6svg6-dev qt6-multimedia-dev qt6-base-private-dev
# other deps
RUN apt update && apt install -y libyaml-cpp-dev
