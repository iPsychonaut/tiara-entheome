#!/usr/bin/env bash
# Verify tiara-entheome produces byte-identical output to upstream tiara=1.0.3
# on the same input FASTA.
#
# This is the strict acceptance check. It compares the full output, including
# the per-class probability columns, against a baseline produced by upstream
# tiara=1.0.3. For a quicker label-only check that needs no upstream baseline,
# run the bundled self-test instead:
#
#     tiara-entheome-test
#
# which classifies the packaged fixtures and compares the class labels against
# the expected outputs committed under tiara_entheome/test/test_data/.
#
# Prerequisites for this strict check:
#   - A baseline produced by upstream tiara=1.0.3 on the SAME fasta, with the
#     SAME flags, e.g.:
#         conda create -n tiara_baseline -c conda-forge tiara=1.0.3 -y
#         conda activate tiara_baseline
#         tiara -i test.fasta -o /tmp/upstream_tiara_output.txt --probabilities
#   - tiara-entheome installed in the current environment.
#
# Usage:
#   bash tests/smoke_test_vs_upstream.sh path/to/test.fasta
#   BASELINE=/path/to/baseline.txt bash tests/smoke_test_vs_upstream.sh test.fasta

set -euo pipefail

TEST_FASTA="${1:?usage: $0 path/to/test.fasta}"
BASELINE="${BASELINE:-/tmp/upstream_tiara_output.txt}"

if [[ ! -f "$BASELINE" ]]; then
    echo "ERROR: baseline output not found at $BASELINE"
    echo "Produce it from upstream tiara=1.0.3 first (see the header of this script)."
    exit 1
fi

OUTPUT="/tmp/tiara_entheome_output.txt"

echo "Running tiara-entheome on $TEST_FASTA ..."
tiara-entheome -i "$TEST_FASTA" -o "$OUTPUT" --probabilities

echo "Diffing against upstream baseline ..."
if diff -q "$BASELINE" "$OUTPUT"; then
    echo "PASS: tiara-entheome output is byte-identical to upstream tiara=1.0.3"
    exit 0
else
    echo "FAIL: outputs differ. Review the diff:"
    diff "$BASELINE" "$OUTPUT" | head -40
    exit 1
fi
