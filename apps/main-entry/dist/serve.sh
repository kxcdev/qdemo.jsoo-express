#!/usr/bin/env sh

export NODE_PATH="$(pwd)/node_modules"
([ -d node_modules ] && ./serve-noinit.sh) || (./init.sh && ./serve-noinit.sh)
