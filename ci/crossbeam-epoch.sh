#!/bin/bash

set -ex

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"/../crossbeam-epoch

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cargo test --features nightly

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    if [[ "$OSTYPE" == "linux"* ]]; then
        # Run sanitizers
        export TSAN_OPTIONS="suppressions=$script_dir/tsan"
        "$script_dir"/san.sh --features sanitize,nightly

        RUSTFLAGS="-Z sanitizer=address" \
        cargo run \
            --release \
            --target x86_64-unknown-linux-gnu \
            --features sanitize,nightly \
            --example sanitize
    fi
fi
