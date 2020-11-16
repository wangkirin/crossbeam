#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-utils

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cargo test --features nightly

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    # Run sanitizers
    "$script_dir"/san.sh --features nightly
fi
