#!/usr/bin/env python3
"""Fragment support for the generator (Track M slice 4, owner ruling of 2026-10-16).

``gen_hinted_asm.py`` is hash-pinned by ``function-xrefs.json`` and cannot change without invalidating the recorded
execution evidence, so this module extends it at run time instead: :func:`extend` wraps a loaded generator module's
``analyze``, ``_register_table``, ``header_lines`` and ``build_manifest``.  ``annotate_machine.py`` and
``audit_tool_assisted.py`` call it on the generator they use; the generator's own census and
``extract_function_xrefs.py`` do not, so the census, the xrefs and the ledger keep describing the unextended analysis.

Owner ruling (decision card, 2026-10-16): a code fragment counts as matched when it reassembles byte for byte with the
pinned assembler, either as a function ending in a never-returning call or bound together with the range it falls
through into.  Two things follow in the generator:

* ``Layout.ending``: ``"call-end"`` when the code part ends in a ``call`` with no data after it, ``"fall-through"``
  when the code runs into the next range, otherwise empty.  Whether the callee of a call-end returns cannot be proven
  from the bytes (six of the thirteen call-ends call ``__fload_withFB``, which does return), so both endings are
  counted only bound together with the range that follows them, which is the second option of the ruling.  The header carries an ``# ending:`` line (``ending_text``)
  and the batch manifest an ``ending`` key, which the auditor derives from the original and requires to agree.
* The two CRT block-copy routines (``0x0050ed50``, ``0x0050fa90``) keep their jump tables between code runs, so their
  spans are not "code, then tables, then padding".  ``image/text_data.json`` lists those tables (the composer's
  structured ``jump_tables`` group generates their bytes); the span is cut at them and every code run is analyzed as its
  own entry (the first is the indexed function, the others are derived entries), exactly like the unindexed code the span
  split already finds elsewhere.  A ``jmp [reg*4 + table]`` inside such a span is a plain indirect jump whose absolute
  table base stays numeric.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Optional

PROJECT = Path(__file__).resolve().parents[1]
TEXT_VA = 0x401000
TEXT_SIZE = 0x12825A
BLOCK_COPY_STARTS = (0x50ED50, 0x50FA90)
TEXT_DATA = PROJECT / "image" / "text_data.json"
IMAGE_BASE = 0x400000


def ending_text(layout: Any) -> str:
    """Header value of the ``ending`` field, empty for an ordinary terminal ending."""

    ending = getattr(layout, "ending", "")
    if ending == "call-end":
        return (
            f"call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is "
            f"counted only bound together with the range at 0x{layout.span_end:08x} that follows it, under the owner ruling "
            "of 2026-10-16)"
        )
    if ending == "fall-through":
        return (
            f"fall-through into 0x{layout.span_end:08x} (counted only bound together with the range it falls into, "
            "under the owner ruling of 2026-10-16)"
        )
    return ""


def classify_ending(layout: Any) -> str:
    if layout.exceptions or not layout.insns:
        return ""
    if layout.falls_through:
        return "fall-through"
    last = layout.insns[-1]
    if last.mnem == "call" and not layout.data and last.end == layout.span_end:
        return "call-end"
    return ""


def fragment_tables(image: Any) -> tuple[list[tuple[int, int]], list[tuple[int, int]]]:
    """(cut spans, merged inline tables) of an image; empty unless it is the real ``.text`` with ``text_data.json``."""

    cached = getattr(image, "fragment_tables", None)
    if cached is not None:
        return cached
    spans: list[tuple[int, int]] = []
    merged: list[tuple[int, int]] = []
    if image.base == TEXT_VA and len(image.text) == TEXT_SIZE and TEXT_DATA.is_file():
        spans = [image.span(va) for va in BLOCK_COPY_STARTS if va in image.starts]
        data = json.loads(TEXT_DATA.read_text(encoding="utf-8"))
        tables = sorted(
            (IMAGE_BASE + int(item["offset"], 16), IMAGE_BASE + int(item["offset"], 16) + 4 * len(item["entries"]))
            for item in data.get("jump_tables", [])
            if item.get("kind") == "dword"
        )
        for lo, hi in tables:
            if not any(start <= lo and hi <= end for start, end in spans):
                continue
            if merged and merged[-1][1] == lo:  # adjacent tables are one gap
                merged[-1] = (merged[-1][0], hi)
            else:
                merged.append((lo, hi))
    image.fragment_tables = (spans, merged)
    return image.fragment_tables


def in_cut_span(image: Any, addr: int) -> bool:
    return any(lo <= addr < hi for lo, hi in fragment_tables(image)[0])


def next_table(image: Any, start: int, end: int) -> Optional[tuple[int, int]]:
    """The first inline table strictly inside ``(start, end)`` of a cut span, clipped to ``end``."""

    spans, tables = fragment_tables(image)
    if not any(lo <= start < hi for lo, hi in spans):
        return None
    for lo, hi in tables:
        if start < lo < end:
            return lo, min(hi, end)
    return None


def extend(gen: Any) -> Any:
    """Wrap the analysis, header and manifest functions of a loaded ``gen_hinted_asm`` module (idempotent)."""

    if getattr(gen, "_unextended", None) is not None:
        return gen
    original = {
        "analyze": gen.analyze,
        "register_table": gen._register_table,
        "header_lines": gen.header_lines,
        "build_manifest": gen.build_manifest,
    }
    gen._unextended = original

    def analyze(image, va, decoded, span_end=None, known_targets=frozenset()):
        if span_end is None:
            start, span_end = image.span(va)
        else:
            start = va
        cut = next_table(image, start, span_end)
        layout = original["analyze"](image, va, decoded, cut[0] if cut else span_end, known_targets)
        if cut is not None:
            # a jump table follows this code run; the code after the table is the next entry
            layout.notes.append(f"inline_table_follows:0x{cut[0]:08x}-0x{cut[1]:08x}")
            if not layout.next_entry and cut[1] < span_end:
                layout.next_entry = cut[1]
        layout.ending = classify_ending(layout)
        return layout

    def register_table(image, start, *rest):
        if in_cut_span(image, start):
            return  # an entry of a cut span: its table jump stays a plain indirect jump, there is no switch to size here
        return original["register_table"](image, start, *rest)

    def header_lines(image, layout, rendered):
        lines = original["header_lines"](image, layout, rendered)
        if getattr(layout, "ending", ""):
            at = next(i for i, line in enumerate(lines) if line.startswith("# frame:")) + 1
            lines.insert(at, f"# ending:       {ending_text(layout)}")
        return lines

    def build_manifest(image, layouts, vas, *args, **kwargs):
        manifest = original["build_manifest"](image, layouts, vas, *args, **kwargs)
        for entry in manifest["functions"]:
            ending = getattr(layouts[int(entry["va"], 16)], "ending", "")
            if ending:
                entry["ending"] = ending
        return manifest

    gen.analyze = analyze
    gen._register_table = register_table
    gen.header_lines = header_lines
    gen.build_manifest = build_manifest
    return gen
