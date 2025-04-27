#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" 1>&2
    exit 1
}

[ $# -ge 1 ] || die "usage: image [cmd]..."
image=$1; shift

script_dir=$(readlink -f $(dirname $0))

[ -d $script_dir/$image ] || die "$image image can't be found in $script_dir"

# always build base first
podman build $script_dir/base -t linux-emulation-base:24.04 \
    --build-arg=CLANG_VERSION=19 \
    --build-arg=UBUNTU_VERSION=24.04 \
    --build-arg=UBUNTU_NAME=noble

target=linux-emulation-$image
if [ $image == base ]; then
    target=linux-emulation-base:24.04
else
    podman build $script_dir/$image -t $target
fi

# handle not defined variables
export DISPLAY=${DISPLAY:-:0}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/var/run/$UID}

# run container
podman run --rm -it --privileged \
    -w "$(pwd)" \
    -e USER=$USER \
    -e HOME=$HOME \
    -e DISPLAY=$DISPLAY \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR} \
    -v $HOME:$HOME \
    -v /mnt:/mnt \
    -v "$(pwd):$(pwd)" \
    $target "$@"
