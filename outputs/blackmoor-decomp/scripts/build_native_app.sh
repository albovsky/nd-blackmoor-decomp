#!/bin/bash
set -euo pipefail
project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$project_dir/src"
build_dir="$project_dir/build/native-app"
test_hooks=0
if [ "$#" -eq 1 ] && [ "$1" = "--test-hooks" ]; then
    test_hooks=1
elif [ "$#" -ne 0 ]; then
    printf 'Usage: %s [--test-hooks]\n' "$0" >&2
    exit 2
fi
if [ "$test_hooks" -eq 1 ]; then
    bundle="$project_dir/Blackmoor Reconstruction Test.app"
else
    bundle="$project_dir/Blackmoor Reconstruction.app"
fi
stage_dir="$(mktemp -d /private/tmp/blackmoor-native-build.XXXXXX)"
trap 'rm -rf "$stage_dir"' EXIT
staged_bundle="$stage_dir/Blackmoor Reconstruction.app"
ffmpeg_prefix="${FFMPEG_PREFIX:-/opt/homebrew}"
mkdir -p "$build_dir" "$staged_bundle/Contents/MacOS"
objects=()
for module in scene_action_slots sound_control live_audio puzzle_sound native_inventory_render native_conversation_caption native_random_movie native_cel_resources native_jane_responses native_drake_responses native_petrov_responses native_secondary_video interactive_video_input native_display_geometry cif_archive cif_pixels cif_image game_resources hiff engine_boot startup_menu scene_resource bink_adapter bink_player bink_audio session_bindings_a35_bink scene_dependencies scene_conditions action_core action_family_28 action_family28_surface action_family_64 action_ui action_ui_immediate native_phone_popup scene_executor action_sound autotext his_audio world_init world_clock caption_layout caption_lifecycle caption_compositor action_family_51 action_family_62 action_family_62_interaction scene_session input_latch input_consume session_input session_navigation condition_extra session_bindings_conditions session_bindings_conditions_audio session_bindings_a62 session_bindings_a51 session_exit session_bindings_a28 avf_decoder avf_player action_family_35 action_family_35_runtime session_bindings_a35 action_family_97 action_family_97_runtime session_bindings_a97 action_family_a1 action_family_a1_runtime session_bindings_aa1 action_family_79 action_family_79_runtime session_bindings_a79 action_family_78_runtime session_bindings_a78 inventory_view_runtime inventory_examine_runtime inventory_button_runtime action_family_36 action_family_37 action_family_38 action_family_36_runtime session_bindings_a36 action_family_17_runtime session_bindings_a17 action_family_0b_runtime session_bindings_a0b action_family_83_runtime session_bindings_a83 action_family_0c_runtime session_bindings_a0c action_family_3e action_family_3f action_family_3f_runtime session_bindings_a3f action_family_d9_runtime session_bindings_ad9 action_family_95 session_bindings_a95 action_family_4f session_bindings_a4f scene_stack session_bindings_a6e session_bindings_a6f session_bindings_a67 action_family_2e session_bindings_a2e action_family_94_runtime session_bindings_a94 action_family_43 autotext_writer session_bindings_a43 action_family_d1_runtime session_bindings_ad1 action_family_44 action_family_d8_runtime action_family_44_runtime session_bindings_a44 session_bindings_a65_a68_a69 session_bindings_a45 action_family_4b session_bindings_a4b action_family_2d_runtime session_bindings_a2d action_family_7d_runtime session_bindings_a7d action_family_1b action_family_1b_runtime session_bindings_a1b action_family_47_runtime session_bindings_a47 action_family_4e action_family_4e_runtime session_bindings_a4e action_family_33_runtime session_bindings_a33 action_family_ea_runtime session_bindings_aea action_family_20 action_family_70 action_family_80 action_family_20_runtime action_family_70_runtime action_family_80_runtime session_bindings_a20_a70_a80 action_family_77_runtime session_bindings_a77 action_family_f6_runtime session_bindings_af6 action_family_d0_runtime session_bindings_ad0 action_family_aa_runtime session_bindings_aaa action_family_e0_runtime session_bindings_ae0 action_family_d3_runtime session_bindings_ad3 action_family_e4_runtime session_bindings_ae4 score_time_display action_family_f5_runtime session_bindings_af5 action_family_eb_runtime session_bindings_aeb action_family_6d action_family_9a action_family_6d_runtime action_family_9a_runtime session_bindings_a6d_a9a action_family_1c action_family_1c_runtime session_bindings_a1c action_family_76_runtime session_bindings_a76 action_family_da_runtime session_bindings_ada action_family_ee_runtime session_bindings_aee; do
    object="$build_dir/$module.o"
    xcrun --sdk macosx clang -arch arm64 -mmacosx-version-min=27.0 \
        -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 \
        -I"$ffmpeg_prefix/include" \
        -c "$source_dir/$module.c" -o "$object"
    objects+=("$object")
done
test_definitions=()
if [ "$test_hooks" -eq 1 ]; then
    test_definitions+=(-DBLACKMOOR_NATIVE_APP_TEST_HOOKS)
fi
xcrun --sdk macosx clang++ -arch arm64 -mmacosx-version-min=27.0 \
    -std=c++17 -fobjc-arc -Wall -Wextra -Wpedantic -Werror -O2 \
    "${test_definitions[@]+${test_definitions[@]}}" \
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
printf 'Built incomplete native ARM64 startup app: %s test_hooks=%s\n' "$bundle" "$test_hooks"
