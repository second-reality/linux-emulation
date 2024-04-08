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

deps_folder=$(pwd)/deps
deps_script=$(pwd)/.github/workflows/scripts/linux/build-dependencies-qt.sh

# build deps
if ! diff -q $deps_script $deps_folder/version; then
    rm -rf $deps_folder ${deps_folder}-build # temp dir
    $deps_script $deps_folder
    cp $deps_script $deps_folder/version
fi

# https://wiki.pcsx2.net/PCSX2_Documentation/Compiling_on_Linux
mkdir -p build
pushd build
cmake -GNinja -DWAYLAND_API=false -DCMAKE_PREFIX_PATH=$deps_folder -DDISABLE_ADVANCE_SIMD=true -DCMAKE_BUILD_TYPE=Release ..
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

env QMAKE=$deps_folder/bin/qmake VERSION=$version \
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
