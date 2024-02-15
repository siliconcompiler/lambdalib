#!/usr/bin/env bash

# When run from the root of the repository, formats Verilog using verible to ensure that formatting
# CI checks pass.

set -e

FILES=$(mktemp /tmp/format-verilog.XXXXXX)

# Collect all Verilog files, but generally ignore things that are copied verbatim from third party
# sources.
# tests/flows/data/bad.v is ours, but intentionally contains invalid syntax
find . \( \
    -name "*.v" \
    -or -name "*.vh" \
\)  -not \( \
    -path "./siliconcompiler/*" \
\) >> $FILES

verible-verilog-format \
    --failsafe_success=false \
    --indentation_spaces 4 \
    --inplace `cat $FILES`

cat $FILES
rm $FILES
