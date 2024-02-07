#!/bin/bash

THIS_DIR=$(dirname "${BASH_SOURCE[0]}")

cd "${THIS_DIR}/.."
exec pyenv exec poetry shell