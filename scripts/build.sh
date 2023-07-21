#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [[ -z "${PKG}" ]]; then
    echo "PKG must be set"
    exit 1
fi
if [[ -z "${BIN}" ]]; then
    echo "BIN must be set"
    exit 1
fi
if [[ -z "${GOOS}" ]]; then
    echo "GOOS must be set"
    exit 1
fi
if [[ -z "${GOARCH}" ]]; then
    echo "GOARCH must be set"
    exit 1
fi

GCFLAGS=""
if [[ ${DEBUG:-} = "1" ]]; then
    GCFLAGS="all=-N -l"
fi

export CGO_ENABLED=0

if [[ -z "${OUTPUT_DIR:-}" ]]; then
  OUTPUT_DIR=./build
fi
OUTPUT=${BIN}
if [[ "${GOOS}" = "windows" ]]; then
  OUTPUT="${OUTPUT}.exe"
fi

podman run \
        --rm \
        -it \
        -e GOOS=${GOOS} \
        -e GOARCH=${GOARCH} \
        -v "$(pwd):/workspace" \
        -v ${OUTPUT_DIR}:/build \
        -w /workspace \
        docker.io/library/golang:bookworm \
        go build \
            -o /build/${OUTPUT} \
            -gcflags "${GCFLAGS}" \
            -installsuffix "static" \
            ${PKG}/cmd/${BIN}
