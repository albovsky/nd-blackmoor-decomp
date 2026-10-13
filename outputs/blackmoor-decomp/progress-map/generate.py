#!/usr/bin/env python3
"""Generate a static local map from explicit source and private evidence roots."""
from __future__ import annotations
import argparse, datetime as dt, hashlib, json, os, pathlib, re, subprocess

EXPECTED_EXE = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
OUT = pathlib.Path("outputs/blackmoor-decomp/progress-map")
SPECS = [
    ("hotspot-runtime", "S0 hotspot runtime", "outputs/blackmoor-decomp/hotspot-runtime-validation.json", None, "outputs/blackmoor-decomp/src/scene_executor.c", None),
    ("action-core", "Selected action-core handlers", "outputs/blackmoor-decomp/action-core-validation.json", None, "outputs/blackmoor-decomp/src/action_core.c", None),
    ("dependency", "Dependency branch reducer", "outputs/blackmoor-decomp/dependency-validation.json", None, "outputs/blackmoor-decomp/src/scene_dependencies.c", None),
    ("action-ui", "Phone/control-state handlers", "outputs/blackmoor-decomp/action-ui-validation.json", None, "outputs/blackmoor-decomp/src/action_ui.c", None),
    ("action64", "A-64 original oracle", "A-64-original-oracle.json", "A-64-original-oracle.json", "outputs/blackmoor-decomp/src/action_family_64.c", "A-64-validation.json"),
]

def load(path):
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
        return value if isinstance(value, dict) else {}
    except (OSError, json.JSONDecodeError):
        return {}

def digest(path):
    try:
        return hashlib.sha256(path.read_bytes()).hexdigest()
    except OSError:
        return None

def va(value):
    if isinstance(value, int):
        return value
    text = str(value)
    match = re.search(r"0x[0-9a-f]+", text, re.IGNORECASE)
    if match:
        return int(match.group(0), 16)
    return int(text)

def ref(project):
    try:
        return subprocess.check_output(["git", "-C", str(project), "rev-parse", "HEAD"], text=True, stderr=subprocess.DEVNULL).strip()
    except (OSError, subprocess.CalledProcessError):
        return "unavailable"

def href(outdir, path):
    if not path.exists():
        return None
    return pathlib.PurePosixPath(os.path.relpath(str(path), str(outdir))).as_posix()

def original_hash(report):
    return report.get("original_sha256") or report.get("original_executable_sha256") or report.get("original_exe_sha256")

def build_snapshot(project, evidence, generated_utc=None):
    project, evidence = pathlib.Path(project).absolute(), pathlib.Path(evidence).absolute()
    outdir = project / OUT
    index_path = project / "outputs/blackmoor-decomp/function-index.json"
    index = load(index_path)
    if not index.get("functions") or index.get("original_sha256") != EXPECTED_EXE:
        raise ValueError("Function index missing or not bound to the pinned GAME.EXE.")
    entries = sorted(((va(x["address"]), x) for x in index["functions"]), key=lambda x: x[0])
    starts = [x[0] for x in entries]
    if len(starts) != len(set(starts)):
        raise ValueError("Duplicate function starts in index.")

    matching_path = project / "outputs/blackmoor-decomp/matching-report.json"
    matching = load(matching_path)
    exact = {}
    for item in matching.get("functions", []):
        if item.get("exact_byte_range"):
            start = va(item.get("rva", item.get("va", 0))) + (0x400000 if "rva" in item else 0)
            size = int(item.get("compared_bytes", item.get("size", 0)))
            if size:
                exact.setdefault(start, []).append({"start": start, "size": size, "bytes": size, "completeness": item.get("function_completeness", "unverified")})

    s08_path = evidence / "S08-matching-report.json"
    s08 = load(s08_path)
    s08_by_start = {}
    for item in s08.get("functions", []):
        try:
            start, end, size = va(item["va"]), int(item["end_va"]), int(item["size"])
        except (KeyError, TypeError, ValueError):
            continue
        if end > start and end - start == size and item.get("range_audit", {}).get("complete_to_terminal_ret"):
            s08_by_start[start] = {
                "start": start, "end": end, "size": size, "match_status": item.get("match_status"),
                "mismatch_count": item.get("mismatch_count", 0), "evidence_id": item.get("evidence_id"),
                "report_sha256": digest(s08_path),
                "report_link": href(outdir, project / "work/analysis/slices/S08-matching-report.json"),
            }

    oracle_reports, oracle_by_start, oracle_rows = [], {}, []
    for rid, title, path, evname, source, binding_file in SPECS:
        report_path = evidence / evname if evname else project / path
        report = load(report_path)
        if not report:
            continue
        source_path = project / source
        current_source_sha = digest(source_path)
        expected_source_sha = None
        expected_native_sha = None
        binding_report_link = None
        binding_report_sha = None
        if binding_file:
            binding_path = evidence / binding_file
            validation = load(binding_path)
            expected_source_sha = validation.get("source_file_sha256", {}).get("src/action_family_64.c")
            expected_native_sha = validation.get("native_arm64_library_sha256")
            binding_report_link = href(outdir, project / "work/analysis/slices" / binding_file)
            binding_report_sha = digest(binding_path)
        if not binding_file:
            source_binding_reason = "Report does not record a source-file hash binding."
        elif not expected_source_sha:
            source_binding_reason = "Validation report does not record the native source-file hash."
        elif current_source_sha != expected_source_sha:
            source_binding_reason = "Current native source SHA differs from the validation report."
        elif not expected_native_sha:
            source_binding_reason = "Source SHA matches, but validation report has no native-library SHA."
        elif report.get("native_library_sha256") != expected_native_sha:
            source_binding_reason = "Source SHA matches; native-library SHA differs from the validation report."
        else:
            source_binding_reason = "Native source and library SHAs match the validation report."
        source_bound = source_binding_reason.startswith("Native source and library SHAs match")
        mismatch_value = report.get("mismatches", report.get("mismatch_count"))
        mismatch_ok = mismatch_value == 0 or mismatch_value == []
        report_ok = original_hash(report) == EXPECTED_EXE and mismatch_ok
        controlled = set()
        for key in ("controlled_boundary", "controlled_hook"):
            value = report.get(key)
            if isinstance(value, dict) and value.get("address"):
                controlled.add(va(value["address"]))
        for value in report.get("controlled_hooks", []):
            if isinstance(value, dict) and value.get("address"):
                controlled.add(va(value["address"]))
        ranges = list(report.get("code_ranges", []))
        if report.get("function_va"):
            ranges.append({"name": "bounded direct function entry", "start": report["function_va"]})
        rlink = href(outdir, project / "work/analysis/slices" / evname) if evname else href(outdir, project / path)
        entries_for_report = []
        for item in ranges:
            if not item.get("start"):
                continue
            start = va(item["start"])
            kind = "controlled-boundary" if start in controlled else ("stale-or-failing" if not report_ok else ("oracle-bound" if source_bound else "bounded-report"))
            row = {
                "report_id": rid, "report_title": title, "range_name": item.get("name", "original entrypoint"),
                "start": start, "end": va(item["end_exclusive"]) if item.get("end_exclusive") else None,
                "boundary_basis": item.get("boundary_basis", "report range; no function extent inferred"),
                "kind": kind, "scope": report.get("scope", "scope not recorded"),
                "report_sha256": digest(report_path), "report_link": rlink,
                "source_path": source, "source_link": href(outdir, source_path),
                "source_sha256": current_source_sha, "source_sha256_in_report": expected_source_sha,
                "source_binding": "matched" if source_bound else "not source-hash-bound",
                "source_binding_reason": source_binding_reason,
                "binding_report_link": binding_report_link, "binding_report_sha256": binding_report_sha,
                "native_sha256_in_validation": expected_native_sha,
                "native_library_sha256": report.get("native_library_sha256"),
            }
            entries_for_report.append(row)
            oracle_by_start.setdefault(start, []).append(row)
            oracle_rows.append(row)
        oracle_reports.append({
            "id": rid, "title": title, "scope": report.get("scope", "scope not recorded"),
            "status": "original SHA and mismatch check passed" if report_ok else "stale or mismatching report",
            "report_sha256": digest(report_path), "report_link": rlink,
            "source_path": source, "source_link": href(outdir, source_path),
            "source_binding": "matched" if source_bound else "not source-hash-bound",
            "source_binding_reason": source_binding_reason,
            "binding_report_link": binding_report_link, "binding_report_sha256": binding_report_sha,
            "native_library_sha256": report.get("native_library_sha256"), "entrypoint_count": len(entries_for_report),
        })

    functions = []
    for i, (start, item) in enumerate(entries):
        estimated = entries[i + 1][0] - start if i + 1 < len(entries) else None
        audit = s08_by_start.get(start)
        size = audit["size"] if audit else estimated
        span_end = start + size if size is not None else start
        interior_ranges = [dict(row, coverage_location="interior report window; not full function coverage")
                           for row in oracle_rows if start < row["start"] < span_end]
        functions.append({
            "va": start, "address": "0x%06x" % start, "name": item.get("name", "FUN_%08X" % start),
            "evidence_id": item.get("evidence_id", ""), "pseudocode": item.get("file", ""),
            "pseudocode_link": href(outdir, project / "outputs/blackmoor-decomp" / item.get("file", "")),
            "address_unit": ("0x%04x" % (start >> 16)) + "xxxx", "size": size,
            "extent_kind": "complete range audited to terminal return" if audit else ("unknown final extent" if size is None else "next-start address span (estimated)"),
            "exact_ranges": exact.get(start, []), "s08_audit": audit,
            "oracle": oracle_by_start.get(start, []), "oracle_ranges": interior_ranges,
            "is_unknown_extent": size is None,
        })

    registry = load(project / "outputs/blackmoor-decomp/slice-registry.json")
    claims = []
    if evidence.exists():
        for path in sorted(evidence.glob("*claim*.json")):
            claim = load(path)
            sid = claim.get("slice")
            if not sid:
                continue
            claims.append({
                "slice": sid, "owner": claim.get("owner", "owner not recorded"), "status": claim.get("status", "status not recorded"),
                "claim_id": claim.get("claim_id", ""), "commit": claim.get("commit", ""), "file": path.name,
                "sha256": digest(path), "link": href(outdir, project / "work/analysis/slices" / path.name),
            })
    slices = []
    for item in registry.get("slices", []):
        sid = str(item.get("id", ""))
        packet = str(item.get("packet", ""))
        slices.append({
            "id": sid, "title": item.get("title", ""), "registry_status": item.get("status", ""),
            "packet": packet, "packet_link": href(outdir, project / "outputs/blackmoor-decomp" / packet),
            "claims": [c for c in claims if c["slice"] == sid or str(c["slice"]).startswith(sid + "-")],
        })

    s08meta = s08.get("text_section", {})
    text_start = 0x400000 + int(s08meta.get("virtual_address", 0))
    text_end = text_start + int(s08meta.get("virtual_size", 0))
    last_start = starts[-1] if starts else None
    unknown_tail = text_end - last_start if last_start is not None and text_end >= last_start else None
    index_sha = digest(index_path)
    match_sha = digest(matching_path)
    bindings = [
        {"name": "function-index.json", "sha256": index_sha, "link": href(outdir, index_path), "note": "Ghidra/REA indexed starts; not exact extents"},
        {"name": "matching-report.json", "sha256": match_sha, "link": href(outdir, matching_path), "note": "selected byte ranges; completeness unverified"},
        {"name": "S08 matching report", "sha256": digest(s08_path), "link": href(outdir, project / "work/analysis/slices/S08-matching-report.json"), "note": "six complete instruction ranges; all six differ"},
    ] + [{"name": r["title"], "sha256": r["report_sha256"], "link": r["report_link"], "note": r["scope"]} for r in oracle_reports]
    bindings += [
        {"name": r["title"] + " source/library binding", "sha256": r["binding_report_sha256"],
         "link": r["binding_report_link"], "note": "Validation hashes used to bind the report to current source."}
        for r in oracle_reports if r.get("binding_report_link")
    ]

    census_path = project / "outputs/blackmoor-decomp/action-census-current.json"
    census = load(census_path)
    parser_candidates = {
        name: digest(project / name) for name in (
            "outputs/blackmoor-decomp/src/hiff.c",
            "outputs/blackmoor-decomp/src/hiff.h",
            "outputs/blackmoor-decomp/src/scene_resource.c",
        )
    }
    parser_candidates = {k: v for k, v in parser_candidates.items() if v}
    census_bound = census.get("parser_sha256") in parser_candidates.values()
    coord_path = project / "outputs/blackmoor-decomp/COORDINATION-STATUS.md"
    coord_text = coord_path.read_text(encoding="utf-8", errors="replace") if coord_path.exists() else ""
    get_row = lambda needle: next((line.strip() for line in coord_text.splitlines() if needle in line), "")

    if generated_utc is None:
        generated_utc = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
    exact_bytes = sum(r["bytes"] for group in exact.values() for r in group)
    source_bound = {f["va"] for f in functions if any(o["kind"] == "oracle-bound" for o in f["oracle"])}
    report_only = {f["va"] for f in functions if any(o["kind"] == "bounded-report" for o in f["oracle"])}
    controlled_starts = {f["va"] for f in functions if any(o["kind"] == "controlled-boundary" for o in f["oracle"])}
    return {
        "generated_utc": generated_utc, "source_ref": ref(project), "source_root_label": project.name,
        "original": {"sha256": EXPECTED_EXE, "size": 1511424},
        "inventory": {
            "indexed_starts": len(functions), "failures": len(index.get("failures", [])), "provider": "Ghidra 12.1.4 via REA 6.4.0",
            "index_sha256": index_sha, "text_section": {
                "start_va": text_start, "end_va_exclusive": text_end,
                "virtual_size": int(s08meta.get("virtual_size", 0)), "raw_size": int(s08meta.get("raw_size", 0)),
                "final_indexed_start": last_start, "unresolved_tail_bytes": unknown_tail,
                "internal_gaps": "not measurable from starts-only index",
                "span_note": "Estimated spans end at the next indexed start and may include padding, data, or gaps; they are not exact body sizes.",
            },
        },
        "summary": {
            "exact_selected_bytes": exact_bytes, "exact_selected_ranges": sum(map(len, exact.values())),
            "exact_function_completeness": "unverified", "s08_audited_extents": len(s08_by_start),
            "s08_exact_functions": sum(x["match_status"] == "exact-byte-range" for x in s08_by_start.values()),
            "s08_compiler_mismatches": sum(x["match_status"] == "byte-range-mismatch" for x in s08_by_start.values()),
            "bounded_oracle_source_bound_starts": len(source_bound), "bounded_oracle_report_only_starts": len(report_only),
            "controlled_boundary_starts": len(controlled_starts), "whole_executable_rebuilt": False,
        },
        "functions": functions, "oracle_reports": oracle_reports, "report_bindings": bindings,
        "slices": slices, "coordination": {
            "source_link": href(outdir, coord_path), "source_sha256": digest(coord_path),
            "s03_row": get_row("| S03 AVF |"), "s05_row": get_row("| S05 caption"),
            "note": "The coordination table may lag newer claim receipts; both are shown.",
        },
        "census": {
            "included_in_metrics": census_bound,
            "state": "bound to a current parser candidate" if census_bound else "suppressed: saved parser SHA does not match current parser-source candidates",
            "saved_report_sha256": digest(census_path), "saved_parser_sha256": census.get("parser_sha256"),
            "current_parser_sources": parser_candidates, "report_link": href(outdir, census_path),
        },
        "s08": {"status": s08.get("status"), "comparison": s08.get("comparison"), "report_sha256": digest(s08_path),
                "report_link": href(outdir, project / "work/analysis/slices/S08-matching-report.json")},
    }

def embed(template, snapshot):
    payload = json.dumps(snapshot, ensure_ascii=False, separators=(",", ":"))
    for a, b in (("&", "\\u0026"), ("<", "\\u003c"), (">", "\\u003e"), ("\u2028", "\\u2028"), ("\u2029", "\\u2029")):
        payload = payload.replace(a, b)
    if template.count("__SNAPSHOT_JSON__") != 1:
        raise ValueError("Template needs one snapshot marker.")
    return template.replace("__SNAPSHOT_JSON__", payload)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=pathlib.Path, required=True)
    parser.add_argument("--evidence-root", type=pathlib.Path, required=True)
    args = parser.parse_args()
    outdir = args.project_root / OUT
    outdir.mkdir(parents=True, exist_ok=True)
    snapshot = build_snapshot(args.project_root, args.evidence_root)
    template = pathlib.Path(__file__).with_name("app-template.html").read_text(encoding="utf-8")
    (outdir / "snapshot.json").write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (outdir / "index.html").write_text(embed(template, snapshot), encoding="utf-8")
    print("wrote %s (%d starts, source %s)" % (outdir / "index.html", len(snapshot["functions"]), snapshot["source_ref"][:12]))

if __name__ == "__main__":
    main()
