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
    git clone https://github.com/RPCS3/rpcs3 $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive
mkdir -p build
pushd build
cmake -GNinja -DUSE_NATIVE_INSTRUCTIONS=false -DCMAKE_BUILD_TYPE=Release ..
ninja
popd

cat > rpcs3.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=rpcs3
Exec=rpcs3
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=rpcs3
GenericName=PS3 Emulator
Comment=A PS3 Emulator
EOF

env QMAKE=/usr/bin/qmake6 VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/bin/rpcs3 \
    --appdir AppDir \
    --plugin qt \
    --plugin gstreamer \
    --desktop-file=rpcs3.desktop \
    --icon-file=rpcs3/rpcs3.png

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
