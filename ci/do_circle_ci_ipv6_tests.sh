#!/bin/bash

set -e

. ./ci/envoy_build_sha.sh

export ENVOY_SRCDIR="$(pwd)"

export ENVOY_BUILD_DIR=/tmp/envoy-docker

export TEST_TYPE="bazel.ipv6_tests"

function finish {
  echo "disk space at end of build:"
  df -h
}
trap finish EXIT

echo "disk space at beginning of build:"
df -h

docker run -t -i -v "$ENVOY_BUILD_DIR":/build -v "$ENVOY_SRCDIR":/source \
  --network host \
  -e BAZEL_BUILD_EXTRA_OPTIONS="--spawn_strategy=remote \
       --strategy=Javac=remote \
        --genrule_strategy=remote \
        --remote_rest_cache=http://localhost:7643" \
  envoyproxy/envoy-build:"$ENVOY_BUILD_SHA" /bin/bash -c "cd /source && ci/do_ci.sh $TEST_TYPE"
