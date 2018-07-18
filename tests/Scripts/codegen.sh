#!/bin/bash

# the directory of the script. all locations are relative to the $DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$DIR/.."

SOURCERY_DIR="$PARENT_DIR/Pods/Sourcery"
SOURCERY="$SOURCERY_DIR/bin/sourcery"

"$SOURCERY" --config "$PARENT_DIR"/.sourcery-code.yml $1 $2
"$SOURCERY" --config "$PARENT_DIR"/.sourcery-mocks.yml $1 $2
