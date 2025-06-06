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
    git clone https://git.ryujinx.app/ryubing/ryujinx/ $src_dir
fi

pushd $src_dir

git fetch -a
git checkout $version
version=$(git rev-list HEAD --count --first-parent)

# https://github.com/Ryujinx/Ryujinx#building
#dotnet build -c Release -o build
#dotnet publish -c Release

convert -resize 256x256! src/Ryujinx/Assets/UIImages/Logo_Ryujinx.png ryujinx.png

if [ ! -d publish ]; then
    git clone https://github.com/kuiperzone/Publish-AppImage publish
fi

cat > publish-appimage.conf << EOF
################################################################################
# BASH FORMAT CONFIG: Publish-AppImage for .NET
# WEBPAGE : https://kuiper.zone/publish-appimage-dotnet/
################################################################################


########################################
# Application
########################################

# Mandatory application (file) name. This must be the base name of the main
# runnable file to be created by the publish/build process. It should NOT
# include any directory part or extension, i.e. do not append ".exe" or ".dll"
# for dotnet. Example: "MyApp"
APP_MAIN="Ryujinx"

# Optional application version (i.e. "1.2.3.0"). If specified, "-p:Version"
# will be added to the publish command. Leave it blank if you wish to specify
# version information in your dotnet project files.
APP_VERSION="$version"

# Mandatory application ID in reverse DNS form, i.e. "tld.my-domain.MyApp".
# Exclude any ".desktop" post-fix. Note that reverse DNS form is necessary
# for compatibility with Freedesktop.org metadata.
APP_ID="net.example.\${APP_MAIN}"

# Mandatory icon source file relative to this file (appimagetool seems to
# require this). Use .svg or .png only. PNG should be one of standard sizes,
# i.e, 128x128 or 256x256 pixels. Example: "Assets/app.svg"
APP_ICON_SRC="ryujinx.png"

########################################
# Desktop Entry
########################################

# Mandatory friendly name of the application.
DE_NAME="Ryujinx"

# Mandatory category(ies), separated with semicolon, in which the entry should be
# shown. See https://specifications.freedesktop.org/menu-spec/latest/apa.html
# Examples: "Development", "Graphics", "Network", "Utility" etc.
DE_CATEGORIES="Graphics"

# Optional short comment text (single line).
# Example: "Perform calculations"
DE_COMMENT="A Switch emulator"

# Optional keywords, separated with semicolon. Values are not meant for
# display and should not be redundant with the value of DE_NAME.
DE_KEYWORDS=""

# Flag indicating whether the program runs in a terminal window. Use true or false only.
DE_TERMINAL_FLAG=true

# Optional name-value text to be appended to the Desktop Entry file, thus providing
# additional metadata. Name-values should not be redundant with values above and
# are to be terminated with new line ("\n").
# Example: "Comment[fr]=Effectue des calculs compliqués\nMimeType=image/x-foo"
DE_EXTEND=""


########################################
# Dotnet Publish
########################################

# Optional path relative to this file in which to find the dotnet project (.csproj)
# or solution (.sln) file, or the directory containing it. If empty (default), a single
# project or solution file is expected under the same directory as this file.
# IMPORTANT. If set to "null", dotnet publish is disabled (it is NOT called). Instead,
# only POST_PUBLISH is called. Example: "Source/MyProject"
DOTNET_PROJECT_PATH=""

# Optional arguments suppled to "dotnet publish". Do NOT include "-r" (runtime) or version here as they will
# be added (see also \$APP_VERSION). Typically you want as a minimum: "-c Release --self-contained true".
# Additional useful arguments include:
# "-p:DebugType=None -p:DebugSymbols=false -p:PublishSingleFile=true -p:PublishTrimmed=true -p:TrimMode=link"
# Refer: https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish
DOTNET_PUBLISH_ARGS="-c Release --self-contained true -p:DebugType=None -p:DebugSymbols=false"


########################################
# POST-PUBLISH
########################################

# Optional post-publish or standalone build command. The value could, for example, copy
# additional files into the "bin" directory. The working directory will be the location
# of this file. The value is mandatory if DOTNET_PROJECT_PATH equals "null". In
# addition to variables in this file, the following variables are exported prior:
# \$ISO_DATE : date of build, i.e. "2021-10-29",
# \$APP_VERSION : application version (if provided),
# \$DOTNET_RID : dotnet runtime identifier string provided at command line (i.e. "linux-x64),
# \$PKG_KIND : package kind (i.e. "appimage", "zip") provided at command line.
# \$APPDIR_ROOT : AppImage build directory root (i.e. "AppImages/AppDir").
# \$APPDIR_USR : AppImage user directory under root (i.e. "AppImages/AppDir/usr").
# \$APPDIR_BIN : AppImage bin directory under root (i.e. "AppImages/AppDir/usr/bin").
# \$APPRUN_TARGET : The expected target executable file (i.e. "AppImages/AppDir/usr/bin/app-name").
# Example: "Assets/post-publish.sh"
POST_PUBLISH=""


########################################
# Package Output
########################################

# Additional arguments for use with appimagetool. See appimagetool --help.
# Default is empty. Example: "--sign"
PKG_APPIMAGE_ARGS=""

# Mandatory output directory relative to this file. It will be created if it does not
# exist. It will contain the final package file and temporary AppDir. Default: "AppImages".
PKG_OUTPUT_DIR="./"

# Boolean which sets whether to include the application version in the filename of the final
# output package (i.e. "HelloWorld-1.2.3-x86_64.AppImage"). It is ignored if \$APP_VERSION is
# empty or the "output" command arg is specified. Default and recommended: false.
PKG_VERSION_FLAG=false

# Optional AppImage output filename extension. It is ignored if generating a zip file, or if
# the "output" command arg is specified. Default and recommended: ".AppImage".
PKG_APPIMAGE_SUFFIX=".AppImage"


########################################
# Advanced Other
########################################

# The appimagetool command. Default is "appimagetool" which is expected to be found
# in the $PATH. If the tool is not in path or has different name, a full path can be given,
# example: "/home/user/Apps/appimagetool-x86_64.AppImage"
APPIMAGETOOL_COMMAND="appimagetool-x86_64.AppImage"

# Internal use only. Used for compatibility between conf and script. Do not modify.
CONF_IMPL_VERSION=1
EOF

# build and package appimage
./publish/publish-appimage --skip-yes
mv Ryujinx-*.AppImage ryujinx-$version-x86_64.AppImage

popd

du -h $src_dir/*AppImage
mv $src_dir/*AppImage $appimage_outdir/
