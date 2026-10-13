#!/bin/bash
set -euo pipefail
project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build/native-app"
bundle="$project_dir/Blackmoor Reconstruction.app"
stage_dir="$(mktemp -d /private/tmp/blackmoor-native-build.XXXXXX)"
trap 'rm -rf "$stage_dir"' EXIT
staged_bundle="$stage_dir/Blackmoor Reconstruction.app"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
mkdir -p "$build_dir" "$staged_bundle/Contents/MacOS"
objects=()
for module in cif_archive cif_pixels cif_image game_resources hiff engine_boot startup_menu scene_resource bink_adapter scene_dependencies scene_conditions action_core action_ui scene_executor action_sound autotext his_audio; do
    object="$build_dir/$module.o"
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min=27.0 \
        -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 \
        -I"$ffmpeg_prefix/include" \
        -c "$source_dir/$module.c" -o "$object"
    objects+=("$object")
done
xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min=27.0 \
    -std=c++17 -fobjc-arc -Wall -Wextra -Wpedantic -Werror -O2 \
    "$source_dir/blackmoor_app.mm" "$source_dir/macos_platform.mm" "$source_dir/macos_audio.mm" "$source_dir/scene_inspector.mm" "${objects[@]}" \
    -framework AppKit -framework Foundation -framework CoreGraphics -framework AVFAudio \
    -L"$ffmpeg_prefix/lib" -lavformat -lavcodec -lavutil -lswscale -lswresample \
    -Wl,-rpath,"$ffmpeg_prefix/lib" \
    -o "$staged_bundle/Contents/MacOS/BlackmoorNative"
cat > "$staged_bundle/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>BlackmoorNative</string>
<key>CFBundleIdentifier</key><string>com.blackmoor.reconstruction</string>
<key>CFBundleName</key><string>Blackmoor Reconstruction</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleVersion</key><string>0.1</string>
<key>LSMinimumSystemVersion</key><string>27.0</string>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
# File Provider can reattach Finder metadata between cleanup and signing.
# Sign our generated bundle in local temporary storage, then copy its content
# and signature into the workspace without resource forks or extended attrs.
/usr/bin/codesign --force --sign - "$staged_bundle"
/usr/bin/codesign --verify --strict "$staged_bundle"
if [ -L "$bundle" ]; then
    printf 'Refusing to replace a symlink at the generated app path: %s\n' "$bundle" >&2
    exit 1
fi
rm -rf "$bundle"
/usr/bin/ditto --noextattr --norsrc "$staged_bundle" "$bundle"
# The workspace provider may add package Finder metadata again later. The
# archive preserves the verified staged content without those attributes.
/usr/bin/ditto -c -k --noextattr --norsrc --keepParent "$staged_bundle" "$bundle.zip"
printf 'Built incomplete native ARM64 startup app: %s\n' "$bundle"
