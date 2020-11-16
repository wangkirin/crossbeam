#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-channel

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test -- --test-threads=1

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cd benchmarks
    cargo check --bins
    cd ..

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    # Run sanitizers
    export TSAN_OPTIONS="suppressions=$script_dir/tsan"
    "$script_dir"/san.sh --features sanitize
fi
