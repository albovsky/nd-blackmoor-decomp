"""Tests for scripts/extract_function_evidence.py (packet FL-2).

Every case builds a scratch repository under /private/tmp: a synthetic PE
standing in for GAME.EXE, a seven-function index, small C/Python sources and
private-style receipts.  Nothing here edits the committed
function-evidence.json; the last class only runs the extractor's read-only
``--check`` logic against it (and is skipped when the private inputs are
absent).
"""

from __future__ import annotations

import contextlib
import copy
import hashlib
import importlib.util
import io
import json
import os
import shutil
import struct
import sys
import tempfile
import unittest
from pathlib import Path

TESTS = Path(__file__).resolve().parent
OUTPUTS = TESTS.parent
REPO = OUTPUTS.parents[1]
SCRIPT = Path(os.environ.get("FL2_SCRIPT") or OUTPUTS / "scripts" / "extract_function_evidence.py")  # env: mutation runs

SPEC = importlib.util.spec_from_file_location("extract_function_evidence", SCRIPT)
assert SPEC and SPEC.loader, SCRIPT
fe = importlib.util.module_from_spec(SPEC)
sys.modules["extract_function_evidence"] = fe
SPEC.loader.exec_module(fe)

SCRATCH = Path("/private/tmp")
TEXT_VA = 0x401000
TEXT_SIZE = 0x2000
TEXT_END = TEXT_VA + TEXT_SIZE            # 0x403000
RAW_OFF = 0x400                            # not equal to the RVA: exercises the mapping
DATA_VA = 0x404000
STARTS = [0x401000, 0x401100, 0x401200, 0x401400, 0x401800, 0x402000, 0x402800]
TEXT_BYTES = bytes((i * 37 + 11) & 0xFF for i in range(TEXT_SIZE))


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def span_bytes(start: int, end: int) -> bytes:
    return TEXT_BYTES[start - TEXT_VA:end - TEXT_VA]


def h(start: int, end: int) -> str:
    """Hash of the fixture text over [start, end)."""
    return sha(span_bytes(start, end))


def make_pe() -> bytes:
    """Minimal PE32: a .text at RVA 0x1000 / raw 0x400 and a small .data."""
    pe_offset = 0x80
    optional_size = 0xE0
    image = bytearray(RAW_OFF)
    image[:2] = b"MZ"
    struct.pack_into("<I", image, 0x3C, pe_offset)
    image[pe_offset:pe_offset + 4] = b"PE\0\0"
    struct.pack_into("<HHIIIHH", image, pe_offset + 4, 0x014C, 2, 0, 0, 0, optional_size, 0x010F)
    optional = bytearray(optional_size)
    struct.pack_into("<H", optional, 0, 0x010B)
    struct.pack_into("<I", optional, 28, 0x400000)
    struct.pack_into("<I", optional, 32, 0x1000)
    struct.pack_into("<I", optional, 36, 0x200)
    struct.pack_into("<I", optional, 56, 0x6000)
    struct.pack_into("<I", optional, 60, RAW_OFF)
    optional_offset = pe_offset + 4 + 20
    image[optional_offset:optional_offset + optional_size] = optional
    table = optional_offset + optional_size
    sections = [
        (b".text\0\0\0", TEXT_SIZE, 0x1000, TEXT_SIZE, RAW_OFF),
        (b".data\0\0\0", 0x1000, 0x4000, 0x200, RAW_OFF + TEXT_SIZE),
    ]
    for i, (name, vsize, rva, rsize, roff) in enumerate(sections):
        struct.pack_into("<8sIIIIIIHHI", image, table + 40 * i, name, vsize, rva, rsize, roff, 0, 0, 0, 0, 0x60000020)
    return bytes(image) + TEXT_BYTES + bytes((i * 5 + 1) & 0xFF for i in range(0x200))


C_ALPHA = """\
/* File comment: 0x401000 and interior 0x401150. */
#include <stdint.h>

/* Leading comment of alpha_one, recovered from FUN_00401100. */
int alpha_one(int x) {
    /* interior 0x401204 and exact 0x402800 */
    const char *s = "0x401400 inside a string is ignored";
    return x + 0x403100; /* above the end of .text */
}

static int alpha_two(void) { return 0x401800u; }
"""

H_ALPHA = """\
/* Prototype note: 0x401200 exact. */
int alpha_three(int);
"""

PY_TEST = '''\
import unittest


class AlphaTests(unittest.TestCase):
    def test_exact(self):
        self.assertEqual(helper(0x401400), 1)

    def test_interior(self):
        value = 0x401810
        return value


def helper(v):
    return 0x403200
'''


def oracle_source() -> str:
    return f'''\
"""Oracle for 0x401000..0x401100 only."""
CODE = [
    (0x401000, 0x401100, '{h(0x401000, 0x401100)}'),
    (0x401200, 0x200, '{h(0x401200, 0x401400)}'),
]
WINDOWS = {{'entry': (0x401800, 0x401900)}}
'''


def receipt_one(abs_prefix: str) -> dict:
    return {
        "code_windows": [
            {"start": "0x401000", "end_exclusive": "0x401100", "sha256": h(0x401000, 0x401100)},
            {"start": "0x401100", "end": "0x401200", "sha256": h(0x401100, 0x401200)},
        ],
        "independent_review": {"status": "pending", "reviewer": None},
        "unverified_branches": ["fatal path at 0x401250 not modelled", "allocation failure"],
        "deliberate_safety_rejections": ["short body at 0x401410 rejected"],
        "hook_inventory": {
            "code:0x401200": "malloc only: returns a guarded object",
            "memory:input": "observer only",
        },
        "files": [
            abs_prefix + "/outputs/blackmoor-decomp/tests/alpha_original_oracle.py",
            "outputs/blackmoor-decomp/src/alpha.c",
        ],
    }


def receipt_two() -> dict:
    return {
        "oracle": {"code_windows": [[0x401400, 0x401800, h(0x401400, 0x401800)]]},
        "hashes": {
            "code_windows_original": {"0x401800..0x401900 (arm)": h(0x401800, 0x401900)},
            "code_window": h(0x402000, 0x402100),
            "code_start": "0x402000",
            "code_end": "0x402100",
        },
        "original": {"code_windows": [{"va": "0x402800", "size": 256, "sha256": h(0x402800, 0x402900)}]},
        "named": {"x": {"range": ["0x402100", "0x402200"], "sha256": h(0x402100, 0x402200)}},
        "offsets": [{"file_offset": RAW_OFF + (0x402200 - TEXT_VA), "size": 64, "sha256": h(0x402200, 0x402240)}],
        "follow_up_static_code_windows": [
            {"start": "0x401810", "end_exclusive": "0x401820", "sha256": h(0x401810, 0x401820)}
        ],
        "independent_review": "not yet performed",
    }


class Fixture:
    """A scratch repository; ``self.root`` is the repo root."""

    def __init__(self, receipts=True):
        self.tmp = Path(tempfile.mkdtemp(prefix="fl2-", dir=SCRATCH))
        self.root = self.tmp / "repo"
        self.out = self.root / "outputs" / "blackmoor-decomp"
        self.slices = self.root / "work" / "analysis" / "slices"
        for d in (self.out / "src", self.out / "tests", self.slices, self.root / "game"):
            d.mkdir(parents=True)
        (self.root / "game" / "GAME.EXE").write_bytes(make_pe())
        (self.root / "work" / "analysis" / "game-source.json").write_text(
            json.dumps({"bundle": "x", "game_dir": str(self.root / "game")}))
        index = {
            "original_sha256": "0" * 64,
            "pseudocode_functions": len(STARTS),
            "failures": [],
            "functions": [
                {"address": hex(a), "name": f"FUN_{a:08x}", "file": f"x/{a:x}.c.txt", "evidence_id": "ev_0"}
                for a in STARTS
            ],
        }
        (self.out / "function-index.json").write_text(json.dumps(index, indent=2))
        (self.out / "src" / "alpha.c").write_text(C_ALPHA)
        (self.out / "src" / "alpha.h").write_text(H_ALPHA)
        (self.out / "tests" / "test_alpha.py").write_text(PY_TEST)
        (self.out / "tests" / "alpha_original_oracle.py").write_text(oracle_source())
        if receipts:
            self.write_receipt("A-01.1.handoff.json", receipt_one("/Users/tester/Projects/nd-blackmoor-decomp/.claude/worktrees/wt"))
            self.write_receipt("A-02.1.validation.json", receipt_two())

    def write_receipt(self, name, doc):
        (self.slices / name).write_text(json.dumps(doc, indent=1, sort_keys=True))

    def config(self, **kw):
        base = dict(exe_sha256=None, text_end=TEXT_END)
        base.update(kw)
        return fe.Config.for_repo(self.root, **base)

    def derive(self, **kw):
        return fe.derive(self.config(**kw))

    def write(self, **kw):
        cfg = self.config(**kw)
        doc = fe.derive(cfg)
        text = fe.render(doc)
        cfg.output.write_text(text)
        return cfg, doc, text

    def cleanup(self):
        shutil.rmtree(self.tmp, ignore_errors=True)


def by_va(doc):
    return {f["va"]: f for f in doc["functions"]}


def pointers(doc, va, kind=None):
    entry = by_va(doc).get(va)
    if not entry:
        return []
    return [p for p in entry["evidence"] if kind is None or p["kind"] == kind]


class FixtureCase(unittest.TestCase):
    receipts = True

    def setUp(self):
        self.fx = Fixture(receipts=self.receipts)
        self.addCleanup(self.fx.cleanup)


class SelfCheckOfFixture(unittest.TestCase):
    def test_fixture_hashes_are_consistent(self):
        self.assertEqual(len(make_pe()), RAW_OFF + TEXT_SIZE + 0x200)
        self.assertEqual(span_bytes(0x401000, 0x401004), TEXT_BYTES[:4])


class AddressAndPathHelpers(unittest.TestCase):
    def test_parse_address_forms(self):
        self.assertEqual(fe.parse_address("0x40b34a"), 0x40B34A)
        self.assertEqual(fe.parse_address("0x004237f7"), 0x4237F7)
        self.assertEqual(fe.parse_address(4240202), 4240202)
        self.assertIsNone(fe.parse_address("40b34a"))
        self.assertIsNone(fe.parse_address(True))
        self.assertIsNone(fe.parse_address("hello"))
        self.assertIsNone(fe.parse_address(-1))

    def test_normalize_absolute_worktree_paths(self):
        cases = {
            "/Users/someone/Projects/nd-blackmoor-decomp/.claude/worktrees/codex-a1/work/analysis/slices/A-1.json":
                "work/analysis/slices/A-1.json",
            "/Users/someone/Projects/nd-blackmoor-decomp/outputs/blackmoor-decomp/src/x.c":
                "outputs/blackmoor-decomp/src/x.c",
            "/Users/someone/Projects/nd-blackmoor-decomp/.claude/worktrees/w/outputs/blackmoor-decomp/../../work/analysis/slices/y.json":
                "work/analysis/slices/y.json",
            "outputs/blackmoor-decomp/../../work/analysis/z.json": "work/analysis/z.json",
            "work/analysis/slices/q.json": "work/analysis/slices/q.json",
        }
        for raw, want in cases.items():
            self.assertEqual(fe.normalize_path(raw), want, raw)

    def test_normalize_rejects_foreign_absolute_paths(self):
        self.assertIsNone(fe.normalize_path("/tmp/elsewhere/file.json"))
        self.assertIsNone(fe.normalize_path("/Applications/Game.app/GAME.EXE"))

    def test_slice_id_from_filename(self):
        cases = {
            "A-0C.1.handoff.json": "A-0C.1",
            "A-37.2-handoff.json": "A-37.2",
            "A-44.1.parser-proposal-validation.json": "A-44.1",
            "I01-1-caption-transfer-handoff-20261013.json": "I01-1-caption-transfer",
            "A-64-validation.json": "A-64",
            "RT-9.oracle-handoff.json": "RT-9",
        }
        for name, want in cases.items():
            self.assertEqual(fe.slice_id(name), want, name)


class PeAndWindowSettlement(unittest.TestCase):
    def setUp(self):
        self.pe = fe.PE.from_bytes(make_pe())

    def test_read_va_maps_through_section_table(self):
        self.assertEqual(self.pe.read_va(0x401010, 8), span_bytes(0x401010, 0x401018))
        self.assertEqual(self.pe.read_va(0x402FF8, 8), span_bytes(0x402FF8, 0x403000))

    def test_read_va_outside_file_backing_is_none(self):
        self.assertIsNone(self.pe.read_va(0x402FFC, 8))      # runs off the section
        self.assertIsNone(self.pe.read_va(0x500000, 4))
        self.assertIsNone(self.pe.read_va(0x400FF0, 8))      # crosses into the headers

    def test_file_offset_to_va(self):
        self.assertEqual(self.pe.file_offset_to_va(RAW_OFF + 0x10), 0x401010)
        self.assertIsNone(self.pe.file_offset_to_va(0x10))

    def test_each_documented_reading_is_found_by_hash(self):
        a, b = 0x401100, 0x401200
        cases = [
            ((a, b), h(a, b), "end_exclusive"),
            ((a, b - a), h(a, b), "size"),
            ((a, b - 1), h(a, b), "end_inclusive"),
        ]
        for (x, y), digest, reading in cases:
            got = fe.settle_window(self.pe, x, y, digest)
            self.assertEqual(got, (reading, a, b), reading)

    def test_hash_mismatch_is_loud(self):
        with self.assertRaises(fe.WindowMismatch):
            fe.settle_window(self.pe, 0x401100, 0x401200, "0" * 64)

    def test_two_matching_readings_are_ambiguous(self):
        with self.assertRaises(fe.WindowAmbiguous):
            fe.pick_reading({"end_exclusive": "a" * 64, "size": "a" * 64, "end_inclusive": "b" * 64}, "a" * 64)
        self.assertEqual(
            fe.pick_reading({"end_exclusive": "a" * 64, "size": "c" * 64}, "a" * 64), "end_exclusive")
        with self.assertRaises(fe.WindowMismatch):
            fe.pick_reading({"end_exclusive": "a" * 64}, "b" * 64)

    def test_size_reading_rejected_when_it_would_leave_the_image(self):
        got = fe.settle_window(self.pe, 0x401100, 0x401200, h(0x401100, 0x401200))
        self.assertEqual(got[0], "end_exclusive")

    def test_window_outside_file_backing_cannot_be_hashed(self):
        with self.assertRaises(fe.WindowMismatch):
            fe.settle_window(self.pe, 0x402FF0, 0x403100, "1" * 64)


class MalformedInputs(unittest.TestCase):
    """Bounded malformed inputs: only EvidenceError may escape, never a crash."""

    def test_truncated_and_corrupted_pe_images(self):
        good = make_pe()
        cases = [good[:n] for n in (0, 1, 0x3C, 0x40, 0x80, 0x84, 0x98, 0xA0, 0x100, 0x17C, 0x1A0, 0x1C7, 0x300)]
        for off in (0x3C, 0x80, 0x84, 0x86, 0x94, 0xB4, 0x178, 0x17C):
            for val in (0, 0xFF, 0x7F):
                bad = bytearray(good)
                bad[off] = val
                cases.append(bytes(bad))
        for data in cases:
            try:
                pe = fe.PE.from_bytes(data)
                pe.read_va(0x401000, 16)
                pe.file_offset_to_va(0x500)
            except fe.EvidenceError:
                pass

    def test_unbalanced_and_unterminated_c(self):
        samples = ["}}}{{", "/* never closed 0x401200", '"string never closed 0x401200', "'a",
                   "#define X \\\n 0x401200", "int f( {", "int f(void) { /* 0x401200 */", ";;;;", "", "{", "}",
                   "@implementation\n- (", C_ALPHA[:37], C_ALPHA[20:], H_ALPHA[:-3]]
        for text in samples:
            for name in ("x.c", "x.mm"):
                fe.scan_c_source(text, name)

    def test_every_prefix_of_a_c_source_scans(self):
        for n in range(0, len(C_ALPHA), 7):
            fe.scan_c_source(C_ALPHA[:n], "x.c")

    def test_python_that_does_not_parse_is_an_evidence_error(self):
        for text in ("def (:\n", "x = (\n", "class:\n", "'''unterminated\n"):
            with self.assertRaises(fe.EvidenceError):
                fe.scan_python_source(text, "bad.py")
            with self.assertRaises(fe.EvidenceError):
                fe.oracle_windows(text, "bad.py")

    def test_hostile_receipt_structures(self):
        doc = {"a": [[], {}, None, 5, "x", [1, 2], ["0x401000", "0x401100", "z" * 64]], "files": [5, None, {"k": 1}],
               "hook_inventory": [None, 3, {"address": None}], "unverified": [None, [], {"x": None}],
               "independent_review": 7}
        fe.receipt_windows(doc, "r")
        fe.receipt_hooks(doc)
        fe.receipt_files(doc)
        fe.receipt_items(doc, fe.UNVERIFIED_KEY)
        self.assertEqual(fe.receipt_review(doc)["state"], "none")

    def test_receipt_that_is_a_list_is_rejected_loudly(self):
        fx = Fixture(receipts=False)
        self.addCleanup(fx.cleanup)
        (fx.slices / "Z-1.handoff.json").write_text("[1, 2, 3]")
        with self.assertRaises(fe.EvidenceError):
            fx.derive()


class FunctionMapping(unittest.TestCase):
    def setUp(self):
        self.fm = fe.FunctionMap(STARTS, text_start=TEXT_VA, text_end=TEXT_END)

    def test_exact_interior_unresolved(self):
        self.assertEqual(self.fm.classify(0x401100), ("exact", 0x401100))
        self.assertEqual(self.fm.classify(0x401101), ("interior", 0x401100))
        self.assertEqual(self.fm.classify(0x4013FF), ("interior", 0x401200))
        self.assertEqual(self.fm.classify(0x402FFF), ("interior", 0x402800))
        self.assertEqual(self.fm.classify(TEXT_END), ("unresolved", "at_or_above_text_end"))
        self.assertEqual(self.fm.classify(TEXT_END + 5)[0], "unresolved")
        self.assertEqual(self.fm.classify(0x400FFF), ("unresolved", "below_text_start"))

    def test_span_runs_to_next_start_and_last_to_text_end(self):
        self.assertEqual(self.fm.span(0x401200), 0x200)
        self.assertEqual(self.fm.span(0x402800), TEXT_END - 0x402800)

    def test_starts_in_window(self):
        self.assertEqual(self.fm.starts_in(0x401100, 0x401400), [0x401100, 0x401200])
        self.assertEqual(self.fm.starts_in(0x401101, 0x401400), [0x401200])


class CSourceScanning(unittest.TestCase):
    def cites(self, text, name="x.c"):
        return fe.scan_c_source(text, name)

    def test_symbol_resolution(self):
        got = {(c.va, c.symbol) for c in self.cites(C_ALPHA)}
        self.assertIn((0x401000, None), got)                 # file-level comment
        self.assertIn((0x401150, None), got)
        self.assertIn((0x401100, "alpha_one"), got)          # leading comment, FUN_ form
        self.assertIn((0x401204, "alpha_one"), got)          # inside the body
        self.assertIn((0x402800, "alpha_one"), got)
        self.assertIn((0x403100, "alpha_one"), got)
        self.assertIn((0x401800, "alpha_two"), got)          # u suffix, one-line function

    def test_strings_are_not_citations(self):
        self.assertNotIn(0x401400, {c.va for c in self.cites(C_ALPHA)})

    def test_prototype_comment_names_the_prototype(self):
        got = {(c.va, c.symbol) for c in self.cites(H_ALPHA, "x.h")}
        self.assertEqual(got, {(0x401200, "alpha_three")})

    def test_forms(self):
        src = "/* FUN_0040b34a, FUN0040b3ff and 0x004237f7 and 0x40B34A */\nint f(void){return 1;}\n"
        vas = sorted(c.va for c in self.cites(src))
        self.assertEqual(vas, sorted([0x40B34A, 0x40B3FF, 0x4237F7]))

    def test_non_addresses_are_ignored(self):
        src = "int f(void){ return 0x12345 + 0x1000000 + 0x300 + 0xdeadbeef; }\n"
        self.assertEqual([c.va for c in self.cites(src)], [])

    def test_attribute_header(self):
        src = ("/* about FUN_0051cfd1 */\n"
               "unsigned int __attribute__((thiscall)) FUN_0051cfd1(const void *self) {\n"
               "  return 0x51cfd1;\n}\n")
        got = {(c.va, c.symbol) for c in self.cites(src)}
        self.assertEqual(got, {(0x51CFD1, "FUN_0051cfd1")})

    def test_struct_and_table_bodies_have_no_symbol(self):
        src = "struct s {\n  int a; /* 0x401200 */\n};\nstatic const int t[] = { 0x401400 };\n"
        got = {(c.va, c.symbol) for c in self.cites(src)}
        self.assertEqual(got, {(0x401200, None), (0x401400, None)})

    def test_preprocessor_lines_do_not_break_scanning(self):
        src = "#define BEGIN {\n#define VA 0x401200\nint f(void) {\n  return 0x401400;\n}\n"
        got = {(c.va, c.symbol) for c in self.cites(src)}
        self.assertEqual(got, {(0x401200, None), (0x401400, "f")})

    def test_extern_c_wrapper_is_transparent(self):
        src = ('#ifndef X_H\n#define X_H\n#ifdef __cplusplus\nextern "C" {\n#endif\n\n'
               '/* first 0x401200\n * second 0x401400 */\nint proto_a(int a,\n             int b);\n\n'
               '#ifdef __cplusplus\n}\n#endif\n#endif\n')
        got = {(c.va, c.symbol) for c in self.cites(src, "x.h")}
        self.assertEqual(got, {(0x401200, "proto_a"), (0x401400, "proto_a")})

    def test_objc_method_symbol(self):
        src = "@implementation Foo\n- (void)tick:(int)n {\n  call(0x401800);\n}\n@end\n"
        got = {(c.va, c.symbol) for c in self.cites(src, "x.mm")}
        self.assertEqual(got, {(0x401800, "tick")})


class PythonScanning(unittest.TestCase):
    def test_test_ids_and_hex_only(self):
        got = {(c.va, c.symbol) for c in fe.scan_python_source(PY_TEST)}
        self.assertIn((0x401400, "AlphaTests.test_exact"), got)
        self.assertIn((0x401810, "AlphaTests.test_interior"), got)
        self.assertIn((0x403200, "helper"), got)

    def test_decimal_numbers_are_not_citations(self):
        self.assertEqual(fe.scan_python_source("X = 4240202\nY = 401200\n"), [])

    def test_docstring_and_comment_hex_counts(self):
        src = '"""See 0x401200."""\n# also 0x401400\n'
        self.assertEqual(sorted(c.va for c in fe.scan_python_source(src)), [0x401200, 0x401400])

    def test_oracle_windows_from_ast(self):
        wins = fe.oracle_windows(oracle_source(), "alpha_original_oracle.py")
        keyed = {(w.a, w.b, w.sha) for w in wins}
        self.assertIn((0x401000, 0x401100, h(0x401000, 0x401100)), keyed)
        self.assertIn((0x401200, 0x200, h(0x401200, 0x401400)), keyed)
        self.assertIn((0x401800, 0x401900, None), keyed)
        self.assertIn((0x401000, 0x401100, None), keyed)       # the docstring A..B form

    def test_oracle_windows_resolve_named_constants(self):
        src = "START = 0x401400\nEND = START + 0x100\nCODE_WINDOWS = {'a': (START, END)}\n"
        wins = fe.oracle_windows(src, "o.py")
        self.assertEqual({(w.a, w.b) for w in wins}, {(0x401400, 0x401500)})

    def test_non_window_pairs_are_ignored(self):
        src = "HOOKS = [(0x401200, 0x401400)]\nx = (0x401000, 0x401100)\n"
        self.assertEqual(fe.oracle_windows(src, "o.py"), [])

    def test_unparseable_python_is_an_error(self):
        with self.assertRaises(fe.EvidenceError):
            fe.oracle_windows("def (:\n", "bad.py")


class ReceiptWindowShapes(unittest.TestCase):
    def shapes(self, doc):
        return {(w.a, w.b, w.sha is not None, w.shape) for w in fe.receipt_windows(doc, "r.json")}

    def test_start_end_exclusive_dict(self):
        doc = {"code_windows": [{"start": "0x401000", "end_exclusive": "0x401100", "sha256": "a" * 64}]}
        self.assertEqual(self.shapes(doc), {(0x401000, 0x401100, True, "dict")})

    def test_start_size_dict_and_va_alias(self):
        doc = {"w": [{"va": "0x402800", "size": 256, "sha256": "a" * 64}]}
        self.assertEqual(self.shapes(doc), {(0x402800, 256, True, "dict")})

    def test_start_va_aliases(self):
        doc = {"w": [{"start_va": "0x00423d33", "end_va_exclusive": "0x00423da2", "byte_count": 111,
                      "sha256": "a" * 64}]}
        self.assertEqual({(w.a, w.b) for w in fe.receipt_windows(doc, "r")}, {(0x423D33, 0x423DA2)})

    def test_end_and_hash_key_aliases_seen_in_real_receipts(self):
        doc = {"executed_function_hashes": [{"va": "0x43ed71", "indexed_end_exclusive": "0x43edac", "sha256": "a" * 64}],
               "methods": [{"name": "move", "va": "0x4daf9f", "size": 36, "original_window_sha256": "b" * 64}],
               "extents": [{"va": "0x004daf3f", "exclusive_end_va": "0x004daf6e", "length_bytes": 47,
                            "original_sha256": "c" * 64}]}
        got = {(w.a, w.b, w.sha[0]) for w in fe.receipt_windows(doc, "r")}
        self.assertEqual(got, {(0x43ED71, 0x43EDAC, "a"), (0x4DAF9F, 36, "b"), (0x4DAF3F, 0x4DAF6E, "c")})

    def test_start_only_key_form(self):
        doc = {"hashes": {"code_windows": {"open_0x414ceb": "a" * 64}}, "other": {"open_0x414ceb": "a" * 64}}
        got = fe.receipt_windows(doc, "r")
        self.assertEqual([(w.a, w.b, w.shape) for w in got], [(0x414CEB, 0, "start_sha")])

    def test_list_of_three(self):
        doc = {"x": {"code_windows": [[4240202, 4240646, "b" * 64]]}}
        self.assertEqual(self.shapes(doc), {(4240202, 4240646, True, "triple")})

    def test_range_dict(self):
        doc = {"code_windows": {"alloc": {"range": ["0x4150af", "0x415111"], "sha256": "c" * 64}}}
        self.assertEqual(self.shapes(doc), {(0x4150AF, 0x415111, True, "range")})

    def test_label_with_dotdot_key(self):
        doc = {"code_windows_original": {"0x43bfb6..0x43c09e (candidate accept block)": "d" * 64}}
        self.assertEqual(self.shapes(doc), {(0x43BFB6, 0x43C09E, True, "dotdot_key")})

    def test_code_start_end_siblings(self):
        doc = {"hashes": {"code_start": "0x424aa8", "code_end": "0x425b8b", "code_window": "e" * 64}}
        self.assertEqual(self.shapes(doc), {(0x424AA8, 0x425B8B, True, "code_start_end")})

    def test_file_offset_form(self):
        doc = {"w": [{"file_offset": 45995, "size": 19, "sha256": "f" * 64}]}
        got = fe.receipt_windows(doc, "r")
        self.assertEqual([(w.a, w.b, w.shape) for w in got], [(45995, 19, "file_offset")])

    def test_unhashed_pair_is_declared_only(self):
        doc = {"follow_up_children": [{"code_range": ["0x42b217", "0x42b2d6"]}]}
        got = fe.receipt_windows(doc, "r")
        self.assertEqual([(w.a, w.b, w.sha) for w in got], [(0x42B217, 0x42B2D6, None)])

    def test_static_context_detected_from_path_and_scope(self):
        doc = {"follow_up_static_code_windows": [{"start": "0x401000", "end_exclusive": "0x401100", "sha256": "a" * 64}],
               "inputs": {"code_windows": [{"start": "0x401100", "end_exclusive": "0x401200",
                                            "sha256": "a" * 64, "scope": "static navigation"}]},
               "oracle": {"code_windows": [{"start": "0x401200", "end_exclusive": "0x401400", "sha256": "a" * 64}]}}
        ctx = {w.a: w.context for w in fe.receipt_windows(doc, "r")}
        self.assertEqual(ctx, {0x401000: "static", 0x401100: "static", 0x401200: "oracle"})

    def test_non_window_lists_not_misread(self):
        doc = {"x": [1, 2, "a" * 64], "y": ["0x401000", "0x401100"], "z": {"start": "0x401000", "end": "0x401100"}}
        got = fe.receipt_windows(doc, "r")
        # the bare hex pair under "y" has no window key; the start/end dict is a declared-only range
        self.assertEqual([(w.a, w.b, w.sha) for w in got], [(0x401000, 0x401100, None)])


class ReceiptFields(unittest.TestCase):
    def test_review_states(self):
        cases = [
            ({"independent_review": {"status": "pending", "reviewer": None}}, "pending", False),
            ({"independent_review": "not yet performed"}, "none", False),
            ({}, "absent", False),
            ({"review": {"status": "pending", "owner": "root"}}, "pending", False),
            ({"independent_review": {"status": "P2 findings addressed; root re-review pending", "reviewer": None}},
             "findings_addressed", False),
            ({"independent_review": {"status": "no P1/P2/P3 findings", "reviewer": "someone"}},
             "reviewer_recorded", True),
        ]
        for doc, state, recorded in cases:
            got = fe.receipt_review(doc)
            self.assertEqual((got["state"], got["reviewer_recorded"]), (state, recorded), doc)

    def test_unverified_items_with_addresses(self):
        doc = {"unverified_branches": ["a at 0x401250", "none here", {"x": "FUN_00401410 too"}],
               "follow_up_children": [{"unverified": "signed guard at 0x401810"}]}
        items = fe.receipt_items(doc, fe.UNVERIFIED_KEY)
        self.assertEqual(len(items), 4)
        located = sorted(a for it in items for a in it.addresses)
        self.assertEqual(located, [0x401250, 0x401410, 0x401810])
        self.assertTrue(all(len(it.text_sha256) == 64 for it in items))

    def test_divergence_keys(self):
        doc = {"deliberate_safety_rejections": ["x 0x401410"], "deliberate_native_safety_rejections":
               [{"input": "y 0x401800"}], "intentional_divergences": [{"case": "c", "reason": "0x401200"}],
               "native_safety_rejections": 534, "safety_rejections": ["0x402000"]}
        got = sorted(a for it in fe.receipt_items(doc, fe.DIVERGENCE_KEY) for a in it.addresses)
        self.assertEqual(got, [0x401200, 0x401410, 0x401800, 0x402000])

    def test_hook_entries_and_classification(self):
        doc = {"hook_inventory": {"code:0x401200": "malloc only: returns a guarded object",
                                  "0x401400": "observer only: counters, no writes",
                                  "0x401800": "something unusual"},
               "hooks": [{"address": "0x402000", "kind": "replacement", "purpose": "stub"}],
               "oracle_hooks": ["0x402800 trampoline"]}
        got = {x.address: x.kind for x in fe.receipt_hooks(doc)}
        self.assertEqual(got, {0x401200: "replaced", 0x401400: "observed", 0x401800: "unclassified",
                               0x402000: "replaced", 0x402800: "replaced"})

    def test_files_are_normalized_and_foreign_absolute_paths_dropped(self):
        doc = {"files": ["/Users/a/Projects/nd-blackmoor-decomp/.claude/worktrees/w/outputs/blackmoor-decomp/src/x.c",
                         "outputs/blackmoor-decomp/tests/y.py", "/tmp/else.txt"]}
        self.assertEqual(fe.receipt_files(doc),
                         ["outputs/blackmoor-decomp/src/x.c", "outputs/blackmoor-decomp/tests/y.py"])


class DeriveFunctions(FixtureCase):
    def setUp(self):
        super().setUp()
        self.doc = self.fx.derive()

    def test_schema_and_pins(self):
        self.assertEqual(self.doc["schema"], "blackmoor-function-evidence/1")
        self.assertEqual(self.doc["function_index"]["functions"], len(STARTS))
        self.assertEqual(self.doc["text_range"], ["0x401000", "0x403000"])
        self.assertEqual(self.doc["original_sha256"], sha(make_pe()))
        fe.validate_document(self.doc)

    def test_native_source_exact_starts(self):
        def sym(va):
            return sorted((p["path"].rsplit("/", 1)[1], p["symbol"]) for p in pointers(self.doc, va, "native_source"))
        self.assertEqual(sym("0x401000"), [("alpha.c", None)])
        self.assertEqual(sym("0x401100"), [("alpha.c", "alpha_one")])
        self.assertEqual(sym("0x402800"), [("alpha.c", "alpha_one")])
        self.assertEqual(sym("0x401800"), [("alpha.c", "alpha_two")])
        self.assertEqual(sym("0x401200"), [("alpha.h", "alpha_three")])
        self.assertEqual(sym("0x401400"), [])           # only inside a string literal
        for p in pointers(self.doc, "0x401100", "native_source"):
            self.assertEqual(p["sha256"], sha((self.fx.out / "src" / "alpha.c").read_bytes()))
            self.assertTrue(p["path"].startswith("outputs/blackmoor-decomp/src/"))

    def test_interior_addresses_become_mentions_on_the_container(self):
        got = {(p["path"].rsplit("/", 1)[1], p["symbol"], tuple(p["addresses"]))
               for va in ("0x401100", "0x401200", "0x401800") for p in pointers(self.doc, va, "mention")}
        self.assertIn(("alpha.c", None, ("0x401150",)), got)          # in F1 (0x401100)
        self.assertIn(("alpha.c", "alpha_one", ("0x401204",)), got)   # in F2 (0x401200)
        self.assertIn(("test_alpha.py", "AlphaTests.test_interior", ("0x401810",)), got)  # in F4 (0x401800)
        # an interior address is never itself a function entry
        self.assertNotIn("0x401150", by_va(self.doc))
        self.assertNotIn("0x401204", by_va(self.doc))
        for va in by_va(self.doc):
            for p in pointers(self.doc, va, "mention"):
                self.assertIn(p["via"], {"citation", "window_start", "blocker", "divergence", "hook"})

    def test_test_pointers(self):
        got = [(p["test_id"], p["path"].rsplit("/", 1)[1]) for p in pointers(self.doc, "0x401400", "test")]
        self.assertEqual(got, [("AlphaTests.test_exact", "test_alpha.py")])

    def test_addresses_above_text_end_are_unresolved_not_attached(self):
        un = {u["address"]: u for u in self.doc["unresolved"]}
        self.assertIn("0x403100", un)
        self.assertIn("0x403200", un)
        self.assertEqual(un["0x403100"]["reason"], "at_or_above_text_end")
        for va in ("0x403100", "0x403200"):
            self.assertNotIn(va, by_va(self.doc))
        self.assertEqual(self.doc["counts"]["unresolved"]["addresses"], len(self.doc["unresolved"]))

    def test_windows_entry_use_and_hash_settlement(self):
        f0 = pointers(self.doc, "0x401000", "oracle")
        w = [p for p in f0 if p["window"] == ["0x401000", "0x401100"]]
        self.assertEqual(len(w), 1)
        self.assertEqual(w[0]["use"], "entry")
        self.assertEqual(w[0]["window_sha256"], h(0x401000, 0x401100))
        self.assertEqual(w[0]["verified"], "recorded_hash")
        self.assertEqual(w[0]["reading"], "end_exclusive")
        # oracle source and the receipt both declare it; the oracle script becomes the pointer path
        self.assertTrue(w[0]["path"].endswith("alpha_original_oracle.py"))
        self.assertEqual(w[0]["sha256"], sha((self.fx.out / "tests" / "alpha_original_oracle.py").read_bytes()))
        self.assertIn("analysis/slices/A-01.1.handoff.json", w[0]["declared_in"])
        self.assertIn("outputs/blackmoor-decomp/tests/alpha_original_oracle.py", w[0]["declared_in"])
        self.assertEqual(w[0]["tail_gap"], 0)

    def test_receipt_only_window_has_null_path(self):
        w = [p for p in pointers(self.doc, "0x401100", "oracle") if p["window"] == ["0x401100", "0x401200"]]
        self.assertEqual(len(w), 1)
        self.assertIsNone(w[0]["path"])
        self.assertIsNone(w[0]["sha256"])
        self.assertEqual(w[0]["use"], "entry")
        self.assertEqual(w[0]["reading"], "end_exclusive")

    def test_hooked_function_in_window_is_mapped_not_entry(self):
        w = [p for p in pointers(self.doc, "0x401200", "oracle") if p["window"] == ["0x401200", "0x401400"]]
        self.assertEqual(len(w), 1)
        self.assertEqual(w[0]["use"], "mapped")
        self.assertEqual(w[0]["use_basis"], "replaced_by_hook")
        self.assertEqual(w[0]["reading"], "size")
        rec = pointers(self.doc, "0x401200", "receipt")
        self.assertEqual([r["hook"] for r in rec], ["replaced"])

    def test_window_starting_inside_a_function_is_a_mention_there(self):
        # 0x401810..0x401820 (static follow-up) starts inside F4 (0x401800)
        w = [p for p in pointers(self.doc, "0x401800", "oracle") if p["window"] == ["0x401810", "0x401820"]]
        self.assertEqual(w, [])
        m = [p for p in pointers(self.doc, "0x401800", "mention") if p["via"] == "window_start"]
        self.assertTrue(any("0x401810" in p["addresses"] for p in m))

    def test_declared_only_window_joins_the_hashed_twin(self):
        w = [p for p in pointers(self.doc, "0x401800", "oracle") if p["window"] == ["0x401800", "0x401900"]]
        self.assertEqual(len(w), 1)
        self.assertEqual(w[0]["verified"], "recorded_hash")
        self.assertEqual(w[0]["window_sha256"], h(0x401800, 0x401900))
        self.assertIn("outputs/blackmoor-decomp/tests/alpha_original_oracle.py", w[0]["declared_in"])

    def test_every_receipt_shape_in_second_receipt_verified(self):
        wins = {(p["window"][0], p["window"][1]) for va in by_va(self.doc) for p in pointers(self.doc, va, "oracle")}
        for pair in [("0x401400", "0x401800"), ("0x402000", "0x402100"), ("0x402800", "0x402900")]:
            self.assertIn(pair, wins, pair)
        # (0x402100, 0x402200) and (0x402200, 0x402240) start inside F5 (0x402000): mentions
        starts = {a for p in pointers(self.doc, "0x402000", "mention") if p["via"] == "window_start"
                  for a in p["addresses"]}
        self.assertEqual(starts, {"0x402100", "0x402200"})
        self.assertEqual(self.doc["counts"]["windows"]["by_shape"].get("file_offset"), 1)

    def test_window_covers_every_function_start_inside_it(self):
        wins = {tuple(p["window"]) for va in ("0x401200", "0x401400") for p in pointers(self.doc, va, "oracle")}
        self.assertIn(("0x401200", "0x401400"), wins)
        self.assertIn(("0x401400", "0x401800"), wins)

    def test_blockers_and_divergences_attach_by_address(self):
        b = by_va(self.doc)["0x401200"]["blockers"]
        self.assertEqual(len(b), 1)
        self.assertEqual(b[0]["address"], "0x401250")
        self.assertTrue(b[0]["interior"])
        self.assertEqual(b[0]["slice"], "A-01.1")
        self.assertEqual(b[0]["path"], "analysis/slices/A-01.1.handoff.json")
        self.assertEqual(len(b[0]["text_sha256"]), 64)
        d = by_va(self.doc)["0x401400"]["divergences"]
        self.assertEqual([x["address"] for x in d], ["0x401410"])
        receipts = {r["slice"]: r for r in self.doc["receipts"]}
        self.assertEqual(receipts["A-01.1"]["unverified"], {"items": 2, "located": 1})
        self.assertEqual(receipts["A-01.1"]["divergence_items"], 1)

    def test_receipt_pointer_carries_pin_and_review(self):
        rec = pointers(self.doc, "0x401000", "receipt")
        self.assertEqual(len(rec), 1)
        self.assertEqual(rec[0]["slice"], "A-01.1")
        self.assertEqual(rec[0]["review"]["state"], "pending")
        want = sha((self.fx.slices / "A-01.1.handoff.json").read_bytes())
        self.assertEqual(rec[0]["sha256"], want)
        self.assertEqual(rec[0]["path"], "analysis/slices/A-01.1.handoff.json")

    def test_absolute_paths_are_normalized_everywhere(self):
        text = fe.render(self.doc)
        self.assertNotIn(str(self.fx.root), text)
        self.assertNotIn("/Users/", text)
        self.assertNotIn("tester", text)
        r = {r["slice"]: r for r in self.doc["receipts"]}["A-01.1"]
        self.assertIn("outputs/blackmoor-decomp/tests/alpha_original_oracle.py", r["files"])

    def test_counts_are_consistent(self):
        c = self.doc["counts"]
        self.assertEqual(c["windows"]["mismatch"], 0)
        self.assertGreaterEqual(c["windows"]["verified"], 9)
        self.assertEqual(c["functions_with_evidence"], len(self.doc["functions"]))
        kinds = {k: sum(len(pointers(self.doc, f["va"], k)) for f in self.doc["functions"])
                 for k in ("native_source", "oracle", "test", "receipt", "mention")}
        self.assertEqual(c["pointers"], kinds)
        self.assertEqual(c["receipts"]["total"], 2)

    def test_output_is_sorted_and_canonical(self):
        vas = [f["va"] for f in self.doc["functions"]]
        self.assertEqual(vas, sorted(vas, key=lambda s: int(s, 16)))
        text = fe.render(self.doc)
        self.assertEqual(text, fe.render(json.loads(text)))
        self.assertTrue(text.endswith("\n"))


class Determinism(FixtureCase):
    def test_two_runs_are_byte_identical(self):
        self.assertEqual(fe.render(self.fx.derive()), fe.render(self.fx.derive()))

    def test_directory_order_does_not_matter(self):
        a = fe.render(self.fx.derive())
        for name in ("A-02.1.validation.json", "A-01.1.handoff.json"):
            p = self.fx.slices / name
            data = p.read_bytes()
            p.unlink()
            p.write_bytes(data)
        self.assertEqual(a, fe.render(self.fx.derive()))

    def test_independent_scratch_repos_agree(self):
        other = Fixture()
        self.addCleanup(other.cleanup)
        self.assertEqual(fe.render(self.fx.derive()), fe.render(other.derive()))


class FailureModes(FixtureCase):
    def test_hash_mismatch_fails_loudly_and_lists_every_window(self):
        doc = receipt_two()
        doc["oracle"]["code_windows"][0][2] = "0" * 64
        doc["original"]["code_windows"][0]["sha256"] = "1" * 64
        self.fx.write_receipt("A-02.1.validation.json", doc)
        with self.assertRaises(fe.EvidenceError) as cm:
            self.fx.derive()
        text = str(cm.exception)
        self.assertIn("A-02.1.validation.json", text)
        self.assertIn("0x401400", text)
        self.assertIn("0x402800", text)
        self.assertEqual(len(cm.exception.problems), 2)

    def test_mismatching_oracle_source_hash_is_listed_with_its_file(self):
        bad = oracle_source().replace(h(0x401000, 0x401100), "9" * 64)
        (self.fx.out / "tests" / "alpha_original_oracle.py").write_text(bad)
        with self.assertRaises(fe.EvidenceError) as cm:
            self.fx.derive()
        self.assertIn("alpha_original_oracle.py", str(cm.exception))

    def test_cli_exits_nonzero_and_prints_mismatch(self):
        doc = receipt_two()
        doc["oracle"]["code_windows"][0][2] = "0" * 64
        self.fx.write_receipt("A-02.1.validation.json", doc)
        err = io.StringIO()
        with contextlib.redirect_stderr(err), contextlib.redirect_stdout(io.StringIO()):
            rc = fe.main(["--repo", str(self.fx.root), "--text-end", hex(TEXT_END), "--no-exe-pin"])
        self.assertNotEqual(rc, 0)
        self.assertIn("mismatch", err.getvalue().lower())

    def test_wrong_original_hash_is_refused(self):
        with self.assertRaises(fe.EvidenceError):
            fe.derive(self.fx.config(exe_sha256="0" * 64))

    def test_missing_original_is_refused(self):
        (self.fx.root / "game" / "GAME.EXE").unlink()
        with self.assertRaises(fe.EvidenceError):
            self.fx.derive()

    def test_malformed_receipt_is_an_error_not_a_skip(self):
        (self.fx.slices / "A-09.1.handoff.json").write_text("{not json")
        with self.assertRaises(fe.EvidenceError):
            self.fx.derive()

    def test_index_with_duplicate_start_is_refused(self):
        p = self.fx.out / "function-index.json"
        d = json.loads(p.read_text())
        d["functions"].append(copy.deepcopy(d["functions"][0]))
        p.write_text(json.dumps(d))
        with self.assertRaises(fe.EvidenceError):
            self.fx.derive()


class ShapeAmbiguityInReceipts(FixtureCase):
    receipts = False

    def test_end_key_that_only_hashes_as_inclusive_is_accepted_and_flagged(self):
        self.fx.write_receipt("B-01.1.handoff.json", {
            "code_windows": [{"start": "0x401100", "end": "0x4011ff", "sha256": h(0x401100, 0x401200)}]})
        doc = self.fx.derive()
        w = pointers(doc, "0x401100", "oracle")[0]
        self.assertEqual(w["reading"], "end_inclusive")
        self.assertEqual(w["window"], ["0x401100", "0x401200"])
        self.assertEqual(doc["counts"]["windows"]["label_disagrees"], 1)

    def test_start_size_wins_when_size_is_what_hashes(self):
        self.fx.write_receipt("B-01.1.handoff.json", {
            "code_windows": [{"start": "0x401100", "end": 256, "sha256": h(0x401100, 0x401200)}]})
        doc = self.fx.derive()
        self.assertEqual(pointers(doc, "0x401100", "oracle")[0]["reading"], "size")

    def test_window_starting_outside_text_goes_to_unresolved_without_hashing(self):
        self.fx.write_receipt("B-01.1.handoff.json", {
            "code_windows": [{"start": hex(DATA_VA), "end_exclusive": hex(DATA_VA + 16), "sha256": "7" * 64}]})
        doc = self.fx.derive()
        self.assertEqual(doc["counts"]["windows"]["mismatch"], 0)
        self.assertIn(hex(DATA_VA), {u["address"] for u in doc["unresolved"]})

    def test_same_window_declared_twice_is_one_pointer_with_both_declarers(self):
        for name in ("B-01.1.handoff.json", "B-02.1.handoff.json"):
            self.fx.write_receipt(name, {"code_windows": [
                {"start": "0x401400", "end_exclusive": "0x401800", "sha256": h(0x401400, 0x401800)}]})
        doc = self.fx.derive()
        w = pointers(doc, "0x401400", "oracle")
        self.assertEqual(len(w), 1)
        self.assertEqual(w[0]["declared_in"],
                         ["analysis/slices/B-01.1.handoff.json", "analysis/slices/B-02.1.handoff.json"])


class UseMerging(FixtureCase):
    receipts = False

    def test_same_use_with_different_bases_is_one_pointer_but_different_uses_stay_apart(self):
        win = {"start": "0x401400", "end_exclusive": "0x401800", "sha256": h(0x401400, 0x401800)}
        self.fx.write_receipt("B-01.1.handoff.json", {"code_windows": [win],
                                                      "hook_inventory": {"0x401400": "observer only: counter"}})
        self.fx.write_receipt("B-02.1.handoff.json", {"code_windows": [win]})
        self.fx.write_receipt("B-03.1.handoff.json", {"code_windows": [win],
                                                      "hook_inventory": {"0x401400": "returns a stub value"}})
        doc = self.fx.derive()
        ptrs = sorted((p["use"], p["use_basis"], tuple(p["declared_in"])) for p in pointers(doc, "0x401400", "oracle"))
        self.assertEqual(ptrs, [
            ("entry", "observed_hook", ("analysis/slices/B-01.1.handoff.json", "analysis/slices/B-02.1.handoff.json")),
            ("mapped", "replaced_by_hook", ("analysis/slices/B-03.1.handoff.json",)),
        ])


class WindowUseRules(FixtureCase):
    receipts = False

    def test_static_context_window_at_a_function_start_is_mapped(self):
        self.fx.write_receipt("B-01.1.handoff.json", {"follow_up_static_code_windows": [
            {"start": "0x401400", "end_exclusive": "0x401800", "sha256": h(0x401400, 0x401800)}]})
        doc = self.fx.derive()
        w = [p for p in pointers(doc, "0x401400", "oracle") if p["window"] == ["0x401400", "0x401800"]]
        self.assertEqual([(p["use"], p["use_basis"]) for p in w], [("mapped", "static_scope")])

    def test_window_without_recorded_hash_is_declared_only_and_never_entry(self):
        (self.fx.out / "tests" / "alpha_original_oracle.py").write_text(
            "CODE_WINDOWS = {'f': (0x402000, 0x402100)}\n")
        doc = self.fx.derive()
        w = pointers(doc, "0x402000", "oracle")
        self.assertEqual(len(w), 1)
        self.assertEqual((w[0]["verified"], w[0]["use"], w[0]["use_basis"]), ("declared_only", "mapped", "unhashed"))
        self.assertEqual(w[0]["window_sha256"], h(0x402000, 0x402100))
        self.assertEqual(doc["counts"]["windows"]["declared_only"], 1)
        self.assertEqual(doc["counts"]["windows"]["verified"], 0)

    def test_tail_gap_measures_span_beyond_the_window(self):
        self.fx.write_receipt("B-01.1.handoff.json", {"code_windows": [
            {"start": "0x401000", "end_exclusive": "0x401080", "sha256": h(0x401000, 0x401080)}]})
        doc = self.fx.derive()
        w = [p for p in pointers(doc, "0x401000", "oracle") if p["window"] == ["0x401000", "0x401080"]]
        self.assertEqual([p["tail_gap"] for p in w], [0x80])           # span of F0 is 0x100


class StartOnlyAndExcludedFiles(FixtureCase):
    receipts = False

    def test_start_only_window_resolves_through_a_hashed_twin(self):
        self.fx.write_receipt("B-01.1.handoff.json", {"hashes": {"code_windows": {"open_0x401100": h(0x401100, 0x401200)}}})
        self.fx.write_receipt("B-01.1.validation.json", {"code_windows": {"open_0x401100": {
            "range": ["0x401100", "0x401200"], "sha256": h(0x401100, 0x401200)}}})
        doc = self.fx.derive()
        w = [p for p in pointers(doc, "0x401100", "oracle") if p["window"] == ["0x401100", "0x401200"]]
        self.assertEqual(len(w), 1)
        self.assertEqual(sorted(w[0]["declared_in"]), ["analysis/slices/B-01.1.handoff.json",
                                                       "analysis/slices/B-01.1.validation.json"])
        self.assertEqual(doc["counts"]["windows"]["by_shape"]["start_sha"], 1)

    def test_start_only_window_without_twin_is_a_listed_failure(self):
        self.fx.write_receipt("B-01.1.handoff.json", {"hashes": {"code_windows": {"open_0x401100": h(0x401100, 0x401200)}}})
        with self.assertRaises(fe.EvidenceError) as cm:
            self.fx.derive()
        self.assertIn("B-01.1.handoff.json", str(cm.exception))

    def test_ledger_tooling_tests_are_not_scanned(self):
        (self.fx.out / "tests" / "test_function_ledger.py").write_text("X = 0x401400\n")
        (self.fx.out / "tests" / "test_extract_function_evidence.py").write_text("X = 0x401400\n")
        doc = self.fx.derive()
        only = [p["path"].rsplit("/", 1)[-1] for p in pointers(doc, "0x401400", "test")]
        self.assertEqual(only, ["test_alpha.py"])
        self.assertNotIn("test_function_ledger.py", {r["path"].rsplit("/", 1)[-1] for r in doc["sources"]})


class SourceMutations(FixtureCase):
    def test_changing_a_citation_changes_the_output(self):
        a = fe.render(self.fx.derive())
        p = self.fx.out / "src" / "alpha.c"
        p.write_text(p.read_text().replace("0x401800u", "0x401801u"))
        b = fe.render(self.fx.derive())
        self.assertNotEqual(a, b)
        self.assertEqual(pointers(json.loads(b), "0x401800", "native_source"), [])

    def test_deleting_a_source_file_removes_its_pointers(self):
        (self.fx.out / "src" / "alpha.h").unlink()
        doc = self.fx.derive()
        self.assertEqual(pointers(doc, "0x401200", "native_source"), [])


class CheckMode(FixtureCase):
    def setUp(self):
        super().setUp()
        self.cfg, self.doc, self.text = self.fx.write()

    def drop_receipts(self):
        for p in self.fx.slices.glob("*.json"):
            p.unlink()

    def test_fresh_output_checks_clean(self):
        self.assertEqual(fe.check(self.cfg), [])

    def test_edited_pointer_is_detected(self):
        d = json.loads(self.text)
        d["functions"][0]["evidence"][0]["sha256"] = "0" * 64
        self.cfg.output.write_text(fe.render(d))
        self.assertNotEqual(fe.check(self.cfg), [])

    def test_hand_edited_formatting_is_detected(self):
        self.cfg.output.write_text(self.text.replace('"schema"', ' "schema"', 1))
        self.assertNotEqual(fe.check(self.cfg), [])

    def test_changed_source_is_stale(self):
        p = self.fx.out / "src" / "alpha.c"
        p.write_text(p.read_text() + "\n/* new 0x401400 */\n")
        self.assertTrue(fe.check(self.cfg))

    def test_changed_receipt_is_stale(self):
        d = receipt_two()
        d["independent_review"] = "changed"
        self.fx.write_receipt("A-02.1.validation.json", d)
        problems = fe.check(self.cfg)
        self.assertTrue(any(x.startswith("receipt changed") and "A-02.1.validation.json" in x for x in problems), problems)

    def test_new_receipt_is_stale(self):
        self.fx.write_receipt("A-03.1.handoff.json", {"code_windows": []})
        problems = fe.check(self.cfg)
        self.assertTrue(any(x.startswith("receipt not pinned") and "A-03.1.handoff.json" in x for x in problems), problems)

    def test_ledger_packet_receipts_are_not_inputs(self):
        self.fx.write_receipt("FL-9.handoff.json", {"code_windows": [
            {"start": "0x401400", "end_exclusive": "0x401800", "sha256": "0" * 64}]})
        self.assertEqual(fe.check(self.cfg), [])
        self.assertEqual(self.fx.derive()["counts"]["receipts"]["total"], 2)

    def test_absent_receipts_are_tolerated_with_pinned_hashes_reported(self):
        self.drop_receipts()
        notes = []
        self.assertEqual(fe.check(self.cfg, notes=notes), [])
        self.assertTrue(any("not present" in n and "2 pinned" in n for n in notes), notes)

    def test_absent_receipts_still_detect_source_drift(self):
        self.drop_receipts()
        p = self.fx.out / "src" / "alpha.c"
        p.write_text(p.read_text() + "\n/* new 0x401400 */\n")
        self.assertTrue(fe.check(self.cfg))

    def test_absent_receipts_still_detect_tampered_public_pointer(self):
        self.drop_receipts()
        d = json.loads(self.text)
        for f in d["functions"]:
            for ptr in f["evidence"]:
                if ptr["kind"] == "native_source":
                    ptr["symbol"] = "forged"
        self.cfg.output.write_text(fe.render(d))
        self.assertTrue(fe.check(self.cfg))

    def test_absent_receipts_still_rehash_committed_windows(self):
        self.drop_receipts()
        d = json.loads(self.text)
        for f in d["functions"]:
            for ptr in f["evidence"]:
                if ptr["kind"] == "oracle":
                    ptr["window_sha256"] = "5" * 64
        self.cfg.output.write_text(fe.render(d))
        self.assertTrue(fe.check(self.cfg))

    def test_missing_output_file_is_a_problem(self):
        self.cfg.output.unlink()
        self.assertTrue(fe.check(self.cfg))

    def test_altered_original_is_detected(self):
        exe = self.fx.root / "game" / "GAME.EXE"
        data = bytearray(exe.read_bytes())
        data[RAW_OFF + 5] ^= 0xFF
        exe.write_bytes(bytes(data))
        self.assertTrue(fe.check(self.cfg))


class Validator(FixtureCase):
    def setUp(self):
        super().setUp()
        self.doc = self.fx.derive()

    def mutate(self, fn):
        d = copy.deepcopy(self.doc)
        fn(d)
        with self.assertRaises(fe.ValidationError):
            fe.validate_document(d)

    def test_unknown_top_level_key(self):
        self.mutate(lambda d: d.update(bytes="00"))

    def test_unknown_pointer_key(self):
        self.mutate(lambda d: d["functions"][0]["evidence"][0].update(raw="..."))

    def test_absolute_path_anywhere_is_rejected(self):
        self.mutate(lambda d: d["receipts"][0].update(path="/Users/x/work/analysis/slices/a.json"))

    def test_absolute_path_in_free_form_sections_is_rejected(self):
        self.mutate(lambda d: d["counts"].update(note="/Users/x/y"))
        self.mutate(lambda d: d["unresolved"][0].update(sources=["/etc/passwd"]) if d["unresolved"] else d["counts"].update(n="/x"))

    def test_bad_hex_and_hash_shapes(self):
        self.mutate(lambda d: d["functions"][0].update(va="401000"))
        self.mutate(lambda d: d["receipts"][0].update(sha256="xyz"))

    def test_unsorted_functions(self):
        self.mutate(lambda d: d["functions"].reverse())

    def test_unknown_use(self):
        def f(d):
            for fn in d["functions"]:
                for p in fn["evidence"]:
                    if p["kind"] == "oracle":
                        p["use"] = "maybe"
                        return
        self.mutate(f)

    def test_function_outside_text(self):
        self.mutate(lambda d: d["functions"].append(
            {"va": "0x500000", "evidence": [], "blockers": [], "divergences": []}))


class CliSummary(FixtureCase):
    def run_cli(self, *extra):
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            rc = fe.main(["--repo", str(self.fx.root), "--text-end", hex(TEXT_END), "--no-exe-pin", *extra])
        return rc, out.getvalue(), err.getvalue()

    def test_summary_line_and_write_then_check(self):
        rc, out, _ = self.run_cli("--write")
        self.assertEqual(rc, 0)
        self.assertRegex(out.strip().splitlines()[-1],
                         r"^functions_with_evidence=\d+ windows_verified=\d+ mismatch=0 mentions=\d+ unresolved=\d+$")
        self.assertTrue((self.fx.out / "function-evidence.json").exists())
        rc, out, _ = self.run_cli("--check")
        self.assertEqual(rc, 0, out)
        self.assertIn("check ok", out)

    def test_default_run_does_not_write(self):
        rc, _, _ = self.run_cli()
        self.assertEqual(rc, 0)
        self.assertFalse((self.fx.out / "function-evidence.json").exists())

    def test_check_failure_exits_nonzero(self):
        self.run_cli("--write")
        p = self.fx.out / "function-evidence.json"
        p.write_text(p.read_text().replace('"native_source"', '"mention"', 1))
        rc, _, _ = self.run_cli("--check")
        self.assertNotEqual(rc, 0)


REAL_OUTPUT = OUTPUTS / "function-evidence.json"


@unittest.skipUnless(REAL_OUTPUT.exists() and (REPO / "work" / "analysis" / "game-source.json").exists(),
                     "committed evidence or private inputs absent")
class CommittedEvidence(unittest.TestCase):
    """Read-only checks of the committed file; nothing here edits it."""

    @classmethod
    def setUpClass(cls):
        cls.cfg = fe.Config.for_repo(REPO)
        cls.doc = json.loads(REAL_OUTPUT.read_text())

    def test_valid_and_sanitized(self):
        fe.validate_document(self.doc)
        self.assertNotIn("/Users/", REAL_OUTPUT.read_text())
        self.assertEqual(self.doc["counts"]["windows"]["mismatch"], 0)
        self.assertEqual(self.doc["function_index"]["functions"], 4188)

    def test_public_parts_and_window_hashes_recheck_clean(self):
        """Receipts are live private files other workers keep adding, so this check runs with the
        receipt directory pointed at an empty folder: sources, native/test/mention pointers, the
        function index and every committed window hash are still re-derived."""
        empty = Path(tempfile.mkdtemp(prefix="fl2-empty-", dir=SCRATCH))
        self.addCleanup(shutil.rmtree, empty, True)
        cfg = fe.Config.for_repo(REPO, slices_dir=empty)
        notes = []
        self.assertEqual(fe.check(cfg, notes=notes), [])
        self.assertTrue(any("not present" in n for n in notes))

    def test_full_check_when_receipts_have_not_drifted(self):
        pins = {r["path"]: r["sha256"] for r in self.doc["receipts"]}
        present = {self.cfg.work_rel(p): sha(p.read_bytes()) for p in fe._receipt_files(self.cfg)}
        if present != pins:
            self.skipTest("private receipts changed since function-evidence.json was written; "
                          "rerun scripts/extract_function_evidence.py --write")
        self.assertEqual(fe.check(self.cfg, notes=[]), [])


if __name__ == "__main__":
    unittest.main()
