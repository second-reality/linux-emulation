FROM linux-emulation-base:22.04

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux
RUN apt update && apt install -y qt6-base-dev qt6-base-private-dev qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools
# other deps found
RUN apt update && apt install -y libcurl4-openssl-dev libpcap-dev liblzma-dev libgl1-mesa-dev libaio-dev
