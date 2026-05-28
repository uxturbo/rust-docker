#!/bin/bash

set -e

echo "< ----- Installing Oxide ..."

cd /srv/rust

curl -L \
    https://github.com/OxideMod/Oxide.Rust/releases/latest/download/Oxide.Rust-linux.zip \
    -o oxide.zip

unzip -o oxide.zip

rm oxide.zip

mkdir -p /home/rust/.steam/sdk64

find /srv/rust \
    -name steamclient.so \
    -type f \
    -exec cp {} /home/rust/.steam/sdk64/steamclient.so \; \
    -quit

test -f /home/rust/.steam/sdk64/steamclient.so

mkdir -p /srv/rust/oxide/plugins \
    /srv/rust/oxide/config \
    /srv/rust/oxide/data \
    /srv/rust/oxide/lang \
    /srv/rust/oxide/logs

chown -R rust:rustgroup /srv/rust /home/rust
chmod -R g+rwX /srv/rust

echo "... Oxide installation complete ----- >"