#!/bin/sh

set -ex

# Update DOWNLOAD_URL by using output of
#
# curl -sSL \
#    https://circleci.com/api/v1.1/project/github/notnoopci/bazel-remote-proxy/latest/artifacts?branch=master \
#    | grep -o -e 'https://[^"]*Linux_x86_64'
#
DOWNLOAD_URL="https://5-116431813-gh.circle-artifacts.com/0/pkg/bazel-remote-proxy-$(uname -s)_$(uname -m)"

curl --fail -o ~/bazel-remote-proxy "$DOWNLOAD_URL"
chmod +x ~/bazel-remote-proxy
