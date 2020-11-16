#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-deque

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    # -Zmiri-ignore-leaks is needed for https://github.com/crossbeam-rs/crossbeam/issues/579
    "$script_dir"/miri.sh -- -Zmiri-ignore-leaks
fi
