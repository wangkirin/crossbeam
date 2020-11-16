#!/bin/bash

set -ex

export RUSTFLAGS="-D warnings"

if [[ "$OSTYPE" != "linux"* ]]; then
    exit 0
fi

toolchain=nightly-$(curl -s https://rust-lang.github.io/rustup-components-history/x86_64-unknown-linux-gnu/miri)
rustup set profile minimal
rustup default "$toolchain"
rustup component add miri

cargo miri test "$@"
