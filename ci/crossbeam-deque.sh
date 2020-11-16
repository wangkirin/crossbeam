#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-deque

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    # Run sanitizers
    export TSAN_OPTIONS="suppressions=$script_dir/tsan"
    "$script_dir"/san.sh
fi
