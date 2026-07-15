FROM linux-emulation-base:25.04

ENV DEBIAN_FRONTEND=noninteractive

# https://github.com/Ryujinx/Ryujinx#building
RUN cd /tmp && \
wget https://dot.net/v1/dotnet-install.sh && \
chmod +x dotnet-install.sh && \
./dotnet-install.sh --version 10.0.301

ENV PATH=/root/.dotnet/:$PATH
RUN dotnet --list-sdks

RUN apt update && apt install -y libicu-dev
