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
    git clone https://github.com/PCSX2/pcsx2 $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive

# fix version of SDL
sed -e 's/SDL2.*REQUIRED/SDL2 REQUIRED/' -i cmake/SearchForStuff.cmake

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux
mkdir -p build
pushd build
cmake -GNinja -DWAYLAND_API=false -DDISABLE_ADVANCE_SIMD=true -DCMAKE_BUILD_TYPE=Release ..
ninja
popd

cat > pcsx2.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=pcsx2
Exec=pcsx2-qt
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=pcsx2
GenericName=Switch Emulator
Comment=A Switch Emulator
EOF

# create icon
convert -resize 256x256 ./pcsx2-qt/resources/icons/AppIcon64.png pcsx2.png

env QMAKE=/usr/bin/qmake6 VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/bin/pcsx2-qt \
    --appdir AppDir \
    --plugin qt \
    --desktop-file=pcsx2.desktop \
    --icon-file=pcsx2.png

# copy resources
rsync -av build/bin/resources/ AppDir/usr/bin/resources/

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
