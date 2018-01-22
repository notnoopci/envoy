#!/bin/bash

set -e

BAZEL_BUILD_OPTIONS="--curses=no --show_task_finish --verbose_failures"

if [ -n "$CIRCLECI" ]; then
# Use CircleCI experimental support for bazel cache
  BAZEL_BUILD_OPTIONS="${BAZEL_BUILD_OPTIONS} \
    --spawn_strategy=remote \
    --strategy=Javac=remote \
    --genrule_strategy=remote \
    --remote_rest_cache=http://localhost:7643"
fi

BAZEL_TEST_OPTIONS="${BAZEL_BUILD_OPTIONS} --test_output=all"

# Build envoy and run tests as separate steps so that failure output
# is somewhat more deterministic (rather than interleaving the build
# and test steps).

bazel build ${BAZEL_BUILD_OPTIONS} //source/...
bazel build ${BAZEL_BUILD_OPTIONS} //test/...
bazel test ${BAZEL_TEST_OPTIONS} //test/...
