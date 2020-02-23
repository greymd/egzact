#!/usr/bin/env bash
THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

# Unit testing
for f in "$THIS_DIR"/test/lib/*.egi; do
  result="$(egison -t "$f")"
  if grep -q '^#f' <<<"$result"; then
    echo "$f: Unit tests failed" >&2
    echo "$result" >&2
  else
    echo "$f: Unit tests succeeded" >&2
  fi
done

# Integration testing
sh "$THIS_DIR/test/ShTest.sh"
