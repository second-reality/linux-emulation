#!/usr/bin/env bash

set -euo pipefail

cd $(readlink -f $(dirname $0))/..

base_url=https://github.com/second-reality/linux-emulation/releases/download/latest/

echo "https://github.com/second-reality/linux-emulation/releases/tag/latest"

for script in build_*; do
    emulator=$(echo $script | sed -e 's/build_//' -e 's/.sh$//')
    url=$base_url/$emulator.AppImage
    echo "$emulator -> $(pwd)/bin/$emulator"
    wget -q $url -O bin/$emulator
    chmod +x bin/$emulator
done
