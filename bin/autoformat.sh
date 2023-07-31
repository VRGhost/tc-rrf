#!/bin/bash -xe

THIS_DIR=$(dirname "${BASH_SOURCE[0]}")
cd "${THIS_DIR}/.."

black ./src
ruff --fix ./src