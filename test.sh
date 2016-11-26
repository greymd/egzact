#!/usr/bin/env bash

THIS_DIR=$(cd $(dirname $0) && pwd)

echo $THIS_DIR
# Unit testing
(cd "$THIS_DIR"; runhaskell "$THIS_DIR/test/UnitTest.hs")

# Integration testing
sh "$THIS_DIR/test/ShTest.sh"
