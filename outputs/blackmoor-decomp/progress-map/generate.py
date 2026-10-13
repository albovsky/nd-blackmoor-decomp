#!/usr/bin/env python3
"""Generate a static local map from explicit source and private evidence roots."""
from __future__ import annotations
import argparse, bisect, datetime as dt, hashlib, json, os, pathlib, re, subprocess

EXPECTED_EXE = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
IMAGE_BASE = 0x400000
U32_LIMIT = 0x100000000
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
    value = report.get("original_sha256") or report.get("original_executable_sha256") or report.get("original_exe_sha256")
    nested = report.get("original")
    if not value and isinstance(nested, dict):
        value = nested.get("sha256") or nested.get("original_sha256")
    return value.lower() if isinstance(value, str) else None

def nonnegative_int(value):
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value if value >= 0 else None
    if isinstance(value, str) and re.fullmatch(r"(?:0[xX][0-9a-fA-F]+|[0-9]+)", value.strip()):
        try:
            return int(value.strip(), 0 if value.strip().lower().startswith("0x") else 10)
        except ValueError:
            pass
    return None

def mismatch_free(report):
    value = report.get("mismatches", report.get("mismatch_count"))
    if isinstance(value, list):
        return not value
    count = nonnegative_int(value)
    return count == 0

def usable_state(report, accepted=()):
    status = report.get("status")
    if status is None:
        return True
    return isinstance(status, str) and status.lower() in set(accepted)

def resolve_manifest(project, manifest_value):
    if not isinstance(manifest_value, str) or not manifest_value:
        return None
    raw = pathlib.Path(manifest_value)
    candidates = []
    local_dir = project / "outputs/blackmoor-decomp"
    if raw.is_absolute():
        candidates.extend((local_dir / raw.name, raw))
    else:
        candidates.extend((project / raw, local_dir / raw, local_dir / raw.name))
    return next((candidate for candidate in candidates if candidate.is_file()), None)

def validate_s08(report):
    reasons = []
    if original_hash(report) != EXPECTED_EXE:
        reasons.append("report original SHA does not match pinned GAME.EXE")
    if report.get("status") != "comparison_complete":
        reasons.append("report state is not comparison_complete")
    comparison = report.get("comparison") if isinstance(report.get("comparison"), dict) else {}
    if comparison.get("status") not in {"toolchain_mismatch_reported", "all_byte_ranges_exact"}:
        reasons.append("comparison state is missing or unusable")
    original = report.get("original") if isinstance(report.get("original"), dict) else {}
    original_size = nonnegative_int(original.get("size"))
    section = report.get("text_section") if isinstance(report.get("text_section"), dict) else {}
    values = {key: nonnegative_int(section.get(key)) for key in ("virtual_address", "virtual_size", "raw_pointer", "raw_size")}
    if original_size is None or original_size <= 0 or original_size != 1511424:
        reasons.append("report original size is missing or inconsistent")
    if any(value is None for value in values.values()):
        reasons.append("text-section bounds are incomplete or negative")
    elif values["virtual_size"] <= 0 or values["raw_size"] <= 0:
        reasons.append("text-section sizes are empty")
    elif values["virtual_address"] + values["virtual_size"] + IMAGE_BASE > U32_LIMIT or values["raw_pointer"] + values["raw_size"] > original_size:
        reasons.append("text-section bounds exceed the pinned image")

    functions = report.get("functions") if isinstance(report.get("functions"), list) else []
    function_count = nonnegative_int(comparison.get("function_count"))
    reported_mismatches = nonnegative_int(comparison.get("mismatch_count"))
    reported_exact = nonnegative_int(comparison.get("exact_byte_range_count"))
    reported_differences = nonnegative_int(comparison.get("difference_count"))
    if not functions or function_count != len(functions):
        reasons.append("function count is missing or inconsistent")
    valid_rows = []
    mismatch_rows = exact_rows = difference_total = 0
    if not any(value is None for value in values.values()) and values["virtual_size"] > 0:
        text_start = IMAGE_BASE + values["virtual_address"]
        text_end = text_start + values["virtual_size"]
        for item in functions:
            start = nonnegative_int(item.get("va"))
            end = nonnegative_int(item.get("end_va"))
            size = nonnegative_int(item.get("size"))
            audit = item.get("range_audit") if isinstance(item.get("range_audit"), dict) else {}
            audit_size = nonnegative_int(audit.get("decoded_size"))
            mismatch_count = nonnegative_int(item.get("mismatch_count"))
            match_status = item.get("match_status")
            row_ok = (start is not None and end is not None and size is not None and start >= text_start and
                      end > start and end <= text_end and end - start == size and audit_size == size and
                      audit.get("complete_to_terminal_ret") is True and mismatch_count is not None)
            if match_status == "byte-range-mismatch":
                row_ok = row_ok and mismatch_count > 0 and item.get("exact_byte_range") is False
                mismatch_rows += 1
                difference_total += mismatch_count
            elif match_status == "exact-byte-range":
                row_ok = row_ok and mismatch_count == 0 and item.get("exact_byte_range") is True
                exact_rows += 1
            else:
                row_ok = False
            if row_ok:
                valid_rows.append(item)
            else:
                reasons.append("one or more audited function ranges are malformed or out of bounds")
                break
    if reported_mismatches != mismatch_rows or reported_exact != exact_rows or reported_differences != difference_total:
        reasons.append("comparison totals do not agree with audited ranges")
    if comparison.get("status") == "all_byte_ranges_exact" and (reported_mismatches != 0 or reported_differences != 0):
        reasons.append("all-exact state conflicts with mismatch totals")
    return {"valid": not reasons, "reason": "; ".join(dict.fromkeys(reasons)) if reasons else "pinned original and comparison/range state verified",
            "text_section": values if not any(value is None for value in values.values()) else None,
            "functions": valid_rows if not reasons else [], "report_original_sha256": original_hash(report)}

def validate_matching(project, report):
    reasons = []
    if original_hash(report) != EXPECTED_EXE:
        reasons.append("matching report original SHA does not match pinned GAME.EXE")
    manifest_original = report.get("manifest_original_sha256")
    if not isinstance(manifest_original, str) or manifest_original.lower() != EXPECTED_EXE:
        reasons.append("matching report manifest binding does not match pinned GAME.EXE")
    manifest_path = resolve_manifest(project, report.get("manifest"))
    manifest = load(manifest_path) if manifest_path else {}
    if not manifest_path:
        reasons.append("bound manifest file is missing")
    elif original_hash(manifest) != EXPECTED_EXE:
        reasons.append("manifest original SHA does not match pinned GAME.EXE")
    if not isinstance(report.get("errors"), list) or report.get("errors"):
        reasons.append("matching report has missing or nonempty errors")
    count_fields = ("mismatch_count", "difference_count", "mismatch_bytes", "difference_bytes", "exact_byte_range_count", "exact_byte_range_bytes", "rejected_count")
    if any(nonnegative_int(report.get(key)) is None for key in count_fields):
        reasons.append("matching report aggregate counts are missing or invalid")
    functions = report.get("functions") if isinstance(report.get("functions"), list) else []
    function_count = nonnegative_int(report.get("function_count"))
    if not functions or function_count != len(functions):
        reasons.append("matching report function count is missing or inconsistent")
    counts = report.get("counts") if isinstance(report.get("counts"), dict) else {}
    mismatch_count = nonnegative_int(report.get("mismatch_count"))
    difference_count = nonnegative_int(report.get("difference_count"))
    exact_count = nonnegative_int(report.get("exact_byte_range_count"))
    rejected_count = nonnegative_int(report.get("rejected_count"))
    if (nonnegative_int(counts.get("functions")) != function_count or
            nonnegative_int(counts.get("mismatches")) != mismatch_count or
            nonnegative_int(counts.get("differences")) != difference_count or
            nonnegative_int(counts.get("exact_byte_ranges")) != exact_count or
            nonnegative_int(counts.get("rejected")) != rejected_count):
        reasons.append("matching aggregate counts do not agree")
    exact_rows = sum(1 for row in functions if isinstance(row, dict) and row.get("exact_byte_range") is True)
    exact_bytes = sum(nonnegative_int(row.get("compared_bytes", row.get("size"))) or 0
                      for row in functions if isinstance(row, dict) and row.get("exact_byte_range") is True)
    byte_totals = report.get("bytes") if isinstance(report.get("bytes"), dict) else {}
    all_exact_expected = mismatch_count == 0 and difference_count == 0 and rejected_count == 0 and exact_count == function_count
    if (exact_count != exact_rows or exact_count + mismatch_count + rejected_count != function_count or
            nonnegative_int(report.get("exact_byte_range_bytes")) != exact_bytes or
            nonnegative_int(byte_totals.get("exact_byte_ranges")) != exact_bytes or
            nonnegative_int(byte_totals.get("differences")) != nonnegative_int(report.get("difference_bytes")) or
            nonnegative_int(byte_totals.get("mismatches")) != nonnegative_int(report.get("mismatch_bytes")) or
            not isinstance(report.get("all_byte_ranges_exact"), bool) or report.get("all_byte_ranges_exact") != all_exact_expected):
        reasons.append("matching exact-range state conflicts with row or mismatch totals")
    manifest_rows = manifest.get("functions") if isinstance(manifest.get("functions"), list) else []
    manifest_keys = {(nonnegative_int(row.get("rva")), nonnegative_int(row.get("size"))) for row in manifest_rows if isinstance(row, dict)}
    if not manifest_keys or len(manifest_keys) != len(manifest_rows) or len(manifest_rows) != len(functions):
        reasons.append("manifest entries are missing or inconsistent")
    elif any((nonnegative_int(row.get("rva")), nonnegative_int(row.get("size"))) not in manifest_keys for row in functions):
        reasons.append("matching report ranges do not match the bound manifest")
    status = report.get("status")
    if status is not None and status not in {"comparison_complete", "exact_byte_ranges", "partial_comparison"}:
        reasons.append("matching report state is unusable")
    return {"valid": not reasons, "reason": "; ".join(dict.fromkeys(reasons)) if reasons else "pinned original, manifest, and aggregate state verified; exact rows are checked individually",
            "manifest_path": manifest_path, "manifest_sha256": digest(manifest_path) if manifest_path else None,
            "report_original_sha256": original_hash(report)}

def merge_exact_ranges(ranges):
    merged = []
    for item in sorted(ranges, key=lambda row: (row["start"], row["start"] + row["size"])):
        end = item["start"] + item["size"]
        if merged and item["start"] < merged[-1]["start"] + merged[-1]["size"]:
            merged[-1]["size"] = max(merged[-1]["start"] + merged[-1]["size"], end) - merged[-1]["start"]
            merged[-1]["bytes"] = merged[-1]["size"]
        else:
            merged.append(dict(item))
    return merged

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
    matching_validation = validate_matching(project, matching)
    matching_manifest_path = matching_validation.pop("manifest_path", None)
    matching_validation["manifest_link"] = href(outdir, matching_manifest_path) if matching_manifest_path else None

    s08_path = evidence / "S08-matching-report.json"
    s08 = load(s08_path)
    s08_validation = validate_s08(s08)
    s08_by_start = {}
    if s08_validation["valid"]:
        for item in s08_validation["functions"]:
            start, end, size = item["va"], item["end_va"], item["size"]
            s08_by_start[start] = {
                "start": start, "end": end, "size": size, "match_status": item["match_status"],
                "mismatch_count": item["mismatch_count"], "evidence_id": item.get("evidence_id"),
                "report_sha256": digest(s08_path),
                "report_link": href(outdir, project / "work/analysis/slices/S08-matching-report.json"),
            }

    exact_by_start = {}
    rejected_exact_ranges = []
    text_meta = s08_validation.get("text_section") if s08_validation["valid"] else None
    if matching_validation["valid"] and not text_meta:
        matching_validation["reason"] += "; no ranges admitted because pinned .text bounds are unavailable"
    if matching_validation["valid"] and text_meta:
        text_start = IMAGE_BASE + text_meta["virtual_address"]
        text_end = text_start + text_meta["virtual_size"]
        for item in matching.get("functions", []):
            if not item.get("exact_byte_range"):
                continue
            rva_value = nonnegative_int(item.get("rva")) if "rva" in item else None
            va_value = nonnegative_int(item.get("va")) if "va" in item else None
            size = nonnegative_int(item.get("compared_bytes", item.get("size")))
            item_size = nonnegative_int(item.get("size", item.get("compared_bytes")))
            differences = item.get("differences")
            object_hash, byte_hash = item.get("object_sha256"), item.get("original_sha256")
            valid = (size is not None and size > 0 and item_size == size and
                     item.get("exact_byte_range") is True and item.get("status") == "exact-byte-range" and
                     differences == [])
            if rva_value is not None:
                start = IMAGE_BASE + rva_value
                valid = valid and (va_value is None or va_value == start)
            else:
                start = va_value
                valid = valid and start is not None
            end = start + size if valid else None
            valid = valid and start >= text_start and end <= text_end and end <= U32_LIMIT
            valid = valid and bool(re.fullmatch(r"[0-9a-fA-F]{64}", str(object_hash))) and object_hash == byte_hash
            if not valid:
                rejected_exact_ranges.append({"reason": "range state, digest, or bounds are invalid", "rva": item.get("rva"), "va": item.get("va")})
                continue
            owner_index = bisect.bisect_right(starts, start) - 1
            if owner_index < 0:
                rejected_exact_ranges.append({"reason": "range does not lie inside an indexed function span", "start": start})
                continue
            owner_start = starts[owner_index]
            owner_end = starts[owner_index + 1] if owner_index + 1 < len(starts) else text_end
            if owner_start in s08_by_start:
                owner_end = s08_by_start[owner_start]["end"]
            if start < owner_start or end > owner_end:
                rejected_exact_ranges.append({"reason": "range crosses its indexed function bound", "start": start, "end": end})
                continue
            exact_by_start.setdefault(owner_start, []).append({
                "start": start, "size": size, "bytes": size,
                "completeness": item.get("function_completeness", "unverified"),
            })
    accepted_exact_source_ranges = sum(len(ranges) for ranges in exact_by_start.values())
    exact_by_start = {start: merge_exact_ranges(ranges) for start, ranges in exact_by_start.items()}
    exact_merged = merge_exact_ranges([item for ranges in exact_by_start.values() for item in ranges])
    matching_validation["accepted_range_count"] = accepted_exact_source_ranges
    matching_validation["rejected_ranges"] = rejected_exact_ranges
    if matching_validation["valid"] and rejected_exact_ranges:
        matching_validation["reason"] += "; rejected %d malformed or out-of-bounds range(s)" % len(rejected_exact_ranges)

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
        state_ok = usable_state(report, {"comparison_complete", "passed", "validated", "validation_passed", "complete", "exact_byte_ranges"})
        report_ok = original_hash(report) == EXPECTED_EXE and mismatch_free(report) and state_ok
        controlled = set()
        for key in ("controlled_boundary", "controlled_hook"):
            value = report.get(key)
            if isinstance(value, dict) and value.get("address"):
                address = nonnegative_int(value["address"])
                if address is not None:
                    controlled.add(address)
        for value in report.get("controlled_hooks", []):
            if isinstance(value, dict) and value.get("address"):
                address = nonnegative_int(value["address"])
                if address is not None:
                    controlled.add(address)
        ranges = list(report.get("code_ranges", []))
        if report.get("function_va"):
            ranges.append({"name": "bounded direct function entry", "start": report["function_va"]})
        rlink = href(outdir, project / "work/analysis/slices" / evname) if evname else href(outdir, project / path)
        entries_for_report, rejected_report_ranges = [], []
        for item in ranges:
            if not isinstance(item, dict):
                continue
            start = nonnegative_int(item.get("start"))
            end = nonnegative_int(item.get("end_exclusive")) if item.get("end_exclusive") is not None else None
            bounded = bool(text_meta and start is not None and IMAGE_BASE + text_meta["virtual_address"] <= start <
                           IMAGE_BASE + text_meta["virtual_address"] + text_meta["virtual_size"] and
                           (end is None or start < end <= IMAGE_BASE + text_meta["virtual_address"] + text_meta["virtual_size"]))
            if not bounded:
                rejected_report_ranges.append({"name": item.get("name", "unnamed range"), "start": item.get("start"), "end_exclusive": item.get("end_exclusive")})
                continue
            kind = "stale-or-failing" if not report_ok else ("controlled-boundary" if start in controlled else ("oracle-bound" if source_bound else "bounded-report"))
            row = {
                "report_id": rid, "report_title": title, "range_name": item.get("name", "original entrypoint"),
                "start": start, "end": end,
                "boundary_basis": item.get("boundary_basis", "report range; no function extent inferred"),
                "kind": kind, "scope": report.get("scope", "scope not recorded"),
                "report_sha256": digest(report_path), "report_link": rlink,
                "source_path": source, "source_link": href(outdir, source_path),
                "source_sha256": current_source_sha, "source_sha256_in_report": expected_source_sha,
                "source_binding": "matched" if source_bound and report_ok else "not source-hash-bound",
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
            "status": "original SHA/state/mismatch checks passed" if report_ok else "quarantined: original SHA, state, or mismatch check failed",
            "report_sha256": digest(report_path), "report_link": rlink,
            "source_path": source, "source_link": href(outdir, source_path),
            "source_binding": "matched" if source_bound else "not source-hash-bound",
            "source_binding_reason": source_binding_reason,
            "binding_report_link": binding_report_link, "binding_report_sha256": binding_report_sha,
            "native_library_sha256": report.get("native_library_sha256"), "entrypoint_count": len(entries_for_report),
            "rejected_range_count": len(rejected_report_ranges), "rejected_ranges": rejected_report_ranges,
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
            "exact_ranges": exact_by_start.get(start, []), "s08_audit": audit,
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

    s08meta = s08_validation.get("text_section") if s08_validation["valid"] else None
    text_start = IMAGE_BASE + s08meta["virtual_address"] if s08meta else None
    text_end = text_start + s08meta["virtual_size"] if s08meta else None
    last_start = starts[-1] if starts else None
    unknown_tail = text_end - last_start if text_end is not None and last_start is not None and text_end >= last_start else None
    index_sha = digest(index_path)
    match_sha = digest(matching_path)
    bindings = [
        {"name": "function-index.json", "sha256": index_sha, "link": href(outdir, index_path), "note": "Ghidra/REA indexed starts; not exact extents"},
        {"name": "matching-report.json", "sha256": match_sha, "link": href(outdir, matching_path), "note": ("accepted: " if matching_validation["valid"] else "quarantined: ") + matching_validation["reason"]},
        {"name": "S08 matching report", "sha256": digest(s08_path), "link": href(outdir, project / "work/analysis/slices/S08-matching-report.json"), "note": ("accepted: " if s08_validation["valid"] else "quarantined: ") + s08_validation["reason"]},
    ] + [{"name": r["title"], "sha256": r["report_sha256"], "link": r["report_link"], "note": r["status"] + " · " + r["scope"]} for r in oracle_reports]
    if matching_manifest_path:
        bindings.append({"name": "Bound exact-range manifest", "sha256": matching_validation["manifest_sha256"],
                         "link": matching_validation["manifest_link"],
                         "note": "Manifest original SHA and its link to GAME.EXE are checked before exact-range display."})
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
    exact_bytes = sum(r["bytes"] for r in exact_merged)
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
                "virtual_size": s08meta["virtual_size"] if s08meta else None,
                "raw_size": s08meta["raw_size"] if s08meta else None,
                "final_indexed_start": last_start, "unresolved_tail_bytes": unknown_tail,
                "validation": s08_validation["reason"],
                "internal_gaps": "not measurable from starts-only index",
                "span_note": "Estimated spans end at the next indexed start and may include padding, data, or gaps; they are not exact body sizes.",
            },
        },
        "summary": {
            "exact_selected_bytes": exact_bytes, "exact_selected_ranges": len(exact_merged),
            "exact_source_ranges": matching_validation.get("accepted_range_count", 0),
            "exact_function_completeness": "unverified", "s08_audited_extents": len(s08_by_start),
            "s08_exact_functions": sum(x["match_status"] == "exact-byte-range" for x in s08_by_start.values()),
            "s08_compiler_mismatches": sum(x["match_status"] == "byte-range-mismatch" for x in s08_by_start.values()),
            "bounded_oracle_source_bound_starts": len(source_bound), "bounded_oracle_report_only_starts": len(report_only),
            "controlled_boundary_starts": len(controlled_starts), "whole_executable_rebuilt": False,
        },
        "functions": functions, "oracle_reports": oracle_reports, "report_bindings": bindings,
        "matching_validation": matching_validation,
        "oracle_coverage": {
            "selected_reports": ["S0 hotspot runtime", "selected action-core handlers", "dependency branch reducer", "phone/control-state handlers", "A-64 original oracle"],
            "omitted_families": ["S01 world-init", "S02 Bink/player", "A28", "A51", "coreCIF", "HIFF", "pixels"],
            "note": "This map adapts only the selected report set listed here; omitted report families are not counted or mapped.",
        },
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
        "s08": {"status": s08.get("status"), "comparison": s08.get("comparison"), "validation": s08_validation,
                "report_sha256": digest(s08_path), "report_link": href(outdir, project / "work/analysis/slices/S08-matching-report.json")},
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
