Linux emulation
===============

This repository builds [AppImage](https://appimage.org/) for several games emulators.

Minimal distribution expected to run appimage is latest Debian stable (trixie).

Build is fully automated on [GitHub Actions](https://github.com/second-reality/linux-emulation/blob/master/.github/workflows/build.yml)
and is scheduled every few hours.

Latest AppImages are pushed to [latest release](https://github.com/second-reality/linux-emulation/releases/tag/latest).
Previous versions are available in [build release](https://github.com/second-reality/linux-emulation/releases/tag/build).

Usage
-----

Download this repository and add `bin` directory to your PATH.

A script named
[download_emulators.sh](https://github.com/second-reality/linux-emulation/blob/master/bin/download_emulators.sh)
will automatically download latest version for all emulators from GitHub.

Build from source
-----------------

The only dependency needed is podman. All the builds are containerized.

For every emulator, `build_${emulator}.sh` will produce an AppImage of latest
version automatically. This is what our [CI](https://github.com/second-reality/linux-emulation/blob/master/.github/workflows/build.yml)
uses.

Implementation
--------------

Every emulator has a folder associated, containing a `Dockerfile` and a
`build.sh` script.

Dockerfile uses a [base](https://github.com/second-reality/linux-emulation/blob/master/base/Dockerfile)
image that can be parameterized to target different ubuntu and clang versions.

`run_container.sh` automatically builds base images and the image associated to
an emulator before executing a given command. In this case, we execute the
`build.sh` script.

Thus, to build an AppImage, we simply call:

`./run_container.sh $emulator $emulator/build.sh`

By doing this, our builds are independent from host machine, and can be run on
any distribution.

Emulators
---------

- [Dolphin (GameCube/Wii)](https://dolphin-emu.org/) - [GitHub](https://github.com/dolphin-emu/dolphin)
- [DuckStation (PlayStation 1)](https://www.duckstation.org/) - [GitHub](https://github.com/stenzek/duckstation)
- [PCSX2 (PlayStation 2)](https://pcsx2.net/) - [GitHub](https://github.com/PCSX2/pcsx2)
- [RPCS3 (PlayStation 3)](https://rpcs3.net/) - [GitHub](https://github.com/RPCS3/rpcs3)
- [Yuzu (Nintendo Switch)](https://yuzu-emu.org/) - [GitHub](https://github.com/yuzu-emu/yuzu)
- [Suyu (Nintendo Switch)](https://suyu.dev/) - [Git](https://git.suyu.dev/suyu/suyu)
- [Ryujinx (Nintendo Switch)](https://ryujinx.app/) - [GitHub](https://git.ryujinx.app/ryubing/ryujinx/)
- [Snes9x (Super Nintendo)](https://www.snes9x.com/) - [GitHub](https://github.com/snes9xgit/snes9x)
