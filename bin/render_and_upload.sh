#!/bin/bash -xe

THIS_DIR=$(dirname "${BASH_SOURCE[0]}")

cd "${THIS_DIR}/.."
tc-rrf render
tc-rrf upload dwc.hoopoe