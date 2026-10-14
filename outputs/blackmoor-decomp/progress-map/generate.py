#!/usr/bin/env python3
"""Generate a static local map from explicit source and private evidence roots."""
from __future__ import annotations
import argparse, bisect, datetime as dt, hashlib, json, os, pathlib, re, subprocess

EXPECTED_EXE = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
IMAGE_BASE = 0x400000
U32_LIMIT = 0x100000000
OUT = pathlib.Path("outputs/blackmoor-decomp/progress-map")
MATCHING_REPORT = pathlib.Path("outputs/blackmoor-decomp/matching-report.json")
MATCHING_REPORT_COPY = pathlib.Path("evidence/matching-report.json")
MATCHING_REPORT_COPY_LIMIT = 64 * 1024
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

S08_2_ACCEPTED_PINS = {
    "report_sha256": "144fc98e793d83d054b7698fd6cbfcea8f857b22454fa9e6fad5f828738a36e1",
    "manifest_sha256": "0e5cea6eb58e4f33604600146198d3677461e7b224e9217447040be30a971f03",
    "source_sha256": "22de8caa942c3b26f278137158ae86cbe759f4309d143e811e9aac5e64b8c22a",
    "object_sha256": "ca083f3fa44e665a22c0a1006b10cf1bb082c7904c855b0804a9eb6b920167e7",
    "assembler_sha256": "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b",
    "semantic_report_sha256": "782c2040d4f267649f50670519cb596e3dddea16fd8612b25e306bec618855ce",
    "c_source_sha256": "742cfcb8fec4ae0fcbfe846034b977b5f3ebcd00af2049117b2aa24fd6ab6b8a",
    "cpp_source_sha256": "8173835c2f0f36be8371fef3bd4cb30633ed3eff74975d2fb32fcfb4b022da5a",
}
S08_2_REPORT_NAME = "S08-2-x86-report.json"
S08_2_SEMANTIC_REPORT_NAME = "S08-2-report.json"
S08_2_SOURCE_REF = "outputs/blackmoor-decomp/src/matching_s08_2_x86.s"
S08_2_MANIFEST_REF = "outputs/blackmoor-decomp/matches_s08_2_x86.json"
S08_2_OBJECT_REF = "outputs/blackmoor-decomp/build/matching_s08_2_x86.obj"
S08_2_BUILD_SCRIPTS = {
    "assembly_sha256": "outputs/blackmoor-decomp/scripts/build_matching_s08_2_x86.sh",
    "audit_sha256": "outputs/blackmoor-decomp/scripts/audit_matching_s08_2_x86.py",
    "assembler_bootstrap_sha256": "outputs/blackmoor-decomp/scripts/bootstrap_matching_s08_2_gas.sh",
}
S08_3_ACCEPTED_PINS = {
    "report_sha256": "9ae5742ff7a57e1b8f02d9db7f85a5142b3bc7d059f911042dcff4abc5cbd586",
    "manifest_sha256": "f662172b6cc38b782b0d5dfd1a3a054791a2681dfe2a9e10e8befb542d538987",
    "source_sha256": "b5ed9ea6659e8c179cc796cbcd0c4494b950ddbaadebed185cad92998f98ff44",
    "object_sha256": "d943f78bf39e41efa4f12b48a69777f74fc1898beaf64d8af9900c92af52d25e",
    "assembler_sha256": "459ab053b16d25841cf302ece6f5ddd65ebd0f33a91fbbb6c6a665b74de0565b",
}
S08_3_REPORT_NAME = "S08-3-x86-report.json"
S08_3_SOURCE_REF = "outputs/blackmoor-decomp/src/matching_s08_3_x86.s"
S08_3_MANIFEST_REF = "outputs/blackmoor-decomp/matches_s08_3_x86.json"
S08_3_OBJECT_REF = "outputs/blackmoor-decomp/build/matching_s08_3_x86.obj"
S08_3_ASSEMBLER_REF = "work/tools/s08-binutils-2.43.1/prefix/bin/i686-w64-mingw32-as"
S08_3_FUNCTIONS = (
    {"rva": 0x0DAF9F, "va": 0x4DAF9F, "size": 36, "symbol": "_FUN_004daf9f", "object_offset": 0},
    {"rva": 0x0DAFC3, "va": 0x4DAFC3, "size": 61, "symbol": "_FUN_004dafc3", "object_offset": 36},
    {"rva": 0x0DB000, "va": 0x4DB000, "size": 79, "symbol": "_FUN_004db000", "object_offset": 97},
)

def resolve_project_file(project, reference):
    if not isinstance(reference, str) or not reference:
        return None
    raw = pathlib.Path(reference)
    candidate = raw if raw.is_absolute() else pathlib.Path(project) / raw
    return candidate if candidate.is_file() else None

def validate_s08_2(project, evidence, report, report_path, text_section, object_path=None, binding_root=None):
    """Admit only the root-pinned, reviewed S08-2 assembly and its current files."""
    project, evidence = pathlib.Path(project), pathlib.Path(evidence)
    reasons = []
    report_sha = digest(report_path) if report_path else None
    if report_sha != S08_2_ACCEPTED_PINS["report_sha256"]:
        reasons.append("S08-2 report SHA is not the root-accepted snapshot")
    if not report:
        reasons.append("S08-2 report is missing or malformed")
        report = {}

    original = report.get("original") if isinstance(report.get("original"), dict) else {}
    if original.get("sha256") != EXPECTED_EXE or nonnegative_int(original.get("size")) != 1511424:
        reasons.append("S08-2 report is not bound to the pinned GAME.EXE size and SHA")
    original_path = resolve_project_file(project, original.get("path"))
    if not original_path:
        reasons.append("pinned original file is missing")
    elif digest(original_path) != EXPECTED_EXE or original_path.stat().st_size != 1511424:
        reasons.append("current original file does not match the pinned executable")

    if report.get("status") != "exact_match_from_reviewed_reconstructed_assembly_source":
        reasons.append("S08-2 report status is not the accepted reviewed-assembly state")
    if report.get("classification") != "explicit_reconstructed_assembly_source":
        reasons.append("S08-2 report classification is not explicit reconstructed assembly")
    if report.get("compiler_generated_C_claim") is not False:
        reasons.append("S08-2 report makes an unsupported compiler-generated-C claim")
    if report.get("whole_executable_rebuilt") is not False:
        reasons.append("S08-2 report must leave whole-executable rebuild incomplete")

    source_info = report.get("source") if isinstance(report.get("source"), dict) else {}
    source_ref = source_info.get("path")
    source_path = resolve_project_file(project, source_ref)
    source_sha = source_info.get("sha256")
    association = report.get("source_object_association") if isinstance(report.get("source_object_association"), dict) else {}
    if source_ref != S08_2_SOURCE_REF or association.get("source_path") != S08_2_SOURCE_REF:
        reasons.append("S08-2 source path is not the reviewed source path")
    if not source_path:
        reasons.append("reviewed S08-2 assembly source is missing")
    elif digest(source_path) != source_sha or digest(source_path) != S08_2_ACCEPTED_PINS["source_sha256"]:
        reasons.append("current S08-2 source SHA differs from the reviewed source pin")
    if source_sha != S08_2_ACCEPTED_PINS["source_sha256"] or association.get("source_sha256") != source_sha:
        reasons.append("S08-2 source report hashes disagree with the reviewed source pin")
    if association.get("canonical_reviewed_source_sha256") != S08_2_ACCEPTED_PINS["source_sha256"] or association.get("matches_canonical_reviewed_source") is not True:
        reasons.append("S08-2 source is not bound to the canonical reviewed source")
    if association.get("historical_provenance_claim") is not False:
        reasons.append("S08-2 source provenance must not claim historical original-source identity")
    if association.get("status") != "verified_reassembly_match" or association.get("reassembly_error") is not None or association.get("reassembly_matches_audited_object") is not True:
        reasons.append("S08-2 fresh source reassembly did not verify")

    manifest_info = report.get("manifest") if isinstance(report.get("manifest"), dict) else {}
    manifest_ref = manifest_info.get("path")
    manifest_path = resolve_project_file(project, manifest_ref)
    manifest = load(manifest_path) if manifest_path else {}
    manifest_sha = digest(manifest_path) if manifest_path else None
    if manifest_ref != S08_2_MANIFEST_REF:
        reasons.append("S08-2 manifest path is not the reviewed manifest")
    if not manifest_path:
        reasons.append("S08-2 matching manifest is missing")
    elif manifest_sha != manifest_info.get("sha256") or manifest_sha != S08_2_ACCEPTED_PINS["manifest_sha256"]:
        reasons.append("current S08-2 manifest SHA differs from the reviewed manifest pin")
    if manifest.get("original_sha256") != EXPECTED_EXE:
        reasons.append("S08-2 manifest is not bound to the pinned GAME.EXE")
    if manifest.get("source") != "src/matching_s08_2_x86.s":
        reasons.append("S08-2 manifest refers to a different assembly source")

    object_info = report.get("object") if isinstance(report.get("object"), dict) else {}
    binding = report.get("comparison_binding") if isinstance(report.get("comparison_binding"), dict) else {}
    object_ref = object_info.get("path")
    if object_ref != S08_2_OBJECT_REF or binding.get("object_path") != object_ref:
        reasons.append("S08-2 comparison does not name the accepted object path")
    actual_object_path = pathlib.Path(object_path) if object_path else resolve_project_file(project, object_ref)
    object_sha = digest(actual_object_path) if actual_object_path and actual_object_path.is_file() else None
    object_size = actual_object_path.stat().st_size if actual_object_path and actual_object_path.is_file() else None
    if not actual_object_path or not actual_object_path.is_file():
        reasons.append("current supplied S08-2 object file is missing")
    elif object_sha != object_info.get("sha256") or object_sha != S08_2_ACCEPTED_PINS["object_sha256"] or object_size != nonnegative_int(object_info.get("size")):
        reasons.append("current supplied S08-2 object differs from the audited object pin")
    if binding.get("object_file_sha256") != object_info.get("sha256"):
        reasons.append("S08-2 supplied-object comparison digest does not match the report object")
    if association.get("audited_object_sha256") != object_info.get("sha256") or association.get("reassembled_object_sha256") != object_info.get("sha256"):
        reasons.append("S08-2 object is not bound to both supplied comparison and fresh reassembly")
    if binding.get("strategy") != "ephemeral manifest rewrites every function object to the supplied --object path before verification":
        reasons.append("S08-2 comparison does not record supplied-object manifest binding")

    binding_root = pathlib.Path(binding_root) if binding_root else project
    binding_object = pathlib.Path(object_ref) if isinstance(object_ref, str) else pathlib.Path("__missing_object__")
    if not binding_object.is_absolute():
        binding_object = binding_root / binding_object
    try:
        effective_manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path else {}
        for row in effective_manifest.get("functions", []):
            if isinstance(row, dict):
                row["object"] = str(binding_object.resolve())
        encoded_manifest = json.dumps(effective_manifest, indent=2, sort_keys=True).encode("utf-8") + b"\n"
        effective_sha = hashlib.sha256(encoded_manifest).hexdigest()
    except (OSError, json.JSONDecodeError, TypeError):
        effective_sha = None
    if (not re.fullmatch(r"[0-9a-f]{64}", str(binding.get("effective_manifest_sha256"))) or
            effective_sha != binding.get("effective_manifest_sha256")):
        reasons.append("S08-2 effective supplied-object manifest digest does not reproduce")

    assembler = report.get("assembler") if isinstance(report.get("assembler"), dict) else {}
    reproduction = assembler.get("reproduction_command")
    assembler_path = pathlib.Path(reproduction[0]) if isinstance(reproduction, list) and reproduction and isinstance(reproduction[0], str) else None
    assembler_sha = digest(assembler_path) if assembler_path and assembler_path.is_file() else None
    if not assembler_path or assembler_sha != assembler.get("binary_sha256") or assembler_sha != S08_2_ACCEPTED_PINS["assembler_sha256"]:
        reasons.append("pinned S08-2 assembler binary is missing or has a different SHA")

    script_pins = report.get("build_scripts") if isinstance(report.get("build_scripts"), dict) else {}
    for report_key, relative_path in S08_2_BUILD_SCRIPTS.items():
        current_script_sha = digest(project / relative_path)
        if not current_script_sha or current_script_sha != script_pins.get(report_key):
            reasons.append("current S08-2 build/audit script differs from its report pin: " + relative_path)

    index_path = project / "outputs/blackmoor-decomp/function-index.json"
    index = load(index_path)
    index_sha = digest(index_path)
    inventory = report.get("range_inventory") if isinstance(report.get("range_inventory"), dict) else {}
    if inventory.get("source") != "outputs/blackmoor-decomp/function-index.json" or inventory.get("source_sha256") != index_sha:
        reasons.append("S08-2 function inventory is stale against the current index")
    if nonnegative_int(inventory.get("indexed_functions")) != len(index.get("functions", [])) or nonnegative_int(inventory.get("index_failures")) != len(index.get("failures", [])):
        reasons.append("S08-2 function inventory counts do not match the current index")

    functions = report.get("functions") if isinstance(report.get("functions"), list) else []
    comparison = report.get("comparison") if isinstance(report.get("comparison"), dict) else {}
    comparison_rows = comparison.get("functions") if isinstance(comparison.get("functions"), list) else []
    manifest_rows = manifest.get("functions") if isinstance(manifest.get("functions"), list) else []
    if not functions or nonnegative_int(report.get("function_count")) != len(functions) or len(comparison_rows) != len(functions):
        reasons.append("S08-2 function/comparison row counts are missing or inconsistent")
    sizes = [nonnegative_int(row.get("size")) if isinstance(row, dict) else None for row in functions]
    if any(size is None or size <= 0 for size in sizes):
        reasons.append("S08-2 function row has a missing or invalid size")
    total_bytes = sum(size for size in sizes if size is not None)
    if (nonnegative_int(report.get("compared_bytes")) != total_bytes or
            nonnegative_int(comparison.get("compared_bytes")) != total_bytes or
            nonnegative_int(comparison.get("function_count")) != len(functions) or
            nonnegative_int(comparison.get("exact_byte_range_count")) != len(functions) or
            nonnegative_int(comparison.get("mismatch_count")) != 0 or
            nonnegative_int(comparison.get("difference_count")) != 0 or
            nonnegative_int(comparison.get("rejected_count")) != 0 or
            comparison.get("all_byte_ranges_exact") is not True):
        reasons.append("S08-2 aggregate comparison counts do not agree with function rows")

    text_start = IMAGE_BASE + text_section["virtual_address"] if isinstance(text_section, dict) else None
    text_end = text_start + text_section["virtual_size"] if text_start is not None else None
    index_starts = sorted(va(row["address"]) for row in index.get("functions", []) if isinstance(row, dict) and "address" in row)
    manifest_map = {}
    for row in manifest_rows:
        if not isinstance(row, dict):
            continue
        key = (nonnegative_int(row.get("rva")), nonnegative_int(row.get("size")), row.get("symbol"))
        if None in key[:2] or key in manifest_map:
            reasons.append("S08-2 manifest has malformed or duplicate extents")
        manifest_map[key] = row
    if len(manifest_rows) != len(functions) or len(manifest_map) != len(manifest_rows):
        reasons.append("S08-2 manifest row count is inconsistent")

    valid_rows = []
    seen_symbols, seen_starts = set(), set()
    for row in functions:
        if not isinstance(row, dict):
            reasons.append("S08-2 report has a non-object function row")
            continue
        rva_value, start, size = nonnegative_int(row.get("rva")), nonnegative_int(row.get("va")), nonnegative_int(row.get("size"))
        end = nonnegative_int(row.get("end_va"))
        symbol, evidence_id = row.get("symbol"), row.get("evidence_id")
        if (not isinstance(symbol, str) or not symbol or not isinstance(evidence_id, str) or not evidence_id or
                rva_value is None or start is None or size is None or end is None or start != IMAGE_BASE + rva_value or end != start + size):
            reasons.append("S08-2 function RVA/VA/size/end fields are inconsistent")
            continue
        if symbol in seen_symbols or start in seen_starts:
            reasons.append("S08-2 function rows contain duplicate symbols or starts")
            continue
        seen_symbols.add(symbol); seen_starts.add(start)
        if text_start is None or start < text_start or end > text_end or end > U32_LIMIT:
            reasons.append("S08-2 function extent is outside the pinned .text range")
            continue
        index_pos = bisect.bisect_left(index_starts, start)
        next_start = index_starts[index_pos + 1] if index_pos + 1 < len(index_starts) else None
        audit = row.get("range_audit") if isinstance(row.get("range_audit"), dict) else {}
        candidate_audit = row.get("candidate_audit") if isinstance(row.get("candidate_audit"), dict) else {}
        byte_check = row.get("byte_comparison") if isinstance(row.get("byte_comparison"), dict) else {}
        original_instructions = audit.get("instructions") if isinstance(audit.get("instructions"), list) else []
        candidate_instructions = candidate_audit.get("instructions") if isinstance(candidate_audit.get("instructions"), list) else []
        def instruction_run(instructions, initial):
            cursor = initial
            for instruction in instructions:
                if not isinstance(instruction, dict):
                    return False
                address, instruction_size = nonnegative_int(instruction.get("address")), nonnegative_int(instruction.get("size"))
                if address != cursor or instruction_size is None or instruction_size <= 0:
                    return False
                cursor += instruction_size
            return cursor
        original_end = instruction_run(original_instructions, start)
        object_offset = nonnegative_int(candidate_audit.get("object_offset"))
        candidate_end = instruction_run(candidate_instructions, object_offset) if object_offset is not None else None
        terminal_original = original_instructions[-1].get("mnemonic") if original_instructions and isinstance(original_instructions[-1], dict) else None
        terminal_candidate = candidate_instructions[-1].get("mnemonic") if candidate_instructions and isinstance(candidate_instructions[-1], dict) else None
        if (audit.get("complete_to_terminal_ret") is not True or nonnegative_int(audit.get("decoded_size")) != size or
                original_end != end or terminal_original != "ret" or nonnegative_int(audit.get("instruction_count")) != len(original_instructions) or
                object_offset is None or candidate_end != object_offset + size or
                nonnegative_int(candidate_audit.get("size")) != size or terminal_candidate != "ret" or
                nonnegative_int(candidate_audit.get("instruction_count")) != len(candidate_instructions) or
                next_start != end or nonnegative_int(audit.get("next_indexed_start_va")) != end):
            reasons.append("S08-2 function extent lacks contiguous terminal-return/index-bound evidence")
            continue
        if (byte_check.get("status") != "exact-byte-range" or nonnegative_int(byte_check.get("size")) != size or
                nonnegative_int(byte_check.get("mismatch_count")) != 0 or byte_check.get("mismatch_offsets") != [] or
                byte_check.get("candidate_sha256") != row.get("original_sha256") or
                byte_check.get("original_sha256") != row.get("original_sha256") or
                byte_check.get("contains_original_byte_values") is not False):
            reasons.append("S08-2 per-function exact comparison row is malformed")
            continue
        comparison_row = next((item for item in comparison_rows if isinstance(item, dict) and item.get("symbol") == symbol), None)
        if (not comparison_row or comparison_row.get("status") != "exact-byte-range" or
                nonnegative_int(comparison_row.get("size")) != size or nonnegative_int(comparison_row.get("mismatch_count")) != 0 or
                comparison_row.get("mismatch_offsets") != [] or comparison_row.get("candidate_sha256") != row.get("original_sha256") or
                comparison_row.get("original_sha256") != row.get("original_sha256")):
            reasons.append("S08-2 aggregate comparison row does not match the audited function")
            continue
        manifest_row = manifest_map.get((rva_value, size, symbol))
        expected_manifest_object = pathlib.PurePosixPath(S08_2_OBJECT_REF).relative_to("outputs/blackmoor-decomp").as_posix()
        if (not manifest_row or manifest_row.get("object") != expected_manifest_object or
                manifest_row.get("evidence_id") != evidence_id):
            reasons.append("S08-2 function extent is not present in the pinned manifest")
            continue
        if start not in index_starts:
            reasons.append("S08-2 function start is absent from the current function index")
            continue
        valid_rows.append({
            "start": start, "end": end, "size": size, "symbol": symbol, "rva": rva_value,
            "evidence_id": evidence_id, "report_sha256": report_sha,
        })
    if len(valid_rows) != len(functions):
        reasons.append("not every S08-2 function row passed source, object, manifest, and extent checks")
    ranges = sorted(valid_rows, key=lambda row: row["start"])
    for left, right in zip(ranges, ranges[1:]):
        if left["end"] > right["start"]:
            reasons.append("S08-2 exact function extents overlap")
            break

    semantic = report.get("semantic_C_and_CPP") if isinstance(report.get("semantic_C_and_CPP"), dict) else {}
    semantic_path = evidence / S08_2_SEMANTIC_REPORT_NAME
    semantic_report = load(semantic_path)
    if (semantic.get("semantic_evidence_remains_separate") is not True or
            nonnegative_int(semantic.get("C_O0_difference_count")) != 62 or
            nonnegative_int(semantic.get("C_O0_exact_ranges")) != 0 or
            nonnegative_int(semantic.get("C_plus_plus_O0_difference_count")) != 66 or
            nonnegative_int(semantic.get("C_plus_plus_O0_exact_ranges")) != 0):
        reasons.append("S08-2 C/C++ mismatch summary is missing or internally inconsistent")
    semantic_c = semantic_report.get("comparison") if isinstance(semantic_report.get("comparison"), dict) else {}
    semantic_cpp = semantic_report.get("cpp_comparison") if isinstance(semantic_report.get("cpp_comparison"), dict) else {}
    expected_semantic_sources = {
        "outputs/blackmoor-decomp/src/matching_s08.c": S08_2_ACCEPTED_PINS["c_source_sha256"],
        "outputs/blackmoor-decomp/src/matching_s08_2.cpp": S08_2_ACCEPTED_PINS["cpp_source_sha256"],
    }
    matrix = semantic_report.get("compiler_matrix") if isinstance(semantic_report.get("compiler_matrix"), list) else []
    matrix_by_name = {row.get("name"): row for row in matrix if isinstance(row, dict)}
    c_o0, cpp_o0 = matrix_by_name.get("C-O0", {}), matrix_by_name.get("C++-O0", {})
    source_files = semantic_report.get("source_files") if isinstance(semantic_report.get("source_files"), dict) else {}
    if (semantic_report.get("status") != "comparison_complete_no_exact_match" or
            digest(semantic_path) != S08_2_ACCEPTED_PINS["semantic_report_sha256"] or
            original_hash(semantic_report) != EXPECTED_EXE or
            semantic_report.get("whole_executable_rebuilt") is not False or
            nonnegative_int(semantic_c.get("difference_count")) != 62 or
            nonnegative_int(semantic_c.get("function_count")) != 6 or
            nonnegative_int(semantic_c.get("mismatch_count")) != 6 or
            nonnegative_int(semantic_cpp.get("difference_count")) != 66 or
            nonnegative_int(semantic_cpp.get("function_count")) != 6 or
            nonnegative_int(semantic_cpp.get("mismatch_count")) != 6 or
            nonnegative_int(semantic_c.get("exact_byte_range_count")) != 0 or
            nonnegative_int(semantic_cpp.get("exact_byte_range_count")) != 0 or
            source_files != expected_semantic_sources or
            c_o0.get("status") != "toolchain_mismatch_reported" or
            c_o0.get("source") != "outputs/blackmoor-decomp/src/matching_s08.c" or
            c_o0.get("source_sha256") != expected_semantic_sources["outputs/blackmoor-decomp/src/matching_s08.c"] or
            nonnegative_int(c_o0.get("function_count")) != 6 or nonnegative_int(c_o0.get("mismatch_count")) != 6 or
            nonnegative_int(c_o0.get("difference_count")) != 62 or nonnegative_int(c_o0.get("exact_byte_range_count")) != 0 or
            cpp_o0.get("status") != "toolchain_mismatch_reported" or
            cpp_o0.get("source") != "outputs/blackmoor-decomp/src/matching_s08_2.cpp" or
            cpp_o0.get("source_sha256") != expected_semantic_sources["outputs/blackmoor-decomp/src/matching_s08_2.cpp"] or
            nonnegative_int(cpp_o0.get("function_count")) != 6 or nonnegative_int(cpp_o0.get("mismatch_count")) != 6 or
            nonnegative_int(cpp_o0.get("difference_count")) != 66 or nonnegative_int(cpp_o0.get("exact_byte_range_count")) != 0):
        reasons.append("separate C/C++ compiler-mismatch report does not support the displayed summary")
    for source_ref, expected_sha in expected_semantic_sources.items():
        source_file = resolve_project_file(project, source_ref)
        if not source_file or digest(source_file) != expected_sha:
            reasons.append("current C/C++ comparison source is missing or stale: " + source_ref)

    result = {
        "valid": not reasons,
        "reason": "; ".join(dict.fromkeys(reasons)) if reasons else "root-pinned report, current source/object/manifest files, supplied-object binding, fresh reassembly, and complete terminal-return extents verified",
        "report_sha256": report_sha, "report_path": str(report_path) if report_path else None,
        "source_path": str(source_path) if source_path else None, "source_sha256": digest(source_path) if source_path else None,
        "manifest_path": str(manifest_path) if manifest_path else None, "manifest_sha256": manifest_sha,
        "object_path": str(actual_object_path) if actual_object_path else None, "object_sha256": object_sha, "object_size": object_size,
        "object_report_path": object_ref, "binding_root": str(binding_root),
        "effective_manifest_sha256": effective_sha,
        "assembler_path": str(assembler_path) if assembler_path else None, "assembler_sha256": assembler_sha,
        "semantic_report_path": str(semantic_path), "semantic_report_sha256": digest(semantic_path),
        "semantic_C_and_CPP": {
            "C_O0_difference_count": nonnegative_int(semantic.get("C_O0_difference_count")) or 0,
            "C_O0_exact_ranges": nonnegative_int(semantic.get("C_O0_exact_ranges")) or 0,
            "C_plus_plus_O0_difference_count": nonnegative_int(semantic.get("C_plus_plus_O0_difference_count")) or 0,
            "C_plus_plus_O0_exact_ranges": nonnegative_int(semantic.get("C_plus_plus_O0_exact_ranges")) or 0,
            "classification": "compiler-generated C and C++ candidates; mismatch evidence remains separate from reconstructed assembly",
        },
        "functions": valid_rows if not reasons else [],
        "accepted_function_count": len(valid_rows) if not reasons else 0,
        "exact_bytes": sum(row["size"] for row in valid_rows) if not reasons else 0,
    }
    return result


def validate_s08_3(project, report, report_path, text_section, object_path=None, binding_root=None):
    """Admit only the root-accepted S08-3 schema and its current source/object binding."""
    project = pathlib.Path(project)
    reasons = []
    report_sha = digest(report_path) if report_path else None
    if report_sha != S08_3_ACCEPTED_PINS["report_sha256"]:
        reasons.append("S08-3 report SHA is not the root-accepted snapshot")
    if not isinstance(report, dict) or not report:
        reasons.append("S08-3 accepted report is missing or malformed")
        report = {}
    if report.get("slice") != "S08-3-original-input-methods-x86":
        reasons.append("S08-3 report names a different matching slice")
    if report.get("status") != "exact_match_from_reviewed_reconstructed_assembly_source":
        reasons.append("S08-3 report state is not the accepted reviewed-assembly state")
    if report.get("classification") != "explicit_reconstructed_assembly_source":
        reasons.append("S08-3 report classification is not explicit reconstructed assembly")
    if report.get("compiler_generated_C_claim") is not False or report.get("whole_executable_rebuilt") is not False:
        reasons.append("S08-3 report claims compiler-generated C or a whole-executable rebuild")
    if report.get("contains_original_byte_values") is not False:
        reasons.append("S08-3 report must not contain original byte values")

    original = report.get("original") if isinstance(report.get("original"), dict) else {}
    if original.get("sha256") != EXPECTED_EXE or nonnegative_int(original.get("size")) != 1511424:
        reasons.append("S08-3 report is not bound to the pinned GAME.EXE size and SHA")
    original_path = resolve_project_file(project, original.get("path"))
    if not original_path or digest(original_path) != EXPECTED_EXE or original_path.stat().st_size != 1511424:
        reasons.append("current S08-3 original file does not match the pinned executable")

    source = report.get("source") if isinstance(report.get("source"), dict) else {}
    source_path = resolve_project_file(project, source.get("path"))
    source_sha = source.get("sha256")
    if (source.get("path") != S08_3_SOURCE_REF or not source_path or
            source_sha != S08_3_ACCEPTED_PINS["source_sha256"] or digest(source_path) != source_sha or
            source.get("canonical_reviewed_source_sha256") != S08_3_ACCEPTED_PINS["source_sha256"] or
            source.get("matches_reviewed_source") is not True):
        reasons.append("current S08-3 source is stale, alternate, or not bound to the reviewed source")
    association = report.get("source_object_association") if isinstance(report.get("source_object_association"), dict) else {}
    if (association.get("status") != "verified_reassembly_match" or
            association.get("fresh_reassembled_object_sha256") != S08_3_ACCEPTED_PINS["object_sha256"] or
            association.get("supplied_object_sha256") != S08_3_ACCEPTED_PINS["object_sha256"] or
            association.get("reassembly_error") is not None or association.get("canonical_object_path") is not True or
            association.get("historical_compiler_provenance_claim") is not False):
        reasons.append("S08-3 source does not have a verified current fresh-reassembly/object association")

    manifest_path = project / S08_3_MANIFEST_REF
    manifest = load(manifest_path)
    manifest_sha = digest(manifest_path)
    if manifest_sha != S08_3_ACCEPTED_PINS["manifest_sha256"] or report.get("manifest_sha256") != manifest_sha:
        reasons.append("current S08-3 manifest SHA differs from the root-accepted manifest")
    if manifest.get("original_sha256") != EXPECTED_EXE or manifest.get("source") != "src/matching_s08_3_x86.s":
        reasons.append("S08-3 manifest is not bound to the pinned image and reviewed source")

    object_info = report.get("object") if isinstance(report.get("object"), dict) else {}
    binding = report.get("comparison_binding") if isinstance(report.get("comparison_binding"), dict) else {}
    actual_object_path = pathlib.Path(object_path) if object_path else project / S08_3_OBJECT_REF
    object_sha = digest(actual_object_path) if actual_object_path.is_file() else None
    object_size = actual_object_path.stat().st_size if actual_object_path.is_file() else None
    if (object_info.get("path") != S08_3_OBJECT_REF or binding.get("object_path") != S08_3_OBJECT_REF or
            object_sha != S08_3_ACCEPTED_PINS["object_sha256"] or object_sha != object_info.get("sha256") or
            object_size != nonnegative_int(object_info.get("size"))):
        reasons.append("current supplied S08-3 object differs from the root-accepted object pin")
    if (binding.get("object_file_sha256") != object_info.get("sha256") or
            object_info.get("sha256") != S08_3_ACCEPTED_PINS["object_sha256"]):
        reasons.append("S08-3 comparison binding does not match the supplied object")

    binding_root = pathlib.Path(binding_root) if binding_root else project
    bound_object = pathlib.Path(S08_3_OBJECT_REF)
    if not bound_object.is_absolute():
        bound_object = binding_root / bound_object
    try:
        effective_manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        rows_for_binding = effective_manifest.get("functions")
        if not isinstance(rows_for_binding, list):
            raise ValueError("manifest functions missing")
        for row in rows_for_binding:
            if isinstance(row, dict):
                row["object"] = str(bound_object.resolve())
        effective_sha = hashlib.sha256(
            json.dumps(effective_manifest, indent=2, sort_keys=True).encode("utf-8") + b"\n"
        ).hexdigest()
    except (OSError, json.JSONDecodeError, TypeError, ValueError):
        effective_sha = None
    if effective_sha != binding.get("manifest_sha256"):
        reasons.append("S08-3 effective supplied-object manifest binding does not reproduce")

    assembler_path = project / S08_3_ASSEMBLER_REF
    assembler = report.get("assembler") if isinstance(report.get("assembler"), dict) else {}
    assembler_sha = digest(assembler_path)
    if (assembler_sha != S08_3_ACCEPTED_PINS["assembler_sha256"] or
            assembler_sha != assembler.get("sha256")):
        reasons.append("pinned S08-3 assembler binary is missing or has a different SHA")

    comparison = report.get("comparison") if isinstance(report.get("comparison"), dict) else {}
    rows = comparison.get("functions") if isinstance(comparison.get("functions"), list) else []
    candidates = report.get("candidate_functions") if isinstance(report.get("candidate_functions"), dict) else {}
    manifest_rows = manifest.get("functions") if isinstance(manifest.get("functions"), list) else []
    total_bytes = sum(item["size"] for item in S08_3_FUNCTIONS)
    if (nonnegative_int(report.get("function_count")) != len(S08_3_FUNCTIONS) or
            nonnegative_int(comparison.get("function_count")) != len(S08_3_FUNCTIONS) or
            nonnegative_int(report.get("compared_bytes")) != total_bytes or
            nonnegative_int(comparison.get("compared_bytes")) != total_bytes or
            nonnegative_int(comparison.get("exact_byte_range_count")) != len(S08_3_FUNCTIONS) or
            nonnegative_int(comparison.get("mismatch_count")) != 0 or
            nonnegative_int(comparison.get("difference_count")) != 0 or
            nonnegative_int(comparison.get("rejected_count")) != 0 or
            comparison.get("all_byte_ranges_exact") is not True or
            comparison.get("contains_original_byte_values") is not False or
            len(rows) != len(S08_3_FUNCTIONS) or len(manifest_rows) != len(S08_3_FUNCTIONS) or
            len(candidates) != len(S08_3_FUNCTIONS)):
        reasons.append("S08-3 aggregate report, comparison, candidate, or manifest row totals disagree")

    expected_by_symbol = {item["symbol"]: item for item in S08_3_FUNCTIONS}
    manifest_by_symbol = {row.get("symbol"): row for row in manifest_rows if isinstance(row, dict)}
    comparison_by_symbol = {row.get("symbol"): row for row in rows if isinstance(row, dict)}
    starts = []
    index_path = project / "outputs/blackmoor-decomp/function-index.json"
    index = load(index_path)
    indexed = {}
    for item in index.get("functions", []):
        if isinstance(item, dict) and "address" in item:
            indexed[va(item["address"])] = item
    text_start = IMAGE_BASE + text_section["virtual_address"] if isinstance(text_section, dict) else None
    text_end = text_start + text_section["virtual_size"] if text_start is not None else None
    valid_rows = []
    object_cursor = 0
    for expected in S08_3_FUNCTIONS:
        symbol = expected["symbol"]
        start, size, end = expected["va"], expected["size"], expected["va"] + expected["size"]
        manifest_row = manifest_by_symbol.get(symbol)
        if (not manifest_row or nonnegative_int(manifest_row.get("rva")) != expected["rva"] or
                nonnegative_int(manifest_row.get("size")) != size or
                manifest_row.get("object") != "build/matching_s08_3_x86.obj" or
                not isinstance(manifest_row.get("evidence_id"), str) or not manifest_row.get("evidence_id")):
            reasons.append("S08-3 manifest row differs from the accepted function extent for " + symbol)
            continue
        function_index_row = indexed.get(start)
        if (not function_index_row or function_index_row.get("evidence_id") != manifest_row.get("evidence_id") or
                function_index_row.get("name") != symbol.removeprefix("_")):
            reasons.append("S08-3 current function-index association differs for " + symbol)
            continue
        starts.append(start)
        later_starts = sorted(value for value in indexed if value > start)
        next_start = later_starts[0] if later_starts else None
        if (text_start is None or start < text_start or end > text_end or end > U32_LIMIT or next_start != end):
            reasons.append("S08-3 function extent is outside current text or indexed-start bounds: " + symbol)
            continue
        candidate = candidates.get(symbol) if isinstance(candidates.get(symbol), dict) else {}
        if (nonnegative_int(candidate.get("object_offset")) != expected["object_offset"] or
                nonnegative_int(candidate.get("size")) != size or
                nonnegative_int(candidate.get("instruction_count")) is None or
                nonnegative_int(candidate.get("instruction_count")) <= 0 or
                candidate.get("terminal_mnemonic") != "ret" or
                candidate.get("terminal_operand", "").strip().lower() not in {"0x8", "8"}):
            reasons.append("S08-3 object audit does not cover the pinned extent to terminal ret 8: " + symbol)
            continue
        comparison_row = comparison_by_symbol.get(symbol)
        if (not comparison_row or comparison_row.get("status") != "exact-byte-range" or
                nonnegative_int(comparison_row.get("size")) != size or
                nonnegative_int(comparison_row.get("mismatch_count")) != 0 or
                comparison_row.get("mismatch_offsets") != [] or
                comparison_row.get("contains_original_byte_values") is not False or
                comparison_row.get("original_sha256") != comparison_row.get("candidate_sha256") or
                not re.fullmatch(r"[0-9a-f]{64}", str(comparison_row.get("original_sha256")))):
            reasons.append("S08-3 exact comparison row is malformed or contains a byte mismatch: " + symbol)
            continue
        valid_rows.append({"start": start, "end": end, "size": size, "symbol": symbol,
                           "rva": expected["rva"], "object_offset": expected["object_offset"],
                           "evidence_id": manifest_row["evidence_id"], "report_sha256": report_sha})
        object_cursor += size
    if object_cursor != total_bytes or len(valid_rows) != len(S08_3_FUNCTIONS):
        reasons.append("not every S08-3 function row passed current source/object/manifest/extent checks")

    return {
        "valid": not reasons,
        "reason": "; ".join(dict.fromkeys(reasons)) if reasons else "root-pinned S08-3 report, current reviewed source/object/manifest, fresh reassembly, and current indexed extents verified",
        "report_sha256": report_sha, "report_path": str(report_path) if report_path else None,
        "source_path": str(source_path) if source_path else None, "source_sha256": digest(source_path) if source_path else None,
        "manifest_path": str(manifest_path), "manifest_sha256": manifest_sha,
        "object_path": str(actual_object_path), "object_sha256": object_sha, "object_size": object_size,
        "object_report_path": S08_3_OBJECT_REF, "effective_manifest_sha256": effective_sha,
        "assembler_path": str(assembler_path), "assembler_sha256": assembler_sha,
        "accepted_function_count": len(valid_rows) if not reasons else 0,
        "exact_bytes": sum(row["size"] for row in valid_rows) if not reasons else 0,
        "functions": valid_rows if not reasons else [],
    }


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

def merge_address_ranges(ranges):
    """Merge adjacent exact extents into address runs for the map summary."""
    merged = []
    for item in sorted(ranges, key=lambda row: (row["start"], row["start"] + row["size"])):
        end = item["start"] + item["size"]
        if merged and item["start"] <= merged[-1]["start"] + merged[-1]["size"]:
            merged[-1]["size"] = max(merged[-1]["start"] + merged[-1]["size"], end) - merged[-1]["start"]
            merged[-1]["bytes"] = merged[-1]["size"]
        else:
            merged.append(dict(item))
    return merged

def build_snapshot(project, evidence, generated_utc=None, artifact_root=None, assembly_object_path=None, assembly_binding_root=None,
                   s08_3_report_path=None, s08_3_object_path=None, s08_3_binding_root=None):
    project, evidence = pathlib.Path(project).absolute(), pathlib.Path(evidence).absolute()
    artifact_root = pathlib.Path(artifact_root).absolute() if artifact_root else project
    outdir = artifact_root / OUT
    def output_link(path):
        path = pathlib.Path(path)
        try:
            relative = path.relative_to(project)
        except ValueError:
            return href(outdir, path)

        # This small JSON report is metadata-only but can contain build-root
        # paths that differ between the canonical source checkout and the
        # managed artifact checkout. Preserve the exact source digest in a
        # portable copy instead of linking to a differing local report or
        # emitting a machine-specific path that breaks after collection.
        if relative == MATCHING_REPORT and path.is_file():
            if path.stat().st_size > MATCHING_REPORT_COPY_LIMIT:
                return None
            raw = path.read_bytes()
            try:
                if not isinstance(json.loads(raw), dict):
                    return None
            except (UnicodeDecodeError, json.JSONDecodeError):
                return None
            target = outdir / MATCHING_REPORT_COPY
            target.parent.mkdir(parents=True, exist_ok=True)
            if digest(target) != hashlib.sha256(raw).hexdigest():
                target.write_bytes(raw)
            return href(outdir, target)

        candidate = artifact_root / relative
        if path.is_file() and candidate.is_file() and digest(path) == digest(candidate):
            return href(outdir, candidate)
        # A project-relative URL would point at the intended canonical
        # artifact after collection, but it cannot be verified against the
        # source bytes in this checkout. Omit such links rather than attach a
        # stale or machine-specific target to the source digest.
        return None
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
    matching_validation["manifest_link"] = output_link(matching_manifest_path) if matching_manifest_path else None

    s08_path = evidence / "S08-matching-report.json"
    s08 = load(s08_path)
    s08_validation = validate_s08(s08)
    text_meta = s08_validation.get("text_section") if s08_validation["valid"] else None

    s08_2_path = evidence / S08_2_REPORT_NAME
    s08_2_report = load(s08_2_path)
    s08_2_validation = validate_s08_2(
        project, evidence, s08_2_report, s08_2_path, text_meta,
        object_path=assembly_object_path, binding_root=assembly_binding_root,
    )
    s08_2_source_link = output_link(s08_2_validation["source_path"]) if s08_2_validation.get("source_path") else None
    s08_2_manifest_link = output_link(s08_2_validation["manifest_path"]) if s08_2_validation.get("manifest_path") else None
    s08_2_semantic_link = output_link(s08_2_validation["semantic_report_path"]) if s08_2_validation.get("semantic_report_path") else None
    s08_2_report_link = output_link(s08_2_path)
    s08_3_path = pathlib.Path(s08_3_report_path).absolute() if s08_3_report_path else evidence / S08_3_REPORT_NAME
    s08_3_report = load(s08_3_path)
    s08_3_validation = validate_s08_3(
        project, s08_3_report, s08_3_path, text_meta,
        object_path=s08_3_object_path, binding_root=s08_3_binding_root,
    )
    s08_3_report_link = output_link(s08_3_path)
    s08_3_source_link = output_link(s08_3_validation["source_path"]) if s08_3_validation.get("source_path") else None
    s08_3_manifest_link = output_link(s08_3_validation["manifest_path"]) if s08_3_validation.get("manifest_path") else None
    s08_3_claim_path = next(iter(sorted(evidence.glob("S08-3*claim*.json"))), None)
    s08_3_claim_link = output_link(s08_3_claim_path) if s08_3_claim_path else None
    s08_by_start = {}
    if s08_validation["valid"]:
        for item in s08_validation["functions"]:
            start, end, size = item["va"], item["end_va"], item["size"]
            s08_by_start[start] = {
                "start": start, "end": end, "size": size, "match_status": item["match_status"],
                "mismatch_count": item["mismatch_count"], "evidence_id": item.get("evidence_id"),
                "report_sha256": digest(s08_path),
                "report_link": output_link(s08_path),
            }

    assembly_by_start = {}
    if s08_2_validation["valid"]:
        for item in s08_2_validation["functions"]:
            assembly_by_start[item["start"]] = {
                **item,
                "source_class": "explicit_reconstructed_assembly_source",
                "report_link": s08_2_report_link,
                "source_link": s08_2_source_link,
                "manifest_link": s08_2_manifest_link,
                "source_sha256": s08_2_validation["source_sha256"],
                "manifest_sha256": s08_2_validation["manifest_sha256"],
                "object_sha256": s08_2_validation["object_sha256"],
                "object_report_path": s08_2_validation["object_report_path"],
                "object_actual_path": s08_2_validation["object_path"],
                "effective_manifest_sha256": s08_2_validation["effective_manifest_sha256"],
                "family": "S08-2",
            }

    if s08_3_validation["valid"]:
        if any(row["start"] in assembly_by_start for row in s08_3_validation["functions"]):
            s08_3_validation.update(valid=False, reason="S08-2 and S08-3 accepted extents share a function start",
                                    accepted_function_count=0, exact_bytes=0, functions=[])
        else:
            for item in s08_3_validation["functions"]:
                assembly_by_start[item["start"]] = {
                    **item,
                    "source_class": "explicit_reconstructed_assembly_source",
                    "report_link": s08_3_report_link,
                    "source_link": s08_3_source_link,
                    "manifest_link": s08_3_manifest_link,
                    "source_sha256": s08_3_validation["source_sha256"],
                    "manifest_sha256": s08_3_validation["manifest_sha256"],
                    "object_sha256": s08_3_validation["object_sha256"],
                    "object_report_path": s08_3_validation["object_report_path"],
                    "object_actual_path": s08_3_validation["object_path"],
                    "effective_manifest_sha256": s08_3_validation["effective_manifest_sha256"],
                    "family": "S08-3",
                }

    exact_by_start = {}
    rejected_exact_ranges = []
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
    accepted_partial_source_ranges = sum(len(ranges) for ranges in exact_by_start.values())
    exact_by_start = {start: merge_exact_ranges(ranges) for start, ranges in exact_by_start.items()}
    partial_merged = merge_exact_ranges([item for ranges in exact_by_start.values() for item in ranges])
    all_exact_ranges = [item for ranges in exact_by_start.values() for item in ranges]
    all_exact_ranges += [{"start": row["start"], "size": row["size"], "bytes": row["size"], "completeness": "complete", "source_class": row["source_class"]} for row in assembly_by_start.values()]
    exact_merged = merge_exact_ranges(all_exact_ranges)
    merged_address_ranges = merge_address_ranges(all_exact_ranges)
    accepted_exact_source_ranges = accepted_partial_source_ranges + len(assembly_by_start)
    matching_validation["accepted_range_count"] = accepted_partial_source_ranges
    matching_validation["combined_accepted_range_count"] = accepted_exact_source_ranges
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
            binding_report_link = output_link(binding_path)
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
        rlink = output_link(report_path)
        entries_for_report, rejected_report_ranges, quarantined_report_ranges = [], [], []
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
            if not report_ok:
                quarantined_report_ranges.append({
                    "name": item.get("name", "original entrypoint"), "start": start, "end": end,
                    "reason": "original SHA, report state, or mismatch check failed",
                })
                continue
            kind = "controlled-boundary" if start in controlled else ("oracle-bound" if source_bound else "bounded-report")
            row = {
                "report_id": rid, "report_title": title, "range_name": item.get("name", "original entrypoint"),
                "start": start, "end": end,
                "boundary_basis": item.get("boundary_basis", "report range; no function extent inferred"),
                "kind": kind, "scope": report.get("scope", "scope not recorded"),
                "report_sha256": digest(report_path), "report_link": rlink,
                "source_path": source, "source_link": output_link(source_path),
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
            "source_path": source, "source_link": output_link(source_path),
            "source_binding": "matched" if source_bound else "not source-hash-bound",
            "source_binding_reason": source_binding_reason,
            "binding_report_link": binding_report_link, "binding_report_sha256": binding_report_sha,
            "native_library_sha256": report.get("native_library_sha256"), "entrypoint_count": len(entries_for_report),
            "quarantined_range_count": len(quarantined_report_ranges), "quarantined_ranges": quarantined_report_ranges,
            "rejected_range_count": len(rejected_report_ranges), "rejected_ranges": rejected_report_ranges,
        })

    functions = []
    s08_3_quarantine_by_start = {}
    if not s08_3_validation["valid"]:
        for item in S08_3_FUNCTIONS:
            s08_3_quarantine_by_start[item["va"]] = {
                "family": "S08-3", "reason": s08_3_validation["reason"],
                "report_link": s08_3_report_link, "report_sha256": s08_3_validation["report_sha256"],
                "exact_bytes_contributed": 0,
            }
    for i, (start, item) in enumerate(entries):
        estimated = entries[i + 1][0] - start if i + 1 < len(entries) else None
        audit = s08_by_start.get(start)
        assembly_match = assembly_by_start.get(start)
        size = audit["size"] if audit else (assembly_match["size"] if assembly_match else estimated)
        span_end = start + size if size is not None else start
        interior_ranges = [dict(row, coverage_location="interior report window; not full function coverage")
                           for row in oracle_rows if start < row["start"] < span_end]
        functions.append({
            "va": start, "address": "0x%06x" % start, "name": item.get("name", "FUN_%08X" % start),
            "evidence_id": item.get("evidence_id", ""), "pseudocode": item.get("file", ""),
            "pseudocode_link": output_link(project / "outputs/blackmoor-decomp" / item.get("file", "")),
            "address_unit": ("0x%04x" % (start >> 16)) + "xxxx", "size": size,
            "extent_kind": "complete range audited to terminal return" if audit or assembly_match else ("unknown final extent" if size is None else "next-start address span (estimated)"),
            "exact_ranges": exact_by_start.get(start, []), "assembly_match": assembly_match, "s08_audit": audit,
            "assembly_quarantine": s08_3_quarantine_by_start.get(start),
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
                "sha256": digest(path), "link": output_link(path),
            })
    slices = []
    for item in registry.get("slices", []):
        sid = str(item.get("id", ""))
        packet = str(item.get("packet", ""))
        slices.append({
            "id": sid, "title": item.get("title", ""), "registry_status": item.get("status", ""),
            "packet": packet, "packet_link": output_link(project / "outputs/blackmoor-decomp" / packet),
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
        {"name": "function-index.json", "sha256": index_sha, "link": output_link(index_path), "note": "Ghidra/REA indexed starts; not exact extents"},
        {"name": "matching-report.json", "sha256": match_sha, "link": output_link(matching_path), "note": ("accepted: " if matching_validation["valid"] else "quarantined: ") + matching_validation["reason"]},
        {"name": "S08 matching report", "sha256": digest(s08_path), "link": output_link(s08_path), "note": ("accepted: " if s08_validation["valid"] else "quarantined: ") + s08_validation["reason"]},
    ] + [{"name": r["title"], "sha256": r["report_sha256"], "link": r["report_link"], "note": r["status"] + " · " + r["scope"]} for r in oracle_reports]
    bindings += [
        {"name": "S08-2 reviewed assembly report", "sha256": s08_2_validation["report_sha256"], "link": s08_2_report_link,
         "note": ("accepted: " if s08_2_validation["valid"] else "quarantined: ") + s08_2_validation["reason"]},
        {"name": "S08-2 assembly source", "sha256": s08_2_validation["source_sha256"], "link": s08_2_source_link,
         "note": "Reviewed reconstructed mnemonic assembly source; source SHA is separate from original-source provenance."},
        {"name": "S08-2 assembly manifest", "sha256": s08_2_validation["manifest_sha256"], "link": s08_2_manifest_link,
         "note": "Manifest original SHA, function extents, and actual supplied-object comparison binding are checked."},
        {"name": "S08-2 C/C++ mismatch report", "sha256": s08_2_validation["semantic_report_sha256"], "link": s08_2_semantic_link,
         "note": "Separate compiler-generated C/C++ candidates; their byte mismatches remain unpromoted."},
    ]
    bindings += [
        {"name": "S08-3 reviewed assembly report", "sha256": s08_3_validation["report_sha256"], "link": s08_3_report_link,
         "note": ("accepted: " if s08_3_validation["valid"] else "quarantined: ") + s08_3_validation["reason"]},
        {"name": "S08-3 assembly source", "sha256": s08_3_validation["source_sha256"], "link": s08_3_source_link,
         "note": "Reviewed reconstructed mnemonic assembly source; no historical compiler provenance is claimed."},
        {"name": "S08-3 assembly manifest", "sha256": s08_3_validation["manifest_sha256"], "link": s08_3_manifest_link,
         "note": "Manifest rows, current object SHA, fresh reassembly, and effective supplied-object binding are checked."},
    ]
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
    partial_exact_bytes = sum(row["bytes"] for row in partial_merged)
    assembly_exact_bytes = sum(row["size"] for row in assembly_by_start.values())
    if assembly_by_start and partial_merged:
        exact_completeness = "mixed: complete reconstructed assembly functions and incomplete selected ranges"
    elif assembly_by_start:
        exact_completeness = "complete reconstructed assembly functions"
    elif partial_merged:
        exact_completeness = "unverified"
    else:
        exact_completeness = "none"
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
            "exact_merged_address_ranges": len(merged_address_ranges),
            "exact_source_ranges": accepted_exact_source_ranges,
            "partial_exact_ranges": len(partial_merged), "partial_exact_bytes": partial_exact_bytes,
            "complete_assembly_functions": len(assembly_by_start), "complete_assembly_bytes": assembly_exact_bytes,
            "s08_2_complete_assembly_functions": s08_2_validation["accepted_function_count"],
            "s08_2_complete_assembly_bytes": s08_2_validation["exact_bytes"],
            "s08_3_complete_assembly_functions": s08_3_validation["accepted_function_count"],
            "s08_3_complete_assembly_bytes": s08_3_validation["exact_bytes"],
            "exact_function_completeness": exact_completeness,
            "s08_audited_extents": len(s08_by_start),
            "s08_exact_functions": sum(x["match_status"] == "exact-byte-range" for x in s08_by_start.values()),
            "s08_compiler_mismatches": sum(x["match_status"] == "byte-range-mismatch" for x in s08_by_start.values()),
            "bounded_oracle_source_bound_starts": len(source_bound), "bounded_oracle_report_only_starts": len(report_only),
            "controlled_boundary_starts": len(controlled_starts), "whole_executable_rebuilt": False,
        },
        "functions": functions, "oracle_reports": oracle_reports, "report_bindings": bindings,
        "matching_validation": matching_validation,
        "s08_2": {
            "valid": s08_2_validation["valid"], "reason": s08_2_validation["reason"],
            "classification": s08_2_report.get("classification"),
            "status": s08_2_report.get("status"),
            "report_sha256": s08_2_validation["report_sha256"], "report_link": s08_2_report_link,
            "source_path": s08_2_validation["source_path"], "source_link": s08_2_source_link,
            "source_sha256": s08_2_validation["source_sha256"],
            "manifest_path": s08_2_validation["manifest_path"], "manifest_link": s08_2_manifest_link,
            "manifest_sha256": s08_2_validation["manifest_sha256"],
            "object_report_path": s08_2_validation["object_report_path"],
            "object_actual_path": s08_2_validation["object_path"],
            "object_sha256": s08_2_validation["object_sha256"],
            "effective_manifest_sha256": s08_2_validation["effective_manifest_sha256"],
            "assembler_sha256": s08_2_validation["assembler_sha256"],
            "association": s08_2_report.get("source_object_association", {}),
            "accepted_function_count": s08_2_validation["accepted_function_count"],
            "exact_bytes": s08_2_validation["exact_bytes"],
            "semantic_C_and_CPP": s08_2_validation["semantic_C_and_CPP"],
            "semantic_report_link": s08_2_semantic_link,
            "semantic_report_sha256": s08_2_validation["semantic_report_sha256"],
            "functions": {row["start"]: row for row in s08_2_validation["functions"]},
        },
        "s08_3": {
            "valid": s08_3_validation["valid"], "reason": s08_3_validation["reason"],
            "classification": s08_3_report.get("classification"), "status": s08_3_report.get("status"),
            "report_sha256": s08_3_validation["report_sha256"], "report_link": s08_3_report_link,
            "source_path": s08_3_validation["source_path"], "source_link": s08_3_source_link,
            "source_sha256": s08_3_validation["source_sha256"],
            "manifest_path": s08_3_validation["manifest_path"], "manifest_link": s08_3_manifest_link,
            "manifest_sha256": s08_3_validation["manifest_sha256"],
            "object_report_path": s08_3_validation["object_report_path"],
            "object_actual_path": s08_3_validation["object_path"], "object_sha256": s08_3_validation["object_sha256"],
            "effective_manifest_sha256": s08_3_validation["effective_manifest_sha256"],
            "assembler_sha256": s08_3_validation["assembler_sha256"],
            "accepted_function_count": s08_3_validation["accepted_function_count"],
            "exact_bytes": s08_3_validation["exact_bytes"],
            "claim_sha256": digest(s08_3_claim_path) if s08_3_claim_path else None,
            "claim_link": s08_3_claim_link,
            "functions": {row["start"]: row for row in s08_3_validation["functions"]},
        },
        "oracle_coverage": {
            "selected_reports": ["S0 hotspot runtime", "selected action-core handlers", "dependency branch reducer", "phone/control-state handlers", "A-64 original oracle"],
            "omitted_families": ["S01 world-init", "S02 Bink/player", "A28", "A51", "coreCIF", "HIFF", "pixels"],
            "note": "This map adapts only the selected report set listed here; omitted report families are not counted or mapped.",
        },
        "slices": slices, "coordination": {
            "source_link": output_link(coord_path), "source_sha256": digest(coord_path),
            "s03_row": get_row("| S03 AVF |"), "s05_row": get_row("| S05 caption"),
            "note": "The coordination table may lag newer claim receipts; both are shown.",
        },
        "census": {
            "included_in_metrics": census_bound,
            "state": "bound to a current parser candidate" if census_bound else "suppressed: saved parser SHA does not match current parser-source candidates",
            "saved_report_sha256": digest(census_path), "saved_parser_sha256": census.get("parser_sha256"),
            "current_parser_sources": parser_candidates, "report_link": output_link(census_path),
        },
        "s08": {"status": s08.get("status"), "comparison": s08.get("comparison"), "validation": s08_validation,
                "report_sha256": digest(s08_path), "report_link": output_link(s08_path)},
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
    parser.add_argument("--artifact-root", type=pathlib.Path, help="Directory receiving progress-map output when reading a separate canonical project root.")
    parser.add_argument("--assembly-object", type=pathlib.Path, help="Current supplied S08-2 object file; its bytes must match the accepted report pin.")
    parser.add_argument("--assembly-binding-root", type=pathlib.Path, help="Repository root used for the report's temporary supplied-object manifest path.")
    parser.add_argument("--s08-3-report", type=pathlib.Path, help="Root-accepted S08-3 report using its separate schema.")
    parser.add_argument("--s08-3-object", type=pathlib.Path, help="Current supplied S08-3 object file; its bytes must match the accepted report pin.")
    parser.add_argument("--s08-3-binding-root", type=pathlib.Path, help="Repository root used by the accepted S08-3 supplied-object manifest binding.")
    args = parser.parse_args()
    artifact_root = args.artifact_root or args.project_root
    outdir = artifact_root / OUT
    outdir.mkdir(parents=True, exist_ok=True)
    snapshot = build_snapshot(args.project_root, args.evidence_root,
                              artifact_root=artifact_root,
                              assembly_object_path=args.assembly_object,
                              assembly_binding_root=args.assembly_binding_root,
                              s08_3_report_path=args.s08_3_report,
                              s08_3_object_path=args.s08_3_object,
                              s08_3_binding_root=args.s08_3_binding_root)
    template = pathlib.Path(__file__).with_name("app-template.html").read_text(encoding="utf-8")
    (outdir / "snapshot.json").write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (outdir / "index.html").write_text(embed(template, snapshot), encoding="utf-8")
    print("wrote %s (%d starts, source %s)" % (outdir / "index.html", len(snapshot["functions"]), snapshot["source_ref"][:12]))

if __name__ == "__main__":
    main()
