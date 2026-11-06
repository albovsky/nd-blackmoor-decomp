#!/usr/bin/env python3
"""Build AppIcon.icns from the owner's hash-pinned GAME.EXE; assets stay local.

Uses pefile==2024.8.26 (requirements-build.txt), a strict 4bpp DIB decoder,
then macOS sips/iconutil for PNG resizing and ICNS packaging.
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
import zlib

ORIGINAL_SHA256 = 'afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45'
PEFILE_VERSION = '2024.8.26'
MAX_SOURCE_PNG_BYTES = 1024 * 1024
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


def dib_rgba(image: IconImage) -> bytes:
    """Decode only parse_group's validated bottom-up 4bpp palette/XOR/AND DIB."""
    size = image.size
    xor_stride = size // 2
    mask_start = 104 + xor_stride * size
    rows = bytearray()
    for y in range(size - 1, -1, -1):
        for x in range(size):
            packed = image.data[104 + y * xor_stride + x // 2]
            index = (packed >> (4 if x % 2 == 0 else 0)) & 15
            palette = 40 + index * 4
            alpha = 0 if image.data[mask_start + y * 4 + x // 8] & (128 >> (x % 8)) else 255
            # RGBQUAD's fourth byte is reserved, not an alpha component.
            rows.extend((image.data[palette + 2], image.data[palette + 1], image.data[palette], alpha))
    return bytes(rows)


def make_png(image: IconImage) -> bytes:
    pixels = dib_rgba(image)
    size = image.size
    stride = size * 4
    rows = b''.join(b'\0' + pixels[y * stride:(y + 1) * stride] for y in range(size))

    def chunk(tag, data):
        return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data))
    header = struct.pack('>IIBBBBB', size, size, 8, 6, 0, 0, 0)
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', header) + chunk(b'IDAT', zlib.compress(rows, 9)) + chunk(b'IEND', b'')


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


def decode_png(data: bytes, size: int) -> bytes:
    """Read only bounded 16/32px native 8-bit RGB/RGBA PNGs into straight RGBA."""
    if size not in (16, 32) or len(data) > MAX_SOURCE_PNG_BYTES:
        raise IconError('native PNG exceeds the source-image size limit')
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise IconError('invalid native PNG signature')
    offset = 8
    channels = 0
    compressed = bytearray()
    saw_data = False
    data_ended = False
    ended = False
    while offset < len(data):
        if len(data) - offset < 12:
            raise IconError('truncated native PNG chunk length')
        length, tag = struct.unpack_from('>I4s', data, offset)
        if any(not (65 <= value <= 90 or 97 <= value <= 122) for value in tag) or tag[2] & 32:
            raise IconError('invalid native PNG chunk type')
        end = offset + length + 12
        if end > len(data):
            raise IconError('invalid native PNG chunk length')
        payload = data[offset + 8:end - 4]
        if zlib.crc32(tag + payload) != struct.unpack_from('>I', data, end - 4)[0]:
            raise IconError('invalid native PNG chunk CRC')
        if not channels and tag != b'IHDR':
            raise IconError('native PNG must start with IHDR')
        if tag == b'IHDR':
            if channels or length != 13:
                raise IconError('invalid native PNG IHDR')
            width, height, bits, color, compression, filtering, interlace = struct.unpack('>IIBBBBB', payload)
            if (width, height) != (size, size):
                raise IconError('native PNG dimensions differ from the source icon')
            if bits != 8 or color not in (2, 6) or (compression, filtering, interlace) != (0, 0, 0):
                raise IconError('unsupported native PNG encoding; need noninterlaced 8-bit RGB/RGBA')
            channels = 4 if color == 6 else 3
        elif tag == b'IDAT':
            if data_ended:
                raise IconError('invalid native PNG nonconsecutive IDAT chunks')
            saw_data = True
            compressed.extend(payload)
        elif tag == b'IEND':
            if length or not saw_data:
                raise IconError('invalid native PNG IEND or missing IDAT')
            if end != len(data):
                raise IconError('invalid native PNG trailing bytes after IEND')
            ended = True
            break
        else:
            if tag == b'tRNS':
                raise IconError('unsupported native PNG transparency chunk')
            if not tag[0] & 32:
                raise IconError('unsupported native PNG critical chunk')
            if saw_data:
                data_ended = True
        offset = end
    if not ended:
        raise IconError('native PNG is missing IEND')
    stride = size * channels
    expected = (stride + 1) * size
    try:
        inflater = zlib.decompressobj()
        raw = inflater.decompress(compressed, expected + 1)
    except zlib.error as error:
        raise IconError(f'native PNG decompression failed: {error}') from error
    if len(raw) != expected or not inflater.eof or inflater.unused_data or inflater.unconsumed_tail:
        raise IconError('native PNG decompression length or stream mismatch')
    previous = bytearray(stride)
    pixels = bytearray()
    for y in range(size):
        start = y * (stride + 1)
        kind = raw[start]
        if kind > 4:
            raise IconError('unsupported native PNG row filter')
        row = bytearray(raw[start + 1:start + 1 + stride])
        for x in range(stride):
            left = row[x - channels] if x >= channels else 0
            up = previous[x]
            upper_left = previous[x - channels] if x >= channels else 0
            if kind == 1:
                predictor = left
            elif kind == 2:
                predictor = up
            elif kind == 3:
                predictor = (left + up) // 2
            elif kind == 4:
                guess = left + up - upper_left
                a = abs(guess - left)
                b = abs(guess - up)
                c = abs(guess - upper_left)
                predictor = left if a <= b and a <= c else up if b <= c else upper_left
            else:
                predictor = 0
            row[x] = (row[x] + predictor) & 255
        for x in range(0, stride, channels):
            pixels.extend(row[x:x + 3])
            pixels.append(row[x + 3] if channels == 4 else 255)
        previous = row
    return bytes(pixels)


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
        for image in images:
            base = root / f'original-{image.size}.png'
            base.write_bytes(make_png(image))
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
        for image in images:
            path = decoded / f'icon_{image.size}x{image.size}.png'
            with path.open('rb') as stream:
                actual = decode_png(stream.read(MAX_SOURCE_PNG_BYTES + 1), image.size)
            expected = dib_rgba(image)
            for offset in range(0, len(expected), 4):
                alpha_matches = actual[offset + 3] == expected[offset + 3]
                rgb_matches = not expected[offset + 3] or actual[offset:offset + 3] == expected[offset:offset + 3]
                if not alpha_matches or not rgb_matches:
                    pixel = offset // 4
                    raise IconError(f'ICNS round-trip pixel mismatch for {image.size}px icon at '
                                    f'({pixel % image.size}, {pixel // image.size})')
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
