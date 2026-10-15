#!/usr/bin/env python3
"""Build the decomp-progress report and treemap for GAME.EXE.

Reads only committed evidence (function index, match manifests, layout facts)
and writes ``progress.json``, ``REPORT.md`` and a self-contained ``index.html``.
It never reads or embeds original bytes.

Two evidence modes:

* baseline (default): matched code comes from reviewed ``matches*.json`` and
  audited M03 ``asm/batch-*.json`` manifests; data items are excluded.
* ledger (``--ledger``): a whole-file range ledger (see README.md, "Range
  ledger contract") supplies code/data kind and class for every file byte.
  This is the shape the M02 composer's coverage report is adapted to.
"""

from __future__ import annotations

import argparse
import bisect
import hashlib
import importlib.util
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parent  # outputs/blackmoor-decomp

PLAYABLE_SPEC = importlib.util.spec_from_file_location("blackmoor_playable_progress", HERE / "playable.py")
PLAYABLE = importlib.util.module_from_spec(PLAYABLE_SPEC)
PLAYABLE_SPEC.loader.exec_module(PLAYABLE)

# The function ledger (blackmoor-function-ledger/1) is a different artifact from the
# whole-file range ledger below (--ledger, blackmoor-range-ledger/1); nothing is shared.
FUNCTION_LEDGER_SPEC = importlib.util.spec_from_file_location("blackmoor_function_ledger", HERE / "function_ledger.py")
FNL = importlib.util.module_from_spec(FUNCTION_LEDGER_SPEC)
FUNCTION_LEDGER_SPEC.loader.exec_module(FNL)
FUNCTION_LEDGER_FILE = "function-ledger.json"

IMAGE_BASE = 0x400000
PINNED_SHA = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
SCHEMA = "blackmoor-decomp-progress/1"
LEDGER_SCHEMA = "blackmoor-range-ledger/1"

# Manifests whose ranges are byte-exact against the original (confirmed by
# scripts/verify_matches.py when --verify-original is given). The C and C++
# compiler candidates are mismatch evidence, not exact-match claims, so they
# are deliberately absent.
COUNTED_MANIFESTS = [
    "matches.json",
    "matches_s08_2_x86.json",
    "matches_s08_3_x86.json",
    "matches_s08_4_x86.json",
]
EXCLUDED_MANIFESTS = {
    "matches_s08.json": "C compiler candidate; verify_matches.py reports 62 differing bytes (the same addresses are matched by matches_s08_2_x86.json)",
    "matches_s08_2.json": "C++ compiler comparison; semantic evidence, not an exact-match claim",
}

# Provenance of each counted manifest, from status.json's classification and the
# manifest descriptions. matches.json holds two 7-byte ranges compiled from
# src/initial_functions.c whose function completeness is unverified.
MANIFEST_PROVENANCE = {
    "matches.json": "exact_range_compiled_c_partial",
    "matches_s08_2_x86.json": "explicit_reconstructed_assembly_source",
    "matches_s08_3_x86.json": "explicit_reconstructed_assembly_source",
    "matches_s08_4_x86.json": "explicit_reconstructed_assembly_source",
}
# status.json keys that record the reviewed source and object hashes per manifest.
STATUS_BINDING = {
    "matches_s08_2_x86.json": "matching_s08_2",
    "matches_s08_3_x86.json": "matching_s08_3",
    "matches_s08_4_x86.json": "matching_s08_4",
}
PROVENANCE_RE = r"^[a-z][a-z0-9_]*$"
LEDGER_CLASSES = {"structured", "reconstructed", "referenced"}
LEDGER_KINDS = {"code", "data"}
TOOL_ASSISTED = "tool_assisted_reconstructed_assembly"
# Same pin as scripts/audit_tool_assisted.py. Only audit metadata is read here;
# neither the assembler, objects nor GAME.EXE are needed for normal generation.
M03_ASSEMBLER_VERSION = "GNU assembler (GNU Binutils) 2.43.1"


class ProgressError(Exception):
    pass


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        raise ProgressError(f"cannot read {path}: {exc}") from exc


# ---------------------------------------------------------------- layout --

def load_layout(path: Path) -> dict:
    layout = load_json(path)
    if layout.get("schema") != "blackmoor-image-layout/1":
        raise ProgressError("layout.json: unexpected schema")
    return layout


def build_atoms(layout: dict, index: dict, band_bytes: int) -> tuple[list[dict], list[dict]]:
    """Partition the whole file into atoms and group atoms into units.

    An atom is the smallest accounted extent: one indexed function span or one
    data piece. Returns (units, atoms); every file byte is in exactly one atom.
    """
    if index.get("original_sha256") != layout["original_sha256"]:
        raise ProgressError("function-index.json does not describe the pinned GAME.EXE")
    starts = sorted(int(f["address"], 16) for f in index["functions"])
    if len(set(starts)) != len(starts):
        raise ProgressError("function index has duplicate starts")
    text = next(s for s in layout["sections"] if s["name"] == ".text")
    base = layout["image_base"]
    text_va0 = base + text["rva"]
    text_va_end = text_va0 + text["virt_size"]
    if starts[0] != text_va0:
        raise ProgressError("first function does not start at the .text base")
    if starts[-1] >= text_va_end:
        raise ProgressError("function start beyond .text")
    regions = layout["code_regions"]
    region_edges = [r["start_va"] for r in regions]
    region_edges.append(regions[-1]["end_va"])
    if region_edges[0] != text_va0 or region_edges[-1] != text_va_end:
        raise ProgressError("code regions do not tile .text")

    units: dict[str, dict] = {}
    unit_order: list[str] = []
    atoms: list[dict] = []

    def unit(uid, group, label, **extra):
        if uid not in units:
            units[uid] = {"id": uid, "group": group, "label": label, **extra}
            unit_order.append(uid)
        return units[uid]

    for i, va in enumerate(starts):
        end = starts[i + 1] if i + 1 < len(starts) else text_va_end
        ridx = bisect.bisect_right(region_edges, va) - 1
        if ridx < 0 or ridx >= len(regions):
            raise ProgressError(f"function 0x{va:x} outside every code region")
        region = regions[ridx]
        if end > region["end_va"]:
            raise ProgressError(f"function 0x{va:x} crosses the {region['id']} seam")
        band = (va - region["start_va"]) // band_bytes
        b0 = region["start_va"] + band * band_bytes
        uid = f"{region['id']}-{b0:06x}"
        label = f"0x{b0:06x} band"
        unit(uid, region["id"], label, kind="code", band_start_va=b0)
        atoms.append({"unit": uid, "kind": "code", "va": va,
                      "off": va - base, "size": end - va})

    for piece in layout["data_pieces"]:
        unit(piece["id"], piece["group"], piece["label"], kind="data",
             file_off=piece["file_off"])
        atoms.append({"unit": piece["id"], "kind": "data", "va": None,
                      "off": piece["file_off"], "size": piece["size"]})

    atoms.sort(key=lambda a: a["off"])
    cursor = 0
    for a in atoms:
        if a["off"] != cursor:
            raise ProgressError(f"layout gap or overlap at file offset 0x{cursor:x}")
        cursor += a["size"]
    if cursor != layout["file_size"]:
        raise ProgressError(f"layout covers {cursor} bytes, expected {layout['file_size']}")
    return [units[u] for u in unit_order], atoms


# --------------------------------------------------------------- evidence --

def merge_intervals(ivs):
    out = []
    for s, e in sorted(ivs):
        if out and s <= out[-1][1]:
            out[-1][1] = max(out[-1][1], e)
        else:
            out.append([s, e])
    return out


VERIFIER = OUT / "scripts" / "verify_matches.py"


def verify_manifests(names, root: Path, original: Path, verifier: Path = VERIFIER) -> dict:
    """Run the repository's byte verifier on each counted manifest.

    ``root`` must hold the manifests with their ``build/`` objects (the
    objects are gitignored, so this is usually the primary checkout). Every
    manifest must exit 0 with ``all_byte_ranges_exact``; anything else is an
    error, so an unverified manifest cannot add to the totals.
    """
    import subprocess
    import tempfile
    original, root, verifier = original.resolve(), root.resolve(), verifier.resolve()
    if not original.is_file():
        raise ProgressError(f"original executable not found: {original}")
    if sha256_file(original) != PINNED_SHA:
        raise ProgressError("--verify-original does not point at the pinned GAME.EXE")
    results = {}
    for name in names:
        manifest = root / name
        if not manifest.is_file():
            raise ProgressError(f"cannot verify {name}: not found under {root}")
        with tempfile.TemporaryDirectory() as td:
            report = Path(td) / "report.json"
            proc = subprocess.run(
                [sys.executable, str(verifier), str(original), str(manifest), "--report", str(report)],
                cwd=root, capture_output=True, text=True)
            try:
                rep = json.loads(report.read_text(encoding="utf-8"))
            except (OSError, ValueError):
                rep = {}
        if proc.returncode != 0 or rep.get("all_byte_ranges_exact") is not True:
            raise ProgressError(
                f"{name}: verify_matches.py did not confirm exact bytes (exit {proc.returncode})")
        results[name] = {"exact": True, "exact_byte_range_bytes": rep.get("exact_byte_range_bytes"),
                         "manifest_sha256": sha256_file(manifest)}
    return {"run": True, "verifier_sha256": sha256_file(verifier),
            "original_sha256": PINNED_SHA, "manifests": results}


def bind_reviewed_artifacts(names, root: Path, evidence_dir: Path, status: dict | None,
                            starts: set | None = None) -> dict:
    """Tie each verified object to its committed source and the reviewed hashes.

    For the assembly manifests, ``status.json`` records the reviewed source and
    object SHA-256. The committed source must match the reviewed source hash and
    the object that verify_matches.py just checked must match the reviewed object
    hash, so a rebuilt-from-edited-source or swapped object is rejected. A fresh
    reassembly with the pinned assembler is not rerun here; the slice audits own
    that (see scripts/audit_matching_s08_*_x86.py). Manifests with no recorded
    hashes (matches.json, two partial 7-byte C ranges) are reported as unbound.
    Row identity is checked too: each row's symbol must encode its own address, and
    (when ``starts`` is given) every row must begin at an indexed function start.
    """
    out = {}
    for name in names:
        man = load_json(evidence_dir / name)
        src = evidence_dir / man.get("source", "")
        objs = {fn.get("object") for fn in man["functions"]}
        key = STATUS_BINDING.get(name)
        rec = (status or {}).get(key) if key else None
        if key is None:
            out[name] = {"bound_to_reviewed_hashes": False,
                         "note": "no reviewed source/object hashes exist for this manifest"}
            continue
        if rec is None:
            raise ProgressError(
                f"{name}: status.json has no reviewed hash record ({key}); "
                "an assembly manifest cannot be counted as verified without one")
        if len(objs) != 1 or None in objs:
            raise ProgressError(f"{name}: expected exactly one object path")
        obj = root / objs.pop()
        if not src.is_file() or not obj.is_file():
            raise ProgressError(f"{name}: source or object file missing")
        funcs = man["functions"]
        if len(funcs) != rec.get("complete_functions") or \
                sum(int(f["size"]) for f in funcs) != rec.get("exact_bytes"):
            raise ProgressError(
                f"{name}: manifest has {len(funcs)} functions / "
                f"{sum(int(f['size']) for f in funcs)} bytes but status.json records "
                f"{rec.get('complete_functions')} / {rec.get('exact_bytes')}")
        base = IMAGE_BASE
        for f in funcs:
            m = re.fullmatch(r"_?FUN_([0-9a-f]{8})", str(f.get("symbol", "")))
            va = base + int(f["rva"])
            if not m or int(m.group(1), 16) != va:
                raise ProgressError(
                    f"{name}: symbol {f.get('symbol')!r} does not match its RVA 0x{int(f['rva']):x}")
            if starts is not None and va not in starts:
                raise ProgressError(
                    f"{name}: 0x{va:x} is not an indexed function start, so it cannot be a "
                    "complete-function claim")
        got_src, got_obj = sha256_file(src), sha256_file(obj)
        if got_src != rec.get("source_sha256"):
            raise ProgressError(f"{name}: committed source does not match the reviewed source hash")
        if got_obj != rec.get("object_sha256"):
            raise ProgressError(f"{name}: verified object does not match the reviewed object hash")
        out[name] = {"bound_to_reviewed_hashes": True, "source_sha256": got_src,
                     "object_sha256": got_obj,
                     "functions": len(funcs), "bytes": sum(int(f["size"]) for f in funcs)}
    return out


def audited_batch_evidence(layout: dict, out_dir: Path):
    """Validate committed M03 claims against audit reports and source hashes.

    Root's acceptance of the independent annotation review is a prerequisite
    for publishing these batches; the audit report alone cannot prove it.
    This consumer checks that the published source is still the audited source.
    It does not rerun the audit or infer provenance from original machine bytes.
    """
    text = next(s for s in layout["sections"] if s["name"] == ".text")
    rows, claims, inputs, batches, seen_sources, seen_functions = [], [], [], [], set(), {}
    for path in sorted((out_dir / "asm").glob("batch-*.json")):
        if not re.fullmatch(r"batch-[0-9]+\.json", path.name):
            continue  # report files are not manifests
        name = path.relative_to(out_dir).as_posix()
        report_path = path.with_name(path.stem + "-report.json")
        man, report = load_json(path), load_json(report_path)

        def require(ok, reason):
            if not ok:
                raise ProgressError(f"{name}: {reason}")

        try:
            require(man["original_sha256"] == report["original_sha256"] == layout["original_sha256"],
                    "audit/manifest does not describe the pinned GAME.EXE")
            require(man["class"] == report["class_requested"] == TOOL_ASSISTED,
                    "wrong tool-assisted provenance class")
            require(man["batch"] == report["batch"] == path.stem.removeprefix("batch-"),
                    "batch identity differs from its audit")
            require(report["manifest_sha256"] == sha256_file(path), "manifest hash differs from audit")
            require(report["all_accepted"] is True and report["errors"] == [], "batch audit not accepted")
            assembler = report["assembler"]
            require(assembler.get("self_test") == "passed" and
                    assembler["version_line"] == M03_ASSEMBLER_VERSION, "audit assembler is not pinned")
            functions, audited = man["functions"], report["functions"]
            require(isinstance(functions, list) and len(functions) > 0 and isinstance(audited, list),
                    "batch needs audited functions")
            by_symbol = {f["function"]: f for f in audited}
            require(len(by_symbol) == len(audited) == len(functions) == report["accepted_count"],
                    "audit function count differs from manifest")
            require(len({f["function"] for f in functions}) == len(functions), "duplicate function in batch")
            require(sum(f["code"]["size"] for f in functions) == report["code_bytes_accepted"],
                    "audit code byte total differs from manifest")
            batch_ranges, batch_data = [], 0
            for fn in functions:
                a = by_symbol[fn["function"]]
                code = fn["code"]
                va, rva, size = int(fn["va"], 0), code["rva"], code["size"]
                require(type(rva) is int and type(size) is int and size > 0 and
                        rva >= text["rva"] and rva + size <= text["rva"] + text["virt_size"],
                        "code extent is outside .text")
                require(fn["function"] == code["symbol"] == f"FUN_{va:08x}" and
                        va == layout["image_base"] + rva, "function symbol/VA/RVA disagree")
                require(a["status"] == "accepted" and a["reasons"] == [] and
                        a["relocations"] == 0 and a["code"] == code and a["va"] == va and
                        a["region"] == fn["region"], "function differs from accepted audit")
                require(re.fullmatch(r"[0-9a-f]{64}", code["sha256"]) is not None and
                        re.fullmatch(r"[0-9a-f]{64}", a["object"]["sha256"]) is not None,
                        "missing code/object hash in audit")
                data = fn["data_items"]
                require(len(data) == len(a["data_items"]) and
                        all(all(item.get(k) == v for k, v in expected.items())
                            for expected, item in zip(data, a["data_items"])),
                        "data item split differs from audit")
                data_size = sum(d["size"] for d in data)
                require(a["compared_bytes"] == size + data_size, "audit did not compare the full extent")
                source = (path.parent / fn["source"]).resolve()
                require(source.parent == path.parent.resolve() and source.suffix == ".s", "bad source path")
                require(a["source"]["path"] == fn["source"] and
                        a["source"]["sha256"] == fn["source_sha256"] == sha256_file(source),
                        "source hash differs from audit")
                identity = (rva, size, code["sha256"])
                require(va not in seen_functions or seen_functions[va] == identity,
                        "conflicting audited code extents for the same function")
                seen_functions[va] = identity
                off = text["raw_off"] + rva - text["rva"]
                rows.append((off, off + size, "reconstructed", name, code["symbol"]))
                claims.append({"va": va, "size": size, "symbol": code["symbol"], "manifest": name,
                               "provenance": TOOL_ASSISTED, "audited": True, "data_size": data_size})
                batch_ranges.append((off, off + size))
                batch_data += data_size
                if source not in seen_sources:
                    seen_sources.add(source)
                    inputs.append({"path": source.relative_to(out_dir.resolve()).as_posix(),
                                   "sha256": fn["source_sha256"], "role": "audited-source"})
            require(sum(e - s for s, e in merge_intervals(batch_ranges)) == report["code_bytes_accepted"],
                    "code extents overlap within the batch")
            batches.append({"manifest": name, "audit": report_path.relative_to(out_dir).as_posix(),
                            "functions": len(functions), "code_bytes": report["code_bytes_accepted"],
                            "excluded_data_bytes": batch_data, "source_hashes_checked": True,
                            "assembler_sha256": assembler["sha256"],
                            "assembler_version": assembler["version_line"]})
            inputs.extend([{"path": name, "sha256": sha256_file(path), "role": "counted"},
                           {"path": report_path.relative_to(out_dir).as_posix(),
                            "sha256": sha256_file(report_path), "role": "audit"}])
        except (KeyError, TypeError, ValueError, OSError) as exc:
            raise ProgressError(f"{name}: malformed or unavailable audited evidence: {exc}") from exc
    return rows, claims, inputs, batches


def subtract_interval(s, e, claimed):
    """Parts of [s,e) not already owned by sorted, merged intervals."""
    pieces, pos = [], s
    for a, b in claimed:
        if b <= pos:
            continue
        if a >= e:
            break
        if a > pos:
            pieces.append((pos, min(a, e)))
        pos = max(pos, b)
    if pos < e:
        pieces.append((pos, e))
    return pieces


def baseline_evidence(layout: dict, out_dir: Path) -> tuple[list[tuple], dict]:
    """Matched intervals (file offsets, class reconstructed) from manifests."""
    text = next(s for s in layout["sections"] if s["name"] == ".text")
    ivs, inputs, prov, claims = [], [], [], []
    for name in COUNTED_MANIFESTS:
        path = out_dir / name
        man = load_json(path)
        if man.get("original_sha256") != layout["original_sha256"]:
            raise ProgressError(f"{name}: does not describe the pinned GAME.EXE")
        for fn in man["functions"]:
            rva, size = int(fn["rva"]), int(fn["size"])
            if size <= 0 or rva < text["rva"] or rva + size > text["rva"] + text["virt_size"]:
                raise ProgressError(f"{name}: {fn.get('symbol')} is outside .text")
            off = text["raw_off"] + (rva - text["rva"])
            ivs.append((off, off + size, "reconstructed", name, fn.get("symbol", "")))
            prov.append((off, off + size, MANIFEST_PROVENANCE[name]))
            claims.append({"va": layout["image_base"] + rva, "size": size,
                           "symbol": fn.get("symbol", ""), "manifest": name,
                           "provenance": MANIFEST_PROVENANCE[name], "audited": False})
        inputs.append({"path": name, "sha256": sha256_file(path), "role": "counted"})
    legacy = merge_intervals([(s, e) for s, e, *_ in ivs])
    audited, audited_claims, audited_inputs, batches = audited_batch_evidence(layout, out_dir)
    # Preserve the legacy provenance of overlapping bytes. Same-class batch
    # duplicates are merged by build_model, so neither total can be inflated.
    for s, e, *_ in audited:
        prov.extend((a, b, TOOL_ASSISTED) for a, b in subtract_interval(s, e, legacy))
    ivs.extend(audited)
    inputs.extend(audited_inputs)
    claims.extend(audited_claims)
    for name, why in sorted(EXCLUDED_MANIFESTS.items()):
        path = out_dir / name
        if path.exists():
            inputs.append({"path": name, "sha256": sha256_file(path), "role": "excluded",
                           "reason": why})
    return ivs, {"mode": "baseline", "inputs": inputs, "provenance_ranges": prov,
                 "function_claims": claims, "tool_assisted_batches": batches,
                 "legacy_matched_code": sum(e - s for s, e in legacy)}


def ledger_evidence(layout: dict, ledger_path: Path, allow_partial: bool):
    ledger = load_json(ledger_path)
    if ledger.get("schema") != LEDGER_SCHEMA:
        raise ProgressError(f"ledger schema must be {LEDGER_SCHEMA}")
    if ledger.get("original_sha256") != layout["original_sha256"]:
        raise ProgressError("ledger does not describe the pinned GAME.EXE")
    if ledger.get("file_size") != layout["file_size"]:
        raise ProgressError("ledger file_size differs from the layout")
    rows, prov = [], []
    for r in ledger["ranges"]:
        if r.get("class") == "missing":
            raise ProgressError("ledger contains a 'missing' range; the composer must not emit one")
        if r.get("class") not in LEDGER_CLASSES or r.get("kind") not in LEDGER_KINDS:
            raise ProgressError(f"bad ledger range {r}")
        off, size = int(r["offset"]), int(r["size"])
        if size <= 0 or off < 0 or off + size > layout["file_size"]:
            raise ProgressError(f"ledger range out of bounds: {r}")
        rows.append((off, off + size, r["kind"], r["class"], r.get("label", "")))
        if r["class"] in ("reconstructed", "structured"):
            p = r.get("provenance")
            if not isinstance(p, str) or not re.match(PROVENANCE_RE, p):
                raise ProgressError(
                    f"matched ledger range at 0x{off:x} needs a provenance class "
                    f"(for example explicit_reconstructed_assembly_source or "
                    f"tool_assisted_reconstructed_assembly), got {p!r}")
            prov.append((off, off + size, p))
    rows.sort()
    covered = 0
    for prev, cur in zip(rows, rows[1:]):
        if cur[0] < prev[1]:
            raise ProgressError(f"ledger ranges overlap at file offset 0x{cur[0]:x}")
    covered = sum(e - s for s, e, *_ in rows)
    if covered != layout["file_size"] and not allow_partial:
        raise ProgressError(
            f"ledger covers {covered} of {layout['file_size']} bytes; every byte needs a class")
    meta = {"mode": "ledger",
            "inputs": [{"path": str(ledger_path.name), "sha256": sha256_file(ledger_path),
                        "role": "ledger"}],
            "ledger_bytes_covered": covered, "provenance_ranges": prov}
    return rows, meta


def overlap(ivs_sorted: list[list[int]], s: int, e: int) -> int:
    """Total overlap of [s,e) with a sorted list of disjoint [a,b) intervals."""
    starts = [iv[0] for iv in ivs_sorted]
    i = max(bisect.bisect_right(starts, s) - 1, 0)
    total = 0
    while i < len(ivs_sorted) and ivs_sorted[i][0] < e:
        a, b = ivs_sorted[i]
        total += max(0, min(b, e) - max(a, s))
        i += 1
    return total


# ------------------------------------------------------------- accounting --

def account(units, atoms, evidence_rows, mode, complete_starts=None):
    """Fill per-atom code/data/matched figures from the evidence rows."""
    by_unit = {u["id"]: u for u in units}
    for u in units:
        u.update(code=0, data=0, matched_code=0, matched_data=0, extent=0, functions=[])
    for a in atoms:
        by_unit[a["unit"]]["extent"] += a["size"]
    if mode == "baseline":
        matched = merge_intervals([(s, e) for s, e, *_ in evidence_rows])
        for a in atoms:
            u = by_unit[a["unit"]]
            m = overlap(matched, a["off"], a["off"] + a["size"])
            if a["kind"] == "code":
                u["code"] += a["size"]
                u["matched_code"] += m
            else:
                u["data"] += a["size"]
                u["matched_data"] += m  # always 0: no data evidence in baseline
            if a["kind"] == "code":
                u["functions"].append([a["va"], a["size"], m, 0])
    else:
        done = {k: merge_intervals([(s, e) for s, e, kind, cls, _ in evidence_rows
                                    if kind == k and cls in ("reconstructed", "structured")])
                for k in LEDGER_KINDS}
        kinds = {k: merge_intervals([(s, e) for s, e, kind, *_ in evidence_rows if kind == k])
                 for k in LEDGER_KINDS}
        for a in atoms:
            u = by_unit[a["unit"]]
            lo, hi = a["off"], a["off"] + a["size"]
            c = overlap(kinds["code"], lo, hi)
            d = overlap(kinds["data"], lo, hi)
            mc = overlap(done["code"], lo, hi)
            md = overlap(done["data"], lo, hi)
            u["code"] += c
            u["data"] += d
            u["matched_code"] += mc
            u["matched_data"] += md
            if a["va"] is not None:
                u["functions"].append([a["va"], a["size"], mc, md])
    for u in units:
        # A unit keeps its full extent even when a partial ledger leaves bytes
        # unclassified; those bytes render as not done.
        u["size"] = u.pop("extent")
        u["unclassified"] = u["size"] - u["code"] - u["data"]
        if u["kind"] == "data":
            u.pop("functions")
        else:
            u["function_count"] = len(u["functions"])
            u["functions_complete"] = sum(
                1 for va, sz, mc, md in u["functions"]
                if (va in complete_starts if complete_starts is not None else mc + md == sz))


def build_model(layout, index, evidence_rows, evidence_meta, band_bytes, status, sources):
    units, atoms = build_atoms(layout, index, band_bytes)
    matched_rows, function_classes, complete_starts = [], {}, None
    if evidence_meta["mode"] == "baseline":
        span_by_va = {a["va"]: a for a in atoms if a["kind"] == "code"}
        complete_starts, by_extent = set(), {}
        for claim in evidence_meta["function_claims"]:
            va, size, p = claim["va"], claim["size"], claim["provenance"]
            atom = span_by_va.get(va)
            if claim["audited"] and (atom is None or size > atom["size"]):
                raise ProgressError(f"{claim['manifest']}: audited code is outside its indexed function span")
            complete = bool(atom and p != "exact_range_compiled_c_partial" and
                            size + (claim["data_size"] if claim["audited"] else 0) == atom["size"])
            function_classes.setdefault(p, set())
            if complete:
                function_classes[p].add(va)
                complete_starts.add(va)
            key = (va, size)
            if key not in by_extent:
                by_extent[key] = {k: claim[k] for k in ("va", "size", "symbol", "manifest", "provenance")}
                by_extent[key].update(complete_function=complete, supporting_manifests=[], provenances=[])
            row = by_extent[key]
            row["complete_function"] |= complete
            if claim["manifest"] not in row["supporting_manifests"]:
                row["supporting_manifests"].append(claim["manifest"])
            if p not in row["provenances"]:
                row["provenances"].append(p)
        matched_rows = [by_extent[k] for k in sorted(by_extent)]
    account(units, atoms, evidence_rows, evidence_meta["mode"], complete_starts)
    group_labels = {r["id"]: r["label"] for r in layout["code_regions"]}
    group_labels.update({g["id"]: g["label"] for g in layout["data_groups"]})
    group_order = [r["id"] for r in layout["code_regions"]] + [g["id"] for g in layout["data_groups"]]
    groups = []
    for gid in group_order:
        gu = [u for u in units if u["group"] == gid]
        if not gu:
            continue
        groups.append({"id": gid, "label": group_labels[gid],
                       "kind": "code" if gu[0]["kind"] == "code" else "data",
                       "size": sum(u["size"] for u in gu),
                       "code": sum(u["code"] for u in gu), "data": sum(u["data"] for u in gu),
                       "matched_code": sum(u["matched_code"] for u in gu),
                       "matched_data": sum(u["matched_data"] for u in gu)})
    totals = {
        "file_bytes": layout["file_size"],
        "code": sum(u["code"] for u in units),
        "data": sum(u["data"] for u in units),
        "matched_code": sum(u["matched_code"] for u in units),
        "matched_data": sum(u["matched_data"] for u in units),
        "functions": sum(u.get("function_count", 0) for u in units),
        "functions_complete": sum(u.get("functions_complete", 0) for u in units),
    }
    by_prov, claimed = {}, []
    for p in sorted({p for *_, p in evidence_meta.get("provenance_ranges", [])}):
        ivs = merge_intervals([(a, b) for a, b, q in evidence_meta["provenance_ranges"] if q == p])
        for a, b in ivs:
            if overlap(claimed, a, b):
                raise ProgressError(
                    f"provenance classes overlap near file offset 0x{a:x}; each matched byte "
                    "must belong to exactly one provenance class")
        claimed = merge_intervals([tuple(c) for c in claimed] + [(a, b) for a, b in ivs])
        by_prov[p] = sum(b - a for a, b in ivs)
    totals["by_provenance"] = by_prov
    totals["functions_by_provenance"] = {p: len(vas) for p, vas in sorted(function_classes.items())}
    totals["classified"] = totals["code"] + totals["data"]
    totals["unclassified"] = layout["file_size"] - totals["classified"]
    if totals["unclassified"] and evidence_meta.get("ledger_bytes_covered") is None:
        raise ProgressError("accounted bytes differ from the file size")

    crosscheck = None
    if evidence_meta["mode"] == "baseline" and status is not None:
        want = status.get("unique_matched_bytes")
        crosscheck = {"status_json_unique_matched_bytes": want,
                      "scope": "legacy match manifests only; audited M03 code is added separately",
                      "computed_legacy_matched_code": evidence_meta["legacy_matched_code"],
                      "computed_matched_code": totals["matched_code"],
                      "additional_audited_code": totals["matched_code"] - evidence_meta["legacy_matched_code"],
                      "agrees": want == evidence_meta["legacy_matched_code"]}
    if evidence_meta["mode"] == "baseline":
        totals["functions_complete_manifest"] = len(complete_starts)
    return {
        "schema": SCHEMA,
        "original_sha256": layout["original_sha256"],
        "file_size": layout["file_size"],
        "evidence": {**{k: v for k, v in evidence_meta.items()
                        if k not in ("provenance_ranges", "function_claims")},
                     "sources": sources, "crosscheck": crosscheck},
        "unit_definition": ("Code units are address bands of the indexed function spans "
                            f"({band_bytes // 1024} KiB bands within each code region), a stand-in "
                            "for translation units until a unit map exists. Data units are "
                            "image pieces from layout.json."),
        "band_bytes": band_bytes,
        "totals": totals,
        "groups": groups,
        "units": units,
        "matched_ranges": matched_rows,
    }


# ----------------------------------------------------------------- output --

def pct(n, d):
    if d == 0:
        return "n/a"
    p = 100.0 * n / d
    if p == 0:
        return "0%"
    if p < 1:
        return f"{p:.3f}%"
    return f"{p:.2f}%"


def dump_model(model: dict) -> str:
    """One line per top-level key and per unit/group/range, so diffs stay readable."""
    compact = lambda v: json.dumps(v, separators=(",", ":"))
    lines = []
    for key, val in model.items():
        if isinstance(val, list):
            body = ",\n".join("  " + compact(item) for item in val)
            lines.append(f' "{key}": [\n{body}\n ]' if val else f' "{key}": []')
        else:
            lines.append(f' "{key}": {compact(val)}')
    return "{\n" + ",\n".join(lines) + "\n}\n"


def matched_meaning(model: dict) -> str:
    ev = model["evidence"]
    ver = ev.get("verification", {})
    if ev["mode"] == "baseline":
        how = ("legacy manifest ranges that the repository verifier confirmed byte-exact in this run"
               if ver.get("run") else
               "legacy manifest ranges taken as given and not re-verified in this run")
        if ev.get("tool_assisted_batches"):
            how += (", plus audited M03 code extents bound to the committed source hashes. "
                    "M03 byte comparison and root acceptance of independent annotation review "
                    "are prior evidence, not rerun here")
    elif ver.get("run") and ver.get("kind") == "composed image hash":
        how = ("composer ledger ranges classed `reconstructed` or `structured`; the composed "
               "image hash was checked in this run, the classes are the composer's declaration")
    else:
        how = ("ranges the composer's ledger declares `reconstructed` or `structured`; "
               "declared only, not verified against a composed image in this run")
    return (f"Matched means: {how}. Provenance classes are kept separate below. Nothing here "
            "claims original C++ or compiler provenance, and the whole-file rebuild is incomplete.")


def write_report(model, path: Path):
    t = model["totals"]
    ev = model["evidence"]
    lines = [
        "# GAME.EXE reconstruction progress",
        "",
        "Generated by `decomp-progress/generate.py`; do not edit by hand. "
        "Open `index.html` for the treemap.",
        "",
        *playable_report(model.get("playable")),
        *function_ledger_report(model.get("function_ledger")),
        *(["## x86 matching", ""] if model.get("playable") or model.get("function_ledger") else []),
        f"Evidence mode: **{ev['mode']}**. Original SHA-256 `{model['original_sha256']}`, "
        f"{model['file_size']:,} bytes.",
        "",
        "| Measure | Matched | Total | Share |",
        "|---|---:|---:|---:|",
        f"| Code bytes | {t['matched_code']:,} | {t['code']:,} | {pct(t['matched_code'], t['code'])} |",
        f"| Data bytes | {t['matched_data']:,} | {t['data']:,} | {pct(t['matched_data'], t['data'])} |",
        f"| Whole file | {t['matched_code'] + t['matched_data']:,} | {t['file_bytes']:,} | "
        f"{pct(t['matched_code'] + t['matched_data'], t['file_bytes'])} |",
        *([f"| Unclassified (partial ledger) | n/a | {t['unclassified']:,} | n/a |"] if t.get("unclassified") else []),
        f"| Functions fully matched | {t['functions_complete']:,} | {t['functions']:,} | "
        f"{pct(t['functions_complete'], t['functions'])} |",
        "",
        matched_meaning(model),
        "",
        "| Provenance | Unique matched bytes | Complete function claims |",
        "|---|---:|---:|",
        *([f"| `{p}` | {n:,} | {t['functions_by_provenance'].get(p, 'n/a')} |"
           for p, n in t["by_provenance"].items()] or ["| none | 0 | 0 |"]),
        *(["", "Legacy classes keep overlapping bytes; M03 receives the remaining unique bytes. "
           "Complete function claims are deduplicated within each class but can overlap between "
           "classes; the total above counts each function once. An audited function is complete "
           "only when its code size plus audited table/padding sizes equals its indexed span; "
           "tables and padding remain excluded from matched code."]
          if ev["mode"] == "baseline" else []),
        "",
        "## By group",
        "",
        "| Group | Kind | Bytes | Matched code | Matched data | Share |",
        "|---|---|---:|---:|---:|---:|",
    ]
    for g in model["groups"]:
        lines.append(f"| {g['label']} | {g['kind']} | {g['size']:,} | {g['matched_code']:,} | "
                     f"{g['matched_data']:,} | {pct(g['matched_code'] + g['matched_data'], g['size'])} |")
    hit = [u for u in model["units"] if u["matched_code"] or u["matched_data"]]
    lines += ["", "## Units with matched bytes", ""]
    if hit:
        lines += ["| Unit | Group | Bytes | Matched | Share |", "|---|---|---:|---:|---:|"]
        for u in sorted(hit, key=lambda u: -(u["matched_code"] + u["matched_data"])):
            m = u["matched_code"] + u["matched_data"]
            lines.append(f"| {u['label']} | {u['group']} | {u['size']:,} | {m:,} | {pct(m, u['size'])} |")
    else:
        lines.append("None yet.")
    if model["matched_ranges"]:
        lines += ["", "## Matched ranges (from manifests)", "",
                  "| VA | Code bytes | Symbol | Manifests | Provenance classes | Complete code function |",
                  "|---|---:|---|---|---|---|"]
        for r in model["matched_ranges"]:
            lines.append(f"| 0x{r['va']:08x} | {r['size']} | `{r['symbol']}` | "
                         f"{', '.join(r['supporting_manifests'])} | {', '.join(r['provenances'])} | "
                         f"{'yes' if r['complete_function'] else 'no (partial range)'} |")
    notes = [f"- {model['unit_definition']}"]
    if ev["mode"] == "baseline":
        notes += [
            "- Baseline code totals are function spans (start to next indexed start). A span "
            "also holds the function's switch jump tables and `int 3` padding "
            "(about 10.9 KB in all, M0 report section 3), so baseline code is slightly "
            "overstated and baseline data slightly understated until the M02 ledger splits them.",
            "- M03 tables and padding are excluded from matched code; their data items are "
            "handed to M02. Baseline mode does not ingest composer data evidence; use a ledger "
            "to count structured/reconstructed data."]
    else:
        notes += [
            "- Code and data totals come from the composer ledger, where every classified byte has "
            "a kind; matched data is the ledger's `structured` data ranges."]
        if t.get("unclassified"):
            notes += [f"- {t['unclassified']:,} bytes are unclassified (partial ledger) and are "
                      "counted as not done."]
    notes += ["- Referenced (not yet reconstructed) ranges are reported as not done, never as matched."]
    lines += ["", "## How to read the denominators", "", *notes]
    ver = ev.get("verification", {})
    if ver.get("run") and ver.get("kind") == "composed image hash":
        lines += ["", f"The composed image was hashed in this run and equals the pinned GAME.EXE "
                  f"(`{ver['image_sha256']}`). {ver['scope']}"]
    elif ver.get("run"):
        lines += ["", "Legacy manifests re-verified against the original in this run with "
                  f"`scripts/verify_matches.py` (sha256 `{ver['verifier_sha256']}`): "
                  f"{', '.join(sorted(ver['manifests']))}, all exact."]
        bound = sorted(n for n, m in ver["manifests"].items() if m.get("bound_to_reviewed_hashes"))
        unbound = sorted(n for n, m in ver["manifests"].items() if not m.get("bound_to_reviewed_hashes"))
        lines += ["", "Source and object hashes matched the reviewed values recorded in `status.json` for: "
                  f"{', '.join(bound) or 'none'}. No reviewed hashes are recorded for: "
                  f"{', '.join(unbound) or 'none'} (partial 7-byte C ranges). A fresh reassembly with "
                  "the pinned assembler is not rerun here; the slice audits own that."]
    else:
        lines += ["", f"Byte evidence was **not** re-verified in this run ({ver.get('reason', 'not run')})."]
    if ev.get("tool_assisted_batches"):
        lines += ["", "## Audited M03 batches", "",
                  "| Manifest | Functions | Audited code bytes | Excluded data bytes |",
                  "|---|---:|---:|---:|"]
        for b in ev["tool_assisted_batches"]:
            lines += [f"| {b['manifest']} | {b['functions']} | {b['code_bytes']:,} | {b['excluded_data_bytes']:,} |"]
        lines += ["", "Audit manifest hashes, accepted function records, pinned GNU assembler 2.43.1 "
                  "metadata and current source hashes were checked in this run. The audit reports "
                  "record object/code hashes, no relocations and exact comparisons of code and "
                  "separate data items. The assembler and original executable are not read by "
                  "this metadata check. Publication relies on root's accepted independent review "
                  "of each batch; an audit alone is not review acceptance."]
    ck = ev.get("crosscheck")
    if ck:
        lines += ["", f"Cross-check of **legacy manifests only** against `status.json` unique_matched_bytes "
                  f"({ck['status_json_unique_matched_bytes']}): "
                  f"{'agrees' if ck['agrees'] else 'DISAGREES'}. "
                  f"Audited M03 adds {ck['additional_audited_code']:,} unique code bytes."]
    lines += ["", "## Sources", ""]
    for s in ev["sources"]:
        lines.append(f"- `{s['path']}` sha256 `{s['sha256']}` ({s['role']})")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def playable_report(panel):
    if panel is None:
        return []
    a, tests, stop = panel["action_types"], panel["tests"], panel["stop"]
    at = stop["target_scene"] or stop["scene"]
    line = (f"**Current stop:** {stop['scene']}" +
            (f" → {stop['target_scene']}" if stop["target_scene"] else "") +
            f"; row {stop['row'] if stop['row'] is not None else 'unavailable'} in {at}; " +
            f"type {stop['action_type'] or 'unavailable'}; provider {stop['provider'] or 'unavailable'} " +
            f"({stop['reason']}).")
    lines = ["## Playable build", "",
             f"**Scenes reached:** {len(panel['reached_scenes']):,} / {panel['scene_total']:,} "
             f"({pct(len(panel['reached_scenes']), panel['scene_total'])}).",
             "", " → ".join(panel["reached_scenes"]), "", line, "",
             "| Action body / live dispatch | Types | Corpus records |",
             "|---|---:|---:|",
             *[f"| {label} | {a[key]['type_count']:,} | {a[key]['records']:,} |" for key, label in
               (("typed", "Typed body layouts"), ("opaque", "Opaque bodies"),
                ("handled", "Typed with native live handler (upper bound)"), ("unsupported", "Typed without live handler"))],
             "", "Counts use current parser registrations and the census's per-type record counts. "
             "A registered native handler can still block on an unsupported branch or provider; "
             "these counts do not prove every record or scene playable. The handled record count is an "
             "upper bound: raw `0x15` is a hotspot only when `typed_body[0] == 0x0d`.", "",
             f"**Tests:** {tests['discovered']:,} discovered; {tests['passed']:,} passed; "
             f"{tests['skipped']:,} skipped (committed `status.json` `{tests['source_field']}`).", "",
             f"Test totals come from `status.json` `{tests['source_field']}` at its recorded source "
             f"`{panel.get('test_source_ref') or 'unavailable'}`, which may differ from the live-run commit.", "",
             f"**Next blocker:** {panel['next_blocker']}", ""]
    for key, label in (("handled", "Live handlers"), ("unsupported", "Typed, unsupported"), ("opaque", "Opaque")):
        lines += [f"- {label}: " + ", ".join(f"`{t}`" for t in a[key]["types"])]
    lines += ["", f"Playable evidence: `{panel['schema']}` / `{panel['evidence']['kind']}`; "
              f"source `{panel['evidence']['source_ref']}`; "
              f"native SHA-256 `{panel['evidence']['native_sha256'] or 'unavailable (seed)'}`; "
              f"{panel['ticks']:,} session ticks.", "",
              f"`playable-status.json` sha256 `{panel['status_sha256']}`. "
              "Derivation and limits: `README.md`.", ""]
    return lines


# ------------------------------------------------------- function ledger --

LEDGER_CAVEATS = (
    "Ported is a reviewed claim, not an x86 match: native code or a test covers the function, and the x86 "
    "match stays a separate, orthogonal track.",
    "Tests-only is weaker evidence than oracle-verified (a test names the function, but no original-x86 "
    "oracle window proves it); adapter-tested covers Win32 or library behaviour replaced by a tested "
    "adapter. The three ported classes are reported separately.",
    "Spans include tables, padding and thunks: a span runs from a function start to the next indexed "
    "start, and the Ghidra body size can be smaller.",
    "Region seams are accurate to a few hundred bytes; a seam function is never decided by a rule.",
    "Private receipts are not re-hashed at build time: the page shows only a receipt's name and sha256. "
    "Cited committed src/ and tests/ files are re-hashed, so changing one needs "
    "extract_function_evidence.py --write and build_function_ledger.py --write before this map can be rebuilt.",
)


def function_ledger_report(panel):
    if panel is None:
        return []
    c, n = panel["counts"], panel["total"]
    st, cl, rs = c["status"], c["class"], c["reason"]
    lines = ["## Function ledger", "",
             f"**{n:,} functions:** {st['ported']:,} ported, {st['not_needed']:,} not needed, "
             f"{st['pending']:,} pending ({pct(st['pending'], n)}).", ""]
    if st["ported"] == 0 and st["not_needed"] == 0:
        lines += ["With 0 ported and 0 not needed, this ledger is the honest baseline: every function is pending "
                  "until a reviewed acceptance says otherwise. The pending subclasses are leads, not progress.", ""]
    elif st["pending"] * 5 > n * 4:
        lines += ["More than 80% of functions are still pending at this publication.", ""]
    lines += ["| Status | Class | Functions |", "|---|---|---:|"]
    for status, classes in (("ported", FNL.PORTED_CLASSES), ("not_needed", FNL.NOT_NEEDED_CLASSES),
                            ("pending", FNL.PENDING_CLASSES)):
        lines += [f"| {status} | `{k}` | {cl[k]:,} |" for k in classes]
    lines += ["", "| Region | Functions | Ported | Not needed | Pending |", "|---|---:|---:|---:|---:|"]
    for region in panel["regions"]:
        r = c["region"][region]
        lines.append(f"| {region} | {sum(r.values()):,} | {r['ported']:,} | {r['not_needed']:,} | {r['pending']:,} |")
    lines += ["", "Not needed, by reason: " +
              (", ".join(f"`{k}` {v:,}" for k, v in rs.items() if v) or "none accepted yet") + ".", "",
              "| x86 match vs native port | Ported | Not needed | Pending |", "|---|---:|---:|---:|"]
    labels = {"complete": "x86 complete function match", "partial": "x86 partial range", "none": "no x86 match"}
    for key, label in labels.items():
        row = panel["crosstab"][key]
        lines.append(f"| {label} | {row['ported']:,} | {row['not_needed']:,} | {row['pending']:,} |")
    lines += ["", "Caveats:", "", *[f"- {text}" for text in panel["caveats"]], "",
              f"Ledger `function-ledger.json` sha256 `{panel['ledger_sha256']}`; {panel['input_count']:,} pinned "
              "inputs; see `README.md` for how it is derived and checked.", ""]
    return lines


def function_ledger_panel(root: Path, expected_functions: int):
    """Compact public summary of the committed function ledger, or None when there is none.

    Only committed-file consistency is checked here: the ledger must pass the strict
    schema validation and equal a fresh derivation from the committed, hash-pinned
    inputs. It never reads work/ or GAME.EXE, so private receipt drift is not detected here
    (`extract_function_evidence.py --check` does that); committed src/ and tests/ files cited
    by the evidence are re-hashed, and a changed one fails with `function ledger invalid`."""
    path = root / FUNCTION_LEDGER_FILE
    if not path.is_file():
        return None
    try:
        raw = path.read_bytes()
        ledger = FNL.check(root, path, expected_functions=expected_functions)
    except FNL.LedgerError as exc:
        if str(exc) == FNL.STALE_MESSAGE:
            raise ProgressError(FNL.STALE_MESSAGE) from exc
        raise ProgressError(f"function ledger invalid: {exc}") from exc
    except OSError as exc:
        raise ProgressError(f"cannot read {path.name}: {exc}") from exc
    return compact_function_ledger(ledger, hashlib.sha256(raw).hexdigest())


def compact_function_ledger(ledger: dict, ledger_sha256: str) -> dict:
    """Rows are `[va, span, region_i, status_i, class_i, ev_i]`; `ev_i` indexes `details` (0 = none)."""
    statuses, regions, classes = list(FNL.STATUSES), list(FNL.REGIONS), list(FNL.CLASSES)
    uses, paths, path_ix = list(FNL.USES), [], {}
    receipts, receipt_ix, items, item_ix = [], {}, [], {}     # shared tables keep 4,188 rows small

    def table_index(table, ix, key):
        if key not in ix:
            ix[key] = len(table)
            table.append(list(key))
        return ix[key]

    def path_index(p):
        if p not in path_ix:
            path_ix[p] = len(paths)
            paths.append(p)
        return path_ix[p]

    def pointer(p):
        k = p["kind"]
        if k == "native_source":
            return ["s", path_index(p["path"]), p["symbol"] or ""]
        if k == "test":
            return ["t", path_index(p["path"]), p["test_id"] or ""]
        if k == "oracle":
            return ["o", path_index(p["path"]) if p["path"] else -1,
                    int(p["window"][0], 16), int(p["window"][1], 16), uses.index(p["use"])]
        if k == "receipt":     # private: the page shows the slice name and sha256 only, never a path
            return ["r", table_index(receipts, receipt_ix, (p["slice"], p["sha256"], p["review"]))]
        if p["path"].startswith(FNL.PRIVATE_PREFIX):     # a mention inside a private receipt: its file name only
            return ["n", p["path"].rsplit("/", 1)[-1], p["symbol"] or "", p["via"]]
        return ["m", path_index(p["path"]), p["symbol"] or "", p["via"]]

    rows, details = [], [{}]
    cross = {key: {s: 0 for s in statuses} for key in ("complete", "partial", "none")}
    for e in ledger["entries"]:
        d = {}
        if e["evidence"]:
            d["p"] = [pointer(p) for p in e["evidence"]]
        if e["blockers"]:
            d["b"] = [[int(b["address"], 16), table_index(items, item_ix, (b["id"], b["text"]))]
                      for b in e["blockers"]]
        if e["divergences"]:
            d["d"] = [[table_index(items, item_ix, (v["id"], v["text"])), 1 if v["safety_rejection"] else 0]
                      for v in e["divergences"]]
        if e["reason"]:
            d["r"] = [e["reason"]["code"], e["reason"]["text"], e["reason"]["rule"] or ""]
        if e["review"]:
            d["v"] = [e["review"]["reviewer"], e["review"]["date"], e["review"]["sample"] or ""]
        x = e["x86_match"]
        if x:
            d["x"] = [x["provenance"], 1 if x["complete"] else 0, x["manifest"]]
        if d or e["seam"]:
            d["g"] = [e["origin"], 1 if e["seam"] else 0]
        ev_i = 0
        if d:
            ev_i = len(details)
            details.append(d)
        rows.append([int(e["va"], 16), e["span"], regions.index(e["region"]),
                     statuses.index(e["status"]), classes.index(e["class"]), ev_i])
        cross["complete" if x and x["complete"] else "partial" if x else "none"][e["status"]] += 1
    counts = ledger["counts"]
    # Defence in depth: the compact rows must reproduce the validated counts.
    by_status = [0] * len(statuses)
    by_class = [0] * len(classes)
    by_region = [[0] * len(statuses) for _ in regions]
    for _, _, ri, si, ci, _ in rows:
        by_status[si] += 1
        by_class[ci] += 1
        by_region[ri][si] += 1
    if (by_status != [counts["status"][s] for s in statuses]
            or by_class != [counts["class"][c] for c in classes]
            or by_region != [[counts["region"][r][s] for s in statuses] for r in regions]
            or len(rows) != counts["total"]):
        raise ProgressError("function ledger rows disagree with the ledger counts")
    x86 = counts["x86"]
    if (cross["complete"]["ported"] != x86["complete_ported"]
            or sum(sum(c.values()) for k, c in cross.items() if k != "none") != x86["matched"]
            or sum(cross["complete"].values()) != x86["complete"]):
        raise ProgressError("function ledger x86 cross-tab disagrees with the ledger counts")
    return {"schema": ledger["schema"], "ledger_sha256": ledger_sha256, "total": counts["total"],
            "counts": counts, "statuses": statuses, "regions": regions, "classes": classes,
            "class_status": [statuses.index(FNL.CLASS_STATUS[c]) for c in classes],
            "uses": uses, "crosstab": cross, "caveats": list(LEDGER_CAVEATS), "input_count": len(ledger["inputs"]),
            "paths": paths, "receipts": receipts, "items": items, "details": details, "rows": rows}


def write_html(model, template: Path, path: Path):
    blob = json.dumps(model, separators=(",", ":")).replace("</", "<\\/")
    html = template.read_text(encoding="utf-8").replace("/*__DATA__*/null", blob)
    path.write_text(html, encoding="utf-8")


def write_preview(browser: Path, out_dir: Path):
    """Headless artifact export; no desktop/browser session or visual inspection."""
    import subprocess
    import tempfile
    with tempfile.TemporaryDirectory(prefix="blackmoor-progress-preview-") as profile:
        preview = Path(profile) / "preview.png"
        command = [str(browser.resolve()), "--headless", "--no-sandbox", "--disable-gpu",
                   "--no-first-run", "--disable-background-networking", "--hide-scrollbars",
                   f"--user-data-dir={profile}/profile", "--window-size=1440,1200",
                   "--virtual-time-budget=1000", f"--screenshot={preview}",
                   (out_dir / "index.html").resolve().as_uri() + "?theme=light"]
        try:
            run = subprocess.run(command, capture_output=True, timeout=30)
        except (OSError, subprocess.SubprocessError) as exc:
            raise ProgressError(f"headless preview export failed: {exc}") from exc
        if run.returncode or not preview.is_file():
            raise ProgressError(f"headless preview export failed (exit {run.returncode})")
        (out_dir / "preview.png").write_bytes(preview.read_bytes())


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--out-dir", type=Path, default=HERE, help="where to write outputs")
    ap.add_argument("--evidence-dir", type=Path, default=OUT,
                    help="directory holding function-index.json, matches*.json, asm/batch-*.json, status.json")
    ap.add_argument("--layout", type=Path, default=HERE / "layout.json")
    ap.add_argument("--ledger", type=Path, help="whole-file range ledger (M02-shaped)")
    ap.add_argument("--allow-partial-ledger", action="store_true")
    ap.add_argument("--verify-original", type=Path, metavar="GAME.EXE",
                    help="re-run scripts/verify_matches.py on the legacy match manifests against "
                         "this original; any non-exact manifest is an error")
    ap.add_argument("--verify-root", type=Path,
                    help="directory holding the manifests and their build/ objects "
                         "(default: --evidence-dir); manifests must be byte-identical to the evidence copies")
    ap.add_argument("--verify-image", type=Path, metavar="COMPOSED.EXE",
                    help="with --ledger: the composer's output image; its SHA-256 must equal the "
                         "pinned GAME.EXE hash or the run fails")
    ap.add_argument("--band-kib", type=int, default=16, help="code unit band size in KiB")
    ap.add_argument("--function-ledger-root", type=Path,
                    help="tree holding function-ledger.json and its pinned inputs (default: --evidence-dir; "
                         "a missing function-ledger.json hides the panel)")
    ap.add_argument("--ledger-functions", type=int, default=FNL.EXPECTED_FUNCTIONS,
                    help="pinned function count of function-ledger.json (default: %(default)s; "
                         "fixture trees use their own count)")
    ap.add_argument("--preview-browser", type=Path, help="optional Chromium executable for a headless preview.png export")
    args = ap.parse_args(argv)

    if args.verify_image and not args.ledger:
        print("error: --verify-image needs --ledger", file=sys.stderr)
        return 2
    try:
        layout = load_layout(args.layout)
        index_path = args.evidence_dir / "function-index.json"
        index = load_json(index_path)
        if args.ledger:
            rows, meta = ledger_evidence(layout, args.ledger, args.allow_partial_ledger)
            if args.verify_image:
                if not args.verify_image.is_file():
                    raise ProgressError(f"composed image not found: {args.verify_image}")
                got = sha256_file(args.verify_image)
                if got != PINNED_SHA:
                    raise ProgressError("--verify-image does not hash to the pinned GAME.EXE")
                meta["verification"] = {
                    "run": True, "kind": "composed image hash", "image_sha256": got,
                    "scope": "The image hash is checked here; which ranges are reconstructed or "
                             "structured rather than referenced is the composer's declaration "
                             "and is not independently derivable from the bytes."}
            else:
                meta["verification"] = {"run": False, "reason": "ledger not tied to a composed image; "
                                        "pass --verify-image with the composer's output"}
        else:
            rows, meta = baseline_evidence(layout, args.evidence_dir)
            if args.verify_original:
                root = args.verify_root or args.evidence_dir
                for name in COUNTED_MANIFESTS:
                    if sha256_file(root / name) != sha256_file(args.evidence_dir / name):
                        raise ProgressError(f"{name} under --verify-root differs from the evidence copy")
                meta["verification"] = verify_manifests(
                    COUNTED_MANIFESTS, root, args.verify_original)
                bound = bind_reviewed_artifacts(
                    COUNTED_MANIFESTS, root.resolve(), args.evidence_dir,
                    load_json(args.evidence_dir / "status.json")
                    if (args.evidence_dir / "status.json").exists() else None,
                    starts={int(f["address"], 16) for f in index["functions"]})
                for n, b in bound.items():
                    meta["verification"]["manifests"][n].update(b)
            else:
                meta["verification"] = {"run": False,
                                        "reason": "legacy manifests trusted; pass --verify-original to re-verify them; "
                                                  "M03 audits are prior evidence with current source hashes checked"}
        sources = [{"path": "function-index.json", "sha256": sha256_file(index_path), "role": "index"},
                   {"path": "layout.json", "sha256": sha256_file(args.layout), "role": "layout"}]
        sources += meta.pop("inputs")
        status = None
        sp = args.evidence_dir / "status.json"
        if sp.exists():
            status = load_json(sp)
            sources.append({"path": "status.json", "sha256": sha256_file(sp), "role": "crosscheck"})
        model = build_model(layout, index, rows, meta, args.band_kib * 1024, status, sources)
        if args.evidence_dir == OUT or (args.evidence_dir / "playable-status.json").exists():
            model["playable"] = PLAYABLE.build_panel(args.evidence_dir, status or {})
        panel = function_ledger_panel(args.function_ledger_root or args.evidence_dir, args.ledger_functions)
        if panel is not None:
            model["function_ledger"] = panel
    except (ProgressError, PLAYABLE.PlayableError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    args.out_dir.mkdir(parents=True, exist_ok=True)
    (args.out_dir / "progress.json").write_text(dump_model(model), encoding="utf-8")
    write_report(model, args.out_dir / "REPORT.md")
    write_html(model, HERE / "template.html", args.out_dir / "index.html")
    if args.preview_browser:
        try:
            write_preview(args.preview_browser, args.out_dir)
        except ProgressError as exc:
            print(f"error: {exc}", file=sys.stderr)
            return 2
    t = model["totals"]
    print(f"code {t['matched_code']}/{t['code']}  data {t['matched_data']}/{t['data']}  "
          f"functions {t['functions_complete']}/{t['functions']}  ({meta['mode']})")
    ck = model["evidence"].get("crosscheck")
    if ck and not ck["agrees"]:
        print("warning: status.json unique_matched_bytes disagrees", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
