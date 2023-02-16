#!/bin/bash

# the directory of the script. all locations are relative to the $DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$DIR/.."
CACHES_DIR="$PARENT_DIR/.SourceryCache"

if [ "$1" == "--disableCache" ]; then
  echo "🧹 Cleaning caches dir..."
  rm -rf "$CACHES_DIR"
fi

SOURCERY_DIR="$PARENT_DIR/Pods/Sourcery"
SOURCERY="$SOURCERY_DIR/bin/sourcery"

echo "⚡️ Running codegen..."
"$SOURCERY" --config "$PARENT_DIR"/.sourcery-code.yml $1 $2
"$SOURCERY" --config "$PARENT_DIR"/.sourcery-mocks.yml $1 $2

echo "✅ Dones"
