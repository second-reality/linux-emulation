#!/usr/bin/env bash

set -euo pipefail

script_dir=$(readlink -f $(dirname $0))
$script_dir/run_container.sh snes9x \
    ./snes9x/build.sh origin/master $script_dir/build/snes9x .
