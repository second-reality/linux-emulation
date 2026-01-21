#!/usr/bin/env bash

set -euo pipefail
set -x

die()
{
    echo "$@" 1>&2
    exit 1
}

[ $# -eq 3 ] || die "usage: version src_dir appimage_outdir"
script_dir=$(dirname $(readlink -f $0))
version=$1;shift
src_dir=$1;shift
appimage_outdir=$1;shift

if [ ! -d $src_dir ]; then
    git clone https://github.com/stenzek/duckstation $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive

deps_folder=$(pwd)/deps
deps_script=$(pwd)/scripts/deps/build-dependencies-linux.sh

# build deps
if ! diff -q $deps_script $deps_folder/version; then
    rm -rf $deps_folder ${deps_folder}-build # temp dir
    $deps_script $deps_folder
    cp $deps_script $deps_folder/version
fi

mkdir -p build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$deps_folder" -DSDL_X11_XSCRNSAVER=OFF -G Ninja ..
ninja
popd

cat > duckstation.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=duckstation
Exec=duckstation-qt
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=duckstation
GenericName=PlayStation Emulator
Comment=A Switch Emulator
EOF

# create icon
convert -resize 256x256 data/resources/images/duck.png duckstation.png

env QMAKE=$deps_folder/bin/qmake VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/bin/duckstation-qt \
    --appdir AppDir \
    --plugin qt \
    --desktop-file=duckstation.desktop \
    --icon-file=duckstation.png

# copy resources
rsync -av build/bin/resources/ AppDir/usr/bin/resources/
rsync -av build/bin/translations/ AppDir/usr/bin/translations/

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
