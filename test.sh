#!/usr/bin/env bash

# Unit testing
runhaskell test/UnitTest.hs

# Integration testing
sh test/ShTest.sh
