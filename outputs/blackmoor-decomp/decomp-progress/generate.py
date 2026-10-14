#!/usr/bin/env python3
"""Build the decomp-progress report and treemap for GAME.EXE.

Reads only committed evidence (function index, match manifests, layout facts)
and writes ``progress.json``, ``REPORT.md`` and a self-contained ``index.html``.
It never reads or embeds original bytes.

Two evidence modes:

* baseline (default): matched code comes from the reviewed ``matches*.json``
  manifests; no data bytes are matched yet.
* ledger (``--ledger``): a whole-file range ledger (see README.md, "Range
  ledger contract") supplies code/data kind and class for every file byte.
  This is the shape the M02 composer's coverage report is adapted to.
"""

from __future__ import annotations

import argparse
import bisect
import hashlib
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parent  # outputs/blackmoor-decomp

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
PROVENANCE_RE = r"^[a-z][a-z0-9_]*$"
LEDGER_CLASSES = {"structured", "reconstructed", "referenced"}
LEDGER_KINDS = {"code", "data"}


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


def baseline_evidence(layout: dict, out_dir: Path) -> tuple[list[tuple], dict]:
    """Matched intervals (file offsets, class reconstructed) from manifests."""
    text = next(s for s in layout["sections"] if s["name"] == ".text")
    ivs, inputs, prov = [], [], []
    for name in COUNTED_MANIFESTS:
        path = out_dir / name
        man = load_json(path)
        if man.get("original_sha256") != layout["original_sha256"]:
            raise ProgressError(f"{name}: does not describe the pinned GAME.EXE")
        for fn in man["functions"]:
            rva, size = int(fn["rva"]), int(fn["size"])
            if rva < text["rva"] or rva + size > text["rva"] + text["virt_size"]:
                raise ProgressError(f"{name}: {fn.get('symbol')} is outside .text")
            off = text["raw_off"] + (rva - text["rva"])
            ivs.append((off, off + size, "reconstructed", name, fn.get("symbol", "")))
            prov.append((off, off + size, MANIFEST_PROVENANCE[name]))
        inputs.append({"path": name, "sha256": sha256_file(path), "role": "counted"})
    for name, why in sorted(EXCLUDED_MANIFESTS.items()):
        path = out_dir / name
        if path.exists():
            inputs.append({"path": name, "sha256": sha256_file(path), "role": "excluded",
                           "reason": why})
    return ivs, {"mode": "baseline", "inputs": inputs, "provenance_ranges": prov}


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

def account(units, atoms, evidence_rows, mode):
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
            u["functions_complete"] = sum(1 for _, sz, mc, md in u["functions"] if mc + md == sz)


def build_model(layout, index, evidence_rows, evidence_meta, band_bytes, status, sources):
    units, atoms = build_atoms(layout, index, band_bytes)
    account(units, atoms, evidence_rows, evidence_meta["mode"])
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
    by_prov = {}
    for p in sorted({p for *_, p in evidence_meta.get("provenance_ranges", [])}):
        ivs = merge_intervals([(a, b) for a, b, q in evidence_meta["provenance_ranges"] if q == p])
        by_prov[p] = sum(b - a for a, b in ivs)
    totals["by_provenance"] = by_prov
    totals["classified"] = totals["code"] + totals["data"]
    totals["unclassified"] = layout["file_size"] - totals["classified"]
    if totals["unclassified"] and evidence_meta.get("ledger_bytes_covered") is None:
        raise ProgressError("accounted bytes differ from the file size")

    crosscheck = None
    if evidence_meta["mode"] == "baseline" and status is not None:
        want = status.get("unique_matched_bytes")
        crosscheck = {"status_json_unique_matched_bytes": want,
                      "computed_matched_code": totals["matched_code"],
                      "agrees": want == totals["matched_code"]}

    matched_rows = []
    if evidence_meta["mode"] == "baseline":
        span_by_va = {a["va"]: a for a in atoms if a["kind"] == "code"}
        seen = set()
        for s, e, cls, src, sym in sorted(evidence_rows):
            va = s + layout["image_base"]
            key = (s, e)
            if key in seen:
                continue
            seen.add(key)
            atom = span_by_va.get(va)
            matched_rows.append({
                "va": va, "size": e - s, "symbol": sym, "manifest": src,
                "complete_function": bool(atom and atom["size"] == e - s)})
        totals["functions_complete_manifest"] = sum(1 for r in matched_rows if r["complete_function"])
    return {
        "schema": SCHEMA,
        "original_sha256": layout["original_sha256"],
        "file_size": layout["file_size"],
        "evidence": {**{k: v for k, v in evidence_meta.items() if k != "provenance_ranges"}, "sources": sources, "crosscheck": crosscheck},
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


def write_report(model, path: Path):
    t = model["totals"]
    ev = model["evidence"]
    lines = [
        "# GAME.EXE reconstruction progress",
        "",
        "Generated by `decomp-progress/generate.py`; do not edit by hand. "
        "Open `index.html` for the treemap.",
        "",
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
        "Matched means byte-exact against the original (baseline: manifest ranges the "
        "repository verifier confirms; ledger mode: composer ranges classed `reconstructed` "
        "or `structured`). Provenance classes are kept separate below. Nothing here claims "
        "original C++ or compiler provenance, and the whole-file rebuild is incomplete.",
        "",
        "| Matched bytes by provenance | Bytes |",
        "|---|---:|",
        *([f"| `{p}` | {n:,} |" for p, n in t["by_provenance"].items()] or ["| none | 0 |"]),
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
                  "| VA | Bytes | Symbol | Manifest | Whole indexed function |",
                  "|---|---:|---|---|---|"]
        for r in model["matched_ranges"]:
            lines.append(f"| 0x{r['va']:08x} | {r['size']} | `{r['symbol']}` | {r['manifest']} | "
                         f"{'yes' if r['complete_function'] else 'no (partial range)'} |")
    lines += ["", "## How to read the denominators", "",
              f"- {model['unit_definition']}",
              "- Baseline code totals are function spans (start to next indexed start). A span "
              "also holds the function's switch jump tables and `int 3` padding "
              "(about 10.9 KB in all, M0 report section 3), so baseline code is slightly "
              "overstated and baseline data slightly understated until the M02 ledger splits them.",
              "- Data progress is 0 until the composer reproduces data ranges; no data evidence "
              "exists in the repository today.",
              "- Referenced (not yet reconstructed) ranges are reported as not done, never as matched."]
    ver = ev.get("verification", {})
    if ver.get("run") and ver.get("kind") == "composed image hash":
        lines += ["", f"The composed image was hashed in this run and equals the pinned GAME.EXE "
                  f"(`{ver['image_sha256']}`). {ver['scope']}"]
    elif ver.get("run"):
        lines += ["", "Manifests re-verified against the original in this run with "
                  f"`scripts/verify_matches.py` (sha256 `{ver['verifier_sha256']}`): "
                  f"{', '.join(sorted(ver['manifests']))}, all exact."]
    else:
        lines += ["", f"Evidence was **not** re-verified in this run ({ver.get('reason', 'not run')})."]
    ck = ev.get("crosscheck")
    if ck:
        lines += ["", f"Cross-check against `status.json` unique_matched_bytes "
                  f"({ck['status_json_unique_matched_bytes']}): "
                  f"{'agrees' if ck['agrees'] else 'DISAGREES'}."]
    lines += ["", "## Sources", ""]
    for s in ev["sources"]:
        lines.append(f"- `{s['path']}` sha256 `{s['sha256']}` ({s['role']})")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_html(model, template: Path, path: Path):
    blob = json.dumps(model, separators=(",", ":")).replace("</", "<\\/")
    html = template.read_text(encoding="utf-8").replace("/*__DATA__*/null", blob)
    path.write_text(html, encoding="utf-8")


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--out-dir", type=Path, default=HERE, help="where to write outputs")
    ap.add_argument("--evidence-dir", type=Path, default=OUT,
                    help="directory holding function-index.json, matches*.json, status.json")
    ap.add_argument("--layout", type=Path, default=HERE / "layout.json")
    ap.add_argument("--ledger", type=Path, help="whole-file range ledger (M02-shaped)")
    ap.add_argument("--allow-partial-ledger", action="store_true")
    ap.add_argument("--verify-original", type=Path, metavar="GAME.EXE",
                    help="re-run scripts/verify_matches.py on every counted manifest against "
                         "this original; any non-exact manifest is an error")
    ap.add_argument("--verify-root", type=Path,
                    help="directory holding the manifests and their build/ objects "
                         "(default: --evidence-dir); manifests must be byte-identical to the evidence copies")
    ap.add_argument("--verify-image", type=Path, metavar="COMPOSED.EXE",
                    help="with --ledger: the composer's output image; its SHA-256 must equal the "
                         "pinned GAME.EXE hash or the run fails")
    ap.add_argument("--band-kib", type=int, default=16, help="code unit band size in KiB")
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
            else:
                meta["verification"] = {"run": False,
                                        "reason": "manifests trusted; pass --verify-original to re-verify"}
        sources = [{"path": "function-index.json", "sha256": sha256_file(index_path), "role": "index"},
                   {"path": "layout.json", "sha256": sha256_file(args.layout), "role": "layout"}]
        sources += meta.pop("inputs")
        status = None
        sp = args.evidence_dir / "status.json"
        if sp.exists():
            status = load_json(sp)
            sources.append({"path": "status.json", "sha256": sha256_file(sp), "role": "crosscheck"})
        model = build_model(layout, index, rows, meta, args.band_kib * 1024, status, sources)
    except ProgressError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    args.out_dir.mkdir(parents=True, exist_ok=True)
    (args.out_dir / "progress.json").write_text(dump_model(model), encoding="utf-8")
    write_report(model, args.out_dir / "REPORT.md")
    write_html(model, HERE / "template.html", args.out_dir / "index.html")
    t = model["totals"]
    print(f"code {t['matched_code']}/{t['code']}  data {t['matched_data']}/{t['data']}  "
          f"functions {t['functions_complete']}/{t['functions']}  ({meta['mode']})")
    ck = model["evidence"].get("crosscheck")
    if ck and not ck["agrees"]:
        print("warning: status.json unique_matched_bytes disagrees", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
