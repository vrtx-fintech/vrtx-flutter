#!/usr/bin/env bash
# Downloads the VRTX iOS xcframework from the upstream release into
# ios/Frameworks/. Run before `pod install` in any host app that depends
# on this plugin (CI does this automatically in the iOS workflow).
#
# Skips if the framework is already present and skips entirely on
# non-Darwin platforms where the iOS build would never run anyway.
#
# Override VRTX_IOS_VERSION to pin a different release.
set -euo pipefail

VRTX_IOS_VERSION="${VRTX_IOS_VERSION:-0.0.15}"

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
frameworks_dir="$repo_root/ios/Frameworks"
target_framework="$frameworks_dir/VRTX.xcframework"
release_url="https://github.com/vrtx-fintech/vrtx-ios/releases/download/${VRTX_IOS_VERSION}/VRTX.xcframework.zip"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "[vrtx-ios] Non-Darwin platform, skipping iOS framework fetch."
  exit 0
fi

if [ -d "$target_framework" ]; then
  echo "[vrtx-ios] VRTX.xcframework ${VRTX_IOS_VERSION} already present, skipping."
  exit 0
fi

echo "[vrtx-ios] Downloading VRTX.xcframework ${VRTX_IOS_VERSION}..."
mkdir -p "$frameworks_dir"
tmp_zip="$(mktemp -t vrtx-xcframework.XXXXXX).zip"
trap 'rm -f "$tmp_zip"' EXIT

curl --fail --location --silent --show-error --output "$tmp_zip" "$release_url"
unzip -q "$tmp_zip" -d "$frameworks_dir"

echo "[vrtx-ios] Installed VRTX.xcframework ${VRTX_IOS_VERSION} to $frameworks_dir"
