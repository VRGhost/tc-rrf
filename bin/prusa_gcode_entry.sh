#!/bin/bash -xe

echo "PRUSA SLICER ENTRYPOINT"
TARGET_FILE="$1"
TMP_FILE=$(mktemp)
THIS_DIR=$(dirname "${BASH_SOURCE[0]}")
cd "${THIS_DIR}/.."
/home/ilo/.pyenv/bin/pyenv exec poetry run tc-gcode "${TARGET_FILE}" "${TMP_FILE}"
cat "${TMP_FILE}" > "${TARGET_FILE}"
rm "${TMP_FILE}"