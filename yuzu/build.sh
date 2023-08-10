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
    git clone https://github.com/yuzu-emu/yuzu $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive
# https://yuzu-emu.org/wiki/building-for-linux/
mkdir -p build
pushd build
cmake -GNinja -DYUZU_TESTS=false -DCMAKE_BUILD_TYPE=Release ..
ninja
popd

cat > yuzu.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=yuzu
Exec=yuzu
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=yuzu
GenericName=Switch Emulator
Comment=A Switch Emulator
EOF

env VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/bin/yuzu \
    --appdir AppDir \
    --desktop-file=yuzu.desktop \
    --icon-file=dist/qt_themes/default/icons/256x256/yuzu.png

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
