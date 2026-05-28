#!/bin/bash

set -e

echo "< ----- Installing Carbon ..."

cd /srv/rust

curl -L \
    https://github.com/CarbonCommunity/Carbon/releases/latest/download/Carbon.Linux.Release.tar.gz \
    -o carbon.tar.gz

tar -xzf carbon.tar.gz

rm carbon.tar.gz

mkdir -p /home/rust/.steam/sdk64

find /srv/rust \
    -name steamclient.so \
    -type f \
    -exec cp {} /home/rust/.steam/sdk64/steamclient.so \; \
    -quit

test -f /home/rust/.steam/sdk64/steamclient.so

mkdir -p \
    /srv/rust/carbon/plugins \
    /srv/rust/carbon/config \
    /srv/rust/carbon/data \
    /srv/rust/carbon/lang \
    /srv/rust/carbon/logs

chown -R rust:rustgroup /srv/rust /home/rust
chmod -R g+rwX /srv/rust

echo "... Carbon installation complete ----- >"