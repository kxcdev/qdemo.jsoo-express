#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
  >&2 echo "usage: $0 <context.tar> <script.sh> [...args]"
  exit 1
fi

if [ ! -f "$1" ]; then
  >&2 echo "file does not exists: $1"
  exit 1
fi

TEMPD=$(mktemp -d)
if [ ! -e "$TEMPD" ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi

set -e

CTX="$(pwd)/$1"
cd "$TEMPD"
tar xf "$CTX"

PROG="$(pwd)/$2"
if [ ! -f "$PROG" ]; then
    >&2 echo "Script/program file does not exists: $2"
    exit 1
fi

shift 2
"$PROG" "$@"

# Make sure the temp directory gets removed on script exit.
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT
