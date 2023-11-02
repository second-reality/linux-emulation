#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" 1>&2
    exit 1
}

[ $# -eq 3 ] || die "usage: version src_dir appimage_outdir"
version=$1;shift
src_dir=$1;shift
appimage_outdir=$1;shift

if [ ! -d $src_dir ]; then
    git clone https://github.com/dolphin-emu/dolphin $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive
# https://github.com/dolphin-emu/dolphin#linux-portable-build-steps
cmake -GNinja -DLINUX_LOCAL_DEV=true -DCMAKE_CXX_FLAGS=-Wno-enum-constexpr-conversion -DCMAKE_BUILD_TYPE=Release .
ninja

cat > dolphin-emu.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=dolphin-emu
Exec=dolphin-emu
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=dolphin
GenericName=Wii/GameCube Emulator
Comment=A Wii/GameCube Emulator
EOF

env QMAKE=/usr/bin/qmake6 VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e Binaries/dolphin-emu \
    --appdir AppDir \
    --plugin qt \
    --desktop-file=dolphin-emu.desktop \
    --icon-file=Data/dolphin-emu.png

# Since we build with -DLINUX_LOCAL_DEV=true, dolphin will look for resources in
# ./Sys folder instead of INSTALL_PREFIX/.../Sys
rsync -av Data/Sys/ AppDir/usr/bin/Sys/
env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
