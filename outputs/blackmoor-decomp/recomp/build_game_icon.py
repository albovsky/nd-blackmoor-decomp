#!/usr/bin/env python3
"""Build AppIcon.icns from the owner's hash-pinned GAME.EXE; assets stay local.

Uses pefile==2024.8.26 (requirements-build.txt), then macOS sips/iconutil.
The original group 128 / language 1033 contains distinct 16px and 32px icons.
Larger macOS representations are scaled from the original 32px image.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
import hashlib
from pathlib import Path
import struct
import subprocess
import sys
import tempfile

ORIGINAL_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
PEFILE_VERSION = '2024.8.26'
ICONSET_SIZES = (
    ('icon_16x16.png', 16), ('icon_16x16@2x.png', 32),
    ('icon_32x32.png', 32), ('icon_32x32@2x.png', 64),
    ('icon_128x128.png', 128), ('icon_128x128@2x.png', 256),
    ('icon_256x256.png', 256), ('icon_256x256@2x.png', 512),
    ('icon_512x512.png', 512), ('icon_512x512@2x.png', 1024),
)


class IconError(ValueError):
    """An invalid original, resource or native conversion must stop the build."""


@dataclass(frozen=True)
class IconImage:
    size: int
    data: bytes


def parse_group(group: bytes, payloads: dict[int, bytes]) -> list[IconImage]:
    """Validate the owned two-entry GRPICONDIR and its uncompressed 4bpp DIBs."""
    if len(group) != 34 or struct.unpack_from('<HHH', group) != (0, 1, 2):
        raise IconError('invalid RT_GROUP_ICON 128: expected two complete icon entries')
    images = []
    for index, (size, resource_id) in enumerate(((32, 1), (16, 2))):
        entry = struct.unpack_from('<BBBBHHIH', group, 6 + index * 14)
        expected_size = 40 + 64 + ((size * 4 + 31) // 32) * 4 * size + ((size + 31) // 32) * 4 * size
        if entry != (size, size, 16, 0, 1, 4, expected_size, resource_id):
            raise IconError(f'invalid RT_GROUP_ICON entry {index}: expected {size}px resource {resource_id}')
        data = payloads.get(resource_id, b'')
        if len(data) != expected_size:
            raise IconError(f'missing or truncated RT_ICON resource {resource_id}: expected {expected_size} bytes')
        header = struct.unpack_from('<IiiHHIIiiII', data)
        xor_size = ((size * 4 + 31) // 32) * 4 * size
        if header[:6] != (40, size, size * 2, 1, 4, 0) or header[6] != xor_size or header[9:] != (0, 0):
            raise IconError(f'invalid RT_ICON resource {resource_id}: unsupported or inconsistent DIB')
        images.append(IconImage(size, data))
    return images


def resource_bytes(pe, kind: int, resource_id: int) -> bytes:
    """Select numeric IDs and US English explicitly; never choose a fallback icon."""
    entries = getattr(getattr(pe, 'DIRECTORY_ENTRY_RESOURCE', None), 'entries', [])
    for wanted in (kind, resource_id, 1033):
        matches = [entry for entry in entries if entry.id == wanted]
        if len(matches) != 1:
            state = 'missing' if not matches else 'ambiguous'
            raise IconError(f'{state} PE resource {kind}/{resource_id}/1033 at ID {wanted}')
        selected = matches[0]
        entries = getattr(getattr(selected, 'directory', None), 'entries', [])
    try:
        item = selected.data.struct
        data = pe.get_data(item.OffsetToData, item.Size)
    except (AttributeError, ValueError) as error:
        raise IconError(f'invalid PE resource {kind}/{resource_id}/1033: {error}') from error
    if len(data) != item.Size:
        raise IconError(f'truncated PE resource {kind}/{resource_id}/1033')
    return data


def extract_icons(pe) -> list[IconImage]:
    return parse_group(resource_bytes(pe, 14, 128), {key: resource_bytes(pe, 3, key) for key in (1, 2)})


def make_ico(images: list[IconImage]) -> bytes:
    offset = 6 + 16 * len(images)
    directory = bytearray(struct.pack('<HHH', 0, 1, len(images)))
    for image in images:
        directory.extend(struct.pack('<BBBBHHII', image.size, image.size, 16, 0, 1, 4, len(image.data), offset))
        offset += len(image.data)
    return bytes(directory) + b''.join(image.data for image in images)


def run_tool(command: list[str]) -> None:
    try:
        subprocess.run(command, check=True, capture_output=True, text=True, timeout=30)
    except (OSError, subprocess.SubprocessError) as error:
        detail = (getattr(error, 'stderr', '') or str(error)).strip()[:1000]
        raise IconError(f'{Path(command[0]).name} conversion failed: {detail}') from error


def png_size(path: Path) -> tuple[int, int]:
    with path.open('rb') as stream:
        header = stream.read(24)
    if len(header) != 24 or header[:16] != b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR':
        raise IconError(f'invalid PNG produced by native conversion: {path.name}')
    return struct.unpack_from('>II', header, 16)


def convert_icons(images: list[IconImage], output: Path) -> None:
    """Use private intermediate files and publish only a validated complete ICNS."""
    if sys.platform != 'darwin':
        raise IconError('building the game icon requires macOS sips and iconutil')
    if output.suffix.lower() != '.icns' or output.is_symlink():
        raise IconError('icon output must be a regular .icns path, not a symlink')
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.blackmoor-icon-', dir=output.parent) as scratch:
        root = Path(scratch)
        iconset = root / 'AppIcon.iconset'
        iconset.mkdir()
        bases = {}
        # Keep an ICO holding both exact original payloads as well as per-size sources.
        (root / 'original.ico').write_bytes(make_ico(images))
        for image in images:
            source = root / f'original-{image.size}.ico'
            source.write_bytes(make_ico([image]))
            base = root / f'original-{image.size}.png'
            run_tool(['/usr/bin/sips', '-s', 'format', 'png', str(source), '--out', str(base)])
            if png_size(base) != (image.size, image.size):
                raise IconError(f'native ICO decode returned wrong size for {image.size}px icon')
            bases[image.size] = base
        for name, size in ICONSET_SIZES:
            source = bases[16 if size == 16 else 32]
            target = iconset / name
            run_tool(['/usr/bin/sips', '-z', str(size), str(size), str(source), '--out', str(target)])
            if png_size(target) != (size, size):
                raise IconError(f'native resize returned wrong size for {name}')
        candidate = root / 'AppIcon.icns'
        run_tool(['/usr/bin/iconutil', '-c', 'icns', str(iconset), '-o', str(candidate)])
        data = candidate.read_bytes()
        if len(data) < 8 or data[:4] != b'icns' or struct.unpack_from('>I', data, 4)[0] != len(data):
            raise IconError('native conversion produced an invalid ICNS container')
        decoded = root / 'decoded.iconset'
        run_tool(['/usr/bin/iconutil', '-c', 'iconset', str(candidate), '-o', str(decoded)])
        for name, size in ICONSET_SIZES:
            if png_size(decoded / name) != (size, size):
                raise IconError(f'ICNS round-trip returned wrong size for {name}')
        candidate.replace(output)


def build_icon(exe: Path, output: Path) -> None:
    data = exe.read_bytes()
    actual = hashlib.sha256(data).hexdigest()
    if actual != ORIGINAL_SHA256:
        raise IconError(f'GAME.EXE SHA-256 mismatch: expected {ORIGINAL_SHA256}, got {actual}')
    try:
        import pefile
    except ImportError as error:
        raise IconError(f'pefile=={PEFILE_VERSION} is required; install recomp/requirements-build.txt') from error
    if pefile.__version__ != PEFILE_VERSION:
        raise IconError(f'pefile=={PEFILE_VERSION} is required, found {pefile.__version__}')
    try:
        with pefile.PE(data=data, fast_load=True) as pe:
            pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_RESOURCE']])
            images = extract_icons(pe)
    except pefile.PEFormatError as error:
        raise IconError(f'invalid GAME.EXE PE resources: {error}') from error
    convert_icons(images, output)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--exe', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    try:
        build_icon(args.exe, args.output)
    except (IconError, OSError) as error:
        print(f'game icon: {error}', file=sys.stderr)
        return 1
    print(f'Built {args.output}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
