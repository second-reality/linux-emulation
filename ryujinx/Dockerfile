FROM linux-emulation-base:23.04

ENV DEBIAN_FRONTEND=noninteractive

# https://github.com/Ryujinx/Ryujinx#building
RUN wget https://packages.microsoft.com/config/ubuntu/23.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm *.deb && \
    apt update && \
    apt install -y dotnet-sdk-8.0
