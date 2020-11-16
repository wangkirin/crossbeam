#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-skiplist

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cargo test --features nightly

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    # -Zmiri-disable-stacked-borrows is needed for https://github.com/crossbeam-rs/crossbeam/issues/545
    # -Zmiri-ignore-leaks is needed for https://github.com/crossbeam-rs/crossbeam/issues/579
    "$script_dir"/miri.sh -- -Zmiri-disable-stacked-borrows -Zmiri-ignore-leaks
fi
