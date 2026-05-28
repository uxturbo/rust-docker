#!/bin/bash

set -e

if [ -f "/srv/rust/carbon.sh" ]; then
    exec /srv/rust/carbon.sh "$@"
fi

exec /srv/rust/RustDedicated "$@"