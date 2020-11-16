#!/bin/bash

set -ex

if [[ "$OSTYPE" != "linux"* ]]; then
    exit 0
fi

rustup component add rust-src

# Run address sanitizer
cargo clean
RUSTFLAGS="-Z sanitizer=address" \
cargo test --release --target x86_64-unknown-linux-gnu --tests "$@"

# Run leak sanitizer (when memory leak detection is enabled)
if [[ "$ASAN_OPTIONS" != *"detect_leaks=0"* ]]; then
    cargo clean
    RUSTFLAGS="-Z sanitizer=leak" \
    cargo test --release --target x86_64-unknown-linux-gnu --tests "$@"
fi

# Run memory sanitizer
cargo clean
RUSTFLAGS="-Z sanitizer=memory" \
cargo test -Zbuild-std --release --target x86_64-unknown-linux-gnu --tests "$@"

# Run thread sanitizer
cargo clean
RUSTFLAGS="-Z sanitizer=thread" \
cargo test -Zbuild-std --release --target x86_64-unknown-linux-gnu --tests "$@"
