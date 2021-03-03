#!/usr/bin/env bash
set -e

if [ ! -f testbin ]; then
  git submodule update --init
  cd go-jsonnet
  go test -o ../testbin -c .
  cd ..
fi

# This will run all tests in the testdata/ dir
exec ./testbin -test.run 'TestEval$' $@
