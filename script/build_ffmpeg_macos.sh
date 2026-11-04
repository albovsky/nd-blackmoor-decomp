#!/bin/bash
# Build the minimal, LGPL-only, shared ARM64 FFmpeg that ships inside the private macOS package.
#
#   script/build_ffmpeg_macos.sh
#
# Output (all under work/, never committed):
#   work/ffmpeg-download/ffmpeg-<version>.tar.xz    official release tarball, SHA-256 pinned below
#   work/ffmpeg-macos/src-<version>/                extracted source (untouched)
#   work/ffmpeg-macos/build-<version>-macos<min>/   out-of-tree build directory
#   work/ffmpeg-macos/prefix-<version>-macos<min>/   install prefix: lib/, include/ and the licence record
#                                                    share/blackmoor-licenses/ffmpeg/
#
# Only what the game needs is enabled: the file protocol, the Bink demuxer and the three Bink
# decoders (configure names bink, binkaudio_dct, binkaudio_rdft; the video codec's own name is
# "binkvideo"), in libavformat, libavcodec, libavutil, libswscale and libswresample. Nothing is GPL,
# version3 or nonfree, nothing autodetects a system library, and the dylibs are built with install
# names @rpath/<lib> and an @loader_path rpath so the packager can relocate them.
#
# Environment (each optional):
#   MIN_MACOS      deployment floor (default 11.0)
#   FFMPEG_WORK    scratch root (default <workspace>/work/ffmpeg-macos)
#   FFMPEG_DOWNLOAD_DIR  tarball cache (default <workspace>/work/ffmpeg-download)
#   FFMPEG_TARBALL       use this local tarball instead of downloading (its SHA-256 must still match)
#   JOBS           parallel make jobs (default: hw.ncpu)
#   DEVELOPER_DIR  Xcode to use; if the active one cannot compile, an installed Xcode*.app is chosen
#
# The script never deletes anything: re-running reuses the extracted source and build directory
# (make is incremental) and does nothing when a finished install with the same configuration exists.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace="$(cd "$here/.." && pwd)"

version="9.0.1"
tarball_name="ffmpeg-$version.tar.xz"
tarball_url="https://ffmpeg.org/releases/$tarball_name"
tarball_sha256="cf38e0e28c7e5605942c4a77755349b0145804a397af37eb1fb4c77cb237f635"

min_os="${MIN_MACOS:-11.0}"
work_root="${FFMPEG_WORK:-$workspace/work/ffmpeg-macos}"
download_dir="${FFMPEG_DOWNLOAD_DIR:-$workspace/work/ffmpeg-download}"
jobs="${JOBS:-$(sysctl -n hw.ncpu)}"
python_bin="${BLACKMOOR_PYTHON:-$workspace/work/tools/recomp-python/bin/python3}"

src_dir="$work_root/src-$version"
build_dir="$work_root/build-$version-macos$min_os"
prefix="$work_root/prefix-$version-macos$min_os"
license_dir="$prefix/share/blackmoor-licenses/ffmpeg"

fail() {
    printf 'build_ffmpeg_macos.sh: %s\n' "$1" >&2
    exit 1
}

# `--print-prefix` prints where the finished install lives, without building anything.
if [[ "${1:-}" == "--print-prefix" ]]; then
    printf '%s\n' "$prefix"
    exit 0
fi

if [[ ! -x "$python_bin" ]]; then
    fail "pinned Python not found: $python_bin (run script/setup_recomp_python.sh, or set BLACKMOOR_PYTHON)"
fi

# --- a working Xcode: keep the active one when it can compile, otherwise pick an installed Xcode*.app
sdk_ok=0
if xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
    sdk_ok=1
fi
if [[ "$sdk_ok" -eq 0 ]]; then
    for candidate in /Applications/Xcode*.app/Contents/Developer; do
        if [[ -d "$candidate" ]]; then
            if DEVELOPER_DIR="$candidate" xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
                export DEVELOPER_DIR="$candidate"
                sdk_ok=1
                break
            fi
        fi
    done
fi
if [[ "$sdk_ok" -eq 0 ]]; then
    fail "no working Xcode found; install Xcode or set DEVELOPER_DIR"
fi
sdk_path="$(xcrun --sdk macosx --show-sdk-path)"
cc_path="$(xcrun --sdk macosx --find clang)"
# configure also runs the host compiler directly (no xcrun wrapper), so give every clang the SDK
export SDKROOT="$sdk_path"

# --- the pinned tarball
if [[ -n "${FFMPEG_TARBALL:-}" ]]; then
    tarball="$FFMPEG_TARBALL"
else
    tarball="$download_dir/$tarball_name"
    mkdir -p "$download_dir"
    if [[ ! -f "$tarball" ]]; then
        printf 'Downloading %s\n' "$tarball_url"
        curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 --max-time 900 \
            --output "$tarball.partial" "$tarball_url"
        mv "$tarball.partial" "$tarball"
    fi
fi
if [[ ! -f "$tarball" ]]; then
    fail "tarball not found: $tarball"
fi
sum_line="$(shasum -a 256 "$tarball")"
actual_sha256="${sum_line%% *}"
if [[ "$actual_sha256" != "$tarball_sha256" ]]; then
    fail "SHA-256 mismatch for $tarball: got $actual_sha256, pinned $tarball_sha256"
fi
printf 'FFmpeg %s source verified: sha256 %s\n' "$version" "$actual_sha256"

mkdir -p "$work_root"

# --- extract once; the stamp says the extraction completed
if [[ -d "$src_dir" ]]; then
    if [[ ! -f "$src_dir/.blackmoor-extracted" ]]; then
        fail "$src_dir exists but is incomplete; remove it by hand and re-run"
    fi
fi
if [[ ! -d "$src_dir" ]]; then
    stage="$work_root/extract-$version.$$"
    mkdir "$stage"
    tar -xJf "$tarball" -C "$stage"
    mv "$stage/ffmpeg-$version" "$src_dir"
    printf '%s\n' "$tarball_sha256" > "$src_dir/.blackmoor-extracted"
fi

configure_args=(
    "--prefix=$prefix"
    --enable-shared
    --disable-static
    --disable-programs
    --disable-doc
    --disable-debug
    --disable-autodetect
    --disable-network
    --disable-everything
    --disable-avdevice
    --disable-avfilter
    --enable-avformat
    --enable-avcodec
    --enable-avutil
    --enable-swscale
    --enable-swresample
    --enable-protocol=file
    --enable-demuxer=bink
    --enable-decoder=bink
    --enable-decoder=binkaudio_dct
    --enable-decoder=binkaudio_rdft
    --enable-pic
    --arch=arm64
    --target-os=darwin
    "--cc=$cc_path"
    --install-name-dir=@rpath
    "--extra-cflags=-arch arm64 -mmacosx-version-min=$min_os -isysroot $sdk_path"
    "--extra-ldflags=-arch arm64 -mmacosx-version-min=$min_os -isysroot $sdk_path -Wl,-rpath,@loader_path -Wl,-headerpad_max_install_names"
)
# the recorded command keeps shell quoting, so it can be pasted and re-run exactly
printf -v configure_command '%q' "$src_dir/configure"
for configure_arg in "${configure_args[@]}"; do
    printf -v quoted_arg ' %q' "$configure_arg"
    configure_command="$configure_command$quoted_arg"
done

if [[ -f "$license_dir/BUILD-INFO.json" ]]; then
    if "$python_bin" -I "$here/macos_bundle.py" ffmpeg-stamp-matches --prefix "$prefix" \
        --sha256 "$tarball_sha256" --configure "$configure_command"; then
        printf 'FFmpeg %s already built at %s\n' "$version" "$prefix"
        exit 0
    fi
    printf 'The install at %s was made with a different configuration; rebuilding over it\n' "$prefix"
fi

mkdir -p "$build_dir"
cd "$build_dir"
"$src_dir/configure" "${configure_args[@]}"
make -j "$jobs"
make install

compiler_text="$("$cc_path" --version)"
compiler_version="${compiler_text%%$'\n'*}"
"$python_bin" -I "$here/macos_bundle.py" ffmpeg-record \
    --prefix "$prefix" --source "$src_dir" --version "$version" \
    --url "$tarball_url" --sha256 "$tarball_sha256" \
    --configure "$configure_command" --min-macos "$min_os" \
    --compiler "$compiler_version" --sdk "$sdk_path"
"$python_bin" -I "$here/macos_bundle.py" ffmpeg-check --prefix "$prefix" --min-macos "$min_os"
printf 'FFmpeg %s ready: %s\n' "$version" "$prefix"
