#!/usr/bin/env python3
"""Regenerate the synthetic function-ledger fixture tree (FL-1b).

The tree mirrors outputs/blackmoor-decomp: the three extractor inputs are written in
the REAL shapes (function-xrefs.json as scripts/extract_function_xrefs.py dumps it,
function-evidence.json as scripts/extract_function_evidence.py renders it,
function-ledger-overrides.json in the FL-3 draft shape plus the FL-1 sections), the
census and the committed fixture ledger follow from them. Everything here is synthetic:
no original bytes, no private receipts. Hand-written fixture files (function-index.json,
decomp-progress/layout.json, src/, tests/, the x86 manifests and asm/batch-001*) are
read, never rewritten.

    python3 make_fixture.py           # rewrite the generated files
    python3 make_fixture.py --check   # exit 1 when a generated file differs

tests/test_function_ledger.py runs --check, so the committed fixture cannot drift.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parents[2]                                   # outputs/blackmoor-decomp
PIN = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
REPO = "outputs/blackmoor-decomp/"


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


XM = load("extract_function_xrefs", OUT / "scripts" / "extract_function_xrefs.py")
EV = load("extract_function_evidence", OUT / "scripts" / "extract_function_evidence.py")
FL = load("function_ledger", OUT / "decomp-progress" / "function_ledger.py")


def sha(data):
    return hashlib.sha256(data if isinstance(data, bytes) else data.encode()).hexdigest()


def sha_file(rel):
    return hashlib.sha256((HERE / rel).read_bytes()).hexdigest()


def h8(va):
    return f"0x{va:08x}"


def h(va):
    return f"0x{va:x}"


# --------------------------------------------------------------- universe --

INDEX = json.loads((HERE / "function-index.json").read_text())
LAYOUT = json.loads((HERE / "decomp-progress/layout.json").read_text())
STARTS = sorted(int(f["address"], 16) for f in INDEX["functions"])
TEXT = next(s for s in LAYOUT["sections"] if s["name"] == ".text")
TEXT_START = LAYOUT["image_base"] + TEXT["rva"]
TEXT_END = TEXT_START + TEXT["virt_size"]
SPAN = {va: (STARTS[i + 1] if i + 1 < len(STARTS) else TEXT_END) - va for i, va in enumerate(STARTS)}
REGIONS = [(r["id"], r["start_va"], r["end_va"]) for r in LAYOUT["code_regions"]]
BOUNDARIES = [r[1] for r in REGIONS[1:]]


def region_of(va):
    return next(r for r, a, b in REGIONS if a <= va < b)


# Body sizes (Ghidra) per function; everything else defaults.
BODY = {0x401000: 240, 0x401100: 496, 0x401300: 64, 0x401340: 368, 0x4014c0: 304, 0x401600: 240, 0x401700: 240,
        0x401800: 240, 0x401900: 248, 0x401a00: 240, 0x401b00: 32, 0x401c00: 48, 0x401d00: 64, 0x401e00: 8448,
        0x404000: 1792, 0x404800: 4864, 0x405c00: 768, 0x406000: 128, 0x406800: 1792, 0x407000: 128, 0x407100: 128,
        0x407200: 128, 0x407300: 64, 0x407400: 64, 0x407500: 64, 0x407600: 6, 0x407700: 64, 0x407800: 64,
        0x407900: 64, 0x407a00: 5376}
# direct calls caller -> callee (function level)
EDGES = [(0x401800, 0x401000), (0x401000, 0x401100), (0x401000, 0x401300), (0x401000, 0x401340),
         (0x401000, 0x4014c0), (0x401000, 0x401600), (0x401000, 0x401700), (0x401000, 0x401900),
         (0x401000, 0x401a00), (0x401000, 0x401e00), (0x401000, 0x404000), (0x401000, 0x405c00),
         (0x401000, 0x406000), (0x4014c0, 0x407100), (0x407000, 0x401800), (0x401800, 0x407800),
         (0x401d00, 0x401c00)]
IMPORTS = {0x401c00: ["KERNEL32.dll!OutputDebugStringA"], 0x401d00: ["KERNEL32.dll!GetCurrentThreadId"],
           0x407600: ["KERNEL32.dll!GetTickCount"]}
ORIGIN = {va: "game" for va in STARTS if region_of(va) == "game"}
ORIGIN.update({0x404000: "unknown", 0x404800: "library", 0x405c00: "library", 0x406000: "library",
               0x406800: "library", 0x407000: "library", 0x407100: "library", 0x407200: "library",
               0x407300: "compiler_eh", 0x407400: "compiler_eh", 0x407500: "compiler_eh",
               0x407600: "import_thunk", 0x407700: "library", 0x407800: "library", 0x407900: "library",
               0x407a00: "library"})
DATA_REF = {0x407200: 1, 0x407700: 1}
FUNCLETS = {0x407300: (0x401000, "unwind"), 0x407400: (0x401800, "unwind"), 0x407500: (0x401100, "catch")}
FINGERPRINTS = {0x406000: ["lcg_rand"], 0x407900: ["x87_ftol"]}
SEAM = {va for va in STARTS if any(abs(va - b) <= 0x400 for b in BOUNDARIES)}
REACH = {va: "game" for va in ORIGIN if ORIGIN[va] == "game"}
REACH.update({0x404000: "unknown_origin", 0x404800: "unreached", 0x405c00: "reachable", 0x406000: "reachable",
              0x406800: "unreached", 0x407000: "unreached", 0x407100: "reachable", 0x407200: "address_taken",
              0x407300: "reachable", 0x407400: "reachable", 0x407500: "reachable", 0x407600: "address_taken",
              0x407700: "address_taken", 0x407800: "reachable", 0x407900: "unreached", 0x407a00: "unreached"})
REACHES_GAME = {0x407000}
DERIVED = {0x401340: [(0x401380, "import_thunk", 6), (0x4013a0, "code", 0x20)], 0x401e00: [(0x401e80, "fallthrough_fragment", 0x10)]}
FRAME_LESS = {0x407a00}


def entry(va):
    callers = sorted({h8(a) for a, b in EDGES if b == va})
    callees = sorted({h8(b) for a, b in EDGES if a == va})
    parts = [h8(p) for p, _, _ in DERIVED.get(va, [])]
    funclet = FUNCLETS.get(va)
    children = sorted(h8(f) for f, (p, _) in FUNCLETS.items() if p == va)
    data = DATA_REF.get(va, 0)
    code_addr = 1 if va in (0x401000, 0x407600) else 0
    return {
        "va": h8(va), "name": f"FUN_{va:08x}", "region": region_of(va), "span": SPAN[va], "body_size": BODY[va],
        "code_size": None if va == 0x407a00 else min(BODY[va], SPAN[va]), "analysis_complete": va != 0x407a00,
        "derived_parts": parts, "contains_thunks": [h8(p) for p, k, _ in DERIVED.get(va, []) if k == "import_thunk"],
        "thunk": ORIGIN[va] == "import_thunk", "std_frame": ORIGIN[va] == "game", "seam": va in SEAM,
        "origin": ORIGIN[va], "origin_basis": {"game": "band_game", "library": "band_library",
                                               "compiler_eh": "eh_funclet", "import_thunk": "lone_import_jump",
                                               "unknown": "seam_unresolved"}[ORIGIN[va]],
        "callers": callers, "callees": callees, "tail_callees": [], "indirect_calls": 0, "indirect_jumps": 0,
        "imports": IMPORTS.get(va, []), "data_refs": data, "data_refs_unaligned": 0, "has_data_ref": data > 0,
        "code_addr_refs": code_addr, "address_taken": data + code_addr > 0,
        "eh_kind": funclet[1] if funclet else None, "eh_parent": h8(funclet[0]) if funclet else None,
        "eh_parents": [h8(funclet[0])] if funclet else [], "eh_parent_region": region_of(funclet[0]) if funclet else None,
        "eh_funclets": children, "fingerprints": FINGERPRINTS.get(va, []), "reach": REACH[va],
        "reaches_game": va in REACHES_GAME,
    }


def build_xrefs():
    entries = [entry(va) for va in STARTS]
    for e in entries:                                    # keep the key order of ENTRY_FIELDS
        assert set(e) == set(XM.ENTRY_FIELDS), sorted(set(e) ^ set(XM.ENTRY_FIELDS))
    entries = [{k: e[k] for k in XM.ENTRY_FIELDS} for e in entries]
    parts = [{"va": h8(p), "parent": h8(va), "size": size, "kind": kind, "direct_refs": 1, "data_refs": 0,
              "code_addr_refs": 0} for va, lst in sorted(DERIVED.items()) for p, kind, size in lst]
    thunks = [{"va": h8(0x401380), "size": 6, "kind": "import", "import": "KERNEL32.dll!GetTickCount",
               "container": h8(0x401340), "ghidra_thunk": True},
              {"va": h8(0x407600), "size": 6, "kind": "import", "import": "KERNEL32.dll!GetTickCount",
               "container": h8(0x407600), "ghidra_thunk": True}]
    doc = {
        "schema": "blackmoor-function-xrefs/1", "original_sha256": PIN,
        "inputs": [
            {"path": "GAME.EXE", "sha256": PIN, "role": "original"},
            {"path": REPO + "function-index.json", "sha256": sha_file("function-index.json"), "role": "function_index"},
            {"path": REPO + "decomp-progress/layout.json", "sha256": sha_file("decomp-progress/layout.json"), "role": "layout"},
            {"path": "work/analysis/m0/fable-census/functions.jsonl", "sha256": sha("fixture-ghidra-dump"), "role": "ghidra_census"},
            {"path": REPO + "scripts/gen_hinted_asm.py", "sha256": sha("fixture-span-split-tool"), "role": "span_split_tool"},
        ],
        "tools": {"disassembler": "synthetic fixture", "note": "informational; ignored by --check"},
        "parameters": {"seam_distance": 0x400, "boundaries": [h8(b) for b in BOUNDARIES]},
        "regions": [{"id": r, "start_va": h8(a), "end_va": h8(b)} for r, a, b in REGIONS],
        "roots": {"image_base": h8(LAYOUT["image_base"]), "entry_point": h8(0x407700), "entry_function": h8(0x407700)},
        "counts": {}, "imports": ["KERNEL32.dll!GetCurrentThreadId", "KERNEL32.dll!GetTickCount",
                                  "KERNEL32.dll!OutputDebugStringA"],
        "thunks": thunks, "eh_stubs": [], "derived_parts": parts, "entries": entries,
    }
    doc["counts"] = XM.compute_counts(doc)
    problems = XM.validate(doc)
    assert not problems, problems
    return XM.dump(doc)


# --------------------------------------------------------------- evidence --

SOURCES = [("src/fixture_core.c", "native_source"), ("src/fixture_rand.c", "native_source"),
           ("tests/fixture_core_oracle.py", "oracle_source"), ("tests/fixture_core_tests.py", "test")]
RECEIPTS = {"FIX-1": ("analysis/slices/FIX-1.handoff.json", sha(b"r-FIX-1"), "reviewer_recorded", True),
            "FIX-2": ("analysis/slices/FIX-2.handoff.json", sha(b"r-FIX-2"), "none", False)}
TEXT_U1, TEXT_U2 = sha("fixture-item-U1"), sha("fixture-item-U2")


def p_native(path, symbol):
    return {"kind": "native_source", "path": REPO + path, "sha256": sha_file(path), "symbol": symbol}


def p_test(test_id):
    return {"kind": "test", "path": REPO + "tests/fixture_core_tests.py", "sha256": sha_file("tests/fixture_core_tests.py"),
            "test_id": test_id}


def p_oracle(start, end, use, basis="window_start", verified="recorded_hash", path=True):
    oracle = "tests/fixture_core_oracle.py"
    return {"kind": "oracle", "path": REPO + oracle if path else None, "sha256": sha_file(oracle) if path else None,
            "window": [h(start), h(end)], "window_sha256": sha(f"window:{start:x}-{end:x}"),
            "reading": "end_exclusive", "verified": verified, "use": use, "use_basis": basis, "tail_gap": 0,
            "declared_in": [REPO + oracle] if path else [RECEIPTS["FIX-1"][0]]}


def p_receipt(slice_, via):
    path, digest, state, recorded = RECEIPTS[slice_]
    return {"kind": "receipt", "slice": slice_, "path": path, "sha256": digest,
            "review": {"state": state, "reviewer_recorded": recorded}, "via": via, "hook": None,
            "unlocated_unverified": 0}


def p_mention(path, symbol, addresses, via):
    return {"kind": "mention", "path": REPO + path, "sha256": sha_file(path), "symbol": symbol,
            "addresses": [h(a) for a in addresses], "via": via}


def item(slice_, field, index, text_sha, address, va):
    path = RECEIPTS[slice_][0]
    return {"slice": slice_, "path": path, "field": field, "index": index, "text_sha256": text_sha,
            "address": h(address), "interior": address != va}


def build_evidence():
    fns = {
        0x401000: [p_native("src/fixture_core.c", "fixture_entry"), p_test("test_entry"),
                   p_oracle(0x401000, 0x401100, "entry", "executed"), p_receipt("FIX-1", ["window"])],
        0x401100: [p_native("src/fixture_core.c", "fixture_tests_only"), p_test("test_tests_only")],
        0x401340: [p_native("src/fixture_core.c", "fixture_with_parts"), p_test("test_with_parts"),
                   p_oracle(0x401340, 0x4014c0, "callee", "executed")],
        0x4014c0: [p_native("src/fixture_core.c", "fixture_candidate_e"),
                   p_oracle(0x4014c0, 0x401600, "mapped", "static_scope")],
        0x401600: [p_native("src/fixture_core.c", "fixture_partial"),
                   p_oracle(0x401600, 0x4016f0, "mapped", "unhashed", "declared_only", path=False)],
        0x401700: [p_mention("src/fixture_core.c", None, [0x401704], "citation"), p_receipt("FIX-2", ["blocker"])],
        0x401900: [p_native("src/fixture_core.c", "fixture_candidate_i"), p_oracle(0x401900, 0x4019f8, "entry")],
        0x401a00: [p_native("src/fixture_core.c", "fixture_rejects"), p_test("test_rejects"),
                   p_oracle(0x401a00, 0x401af0, "entry", "executed")],
        0x406000: [p_native("src/fixture_rand.c", "fixture_rand"), p_test("test_rand_adapter")],
    }
    blockers = {0x401900: [item("FIX-1", "unverified_branches", 0, TEXT_U1, 0x401950, 0x401900)],
                0x401a00: [item("FIX-1", "unverified_branches", 1, TEXT_U2, 0x401a40, 0x401a00)]}
    divergences = {0x401a00: [item("FIX-1", "deliberate_safety_rejections", 0, TEXT_U2, 0x401a40, 0x401a00)]}
    functions = []
    for va in sorted(set(fns) | set(blockers) | set(divergences)):
        order = {"native_source": 0, "test": 1, "oracle": 2, "receipt": 3, "mention": 4}
        evidence = sorted(fns.get(va, []), key=lambda p: (order[p["kind"]], json.dumps(p, sort_keys=True)))
        functions.append({"va": h(va), "evidence": evidence, "blockers": blockers.get(va, []),
                          "divergences": divergences.get(va, [])})
    receipts = [{"slice": s, "kind": "handoff", "path": path, "sha256": digest,
                 "review": {"state": state, "reviewer_recorded": recorded},
                 "windows": {"declared": 1, "hashed": 1, "verified": 1},
                 "unverified": {"items": 1, "located": 1}, "divergence_items": 0, "hook_addresses": 0,
                 "files": [REPO + "src/fixture_core.c"]}
                for s, (path, digest, state, recorded) in sorted(RECEIPTS.items())]
    doc = {"schema": "blackmoor-function-evidence/1", "original_sha256": PIN, "text_range": [h(TEXT_START), h(TEXT_END)],
           "function_index": {"path": REPO + "function-index.json", "sha256": sha_file("function-index.json"),
                              "functions": len(STARTS)},
           "sources": [{"path": REPO + p, "sha256": sha_file(p), "role": role} for p, role in SOURCES],
           "receipts": receipts, "functions": functions, "unresolved": [],
           "counts": {"functions_total": len(STARTS), "functions_with_evidence": len(functions)}}
    EV.validate_document(doc)
    return EV.render(doc)


# -------------------------------------------------------------- the rest --

def build_overrides():
    def accept(va, cls, path, symbol, test, oracle, parts):
        return {"va": h(va), "class": cls, "reviewer": "fixture-reviewer", "date": "2026-10-15",
                "native_source": {"path": path, "symbol": symbol},
                "tests": [{"path": "tests/fixture_core_tests.py", "test_id": test}], "oracle": oracle,
                "parts_accounted": [h(p) for p in parts], "note": "fixture acceptance"}
    oracle = lambda a, b: {"path": "tests/fixture_core_oracle.py", "window": [h(a), h(b)]}
    entry = lambda va, reason, text: {"va": h(va), "reason": reason, "text": text, "reviewer": "fixture-reviewer",
                                      "date": "2026-10-15"}
    doc = {
        "schema": "blackmoor-function-ledger-overrides/1", "status": "fixture",
        "note": "Synthetic fixture overrides in the FL-3 draft shape; the rules are accepted here to exercise them.",
        "port_acceptances": [
            accept(0x401000, "native_oracle_verified", "src/fixture_core.c", "fixture_entry", "test_entry",
                   oracle(0x401000, 0x401100), []),
            accept(0x401100, "native_tests_only", "src/fixture_core.c", "fixture_tests_only", "test_tests_only", None, []),
            accept(0x401340, "native_oracle_verified", "src/fixture_core.c", "fixture_with_parts", "test_with_parts",
                   oracle(0x401340, 0x4014c0), [0x401380, 0x4013a0]),
            accept(0x401a00, "native_oracle_verified", "src/fixture_core.c", "fixture_rejects", "test_rejects",
                   oracle(0x401a00, 0x401af0), []),
            accept(0x406000, "host_adapter_tested", "src/fixture_rand.c", "fixture_rand", "test_rand_adapter", None, []),
        ],
        "not_needed_entries": [
            entry(0x401b00, "unreachable_no_refs", "no callers and no data reference in the reviewed xrefs"),
            entry(0x401c00, "debug_diagnostic_only", "only calls OutputDebugStringA"),
            entry(0x401d00, "win32_plumbing_no_observable_effect", "thread-id query with an allowlisted import"),
            entry(0x407500, "compiler_eh_funclet", "catch funclet of a natively ported parent, reviewed one by one"),
            entry(0x407700, "crt_startup_termination", "CRT initializer table entry, no game caller"),
            entry(0x407800, "host_libc_standard_contract", "standard memory routine replaced by the host libc"),
        ],
        "not_needed_rules": [
            {"id": "R-EH", "predicate": "R-EH", "accepted": True, "reason_code": "compiler_eh_funclet",
             "rationale": "unwind funclet of a natively ported parent", "parameters": {"eh_parent_regions": ["crt_mfc", "vorbis", "game"]},
             "review": {"reviewer": "fixture-reviewer", "date": "2026-10-15", "n": 59, "defects": 0,
                        "sample_sha256": sha("sample-eh")}},
            {"id": "R-LIB-INTERNAL", "predicate": "R-LIB-INTERNAL", "accepted": True,
             "reason_code": "library_internal_unreached_by_game",
             "rationale": "library function with no path from or to game code", "parameters": {},
             "review": {"reviewer": "fixture-reviewer", "date": "2026-10-15", "n": 59, "defects": 0,
                        "sample_sha256": sha("sample-lib")}},
        ],
        "semantics_sensitive": [
            {"id": "SS-RAND", "category": "rand", "basis": "fixture", "propagate": "none", "exclusion_only": True,
             "selectors": [{"kind": "fingerprint", "value": "lcg_rand"}]},
            {"id": "SS-FTOL", "category": "float_to_int", "basis": "fixture", "propagate": "none", "exclusion_only": True,
             "selectors": [{"kind": "fingerprint", "value": "x87_ftol"}]},
        ],
        "win32_import_allowlist": {"names": ["KERNEL32.dll!GetCurrentThreadId"], "reviewer": "fixture-reviewer",
                                   "date": "2026-10-15"},
    }
    return json.dumps(doc, indent=1) + "\n"


def build_census():
    doc = json.loads((HERE / "asm/census-summary.json").read_text())
    doc["derived_functions"] = sum(len(v) for v in DERIVED.values())
    return json.dumps(doc, indent=1) + "\n"


def generate():
    """Relative path -> text, in dependency order."""
    files = {"asm/census-summary.json": build_census(), "function-xrefs.json": build_xrefs(),
             "function-evidence.json": build_evidence(), "function-ledger-overrides.json": build_overrides()}
    return files


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args(argv)
    files = generate()
    stale = [rel for rel, text in files.items() if not (HERE / rel).is_file() or (HERE / rel).read_text() != text]
    if args.check:
        # the ledger last: derive it from the on-disk tree
        ledger = FL.render(FL.derive(HERE, expected_functions=len(STARTS)))
        if not (HERE / "function-ledger.json").is_file() or (HERE / "function-ledger.json").read_text() != ledger:
            stale.append("function-ledger.json")
        if stale:
            print("stale fixture files: " + ", ".join(stale), file=sys.stderr)
            return 1
        return 0
    for rel, text in files.items():
        (HERE / rel).write_text(text)
    (HERE / "function-ledger.json").write_text(FL.render(FL.derive(HERE, expected_functions=len(STARTS))))
    return 0


if __name__ == "__main__":
    sys.exit(main())
