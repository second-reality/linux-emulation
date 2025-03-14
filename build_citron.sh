#!/usr/bin/env bash

set -euo pipefail

script_dir=$(readlink -f $(dirname $0))
$script_dir/run_container.sh citron \
    ./citron/build.sh origin/master $script_dir/build/citron .
