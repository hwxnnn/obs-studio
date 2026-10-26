#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
: "${CODESIGN_TEAM:?Set CODESIGN_TEAM to your Apple Developer team ID}"

git submodule update --init --recursive
cmake --preset macos-webcam
cmake --build build_webcam --config RelWithDebInfo --parallel "$(sysctl -n hw.logicalcpu)" -- -allowProvisioningUpdates
printf '\nBuilt application: %s/build_webcam/frontend/RelWithDebInfo/OBS Webcam.app\n' "$PWD"
