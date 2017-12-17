#!/bin/bash

set -e

. ./ci/envoy_build_sha.sh

export ENVOY_SRCDIR="$(pwd)"

# save cache in /var/lib/docker so it is cached locally to speed up builds
# baze is great at incremental builds while preserving correctness
export ENVOY_BUILD_DIR=/var/lib/docker/cache/envoy-docker

export TEST_TYPE="bazel.ipv6_tests"

function finish {
  echo "disk space at end of build:"
  df -h
}
trap finish EXIT

echo "disk space at beginning of build:"
df -h

docker run -t -i -v "$ENVOY_BUILD_DIR":/build -v "$ENVOY_SRCDIR":/source \
  envoyproxy/envoy-build:"$ENVOY_BUILD_SHA" /bin/bash -c "cd /source && ci/do_ci.sh $TEST_TYPE"

