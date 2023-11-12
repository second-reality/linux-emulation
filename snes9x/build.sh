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
    git clone https://github.com/snes9xgit/snes9x $src_dir
fi

pushd $src_dir

# switch to github mirror for libpng mirror (fails when clone from CI)
git submodule set-url win32/libpng/src https://github.com/glennrp/libpng

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

git submodule update --init --recursive
# https://github.com/snes9xgit/snes9x/blob/master/.cirrus.yml
mkdir -p build
pushd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ../gtk
ninja
popd

cat > snes9x.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=snes9x
Exec=snes9x-gtk
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=snes9x
GenericName=Switch Emulator
Comment=A Switch Emulator
EOF

cp gtk/data/snes9x_256x256.png snes9x.png

env VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/snes9x-gtk \
    --appdir AppDir \
    --desktop-file=snes9x.desktop \
    --icon-file=snes9x.png

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
