#!/usr/bin/env bash

set -euo pipefail

script_dir=$(readlink -f $(dirname $0))
$script_dir/run_container.sh suyu \
    ./suyu/build.sh origin/dev $script_dir/build/suyu .
