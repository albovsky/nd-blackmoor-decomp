#!/usr/bin/env python3
"""Run the original 16-bit blitters unmodified and compare native pixels.

The DirectDraw destination is the original software back buffer selected by
the destination-handle equality in 0x4c4067. No code hooks are installed.
COM-backed destinations, lock failures and non-16-bit modes are outside this
oracle and remain open.
"""

from __future__ import annotations

import argparse
import ctypes as c
import hashlib
import json
import random
import struct
import sys
from pathlib import Path

from hiff_original_oracle import DEFAULT_EXE, PEImage

ROOT = Path(__file__).resolve().parents[3]
DEFAULT_REPORT = ROOT / "work/analysis/slices/S05-3.caption-compositor-original-20261013.json"
EXPECTED_GAME_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
OPAQUE, KEYED = 1, 2
RGB555, RGB565 = 1, 2
BLIT_VA = {OPAQUE: 0x4C5377, KEYED: 0x4C5D4B}
GFX = 0x5CF659
STACK, STACK_SIZE = 0x10000000, 0x80000
HEAP, HEAP_SIZE = 0x20000000, 0x04000000
SENTINEL = 0x3F000000
BACKBUFFER_HANDLE = 0x7150B00F
DEST_WIDTH, DEST_HEIGHT, DEST_PITCH = 640, 480, 1280


class Original:
    def __init__(self, exe: Path):
        from unicorn import UC_ARCH_X86, UC_MODE_32, UC_PROT_ALL, Uc
        from unicorn import x86_const

        self.pe = PEImage.parse_and_map(exe)
        if hashlib.sha256(self.pe.data).hexdigest() != EXPECTED_GAME_SHA256:
            raise RuntimeError("immutable GAME.EXE SHA-256 mismatch")
        self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        self.x = x86_const
        self.uc.mem_map(self.pe.image_base, (self.pe.size_of_image + 0xFFF) & ~0xFFF,
                        UC_PROT_ALL)
        self.uc.mem_write(self.pe.image_base, self.pe.image)
        for address, size in ((STACK, STACK_SIZE), (HEAP, HEAP_SIZE), (SENTINEL, 0x1000)):
            self.uc.mem_map(address, size, UC_PROT_ALL)
        self.uc.mem_write(SENTINEL, b"\xcc" * 0x1000)
        self.source_desc = HEAP + 0x100
        self.source_pixels = HEAP + 0x1000
        self.destination_pixels = HEAP + 0x100000
        self.source_rect = HEAP + 0x200000
        self.destination_rect = HEAP + 0x200100
        self.label = HEAP + 0x200200
        self.stack = STACK + STACK_SIZE - 0x200
        self.hook_addresses: list[str] = []
        self.debug_calls: list[str] = []

    def run(self, kind: int, source: bytes, source_width: int, source_height: int,
            source_pitch: int, src_rect: tuple[int, int, int, int],
            target: bytes, dst_rect: tuple[int, int, int, int],
            fmt: int, key: int, alias: bool = False, debug: bool = False,
            source_offset: int = 0) -> bytes:
        uc = self.uc
        if len(target) != DEST_PITCH * DEST_HEIGHT:
            raise ValueError("destination image must be full original 640x480 back buffer")
        source_origin = self.source_pixels
        if source_pitch < 0:
            source_origin += (source_height - 1) * abs(source_pitch)
        src_ptr = self.destination_pixels + source_offset if alias else source_origin
        uc.mem_write(self.source_desc, bytes(0x40))
        uc.mem_write(self.source_desc, struct.pack("<I", src_ptr))
        uc.mem_write(self.source_desc + 0x2B,
                     struct.pack("<hhh", source_width, source_height, source_pitch))
        if alias:
            uc.mem_write(self.destination_pixels, target)
        else:
            uc.mem_write(self.source_pixels, source)
            uc.mem_write(self.destination_pixels, target)
        uc.mem_write(self.source_rect, struct.pack("<4i", *src_rect))
        uc.mem_write(self.destination_rect, struct.pack("<4i", *dst_rect))
        # GFX+0x0c selects the direct software back buffer; +0x14/+0x1c/+0x20
        # supply base, signed pitch and bytes per pixel to 0x4c4067.
        uc.mem_write(GFX + 0x0C, struct.pack("<I", BACKBUFFER_HANDLE))
        uc.mem_write(GFX + 0x14, struct.pack("<I", self.destination_pixels))
        uc.mem_write(GFX + 0x18, struct.pack("<hh", DEST_WIDTH, DEST_HEIGHT))
        uc.mem_write(GFX + 0x1C, struct.pack("<i", DEST_PITCH))
        uc.mem_write(GFX + 0x20, struct.pack("<h", 2))
        uc.mem_write(GFX + 0x22, bytes(32))
        uc.mem_write(GFX + 0x38D0, struct.pack("<H", key))
        uc.mem_write(0x639895, b"\x02")
        uc.mem_write(0x63A4CD, b"\x01" if debug else b"\0")
        uc.mem_write(self.label, b"S05-3\0")
        uc.mem_write(self.stack, struct.pack("<6I", SENTINEL, self.source_desc,
                                             BACKBUFFER_HANDLE, self.source_rect,
                                             self.destination_rect, self.label))
        uc.reg_write(self.x.UC_X86_REG_ECX, GFX)
        uc.reg_write(self.x.UC_X86_REG_ESP, self.stack)
        uc.emu_start(BLIT_VA[kind], SENTINEL, count=10_000_000)
        if uc.reg_read(self.x.UC_X86_REG_EIP) != SENTINEL:
            raise RuntimeError(f"original 0x{BLIT_VA[kind]:x} stopped at unexpected PC")
        return bytes(uc.mem_read(self.destination_pixels, len(target)))

    def debug_mismatch_probe(self) -> dict:
        """Observe the debug-only unequal-extent fatal path before raster I/O."""
        from unicorn import UC_HOOK_CODE
        from unicorn import x86_const

        uc = self.uc
        self.debug_calls.clear()
        hooks = {0x50CA3E: "format_error", 0x52139C: "report_error", 0x4C97B4: "quit"}

        def skip_external(uc_, address, _size, _user):
            self.debug_calls.append(hooks[address])
            esp = uc_.reg_read(x86_const.UC_X86_REG_ESP)
            ret = struct.unpack("<I", bytes(uc_.mem_read(esp, 4)))[0]
            uc_.reg_write(x86_const.UC_X86_REG_ESP, esp + 4)
            uc_.reg_write(x86_const.UC_X86_REG_EIP, ret)

        for address in hooks:
            uc.hook_add(UC_HOOK_CODE, skip_external, begin=address, end=address)
        before = bytes([0xA5]) * (DEST_PITCH * DEST_HEIGHT)
        # Source is 4x2, destination declaration is 1x1. In release mode the
        # source extent controls; the original debug gate reports/quits first.
        source = b"\x01\x02" * 8
        result = self.run(OPAQUE, source, 4, 2, 8, (0, 0, 3, 1), before,
                          (10, 10, 10, 10), RGB555, 0, False, debug=True)
        return {"debug_gate": True, "result": "diagnostic-and-quit-before-transfer",
                "calls": list(self.debug_calls), "destination_unchanged": result == before,
                "hook_addresses": [f"0x{address:x}" for address in hooks]}


def code_hashes(pe: PEImage) -> dict[str, str]:
    windows = {
        "0x4c5377..0x4c558b opaque helper to pinned next function": (0x4C5377, 0x4C558B),
        "0x4c5d4b..0x4c609b keyed helper to pinned next function": (0x4C5D4B, 0x4C609B),
        "0x4c4067..0x4c4202 direct/COM lock helper to pinned next function": (0x4C4067, 0x4C4202),
        "0x4c4202..0x4c425e unlock helper to pinned next function": (0x4C4202, 0x4C425E),
        "0x4c952f fixed 0x80-byte dirty-rect call window": (0x4C952F, 0x4C95AF),
        "0x4e1113 fixed 0x80-byte taskbar area restore window": (0x4E1113, 0x4E1193),
        "0x4e1157 fixed 0x80-byte caption restore window": (0x4E1157, 0x4E11D7),
    }
    result = {}
    for label, (start, end) in windows.items():
        offset = start - pe.image_base
        result[label] = hashlib.sha256(pe.image[offset:end - pe.image_base]).hexdigest()
    return result


def cases():
    rng = random.Random(0x4C5377)
    rows = []
    # Different source/destination pitches, edge rectangles, exact raw keys,
    # high-bit words, two-byte alias offsets, and overlapping rows.
    layouts = [
        (7, 5, 18, (1, 1, 5, 3), (11, 22, 15, 24), False),
        (9, 6, 22, (0, 0, 7, 2), (630, 477, 637, 479), False),
        (8, 7, 20, (2, 1, 6, 5), (3, 1, 7, 5), True),
        (8, 7, 20, (0, 0, 5, 4), (1, 1, 6, 5), True),
        (10, 4, 24, (3, 0, 8, 3), (620, 10, 625, 13), False),
        # Debug-only right/bottom equality is not part of the release loop.
        (8, 5, 20, (1, 1, 5, 3), (3, 10, 999, -999), False),
        (8, 5, 20, (0, 0, 3, 1), (20, 20, 25, 24), False),
    ]
    for index, (width, height, pitch, src_rect, dst_rect, alias) in enumerate(layouts):
        if alias:
            width, height, pitch = DEST_WIDTH, DEST_HEIGHT, DEST_PITCH
            sr = src_rect
            # Reposition alias source spans over the same small visible area.
            dr = dst_rect
        else:
            sr, dr = src_rect, dst_rect
        row_bytes = pitch * height
        source = bytes(rng.randrange(256) for _ in range(row_bytes))
        # In-range source coordinates are small for non-alias; source rect is
        # clipped only by the source descriptor, not by the destination.
        target = bytes(rng.randrange(256) for _ in range(DEST_PITCH * DEST_HEIGHT))
        for fmt, key in ((RGB555, 0x03E0), (RGB565, 0xF81F), (RGB555, 0xFFFF)):
            for kind in (OPAQUE, KEYED):
                # Seed selected pixels with the exact key and high-bit values.
                patched = bytearray(source)
                if not alias:
                    for y in range(sr[1], sr[3] + 1):
                        for x in range(sr[0], sr[2] + 1):
                            if (x + y + index) % 3 == 0:
                                struct.pack_into("<H", patched, y * pitch + x * 2, key)
                            elif (x + y) % 3 == 1:
                                struct.pack_into("<H", patched, y * pitch + x * 2,
                                                 0x8001 | ((x * 19 + y * 7) & 0x7FFE))
                rows.append({"kind": kind, "format": fmt, "key": key, "source": bytes(patched),
                             "width": width, "height": height, "pitch": pitch,
                             "src": sr, "dst": dr, "target": target, "alias": alias})
    # Same allocation with a two-byte-offset source pointer. The destination
    # row 0 overlays source row 1, so original forward row order is observable.
    for fmt, key in ((RGB555, 0x03E0), (RGB565, 0xF81F), (RGB555, 0xFFFF)):
        target = bytearray(rng.randrange(256) for _ in range(DEST_PITCH * DEST_HEIGHT))
        for y in range(2):
            for x in range(4):
                word = key if (x + y) % 3 == 0 else 0x8001 | ((x * 13 + y * 5) & 0x7FFE)
                struct.pack_into("<H", target, 2 + y * DEST_PITCH + x * 2, word)
        for kind in (OPAQUE, KEYED):
            rows.append({"kind": kind, "format": fmt, "key": key, "source": b"",
                         "width": 6, "height": 2,
                         "pitch": DEST_PITCH, "src": (0, 0, 3, 1),
                         "dst": (0, 1, 999, -999), "target": bytes(target),
                         "alias": True, "source_offset": 2})
    return rows


def native_run(lib, case) -> bytes:
    import test_caption_compositor as native

    if case["alias"]:
        target = native.byte_array(case["target"])
        src = native.view(target, case["width"], case["height"], case["pitch"], case["format"])
        source_offset = case.get("source_offset", 0)
        if source_offset:
            src.pixels = c.cast(c.byref(target, source_offset), c.POINTER(c.c_uint8))
            src.byte_capacity -= source_offset
        dst = native.view(target, 640, 480, 1280, case["format"])
    else:
        source = native.byte_array(case["source"])
        target = native.byte_array(case["target"])
        src = native.view(source, case["width"], case["height"], case["pitch"], case["format"])
        dst = native.view(target, 640, 480, 1280, case["format"])
    sr, dr = native.Rect(*case["src"]), native.Rect(*case["dst"])
    status = lib.caption_compositor_blit(c.byref(src), c.byref(dst), case["kind"],
                                         c.byref(sr), c.byref(dr), case["key"])
    if status != 0:
        raise RuntimeError(f"native blit rejected original-valid case: status {status}")
    return bytes(target)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--library", type=Path,
                        default=ROOT / "outputs/blackmoor-decomp/build/libcaptioncompositor.dylib")
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    args = parser.parse_args()
    import test_caption_compositor as native

    original = Original(args.exe)
    lib = native.bind(args.library)
    mismatches = []
    summaries = []
    all_cases = cases()
    for index, case in enumerate(all_cases):
        expected = original.run(case["kind"], case["source"], case["width"], case["height"],
                                case["pitch"], case["src"], case["target"], case["dst"],
                                case["format"], case["key"], case["alias"],
                                source_offset=case.get("source_offset", 0))
        actual = native_run(lib, case)
        expected_hash = hashlib.sha256(expected).hexdigest()
        actual_hash = hashlib.sha256(actual).hexdigest()
        if expected != actual:
            mismatches.append({"case": index, "expected_sha256": expected_hash,
                               "actual_sha256": actual_hash})
        summaries.append({"case": index, "kind": case["kind"], "format": case["format"],
                          "alias": case["alias"], "source_rect": case["src"],
                          "source_pointer_offset": case.get("source_offset", 0),
                          "destination_rect": case["dst"], "output_sha256": expected_hash})
    logical_rows = []
    for y in range(3):
        row = bytearray()
        for x in range(4):
            word = 0x8000 | (y << 8) | x
            if (x + y) % 3 == 0:
                word = 0xF81F
            row += struct.pack("<H", word)
        row += b"\xee\xee"
        logical_rows.append(bytes(row))
    negative_logical = b"".join(logical_rows)
    negative_physical = b"".join(reversed(logical_rows))
    negative_summaries = []
    for kind in (OPAQUE, KEYED):
        case = {"kind": kind, "format": RGB565, "key": 0xF81F, "source": negative_logical,
                "width": 4, "height": 3, "pitch": 10, "src": (0, 0, 3, 2),
                "dst": (40, 30, 43, 32), "target": bytes([0x3C]) *
                (DEST_PITCH * DEST_HEIGHT), "alias": False}
        expected = original.run(kind, negative_physical, 4, 3, -10, case["src"],
                                case["target"], case["dst"], RGB565, case["key"])
        actual = native_run(lib, case)
        output_hash = hashlib.sha256(expected).hexdigest()
        if expected != actual:
            mismatches.append({"case": len(all_cases) + len(negative_summaries),
                               "expected_sha256": output_hash,
                               "actual_sha256": hashlib.sha256(actual).hexdigest()})
        negative_summaries.append({"kind": kind, "original_pitch": -10,
                                   "native_equivalent_pitch": 10,
                                   "source_logical_rows_sha256": hashlib.sha256(
                                       negative_logical).hexdigest(),
                                   "output_sha256": output_hash,
                                   "matched_positive_pitch_repack": expected == actual})
    debug_gate = original.debug_mismatch_probe()
    exe_sha = hashlib.sha256(args.exe.read_bytes()).hexdigest()
    pe = PEImage.parse_and_map(args.exe)
    report = {
        "scope": "Original 0x4c5377/0x4c5d4b software back-buffer transfer loops; no code hooks",
        "game_exe": str(args.exe), "game_exe_sha256": exe_sha,
        "original_code_hashes_sha256": code_hashes(pe),
        "native_library": str(args.library),
        "native_library_sha256": hashlib.sha256(args.library.read_bytes()).hexdigest(),
        "raster_comparison_hooks": [], "cases": len(summaries) + len(negative_summaries),
        "mismatches": mismatches,
        "compared_output_sha256": [row["output_sha256"] for row in summaries] +
                                  [row["output_sha256"] for row in negative_summaries],
        "negative_pitch_original_probe": negative_summaries,
        "debug_mismatch_probe": debug_gate,
        "direct_backbuffer_selection": {
            "graphics_object": "0x5cf659", "destination_handle_global": "GFX+0x0c",
            "backbuffer_base": "GFX+0x14", "signed_pitch": "GFX+0x1c",
            "bytes_per_pixel": "GFX+0x20", "display_bytes_per_pixel": "0x639895",
            "selected_condition": "blit destination argument equals *(uint32_t *)(GFX+0x0c)"},
        "unverified": ["DirectDraw COM surface Lock/Unlock and driver rasterization",
                       "non-16-bit formats and formats other than exact RGB555/RGB565",
                       "negative pitch is proven in original, but the current native view only "
                       "represents positive-pitch caption/frame allocations",
                       "unsafe release invalid-input behavior"],
        "case_summaries": summaries,
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"cases": report["cases"], "mismatches": len(mismatches),
                      "raster_hooks": report["raster_comparison_hooks"],
                      "debug_gate_calls": debug_gate["calls"], "report": str(args.report),
                      "sha256": hashlib.sha256(args.report.read_bytes()).hexdigest()}, indent=2))
    return 1 if mismatches else 0


if __name__ == "__main__":
    raise SystemExit(main())
