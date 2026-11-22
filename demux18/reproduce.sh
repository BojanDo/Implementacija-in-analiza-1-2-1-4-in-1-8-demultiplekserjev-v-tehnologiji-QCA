#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd -P)
root=$(dirname "$here")
source_tree=${1:-"$root/temp/QCADesigner-E"}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

make -s -C "$source_tree/QCADesignerE/src" -f "$here/verify.mk" VERIFY="$here" RUNNER="$work/runner" verify
for design in demux18_original demux18; do
  if ! "$work/runner" "$root/circuits/$design.qca" "$work/traces.csv" >"$work/engine.log" 2>&1; then
    cat "$work/engine.log" >&2
    exit 1
  fi
  python3 "$here/analyse.py" "$work/traces.csv" "$work/$design-truth.csv"
done
mv "$work/"*-truth.csv "$here/"
