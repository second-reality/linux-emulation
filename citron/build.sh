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
    git clone https://git.citron-emu.org/Citron/Citron $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

sed -e '/-Werror=/d' -i src/CMakeLists.txt

git submodule update --init --recursive
# https://git.citron-emu.org/Citron/Citron/wiki/Building-For-Linux
mkdir -p build
pushd build
export LINKER="lld-${CLANG_VERSION}"
export CFLAGS="-fuse-ld=${LINKER} -Wno-unused-command-line-argument"
export CXXFLAGS="-fuse-ld=${LINKER} -Wno-unused-command-line-argument"
cmake .. -GNinja \
  -DCITRON_ENABLE_LTO=ON \
  -DCITRON_USE_BUNDLED_VCPKG=ON \
  -DCITRON_TESTS=OFF \
  -DCITRON_USE_LLVM_DEMANGLE=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DUSE_SYSTEM_QT=ON \
  -DUSE_DISCORD_PRESENCE=OFF \
  -DBUNDLE_SPEEX=ON \
  -DCMAKE_SYSTEM_PROCESSOR=x86_64 \
  -DCMAKE_BUILD_TYPE=Release
ninja
popd

cat > citron.desktop << EOF
[Desktop Entry]
Version=1.0
Icon=citron
Exec=citron
Terminal=false
Type=Application
Categories=Game;Emulator;
Name=citron
GenericName=Switch Emulator
Comment=A Switch Emulator
EOF

env VERSION=$version \
    linuxdeploy-x86_64.AppImage \
    -e ./build/bin/citron \
    --appdir AppDir \
    --plugin qt \
    --desktop-file=citron.desktop \
    --icon-file=dist/qt_themes/default/icons/256x256/citron.png

env VERSION=$version appimagetool-x86_64.AppImage AppDir

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir
