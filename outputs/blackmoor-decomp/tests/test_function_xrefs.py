"""Tests for the function ledger xrefs extractor, helpers and reviewer sampler (packet FL-3).

Everything runs on a synthetic PE built here (no proprietary bytes).  The final
class checks the committed ``function-xrefs.json`` against the real binary
figures when the owner's local ``GAME.EXE`` and the private Ghidra dump are
present and is skipped otherwise.
"""

import copy
import hashlib
import importlib.util
import json
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
PROJECT = Path(__file__).resolve().parents[1]


def _load(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


gen = _load("gen_hinted_asm")
xr = _load("extract_function_xrefs")
smp = _load("sample_function_ledger")

try:
    HAVE_OBJDUMP = subprocess.run(gen.find_objdump() + ["--version"], capture_output=True).returncode == 0
except OSError:
    HAVE_OBJDUMP = False
TOOLS = unittest.skipUnless(HAVE_OBJDUMP, "llvm-objdump unavailable")

# ---------------------------------------------------------------------------
# Synthetic image
# ---------------------------------------------------------------------------

BASE = 0x401000
TEXT_SIZE = 0x300
IMAGE_BASE = 0x400000
RDATA_VA = 0x402000
DATA_VA = 0x403000

# function offsets inside .text
A, B, C, D, E, H, G = 0x000, 0x040, 0x050, 0x060, 0x070, 0x0E8, 0x0F4
V1, V2 = 0x100, 0x120
L1, L2, L3, L4, L5 = 0x180, 0x1A0, 0x1C0, 0x1D0, 0x1F0
F1, K, FH = 0x200, 0x230, 0x250
THUNK = 0x1A8  # derived import thunk right after L2
STUB = 0x208  # derived exception handler stub right after F1
BOUNDARY_VORBIS, BOUNDARY_CRT = 0x100, 0x180
SEAM = 0x10

IAT0, IAT1 = 0x402000, 0x402004
IMPORT_DIR = 0x402100
VTABLE = 0x402200
FUNCINFO = 0x402240
UNWIND_MAP = 0x402280
TRY_MAP = 0x4022A0
HANDLERS = 0x4022C0


def va(off: int) -> int:
    return BASE + off


def rel(src_end_off: int, target_off: int) -> bytes:
    return struct.pack("<i", target_off - src_end_off)


def put(buf: bytearray, off: int, data: bytes) -> None:
    buf[off : off + len(data)] = data


def build_text() -> bytearray:
    text = bytearray(b"\xcc" * TEXT_SIZE)
    std = b"\x55\x8b\xec"
    # A: EH frame (push -1 / push offset stub), call B, call [IAT0], push offset C
    off = A
    put(text, off, std + b"\x6a\xff" + b"\x68" + struct.pack("<I", va(STUB)))
    off += 3 + 2 + 5
    put(text, off, b"\xe8" + rel(off + 5, B))
    off += 5
    put(text, off, b"\xff\x15" + struct.pack("<I", IAT0))
    off += 6
    put(text, off, b"\x68" + struct.pack("<I", va(C)) + b"\x5d\xc3")
    put(text, B, std + b"\x5d\xc3")
    put(text, C, std + b"\x5d\xe9" + rel(C + 3 + 1 + 5, D))  # pop ebp; jmp D (tail)
    put(text, D, std + b"\x5d\xc3")
    put(text, E, std + b"\xe8" + rel(E + 3 + 5, E) + b"\x5d\xc3")  # recursive: a call into its own span is no edge
    put(text, H, std + b"\x5d\xc3")
    put(text, G, std + b"\xe8" + rel(G + 3 + 5, B) + b"\x5d\xc3")  # seam game function calling B
    put(text, V1, b"\x33\xc0\xc3")  # vorbis seam, no neighbours
    put(text, V2, b"\x33\xc0\xc3")
    put(text, L1, std + b"\xe8" + rel(L1 + 3 + 5, L2) + b"\xe8" + rel(L1 + 3 + 10, V2) + b"\x5d\xc3")  # entry point, calls L2 and V2
    put(text, L2, std + b"\x5d\xc3")
    put(text, THUNK, b"\xff\x25" + struct.pack("<I", IAT1))  # derived import thunk, no padding
    put(text, L3, std + b"\x69\xc0" + struct.pack("<I", 0x343FD) + b"\x5d\xc3")  # dead library function; only half of the rand constants
    put(text, L4, std + b"\x69\xc0" + struct.pack("<I", 0x343FD) + b"\x05" + struct.pack("<I", 0x269EC3) + b"\x5d\xc3")
    put(text, L5, std + b"\xe8" + rel(L5 + 3 + 5, B) + b"\x5d\xc3")  # library calling game: contradiction
    # F1 unwind funclet (lea; jmp B), then the derived handler stub (mov eax, FuncInfo; jmp FH)
    put(text, F1, b"\x8d\x4d\xf0\xe9" + rel(F1 + 8, B))
    put(text, STUB, b"\xb8" + struct.pack("<I", FUNCINFO) + b"\xe9" + rel(STUB + 10, FH))
    put(text, K, b"\xb8" + struct.pack("<I", va(L1)) + b"\xc3")  # catch funclet returning a resume address
    put(text, FH, std + b"\x5d\xc3")
    return text


def build_rdata() -> bytearray:
    rd = bytearray(0x400)

    def at(va_: int, data: bytes) -> None:
        o = va_ - RDATA_VA
        rd[o : o + len(data)] = data

    int_va, name_va = 0x402130, 0x402150
    hint0, hint1, dll_va = name_va + 0x00, name_va + 0x10, name_va + 0x20
    at(IAT0, struct.pack("<III", hint0 - IMAGE_BASE, hint1 - IMAGE_BASE, 0))
    at(int_va, struct.pack("<III", hint0 - IMAGE_BASE, hint1 - IMAGE_BASE, 0))
    at(hint0, b"\0\0Foo\0")
    at(hint1, b"\0\0Bar\0")
    at(dll_va, b"KERNEL32.dll\0")
    at(IMPORT_DIR, struct.pack("<IIIII", int_va - IMAGE_BASE, 0, 0, dll_va - IMAGE_BASE, IAT0 - IMAGE_BASE) + b"\0" * 20)
    at(VTABLE, struct.pack("<II", va(D), 0))
    at(FUNCINFO, struct.pack("<IIIIIIIII", 0x19930520, 1, UNWIND_MAP, 1, TRY_MAP, 0, 0, 0, 0))
    at(UNWIND_MAP, struct.pack("<iI", -1, va(F1)))
    at(TRY_MAP, struct.pack("<iiiiI", 0, 0, 1, 1, HANDLERS))
    at(HANDLERS, struct.pack("<IIiI", 0, 0, 0, va(K)))
    return rd


def build_data() -> bytearray:
    d = bytearray(0x40)
    d[0:4] = struct.pack("<I", va(E))  # aligned pointer to E
    d[0x11:0x15] = struct.pack("<I", va(H))  # unaligned pointer to H
    return d


def build_pe(text: bytes, rdata: bytes, data: bytes, entry_off: int = L1) -> bytes:
    nsec = 3
    e_lfanew = 0x80
    opt_size = 224
    hdr = bytearray(0x200)
    hdr[0:2] = b"MZ"
    struct.pack_into("<I", hdr, 0x3C, e_lfanew)
    hdr[e_lfanew : e_lfanew + 4] = b"PE\0\0"
    struct.pack_into("<HHIIIHH", hdr, e_lfanew + 4, 0x14C, nsec, 0, 0, 0, opt_size, 0x102)
    opt = e_lfanew + 24
    struct.pack_into("<H", hdr, opt, 0x10B)
    struct.pack_into("<I", hdr, opt + 16, BASE + entry_off - IMAGE_BASE)  # AddressOfEntryPoint
    struct.pack_into("<I", hdr, opt + 28, IMAGE_BASE)
    struct.pack_into("<I", hdr, opt + 92, 16)
    struct.pack_into("<II", hdr, opt + 96 + 8 * 1, IMPORT_DIR - IMAGE_BASE, 40)
    struct.pack_into("<II", hdr, opt + 96 + 8 * 12, IAT0 - IMAGE_BASE, 12)
    sec = opt + opt_size
    raw = 0x200
    for i, (name, vaddr, blob) in enumerate(((b".text", BASE, text), (b".rdata", RDATA_VA, rdata), (b".data", DATA_VA, data))):
        struct.pack_into("<8sIIII", hdr, sec + 40 * i, name, len(blob), vaddr - IMAGE_BASE, len(blob), raw)
        raw += len(blob)
    return bytes(hdr) + bytes(text) + bytes(rdata) + bytes(data)


def function_starts() -> list[int]:
    return [va(o) for o in (A, B, C, D, E, H, G, V1, V2, L1, L2, L3, L4, L5, F1, K, FH)]


def build_index(starts: list[int], names: dict | None = None) -> dict:
    names = names or {}
    return {
        "original_sha256": "",  # filled by the fixture
        "pseudocode_functions": len(starts),
        "failures": [],
        "functions": [
            {"address": f"0x{s:x}", "name": names.get(s, f"FUN_{s:08x}"), "file": f"x/{s:x}.c.txt", "evidence_id": "ev_x"}
            for s in sorted(starts)
        ],
    }


def build_layout() -> dict:
    return {
        "schema": "blackmoor-image-layout/1",
        "code_regions": [
            {"id": "game", "label": "g", "start_va": va(0), "end_va": va(BOUNDARY_VORBIS)},
            {"id": "vorbis", "label": "v", "start_va": va(BOUNDARY_VORBIS), "end_va": va(BOUNDARY_CRT)},
            {"id": "crt_mfc", "label": "c", "start_va": va(BOUNDARY_CRT), "end_va": va(TEXT_SIZE)},
        ],
    }


def build_ghidra(starts: list[int], thunk: bool = True) -> str:
    rows = []
    for s in starts:
        rows.append({"addr": f"0x{s:x}", "name": f"FUN_{s:08x}", "size": 7, "source": "DEFAULT", "thunk": False, "external": False})
    if thunk:
        rows.append({"addr": f"0x{va(THUNK):x}", "name": "Bar", "size": 6, "source": "DEFAULT", "thunk": True, "external": False})
    rows.sort(key=lambda r: int(r["addr"], 16))
    return "\n".join(json.dumps(r) for r in rows) + "\n"


class Fixture:
    """Writes the synthetic inputs into a scratch directory and derives from them."""

    def __init__(self, directory: Path, names=None, text_mutator=None, rdata_mutator=None, ghidra_thunk=True):
        self.dir = directory
        text = build_text()
        rdata = build_rdata()
        if text_mutator:
            text_mutator(text)
        if rdata_mutator:
            rdata_mutator(rdata)
        pe = build_pe(bytes(text), bytes(rdata), bytes(build_data()))
        self.sha = hashlib.sha256(pe).hexdigest()
        self.original = directory / "GAME.EXE"
        self.original.write_bytes(pe)
        index = build_index(function_starts(), names)
        index["original_sha256"] = self.sha
        self.index = directory / "function-index.json"
        self.index.write_text(json.dumps(index), encoding="utf-8")
        self.layout = directory / "layout.json"
        self.layout.write_text(json.dumps(build_layout()), encoding="utf-8")
        self.ghidra = directory / "functions.jsonl"
        self.ghidra.write_text(build_ghidra(function_starts(), ghidra_thunk), encoding="utf-8")

    def derive(self) -> dict:
        return xr.derive(
            original=self.original,
            index=self.index,
            layout=self.layout,
            ghidra=self.ghidra,
            expected_sha256=self.sha,
            strict=False,
            seam_distance=SEAM,
            display_paths={
                self.original: "GAME.EXE",
                self.index: "outputs/blackmoor-decomp/function-index.json",
                self.layout: "outputs/blackmoor-decomp/decomp-progress/layout.json",
                self.ghidra: "work/analysis/m0/fable-census/functions.jsonl",
            },
        )

    def cli(self, *args: str, out: Path | None = None) -> subprocess.CompletedProcess:
        out = out or (self.dir / "function-xrefs.json")
        return subprocess.run(
            [
                sys.executable,
                str(SCRIPTS / "extract_function_xrefs.py"),
                *args,
                "--original", str(self.original),
                "--index", str(self.index),
                "--layout", str(self.layout),
                "--ghidra", str(self.ghidra),
                "--out", str(out),
                "--expected-sha256", self.sha,
                "--no-strict",
                "--seam-distance", str(SEAM),
            ],
            capture_output=True,
            text=True,
        )


def entry(doc: dict, off: int) -> dict:
    for item in doc["entries"]:
        if item["va"] == f"0x{va(off):08x}":
            return item
    raise KeyError(off)


class Base(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = tempfile.TemporaryDirectory()
        cls.fx = Fixture(Path(cls.tmp.name))
        cls.doc = cls.fx.derive()

    @classmethod
    def tearDownClass(cls) -> None:
        cls.tmp.cleanup()


def h(off: int) -> str:
    return f"0x{va(off):08x}"


@TOOLS
class EdgeTests(Base):
    def test_universe_is_exactly_the_index_sorted(self) -> None:
        self.assertEqual([e["va"] for e in self.doc["entries"]], [f"0x{s:08x}" for s in sorted(function_starts())])
        self.assertEqual(self.doc["counts"]["entries"], len(function_starts()))

    def test_direct_calls_and_tail_jumps(self) -> None:
        a = entry(self.doc, A)
        self.assertIn(h(B), a["callees"])
        self.assertNotIn(h(B), a["tail_callees"])
        c = entry(self.doc, C)
        self.assertIn(h(D), c["callees"])
        self.assertIn(h(D), c["tail_callees"])

    def test_callers_are_the_exact_inverse_of_callees(self) -> None:
        by_va = {e["va"]: e for e in self.doc["entries"]}
        for e in self.doc["entries"]:
            for t in e["callees"]:
                self.assertIn(e["va"], by_va[t]["callers"])
            for s in e["callers"]:
                self.assertIn(e["va"], by_va[s]["callees"])
        self.assertEqual(sorted(entry(self.doc, B)["callers"]), sorted([h(A), h(G), h(L5), h(F1)]))

    def test_edges_from_derived_parts_belong_to_the_containing_function(self) -> None:
        # the handler stub at STUB sits in F1's span and jumps to FH
        self.assertIn(h(FH), entry(self.doc, F1)["callees"])

    def test_self_and_internal_targets_are_not_edges(self) -> None:
        for e in self.doc["entries"]:
            self.assertNotIn(e["va"], e["callees"])
            self.assertNotIn(e["va"], e["callers"])

    def test_imports_by_name(self) -> None:
        self.assertEqual(entry(self.doc, A)["imports"], ["KERNEL32.dll!Foo"])
        # the thunk belongs to L2's span
        self.assertEqual(entry(self.doc, L2)["imports"], ["KERNEL32.dll!Bar"])
        self.assertEqual(entry(self.doc, B)["imports"], [])

    def test_import_call_is_not_an_unresolved_indirect_call(self) -> None:
        self.assertEqual(entry(self.doc, A)["indirect_calls"], 0)

    def test_body_size_comes_from_the_ghidra_dump(self) -> None:
        self.assertEqual(entry(self.doc, A)["body_size"], 7)
        self.assertEqual(entry(self.doc, A)["span"], B - A)


@TOOLS
class ThunkAndDerivedTests(Base):
    def test_import_thunk_is_listed_with_container_and_import(self) -> None:
        thunks = self.doc["thunks"]
        self.assertEqual(len(thunks), 1)
        t = thunks[0]
        self.assertEqual((t["va"], t["kind"], t["container"], t["import"]), (h(THUNK), "import", h(L2), "KERNEL32.dll!Bar"))
        self.assertEqual(t["size"], 6)
        self.assertTrue(t["ghidra_thunk"])
        self.assertEqual(entry(self.doc, L2)["contains_thunks"], [h(THUNK)])
        self.assertIn(h(THUNK), entry(self.doc, L2)["derived_parts"])

    def test_no_index_start_is_itself_a_thunk_here(self) -> None:
        self.assertFalse(any(e["thunk"] for e in self.doc["entries"]))

    def test_derived_parts_table(self) -> None:
        rows = {r["va"]: r for r in self.doc["derived_parts"]}
        self.assertEqual(set(rows), {h(THUNK), h(STUB)})
        self.assertEqual(rows[h(THUNK)]["kind"], "import_thunk")
        self.assertEqual(rows[h(STUB)]["kind"], "eh_handler_stub")
        self.assertEqual(rows[h(STUB)]["parent"], h(F1))

    def test_a_thunk_missing_from_ghidra_is_reported_not_hidden(self) -> None:
        with tempfile.TemporaryDirectory() as d:
            fx = Fixture(Path(d), ghidra_thunk=False)
            doc = fx.derive()
            self.assertFalse(doc["thunks"][0]["ghidra_thunk"])
            self.assertEqual(doc["counts"]["thunks_not_flagged_by_ghidra"], 1)


@TOOLS
class DataReferenceTests(Base):
    def test_vtable_entry_is_a_data_ref(self) -> None:
        d = entry(self.doc, D)
        self.assertEqual(d["data_refs"], 1)
        self.assertTrue(d["has_data_ref"])
        self.assertTrue(d["address_taken"])

    def test_aligned_and_unaligned_data_pointers(self) -> None:
        self.assertEqual(entry(self.doc, E)["data_refs"], 1)
        h_ = entry(self.doc, H)
        self.assertEqual(h_["data_refs"], 0)
        self.assertEqual(h_["data_refs_unaligned"], 1)
        self.assertTrue(h_["address_taken"])

    def test_code_address_immediate_is_address_taken(self) -> None:
        c = entry(self.doc, C)
        self.assertEqual(c["code_addr_refs"], 1)
        self.assertEqual(c["data_refs"], 0)
        self.assertFalse(c["has_data_ref"])
        self.assertTrue(c["address_taken"])

    def test_direct_branch_targets_are_not_address_refs(self) -> None:
        b = entry(self.doc, B)
        self.assertEqual((b["code_addr_refs"], b["data_refs"], b["data_refs_unaligned"]), (0, 0, 0))
        self.assertFalse(b["address_taken"])

    def test_unreferenced_function(self) -> None:
        l3 = entry(self.doc, L3)
        self.assertEqual((l3["callers"], l3["data_refs"], l3["code_addr_refs"]), ([], 0, 0))


@TOOLS
class ExceptionFuncletTests(Base):
    def test_unwind_funclet_found_through_funcinfo(self) -> None:
        f = entry(self.doc, F1)
        self.assertEqual((f["eh_kind"], f["eh_parent"], f["origin"]), ("unwind", h(A), "compiler_eh"))
        self.assertEqual(f["eh_parent_region"], "game")
        self.assertEqual(entry(self.doc, A)["eh_funclets"], [h(F1), h(K)])

    def test_catch_funclet_found_through_try_block_map(self) -> None:
        k = entry(self.doc, K)
        self.assertEqual((k["eh_kind"], k["eh_parent"], k["origin"]), ("catch", h(A), "compiler_eh"))

    def test_stub_table(self) -> None:
        self.assertEqual(self.doc["eh_stubs"], [{"va": h(STUB), "container": h(F1), "funcinfo": f"0x{FUNCINFO:08x}", "owners": [h(A)]}])
        self.assertEqual(self.doc["counts"]["eh_funclets"], {"unwind": 1, "catch": 1})

    def test_funclet_without_funcinfo_magic_is_not_classified(self) -> None:
        def bad(rd: bytearray) -> None:
            o = FUNCINFO - RDATA_VA
            rd[o : o + 4] = struct.pack("<I", 0x19930521)

        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), rdata_mutator=bad).derive()
            f = entry(doc, F1)
            self.assertIsNone(f["eh_kind"])
            self.assertNotEqual(f["origin"], "compiler_eh")
            self.assertEqual(doc["counts"]["eh_funclets"], {"unwind": 0, "catch": 0})

    def test_stub_with_no_referencing_function_has_no_parent(self) -> None:
        def drop_push(text: bytearray) -> None:
            put(text, A + 5, b"\x90" * 5)  # nop out `push offset stub`

        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), text_mutator=drop_push).derive()
            f = entry(doc, F1)
            self.assertIsNone(f["eh_parent"])
            self.assertIsNone(f["eh_kind"])
            self.assertNotEqual(f["origin"], "compiler_eh")


@TOOLS
class OriginTests(Base):
    def origin(self, off: int) -> str:
        return entry(self.doc, off)["origin"]

    def test_band_origins(self) -> None:
        self.assertEqual(self.origin(A), "game")
        self.assertEqual(self.origin(E), "game")
        self.assertEqual(self.origin(V2), "library")
        self.assertEqual(self.origin(L2), "library")
        self.assertEqual(self.origin(L3), "library")

    def test_seam_flag_and_corroborated_seam_function(self) -> None:
        self.assertTrue(entry(self.doc, G)["seam"])
        self.assertFalse(entry(self.doc, H)["seam"])
        self.assertEqual(self.origin(G), "game")
        self.assertEqual(entry(self.doc, G)["origin_basis"], "band_game_seam_corroborated")

    def test_uncorroborated_seam_function_is_unknown(self) -> None:
        v1 = entry(self.doc, V1)
        self.assertTrue(v1["seam"])
        self.assertEqual((v1["origin"], v1["origin_basis"]), ("unknown", "seam_uncorroborated"))

    def test_library_function_calling_game_is_contradictory(self) -> None:
        l5 = entry(self.doc, L5)
        self.assertEqual((l5["origin"], l5["origin_basis"]), ("unknown", "contradiction_library_calls_game"))

    def test_game_band_function_without_standard_frame_is_unknown(self) -> None:
        def no_frame(text: bytearray) -> None:
            put(text, H, b"\x33\xc0\xc3")

        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), text_mutator=no_frame).derive()
        h_ = entry(doc, H)
        self.assertEqual((h_["origin"], h_["origin_basis"]), ("unknown", "game_band_without_standard_frame"))

    def test_funclets_may_call_game_without_contradiction(self) -> None:
        self.assertEqual(self.origin(F1), "compiler_eh")

    def test_origin_ignores_names(self) -> None:
        names = {va(A): "Unwind@00401000", va(L3): "CMyGameClass::Update", va(B): "_rand", va(F1): "FUN_00401000"}
        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), names=names).derive()
        for item in self.doc["entries"]:
            other = next(e for e in doc["entries"] if e["va"] == item["va"])
            for key in ("origin", "origin_basis", "eh_kind", "eh_parent", "reach", "callees", "seam"):
                self.assertEqual(item[key], other[key], f"{key} at {item['va']}")

    def test_regions_come_from_the_layout_file(self) -> None:
        self.assertEqual(entry(self.doc, A)["region"], "game")
        self.assertEqual(entry(self.doc, V2)["region"], "vorbis")
        self.assertEqual(entry(self.doc, L1)["region"], "crt_mfc")

    def test_origin_counts_cover_every_entry_once(self) -> None:
        self.assertEqual(sum(self.doc["counts"]["origin"].values()), len(function_starts()))
        self.assertEqual(self.doc["counts"]["origin"]["compiler_eh"], 2)
        self.assertEqual(self.doc["counts"]["origin"]["unknown"], 2)


@TOOLS
class ReachabilityAndRuleTests(Base):
    def reach(self, off: int) -> str:
        return entry(self.doc, off)["reach"]

    def test_roots_and_reachability(self) -> None:
        self.assertEqual(self.reach(L1), "entry")
        self.assertEqual(self.reach(A), "game")
        self.assertEqual(self.reach(L2), "reachable")  # called from the entry function
        self.assertEqual(self.reach(FH), "reachable")  # stub in F1's span, F1 reachable through its parent
        self.assertEqual(self.reach(F1), "reachable")
        self.assertEqual(self.reach(L3), "unreached")
        self.assertEqual(self.reach(L4), "unreached")

    def test_address_taken_library_function_is_a_root(self) -> None:
        def poke(rd: bytearray) -> None:
            o = VTABLE - RDATA_VA + 4
            rd[o : o + 4] = struct.pack("<I", va(L3))

        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), rdata_mutator=poke).derive()
            self.assertEqual(entry(doc, L3)["reach"], "address_taken")

    def test_reaches_game_flag(self) -> None:
        self.assertTrue(entry(self.doc, L5)["reaches_game"])
        self.assertTrue(entry(self.doc, F1)["reaches_game"])
        self.assertFalse(entry(self.doc, L3)["reaches_game"])

    def test_fingerprints(self) -> None:
        self.assertEqual(entry(self.doc, L4)["fingerprints"], ["lcg_rand"])
        self.assertEqual(entry(self.doc, L3)["fingerprints"], [])

    def test_rule_candidates(self) -> None:
        spec = [{"id": "SS-RAND", "category": "rand", "selectors": [{"kind": "fingerprint", "value": "lcg_rand"}], "propagate": "callers"}]
        cands = xr.rule_candidates(self.doc, spec)
        self.assertEqual(cands["R-EH"], [h(F1)])  # catch funclets are never rule-covered
        self.assertEqual(cands["R-LIB-INTERNAL"], [h(L3)])  # L4 is semantics-sensitive, L5 is unknown origin

    def test_rule_candidates_respect_parent_region_filter(self) -> None:
        cands = xr.rule_candidates(self.doc, [], eh_parent_regions=["crt_mfc"])
        self.assertEqual(cands["R-EH"], [])

    def test_r_eh_refuses_library_parent_funclet_that_reaches_game(self) -> None:
        funclet = copy.deepcopy(entry(self.doc, F1))
        self.assertTrue(xr.rule_r_eh(funclet, {})[0])
        funclet["eh_parent_region"] = "crt_mfc"
        funclet["reaches_game"] = True
        ok, why = xr.rule_r_eh(funclet, {})
        self.assertFalse(ok)
        self.assertIn("game", why)
        funclet["eh_parent_region"] = "game"  # a game parent legitimately calls game code
        self.assertTrue(xr.rule_r_eh(funclet, {})[0])

    def test_r_eh_refuses_seam_parent(self) -> None:
        funclet = copy.deepcopy(entry(self.doc, F1))
        parent = {"seam": True}
        ok, why = xr.rule_r_eh(funclet, {}, None, parent)
        self.assertFalse(ok)
        self.assertIn("seam", why)
        self.assertTrue(xr.rule_r_eh(funclet, {}, None, {"seam": False})[0])

    def test_semantics_sensitive_closure_propagates_to_callers(self) -> None:
        def add_caller(text: bytearray) -> None:
            put(text, L3, b"\x55\x8b\xec\xe8" + rel(L3 + 8, L4) + b"\x5d\xc3")

        with tempfile.TemporaryDirectory() as d:
            doc = Fixture(Path(d), text_mutator=add_caller).derive()
        spec = [{"id": "SS-RAND", "category": "rand", "selectors": [{"kind": "fingerprint", "value": "lcg_rand"}], "propagate": "callers"}]
        marked = xr.semantics_sensitive_set(doc, spec)
        self.assertEqual(sorted(marked), [h(L3), h(L4)])
        self.assertEqual(marked[h(L3)], ["rand"])
        self.assertEqual(xr.rule_candidates(doc, spec)["R-LIB-INTERNAL"], [])

    def test_import_and_name_selectors(self) -> None:
        spec = [
            {"id": "SS-IO", "category": "file_io", "selectors": [{"kind": "import", "names": ["KERNEL32.dll!Foo"]}], "propagate": "none"},
            {"id": "SS-NAME", "category": "qsort", "selectors": [{"kind": "ghidra_name_regex", "pattern": "^_qsort$"}], "propagate": "none"},
        ]
        doc = copy.deepcopy(self.doc)
        entry(doc, L3)["name"] = "_qsort"
        marked = xr.semantics_sensitive_set(doc, spec)
        self.assertEqual(marked[h(A)], ["file_io"])
        self.assertEqual(marked[h(L3)], ["qsort"])


@TOOLS
class OutputContractTests(Base):
    def test_validator_accepts_the_derived_document(self) -> None:
        self.assertEqual(xr.validate(self.doc), [])

    def test_validator_rejects_mutations(self) -> None:
        def mutated(fn) -> list:
            doc = copy.deepcopy(self.doc)
            fn(doc)
            return xr.validate(doc)

        self.assertTrue(mutated(lambda d: d["entries"].append(copy.deepcopy(d["entries"][0]))))  # duplicate / unsorted
        self.assertTrue(mutated(lambda d: entry(d, A)["callees"].append(h(E))))  # asymmetric callers
        self.assertTrue(mutated(lambda d: entry(d, A).update(origin="banana")))
        self.assertTrue(mutated(lambda d: entry(d, F1).update(eh_parent=None)))  # eh_kind without a parent
        self.assertTrue(mutated(lambda d: d["counts"]["origin"].update(game=99)))
        self.assertTrue(mutated(lambda d: entry(d, A).pop("span")))
        self.assertTrue(mutated(lambda d: d.update(original_sha256="00")))
        self.assertTrue(mutated(lambda d: d["thunks"][0].update(container=h(A))))  # container must hold the thunk
        self.assertTrue(mutated(lambda d: d["entries"].pop()))  # universe no longer matches the counts

    def test_output_is_sanitized(self) -> None:
        text = xr.dump(self.doc)
        for needle in ("/Users", "/private", "/Applications", "\\"):
            self.assertNotIn(needle, text)
        for e in self.doc["entries"]:
            self.assertEqual(set(e), set(xr.ENTRY_FIELDS))

    def test_one_entry_per_line_and_sorted(self) -> None:
        lines = xr.dump(self.doc).splitlines()
        entry_lines = [l for l in lines if l.lstrip().startswith('{"va"') and '"origin"' in l]
        self.assertEqual(len(entry_lines), len(function_starts()))
        vas = [json.loads(l.strip().rstrip(","))["va"] for l in entry_lines]
        self.assertEqual(vas, sorted(vas))

    def test_two_derivations_are_byte_identical(self) -> None:
        with tempfile.TemporaryDirectory() as d:
            other = Fixture(Path(d)).derive()
        self.assertEqual(xr.dump(other), xr.dump(self.doc))

    def test_inputs_are_pinned_by_hash_with_logical_paths(self) -> None:
        roles = {i["role"]: i for i in self.doc["inputs"]}
        self.assertEqual(roles["original"]["path"], "GAME.EXE")
        self.assertEqual(roles["original"]["sha256"], self.fx.sha)
        self.assertEqual(roles["ghidra_census"]["sha256"], hashlib.sha256(self.fx.ghidra.read_bytes()).hexdigest())
        self.assertEqual(roles["function_index"]["sha256"], hashlib.sha256(self.fx.index.read_bytes()).hexdigest())

    def test_cli_write_then_check_and_stale_detection(self) -> None:
        with tempfile.TemporaryDirectory() as d:
            fx = Fixture(Path(d))
            self.assertEqual(fx.cli("--write").returncode, 0)
            ok = fx.cli("--check")
            self.assertEqual(ok.returncode, 0, ok.stderr)
            out = Path(d) / "function-xrefs.json"
            original = out.read_text(encoding="utf-8")
            # a hand edit is detected
            out.write_text(original.replace('"origin": "game"', '"origin": "library"', 1), encoding="utf-8")
            self.assertNotEqual(fx.cli("--check").returncode, 0)
            out.write_text(original, encoding="utf-8")
            self.assertEqual(fx.cli("--check").returncode, 0)
            # a changed input (new Ghidra dump) is detected
            fx.ghidra.write_text(fx.ghidra.read_text() + json.dumps({"addr": "0x401ff0", "name": "x", "size": 1, "thunk": False}) + "\n")
            stale = fx.cli("--check")
            self.assertNotEqual(stale.returncode, 0)
            self.assertIn("stale", stale.stderr.lower())

    def test_wrong_original_hash_is_refused(self) -> None:
        with tempfile.TemporaryDirectory() as d:
            fx = Fixture(Path(d))
            fx.original.write_bytes(fx.original.read_bytes() + b"\0")
            result = fx.cli("--write")
            self.assertNotEqual(result.returncode, 0)

    def test_original_is_not_modified(self) -> None:
        with tempfile.TemporaryDirectory() as d:
            fx = Fixture(Path(d))
            before = fx.original.read_bytes()
            fx.cli("--write")
            self.assertEqual(fx.original.read_bytes(), before)


# ---------------------------------------------------------------------------
# Sampler
# ---------------------------------------------------------------------------


def write_overrides(directory: Path, spec=None) -> Path:
    path = directory / "overrides.json"
    path.write_text(
        json.dumps(
            {
                "schema": "blackmoor-function-ledger-overrides/1",
                "port_acceptances": [],
                "not_needed_entries": [],
                "not_needed_rules": [
                    {"id": "R-EH", "predicate": "R-EH", "accepted": False},
                    {"id": "R-LIB-INTERNAL", "predicate": "R-LIB-INTERNAL", "accepted": False},
                ],
                "semantics_sensitive": spec or [],
            }
        ),
        encoding="utf-8",
    )
    return path


@TOOLS
class SamplerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = tempfile.TemporaryDirectory()
        cls.dir = Path(cls.tmp.name)
        cls.fx = Fixture(cls.dir)
        cls.doc = cls.fx.derive()
        cls.xrefs = cls.dir / "function-xrefs.json"
        cls.xrefs.write_text(xr.dump(cls.doc), encoding="utf-8")
        cls.overrides = write_overrides(
            cls.dir,
            [{"id": "SS-RAND", "category": "rand", "selectors": [{"kind": "fingerprint", "value": "lcg_rand"}], "propagate": "callers"}],
        )

    @classmethod
    def tearDownClass(cls) -> None:
        cls.tmp.cleanup()

    def run_sampler(self, *args: str, xrefs: Path | None = None) -> dict:
        return smp.run(["--xrefs", str(xrefs or self.xrefs), "--overrides", str(self.overrides), *args])

    def test_same_inputs_same_sample_and_stable_text(self) -> None:
        one = self.run_sampler("--origin", "game", "--n", "3")
        two = self.run_sampler("--origin", "game", "--n", "3")
        self.assertEqual(smp.dump(one), smp.dump(two))
        self.assertEqual(len(one["sample"]), 3)
        self.assertEqual(one["sample"], sorted(one["sample"]))
        self.assertEqual(one["sample_sha256"], hashlib.sha256("\n".join(one["sample"]).encode()).hexdigest())

    def test_seed_is_the_hash_of_the_inputs_and_selection(self) -> None:
        one = self.run_sampler("--origin", "game", "--n", "3")
        other = self.run_sampler("--origin", "library", "--n", "3")
        self.assertNotEqual(one["seed"], other["seed"])
        changed = self.dir / "changed.json"
        doc = copy.deepcopy(self.doc)
        entry(doc, A)["name"] = "different"
        changed.write_text(xr.dump(doc), encoding="utf-8")
        third = self.run_sampler("--origin", "game", "--n", "3", xrefs=changed)
        self.assertNotEqual(one["seed"], third["seed"])

    def test_sample_is_a_subset_of_the_universe_and_n_is_capped(self) -> None:
        result = self.run_sampler("--origin", "game", "--n", "500")
        universe = [e["va"] for e in self.doc["entries"] if e["origin"] == "game"]
        self.assertEqual(result["universe_size"], len(universe))
        self.assertEqual(result["sample"], sorted(universe))
        self.assertTrue(result["exhaustive"])

    def test_selection_is_independent_of_list_order(self) -> None:
        vas = [e["va"] for e in self.doc["entries"]]
        seed = "ab" * 32
        self.assertEqual(smp.select(vas, seed, 4), smp.select(list(reversed(vas)), seed, 4))
        self.assertNotEqual(smp.select(vas, seed, 4), smp.select(vas, "cd" * 32, 4))

    def test_rule_sampling_uses_the_xrefs_predicates(self) -> None:
        eh = self.run_sampler("--rule", "R-EH", "--n", "59")
        self.assertEqual(eh["sample"], [h(F1)])
        self.assertEqual(eh["universe_size"], 1)
        lib = self.run_sampler("--rule", "R-LIB-INTERNAL", "--n", "59")
        self.assertEqual(lib["sample"], [h(L3)])

    def test_unknown_rule_is_refused(self) -> None:
        with self.assertRaises(SystemExit):
            self.run_sampler("--rule", "R-NOPE")

    def test_empty_universe_is_reported(self) -> None:
        result = self.run_sampler("--origin", "import_thunk", "--n", "5")
        self.assertEqual((result["universe_size"], result["sample"]), (0, []))

    def test_ledger_status_and_class_filters_when_a_ledger_is_given(self) -> None:
        ledger = {
            "schema": "blackmoor-function-ledger/1",
            "entries": [
                {"va": h(A), "status": "ported", "class": "native_tests_only", "region": "game"},
                {"va": h(B), "status": "pending", "class": "none", "region": "game"},
                {"va": h(C), "status": "pending", "class": "candidate_port", "region": "game"},
            ],
        }
        path = self.dir / "ledger.json"
        path.write_text(json.dumps(ledger), encoding="utf-8")
        base = ["--xrefs", str(self.xrefs), "--overrides", str(self.overrides), "--ledger", str(path)]
        result = smp.run([*base, "--status", "pending", "--n", "10"])
        self.assertEqual(result["sample"], sorted([h(B), h(C)]))
        result = smp.run([*base, "--class", "native_tests_only", "--n", "10"])
        self.assertEqual(result["sample"], [h(A)])


# ---------------------------------------------------------------------------
# Draft overrides
# ---------------------------------------------------------------------------


class DraftOverridesTests(unittest.TestCase):
    path = PROJECT / "function-ledger-overrides.json"

    def test_draft_is_conservative(self) -> None:
        doc = json.loads(self.path.read_text(encoding="utf-8"))
        self.assertEqual(doc["schema"], "blackmoor-function-ledger-overrides/1")
        self.assertEqual(doc["port_acceptances"], [])
        self.assertEqual(doc["not_needed_entries"], [])
        self.assertTrue(doc["not_needed_rules"])
        for rule in doc["not_needed_rules"]:
            self.assertIs(rule["accepted"], False)
            self.assertIn(rule["predicate"], xr.RULE_PREDICATES)
            self.assertIsNone(rule["review"]["sample_sha256"])
        self.assertEqual({r["id"] for r in doc["not_needed_rules"]}, {"R-EH", "R-LIB-INTERNAL"})

    def test_semantics_sensitive_spec_covers_the_plan_categories(self) -> None:
        doc = json.loads(self.path.read_text(encoding="utf-8"))
        cats = {s["category"] for s in doc["semantics_sensitive"]}
        self.assertEqual(
            cats,
            {"rand", "float_to_int", "printf_float_formatting", "qsort", "time", "file_io", "malloc_failure"},
        )
        for s in doc["semantics_sensitive"]:
            self.assertEqual(xr.validate_sensitive_spec(s), [], s["id"])

    def test_spec_validator_rejects_bad_selectors(self) -> None:
        self.assertTrue(xr.validate_sensitive_spec({"id": "x", "category": "c", "selectors": [{"kind": "bogus"}], "propagate": "callers"}))
        self.assertTrue(xr.validate_sensitive_spec({"id": "x", "category": "c", "selectors": [{"kind": "fingerprint", "value": "nope"}], "propagate": "callers"}))
        self.assertTrue(xr.validate_sensitive_spec({"id": "x", "category": "c", "selectors": [], "propagate": "callers"}))
        self.assertTrue(xr.validate_sensitive_spec({"id": "x", "category": "c", "selectors": [{"kind": "ghidra_name_regex", "pattern": "("}], "propagate": "callers"}))


# ---------------------------------------------------------------------------
# The real binary (skipped when the owner's local files are absent)
# ---------------------------------------------------------------------------

REPO = PROJECT.parents[1]
REAL_OK = (REPO / "work/original/GAME.EXE").is_file() and (REPO / "work/analysis/m0/fable-census/functions.jsonl").is_file()


@unittest.skipUnless(REAL_OK and HAVE_OBJDUMP, "owner's local GAME.EXE, Ghidra dump or llvm-objdump unavailable")
class CommittedXrefsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.doc = json.loads((PROJECT / "function-xrefs.json").read_text(encoding="utf-8"))

    def test_committed_file_validates_and_is_the_whole_index(self) -> None:
        self.assertEqual(xr.validate(self.doc), [])
        self.assertEqual(len(self.doc["entries"]), 4188)
        self.assertEqual(sum(e["span"] for e in self.doc["entries"]), 1213018)

    def test_regions_and_funclets(self) -> None:
        regions = {}
        for e in self.doc["entries"]:
            regions[e["region"]] = regions.get(e["region"], 0) + 1
        self.assertEqual(regions, {"game": 2507, "vorbis": 178, "crt_mfc": 1503})
        funclets = [e for e in self.doc["entries"] if e["eh_kind"]]
        self.assertEqual(len(funclets), 570)
        self.assertEqual(sum(1 for e in funclets if e["eh_kind"] == "unwind"), 557)
        self.assertEqual(sum(1 for e in funclets if e["eh_kind"] == "catch"), 13)
        self.assertTrue(all(e["eh_parent"] for e in funclets))

    def test_the_ghidra_thunks_and_the_one_it_missed(self) -> None:
        thunks = self.doc["thunks"]
        # Ghidra flags 22 thunks (16 `jmp [IAT]` import thunks and 6 `jmp rel32` ones); the byte-level
        # derivation finds one more lone `jmp rel32` that Ghidra did not mark as a thunk.
        self.assertEqual(len(thunks), 23)
        self.assertEqual(sum(1 for t in thunks if t["kind"] == "import"), 16)
        self.assertEqual(sum(1 for t in thunks if t["kind"] == "jump"), 7)
        self.assertEqual(sum(1 for t in thunks if t["ghidra_thunk"]), 22)
        self.assertEqual([t["va"] for t in thunks if not t["ghidra_thunk"]], ["0x0051a0e1"])
        self.assertEqual(self.doc["counts"]["ghidra_thunks_not_listed"], 0)
        inside = [t for t in thunks if t["container"] == "0x004fce90"]
        self.assertEqual(len(inside), 7)
        self.assertTrue(all(t["kind"] == "import" for t in inside))

    def test_origin_counts(self) -> None:
        self.assertEqual(
            self.doc["counts"]["origin"],
            {"game": 2507, "library": 1107, "compiler_eh": 570, "import_thunk": 0, "unknown": 4},
        )
        self.assertEqual(self.doc["counts"]["eh_funclets_by_parent_region"]["unwind"], {"crt_mfc": 97, "game": 460})

    def test_rederivation_matches_the_committed_file(self) -> None:
        result = subprocess.run(
            [sys.executable, str(SCRIPTS / "extract_function_xrefs.py"), "--check"], capture_output=True, text=True
        )
        self.assertEqual(result.returncode, 0, result.stderr[-2000:])


if __name__ == "__main__":
    unittest.main()
