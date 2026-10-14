import hashlib
import importlib.util
import json
import pathlib
import shutil
import tempfile
import unittest

MODULE = pathlib.Path(__file__).with_name("generate.py")
SPEC = importlib.util.spec_from_file_location("progress_map_generate", MODULE)
GEN = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GEN)

ORIGINAL = GEN.EXPECTED_EXE


class ProgressMapDataTests(unittest.TestCase):
    def write_json(self, path, value):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value), encoding="utf-8")

    def fixture(self, root, original_hash=ORIGINAL):
        project = root / "project"
        evidence = root / "evidence"
        out = project / "outputs/blackmoor-decomp"
        self.write_json(out / "function-index.json", {
            "original_sha256": original_hash,
            "failures": [],
            "functions": [
                {"address": "0x401000", "name": "FUN_00401000", "file": "unverified-pseudocode/401000.c.txt", "evidence_id": "ev-a"},
                {"address": "0x401010", "name": "FUN_00401010", "file": "unverified-pseudocode/401010.c.txt", "evidence_id": "ev-b"},
            ],
        })
        manifest_path = out / "matches.json"
        self.write_json(manifest_path, {
            "original_sha256": original_hash,
            "functions": [{"rva": 0x1000, "size": 7, "symbol": "_FUN_00401000"}],
        })
        byte_hash = "1" * 64
        self.write_json(out / "matching-report.json", {
            "all_byte_ranges_exact": True,
            "bytes": {"differences": 0, "exact_byte_ranges": 7, "mismatches": 0},
            "counts": {"differences": 0, "exact_byte_ranges": 1, "functions": 1, "mismatches": 0, "rejected": 0},
            "difference_bytes": 0, "difference_count": 0, "errors": [],
            "exact_byte_range_bytes": 7, "exact_byte_range_count": 1,
            "function_completeness": "unverified", "function_count": 1,
            "functions": [{
                "rva": 0x1000, "size": 7, "compared_bytes": 7, "exact_byte_range": True,
                "function_completeness": "unverified", "match_scope": "manifest-selected-byte-range",
                "status": "exact-byte-range", "differences": [], "original_sha256": byte_hash,
                "object_sha256": byte_hash,
            }],
            "manifest": str(manifest_path), "manifest_original_sha256": original_hash,
            "match_scope": "manifest-selected-byte-range", "mismatch_bytes": 0, "mismatch_count": 0,
            "original": str(project / "work/original/GAME.EXE"), "original_sha256": original_hash, "rejected_count": 0,
        })
        self.write_json(evidence / "S08-matching-report.json", {
            "status": "comparison_complete",
            "original": {"sha256": original_hash, "size": 1511424},
            "comparison": {"status": "toolchain_mismatch_reported", "function_count": 1,
                            "mismatch_count": 1, "exact_byte_range_count": 0, "difference_count": 2},
            "text_section": {"virtual_address": 0x1000, "virtual_size": 0x20, "raw_pointer": 0x400, "raw_size": 0x200},
            "functions": [{
                "va": 0x401000, "end_va": 0x401010, "size": 16,
                "range_audit": {"complete_to_terminal_ret": True, "decoded_size": 16},
                "match_status": "byte-range-mismatch", "exact_byte_range": False, "mismatch_count": 2,
            }],
        })
        source = out / "src/scene_executor.c"
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_text("fixture source\n", encoding="utf-8")
        self.write_json(out / "hotspot-runtime-validation.json", {
            "original_sha256": original_hash, "mismatches": [],
            "scope": "bounded fixture", "native_library_sha256": "native",
            "code_ranges": [{"start": "0x401000", "end_exclusive": "0x401010", "name": "fixture entry"}],
        })
        a64_source = out / "src/action_family_64.c"
        a64_source.write_text("A64 fixture\n", encoding="utf-8")
        a64_sha = hashlib.sha256(a64_source.read_bytes()).hexdigest()
        self.write_json(evidence / "A-64-validation.json", {
            "source_file_sha256": {"src/action_family_64.c": a64_sha},
            "native_arm64_library_sha256": "a64-native",
        })
        self.write_json(evidence / "A-64-original-oracle.json", {
            "original_sha256": original_hash, "mismatches": [], "scope": "bounded A64 fixture",
            "native_library_sha256": "a64-native",
            "code_ranges": [
                {"start": "0x401010", "end_exclusive": "0x401020", "name": "A64 entry"},
                {"start": "0x401008", "end_exclusive": "0x40100c", "name": "interior A64 window"},
            ],
        })
        self.write_json(out / "slice-registry.json", {"slices": [
            {"id": "S03", "title": "AVF", "status": "READY", "packet": "tasks/S03.md"},
            {"id": "S05", "title": "Captions", "status": "READY", "packet": "tasks/S05.md"},
        ]})
        self.write_json(evidence / "S05-claim.json", {
            "slice": "S05", "owner": "Claude", "status": "claimed",
        })
        self.write_json(out / "action-census-current.json", {"parser_sha256": "stale"})
        self.write_json(out / "COORDINATION-STATUS.md", {"unused": "fixture"})
        (project / "work/analysis").mkdir(parents=True, exist_ok=True)
        (project / "work/analysis/slices").symlink_to(evidence, target_is_directory=True)
        return project, evidence


    def s08_2_fixture(self, root):
        original_prefix = b"synthetic original executable used only by the report validator fixture"
        original_bytes = original_prefix + bytes(1511424 - len(original_prefix))
        original_hash = hashlib.sha256(original_bytes).hexdigest()
        project, evidence = self.fixture(root, original_hash)
        out = project / "outputs/blackmoor-decomp"
        original_path = project / "work/original/GAME.EXE"
        original_path.parent.mkdir(parents=True, exist_ok=True)
        original_path.write_bytes(original_bytes)

        sizes = [17, 17, 17, 22, 17, 22]
        starts = [0x401100, 0x401111, 0x401122, 0x401133, 0x401149, 0x40115A]
        symbols = ["_FUN_00401100", "_FUN_00401111", "_FUN_00401122",
                   "_FUN_00401133", "_FUN_00401149", "_FUN_0040115a"]
        evidence_id = "ev-synthetic-reviewed-assembly"
        index_path = out / "function-index.json"
        index = json.loads(index_path.read_text(encoding="utf-8"))
        for start, symbol in zip(starts, symbols):
            index["functions"].append({
                "address": hex(start), "name": symbol[1:], "file": "unverified-pseudocode/" + symbol[1:] + ".txt",
                "evidence_id": evidence_id,
            })
        index["functions"].append({
            "address": hex(starts[-1] + sizes[-1]), "name": "FUN_00401170",
            "file": "unverified-pseudocode/00401170.c.txt", "evidence_id": "ev-sentinel",
        })
        self.write_json(index_path, index)

        s08_path = evidence / "S08-matching-report.json"
        s08 = json.loads(s08_path.read_text(encoding="utf-8"))
        s08["text_section"]["virtual_size"] = 0x300
        s08["text_section"]["raw_size"] = 0x400
        self.write_json(s08_path, s08)

        # Keep two earlier partial ranges; the second overlaps a complete assembly function.
        old_manifest_path = out / "matches.json"
        old_manifest = json.loads(old_manifest_path.read_text(encoding="utf-8"))
        old_manifest["functions"].append({"rva": 0x1115, "size": 7, "symbol": "_PARTIAL_OVERLAP"})
        self.write_json(old_manifest_path, old_manifest)
        old_report_path = out / "matching-report.json"
        old_report = json.loads(old_report_path.read_text(encoding="utf-8"))
        partial = dict(old_report["functions"][0], rva=0x1115, size=7, compared_bytes=7)
        old_report["functions"].append(partial)
        old_report.update(function_count=2, exact_byte_range_count=2, exact_byte_range_bytes=14)
        old_report["counts"].update(functions=2, exact_byte_ranges=2)
        old_report["bytes"]["exact_byte_ranges"] = 14
        self.write_json(old_report_path, old_report)

        source_path = out / "src/matching_s08_2_x86.s"
        source_path.parent.mkdir(parents=True, exist_ok=True)
        source_path.write_text("; synthetic six-row source for report validation only\n", encoding="utf-8")
        object_path = out / "build/matching_s08_2_x86.obj"
        object_path.parent.mkdir(parents=True, exist_ok=True)
        object_path.write_bytes(b"synthetic supplied object, not executable code")

        c_source = out / "src/matching_s08.c"
        cpp_source = out / "src/matching_s08_2.cpp"
        c_source.write_text("/* synthetic C candidate */\n", encoding="utf-8")
        cpp_source.write_text("// synthetic C++ candidate\n", encoding="utf-8")

        build_scripts = {}
        for key, relative in GEN.S08_2_BUILD_SCRIPTS.items():
            path = project / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("synthetic pinned build script: " + key + "\n", encoding="utf-8")
            build_scripts[key] = hashlib.sha256(path.read_bytes()).hexdigest()

        assembler_path = project / "work/tools/fake-i686-w64-mingw32-as"
        assembler_path.parent.mkdir(parents=True, exist_ok=True)
        assembler_path.write_bytes(b"synthetic pinned assembler identity")
        assembler_hash = hashlib.sha256(assembler_path.read_bytes()).hexdigest()
        source_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
        object_hash = hashlib.sha256(object_path.read_bytes()).hexdigest()
        manifest_path = out / "matches_s08_2_x86.json"
        manifest_rows = []
        for start, size, symbol in zip(starts, sizes, symbols):
            manifest_rows.append({
                "rva": start - GEN.IMAGE_BASE, "size": size, "symbol": symbol,
                "object": "build/matching_s08_2_x86.obj", "evidence_id": evidence_id,
            })
        manifest = {
            "description": "Fixture only: six complete selected assembly rows.",
            "source": "src/matching_s08_2_x86.s", "original_sha256": original_hash,
            "functions": manifest_rows,
        }
        self.write_json(manifest_path, manifest)
        manifest_hash = hashlib.sha256(manifest_path.read_bytes()).hexdigest()

        index_hash = hashlib.sha256(index_path.read_bytes()).hexdigest()
        rows, comparison_rows = [], []
        object_offset = 0
        for start, size, symbol in zip(starts, sizes, symbols):
            end = start + size
            range_hash = hashlib.sha256((symbol + "-range").encode()).hexdigest()
            range_instructions = [
                {"address": start, "mnemonic": "mov", "operands": "fixture", "size": size - 1},
                {"address": end - 1, "mnemonic": "ret", "operands": "", "size": 1},
            ]
            candidate_instructions = [
                {"address": object_offset, "mnemonic": "mov", "operands": "fixture", "size": size - 1},
                {"address": object_offset + size - 1, "mnemonic": "ret", "operands": "", "size": 1},
            ]
            rows.append({
                "rva": start - GEN.IMAGE_BASE, "va": start, "end_va": end, "size": size,
                "symbol": symbol, "evidence_id": evidence_id, "original_sha256": range_hash,
                "range_audit": {
                    "complete_to_terminal_ret": True, "decoded_size": size, "instruction_count": 2,
                    "next_indexed_start_va": end, "instructions": range_instructions,
                },
                "candidate_audit": {
                    "object_offset": object_offset, "size": size, "instruction_count": 2,
                    "terminal_mnemonic": "ret", "disassembly_sha256": hashlib.sha256((symbol + "-disassembly").encode()).hexdigest(),
                    "instructions": candidate_instructions,
                },
                "byte_comparison": {
                    "status": "exact-byte-range", "size": size, "mismatch_count": 0, "mismatch_offsets": [],
                    "original_sha256": range_hash, "candidate_sha256": range_hash,
                    "contains_original_byte_values": False,
                },
            })
            comparison_rows.append({
                "symbol": symbol, "status": "exact-byte-range", "size": size,
                "original_sha256": range_hash, "candidate_sha256": range_hash,
                "mismatch_offsets": [], "mismatch_count": 0, "contains_original_byte_values": False,
            })
            object_offset += size
        effective_manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        bound_object_path = str(object_path.resolve())
        for item in effective_manifest["functions"]:
            item["object"] = bound_object_path
        effective_hash = hashlib.sha256(
            json.dumps(effective_manifest, indent=2, sort_keys=True).encode("utf-8") + b"\n"
        ).hexdigest()

        semantic_report_path = evidence / GEN.S08_2_SEMANTIC_REPORT_NAME
        c_source_sha = hashlib.sha256(c_source.read_bytes()).hexdigest()
        cpp_source_sha = hashlib.sha256(cpp_source.read_bytes()).hexdigest()
        self.write_json(semantic_report_path, {
            "status": "comparison_complete_no_exact_match",
            "original": {"sha256": original_hash, "size": len(original_bytes)},
            "whole_executable_rebuilt": False,
            "source_files": {
                "outputs/blackmoor-decomp/src/matching_s08.c": c_source_sha,
                "outputs/blackmoor-decomp/src/matching_s08_2.cpp": cpp_source_sha,
            },
            "comparison": {"function_count": 6, "mismatch_count": 6, "difference_count": 62, "exact_byte_range_count": 0},
            "cpp_comparison": {"function_count": 6, "mismatch_count": 6, "difference_count": 66, "exact_byte_range_count": 0},
            "compiler_matrix": [
                {"name": "C-O0", "source": "outputs/blackmoor-decomp/src/matching_s08.c", "source_sha256": c_source_sha,
                 "status": "toolchain_mismatch_reported", "function_count": 6, "mismatch_count": 6,
                 "difference_count": 62, "exact_byte_range_count": 0},
                {"name": "C++-O0", "source": "outputs/blackmoor-decomp/src/matching_s08_2.cpp", "source_sha256": cpp_source_sha,
                 "status": "toolchain_mismatch_reported", "function_count": 6, "mismatch_count": 6,
                 "difference_count": 66, "exact_byte_range_count": 0},
            ],
        })
        semantic = {
            "C_O0_difference_count": 62, "C_O0_exact_ranges": 0,
            "C_plus_plus_O0_difference_count": 66, "C_plus_plus_O0_exact_ranges": 0,
            "C_source": "outputs/blackmoor-decomp/src/matching_s08.c",
            "C_plus_plus_source": "outputs/blackmoor-decomp/src/matching_s08_2.cpp",
            "compiler_matrix_evidence": "work/analysis/slices/S08-2-report.json",
            "semantic_evidence_remains_separate": True,
        }
        report = {
            "status": "exact_match_from_reviewed_reconstructed_assembly_source",
            "classification": "explicit_reconstructed_assembly_source",
            "slice": "S08-2-x86-assembly-lowering",
            "original": {"path": "work/original/GAME.EXE", "sha256": original_hash, "size": len(original_bytes)},
            "source": {"path": GEN.S08_2_SOURCE_REF, "sha256": source_hash},
            "manifest": {"path": GEN.S08_2_MANIFEST_REF, "sha256": manifest_hash},
            "object": {"path": GEN.S08_2_OBJECT_REF, "sha256": object_hash, "size": object_path.stat().st_size},
            "comparison_binding": {
                "strategy": "ephemeral manifest rewrites every function object to the supplied --object path before verification",
                "effective_manifest_sha256": effective_hash, "object_path": GEN.S08_2_OBJECT_REF,
                "object_file_sha256": object_hash,
            },
            "source_object_association": {
                "status": "verified_reassembly_match", "source_path": GEN.S08_2_SOURCE_REF,
                "source_sha256": source_hash, "canonical_reviewed_source_sha256": source_hash,
                "matches_canonical_reviewed_source": True, "historical_provenance_claim": False,
                "audited_object_sha256": object_hash, "reassembled_object_sha256": object_hash,
                "reassembly_error": None, "reassembly_matches_audited_object": True,
            },
            "assembler": {"binary_sha256": assembler_hash, "reproduction_command": [str(assembler_path.resolve()), "--32"]},
            "build_scripts": build_scripts,
            "range_inventory": {
                "source": "outputs/blackmoor-decomp/function-index.json", "source_sha256": index_hash,
                "indexed_functions": len(index["functions"]), "index_failures": 0,
            },
            "function_count": len(rows), "compared_bytes": sum(sizes), "functions": rows,
            "comparison": {
                "all_byte_ranges_exact": True, "compared_bytes": sum(sizes), "difference_count": 0,
                "exact_byte_range_count": len(rows), "function_count": len(rows), "mismatch_count": 0,
                "rejected_count": 0, "functions": comparison_rows,
            },
            "semantic_C_and_CPP": semantic, "compiler_generated_C_claim": False,
            "whole_executable_rebuilt": False,
        }
        report_path = evidence / GEN.S08_2_REPORT_NAME
        self.write_json(report_path, report)
        pins = {
            "report_sha256": hashlib.sha256(report_path.read_bytes()).hexdigest(),
            "manifest_sha256": manifest_hash, "source_sha256": source_hash,
            "object_sha256": object_hash, "assembler_sha256": assembler_hash,
            "semantic_report_sha256": hashlib.sha256(semantic_report_path.read_bytes()).hexdigest(),
            "c_source_sha256": c_source_sha, "cpp_source_sha256": cpp_source_sha,
        }
        return project, evidence, report_path, object_path, original_hash, pins

    def build_with_s08_2(self, project, evidence, original_hash, pins, object_path=None):
        from unittest import mock
        with mock.patch.dict(GEN.S08_2_ACCEPTED_PINS, pins, clear=True), mock.patch.object(GEN, "EXPECTED_EXE", original_hash):
            return GEN.build_snapshot(
                project, evidence, "2026-10-13T00:00:00Z",
                assembly_object_path=object_path,
            )

    def s08_3_fixture(self, root):
        project, evidence, _report2, _object2, original_hash, _pins2 = self.s08_2_fixture(root)
        out = project / "outputs/blackmoor-decomp"
        index_path = out / "function-index.json"
        index = json.loads(index_path.read_text(encoding="utf-8"))
        evidence_id = "ev-synthetic-reviewed-input-assembly"
        for item in GEN.S08_3_FUNCTIONS:
            index["functions"].append({
                "address": hex(item["va"]), "name": item["symbol"].removeprefix("_"),
                "file": "unverified-pseudocode/" + item["symbol"][5:] + ".txt", "evidence_id": evidence_id,
            })
        index["functions"].append({
            "address": hex(GEN.S08_3_FUNCTIONS[-1]["va"] + GEN.S08_3_FUNCTIONS[-1]["size"]),
            "name": "FUN_004db04f", "file": "unverified-pseudocode/004db04f.c.txt", "evidence_id": evidence_id,
        })
        self.write_json(index_path, index)
        s08_path = evidence / "S08-matching-report.json"
        s08 = json.loads(s08_path.read_text(encoding="utf-8"))
        s08["text_section"].update(virtual_size=0xE0000, raw_size=0x100000)
        self.write_json(s08_path, s08)

        source_path = out / "src/matching_s08_3_x86.s"
        source_path.parent.mkdir(parents=True, exist_ok=True)
        source_path.write_text("; synthetic S08-3 source fixture\n", encoding="utf-8")
        object_path = out / "build/matching_s08_3_x86.obj"
        object_path.parent.mkdir(parents=True, exist_ok=True)
        object_path.write_bytes(b"synthetic S08-3 supplied object fixture")
        assembler_path = project / GEN.S08_3_ASSEMBLER_REF
        assembler_path.parent.mkdir(parents=True, exist_ok=True)
        assembler_path.write_bytes(b"synthetic pinned assembler fixture")
        source_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
        object_hash = hashlib.sha256(object_path.read_bytes()).hexdigest()
        assembler_hash = hashlib.sha256(assembler_path.read_bytes()).hexdigest()
        manifest_path = out / "matches_s08_3_x86.json"
        manifest = {
            "description": "Fixture only: three complete selected assembly rows.",
            "source": "src/matching_s08_3_x86.s", "original_sha256": original_hash,
            "functions": [{
                "rva": item["rva"], "size": item["size"], "symbol": item["symbol"],
                "object": "build/matching_s08_3_x86.obj", "evidence_id": evidence_id,
            } for item in GEN.S08_3_FUNCTIONS],
        }
        self.write_json(manifest_path, manifest)
        manifest_sha = hashlib.sha256(manifest_path.read_bytes()).hexdigest()
        effective = json.loads(json.dumps(manifest))
        for row in effective["functions"]:
            row["object"] = str(object_path.resolve())
        effective_sha = hashlib.sha256(
            json.dumps(effective, indent=2, sort_keys=True).encode("utf-8") + b"\n"
        ).hexdigest()
        comparisons, candidates = [], {}
        for item in GEN.S08_3_FUNCTIONS:
            symbol, size = item["symbol"], item["size"]
            byte_hash = hashlib.sha256((symbol + "-exact-range").encode()).hexdigest()
            candidates[symbol] = {
                "object_offset": item["object_offset"], "size": size, "instruction_count": 8,
                "terminal_mnemonic": "ret", "terminal_operand": "0x8",
                "disassembly_sha256": hashlib.sha256((symbol + "-disassembly").encode()).hexdigest(),
            }
            comparisons.append({
                "symbol": symbol, "status": "exact-byte-range", "size": size,
                "original_sha256": byte_hash, "candidate_sha256": byte_hash,
                "mismatch_offsets": [], "mismatch_count": 0, "contains_original_byte_values": False,
            })
        report_path = evidence / GEN.S08_3_REPORT_NAME
        self.write_json(report_path, {
            "slice": "S08-3-original-input-methods-x86",
            "status": "exact_match_from_reviewed_reconstructed_assembly_source",
            "classification": "explicit_reconstructed_assembly_source",
            "original": {"path": "work/original/GAME.EXE", "sha256": original_hash, "size": 1511424},
            "source": {"path": GEN.S08_3_SOURCE_REF, "sha256": source_hash,
                       "canonical_reviewed_source_sha256": source_hash, "matches_reviewed_source": True},
            "source_object_association": {
                "status": "verified_reassembly_match", "fresh_reassembled_object_sha256": object_hash,
                "supplied_object_sha256": object_hash, "reassembly_error": None,
                "canonical_object_path": True, "historical_compiler_provenance_claim": False,
            },
            "assembler": {"sha256": assembler_hash}, "manifest_sha256": manifest_sha,
            "comparison_binding": {
                "manifest_sha256": effective_sha, "object_path": GEN.S08_3_OBJECT_REF,
                "object_file_sha256": object_hash,
            },
            "object": {"path": GEN.S08_3_OBJECT_REF, "sha256": object_hash, "size": object_path.stat().st_size},
            "candidate_functions": candidates,
            "comparison": {
                "function_count": 3, "compared_bytes": 176, "exact_byte_range_count": 3,
                "mismatch_count": 0, "rejected_count": 0, "difference_count": 0,
                "all_byte_ranges_exact": True, "contains_original_byte_values": False, "functions": comparisons,
            },
            "function_count": 3, "compared_bytes": 176, "compiler_generated_C_claim": False,
            "whole_executable_rebuilt": False, "contains_original_byte_values": False,
        })
        report = json.loads(report_path.read_text(encoding="utf-8"))
        pins = {
            "report_sha256": hashlib.sha256(report_path.read_bytes()).hexdigest(),
            "manifest_sha256": manifest_sha, "source_sha256": source_hash,
            "object_sha256": object_hash, "assembler_sha256": assembler_hash,
        }
        return project, evidence, report_path, object_path, original_hash, pins, report

    def test_s08_3_distinct_schema_validates_current_pinned_files_and_extents(self):
        from unittest import mock
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence, report_path, object_path, original_hash, pins, report = self.s08_3_fixture(pathlib.Path(tmp))
            with mock.patch.dict(GEN.S08_3_ACCEPTED_PINS, pins, clear=True), mock.patch.object(GEN, "EXPECTED_EXE", original_hash):
                text = GEN.validate_s08(GEN.load(evidence / "S08-matching-report.json"))["text_section"]
                result = GEN.validate_s08_3(project, report, report_path, text, binding_root=project)
        self.assertTrue(result["valid"], result["reason"])
        self.assertEqual(result["accepted_function_count"], 3)
        self.assertEqual(result["exact_bytes"], 176)
        self.assertEqual([row["end"] for row in result["functions"]], [0x4DAFC3, 0x4DB000, 0x4DB04F])

    def test_s08_3_manifest_object_terminal_and_current_index_mutants_are_quarantined(self):
        from unittest import mock
        mutations = ("manifest", "object", "terminal", "index-boundary", "source-file", "unreviewed", "stale", "reassembly")
        for mutation in mutations:
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as tmp:
                project, evidence, report_path, object_path, original_hash, pins, report = self.s08_3_fixture(pathlib.Path(tmp))
                if mutation == "manifest":
                    manifest_path = project / GEN.S08_3_MANIFEST_REF
                    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
                    manifest["functions"][0]["size"] += 1
                    self.write_json(manifest_path, manifest)
                elif mutation == "object":
                    object_path.write_bytes(b"changed S08-3 object")
                elif mutation == "source-file":
                    (project / GEN.S08_3_SOURCE_REF).write_text("alternate S08-3 source\n", encoding="utf-8")
                elif mutation == "terminal":
                    report["candidate_functions"]["_FUN_004daf9f"]["terminal_mnemonic"] = "jmp"
                    self.write_json(report_path, report)
                    pins["report_sha256"] = hashlib.sha256(report_path.read_bytes()).hexdigest()
                elif mutation == "unreviewed":
                    report["classification"] = "equivalent_unreviewed_assembly"
                    self.write_json(report_path, report)
                    pins["report_sha256"] = hashlib.sha256(report_path.read_bytes()).hexdigest()
                elif mutation == "stale":
                    report["status"] = "comparison_failed"
                    self.write_json(report_path, report)
                    pins["report_sha256"] = hashlib.sha256(report_path.read_bytes()).hexdigest()
                elif mutation == "reassembly":
                    report["source_object_association"]["fresh_reassembled_object_sha256"] = "0" * 64
                    self.write_json(report_path, report)
                    pins["report_sha256"] = hashlib.sha256(report_path.read_bytes()).hexdigest()
                elif mutation == "index-boundary":
                    index_path = project / "outputs/blackmoor-decomp/function-index.json"
                    index = json.loads(index_path.read_text(encoding="utf-8"))
                    index["functions"].append({"address": "0x4dafb0", "name": "inserted", "evidence_id": "new"})
                    self.write_json(index_path, index)
                with mock.patch.dict(GEN.S08_3_ACCEPTED_PINS, pins, clear=True), mock.patch.object(GEN, "EXPECTED_EXE", original_hash):
                    text = GEN.validate_s08(GEN.load(evidence / "S08-matching-report.json"))["text_section"]
                    result = GEN.validate_s08_3(project, GEN.load(report_path), report_path, text, binding_root=project)
                self.assertFalse(result["valid"], mutation)
                self.assertEqual(result["accepted_function_count"], 0)
                self.assertEqual(result["exact_bytes"], 0)

    def test_s08_3_quarantined_candidate_is_visible_without_positive_byte_credit(self):
        from unittest import mock
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence, report_path, object_path, original_hash, pins, report = self.s08_3_fixture(pathlib.Path(tmp))
            report["status"] = "comparison_failed"
            self.write_json(report_path, report)
            with mock.patch.dict(GEN.S08_3_ACCEPTED_PINS, pins, clear=True), mock.patch.object(GEN, "EXPECTED_EXE", original_hash):
                data = GEN.build_snapshot(
                    project, evidence, "2026-10-13T00:00:00Z",
                    s08_3_object_path=object_path, s08_3_binding_root=project,
                )
        candidate = next(row for row in data["functions"] if row["va"] == 0x4DAF9F)
        self.assertFalse(data["s08_3"]["valid"])
        self.assertIsNone(candidate["assembly_match"])
        self.assertEqual(candidate["assembly_quarantine"]["family"], "S08-3")
        self.assertEqual(candidate["assembly_quarantine"]["exact_bytes_contributed"], 0)
        self.assertEqual(data["summary"]["complete_assembly_bytes"], 0)
    def test_source_bound_s08_2_matches_are_complete_and_union_deduplicates_overlap(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence, report_path, object_path, original_hash, pins = self.s08_2_fixture(pathlib.Path(tmp))
            data = self.build_with_s08_2(project, evidence, original_hash, pins)
        assembly = [row for row in data["functions"] if row["assembly_match"]]
        self.assertTrue(data["s08_2"]["valid"], data["s08_2"]["reason"])
        self.assertEqual(len(assembly), 6)
        self.assertEqual(data["summary"]["complete_assembly_functions"], 6)
        self.assertEqual(data["summary"]["complete_assembly_bytes"], 112)
        self.assertEqual(data["summary"]["partial_exact_ranges"], 2)
        self.assertEqual(data["summary"]["partial_exact_bytes"], 14)
        self.assertEqual(data["summary"]["exact_selected_bytes"], 119)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 7)
        self.assertTrue(all(row["extent_kind"] == "complete range audited to terminal return" for row in assembly))
        overlap = next(row for row in assembly if row["va"] == 0x401111)
        self.assertEqual(len(overlap["exact_ranges"]), 1)
        self.assertEqual(data["summary"]["s08_compiler_mismatches"], 1)
        self.assertEqual(data["s08_2"]["semantic_C_and_CPP"]["C_O0_difference_count"], 62)
        self.assertEqual(data["s08_2"]["semantic_C_and_CPP"]["C_plus_plus_O0_difference_count"], 66)
        c_candidate = next(row for row in data["functions"] if row["va"] == 0x401000)
        self.assertIsNotNone(c_candidate["s08_audit"])
        self.assertIsNone(c_candidate["assembly_match"])

    def test_s08_2_source_object_manifest_and_reassembly_mutants_are_quarantined(self):
        mutations = (
            ("current source changed", "source-file", lambda context: context["source_path"].write_text("different source\n", encoding="utf-8"), False),
            ("current object changed", "object-file", lambda context: context["object_path"].write_bytes(b"wrong object"), False),
            ("current C candidate source changed", "c-source-file", lambda context: context["c_source_path"].write_text("stale C candidate\n", encoding="utf-8"), False),
            ("separate mismatch report changed", "semantic-report", lambda context: context["semantic_path"].write_text("{}\n", encoding="utf-8"), False),
            ("wrong object supplied", "alternate-object", lambda context: context["wrong_object_path"].write_bytes(b"other object"), False),
            ("failed fresh reassembly", "report-reassembly", lambda context: context["report"]["source_object_association"].update(reassembly_matches_audited_object=False), True),
            ("effective manifest binding changed", "report-binding", lambda context: context["report"]["comparison_binding"].update(effective_manifest_sha256="0" * 64), True),
            ("terminal return missing", "report-terminal", lambda context: context["report"]["functions"][0]["range_audit"].update(complete_to_terminal_ret=False), True),
            ("row totals inconsistent", "report-counts", lambda context: context["report"]["comparison"].update(compared_bytes=111), True),
            ("equivalent but unreviewed source", "report-class", lambda context: context["report"].update(classification="equivalent_unreviewed_assembly"), True),
            ("stale report state", "report-stale", lambda context: context["report"].update(status="comparison_failed"), False),
        )
        for label, kind, mutate, repin_report in mutations:
            with self.subTest(case=label), tempfile.TemporaryDirectory() as tmp:
                project, evidence, report_path, object_path, original_hash, pins = self.s08_2_fixture(pathlib.Path(tmp))
                context = {
                    "source_path": project / GEN.S08_2_SOURCE_REF,
                    "object_path": object_path,
                    "c_source_path": project / "outputs/blackmoor-decomp/src/matching_s08.c",
                    "semantic_path": evidence / GEN.S08_2_SEMANTIC_REPORT_NAME,
                    "wrong_object_path": pathlib.Path(tmp) / "wrong.obj",
                    "report": json.loads(report_path.read_text(encoding="utf-8")),
                }
                context["wrong_object_path"].write_bytes(b"not the accepted object")
                mutate(context)
                if kind.startswith("report-"):
                    self.write_json(report_path, context["report"])
                    if repin_report:
                        pins["report_sha256"] = hashlib.sha256(report_path.read_bytes()).hexdigest()
                data = self.build_with_s08_2(
                    project, evidence, original_hash, pins,
                    object_path=context["wrong_object_path"] if kind == "alternate-object" else None,
                )
                self.assertFalse(data["s08_2"]["valid"], label)
                self.assertEqual(data["s08_2"]["accepted_function_count"], 0)
                self.assertEqual(data["summary"]["complete_assembly_bytes"], 0)
                self.assertTrue(all(row["assembly_match"] is None for row in data["functions"]))
                self.assertEqual(data["summary"]["exact_selected_bytes"], 14)

    def test_snapshot_keeps_start_spans_and_exact_extents_distinct(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["inventory"]["indexed_starts"], 2)
        self.assertEqual(data["functions"][0]["size"], 16)
        self.assertEqual(data["functions"][0]["extent_kind"], "complete range audited to terminal return")
        self.assertEqual(data["functions"][0]["address_unit"], "0x0040xxxx")
        self.assertEqual(data["functions"][1]["size"], None)
        self.assertTrue(data["functions"][1]["is_unknown_extent"])
        self.assertEqual(data["inventory"]["text_section"]["unresolved_tail_bytes"], 16)
        self.assertEqual(data["summary"]["exact_selected_bytes"], 7)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 1)
        self.assertEqual(data["summary"]["exact_function_completeness"], "unverified")
        self.assertEqual(data["summary"]["s08_compiler_mismatches"], 1)

    def test_report_only_and_source_bound_oracle_records_are_separate(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        first, last = data["functions"]
        self.assertEqual(first["oracle"][0]["kind"], "bounded-report")
        self.assertEqual(first["oracle"][0]["source_binding"], "not source-hash-bound")
        self.assertEqual(first["oracle_ranges"][0]["start"], 0x401008)
        self.assertIn("not full function coverage", first["oracle_ranges"][0]["coverage_location"])
        bound = next(x for x in last["oracle"] if x["kind"] == "oracle-bound")
        self.assertEqual(bound["source_binding_reason"], "Native source and library SHAs match the validation report.")
        self.assertEqual(data["summary"]["bounded_oracle_source_bound_starts"], 1)
        self.assertEqual(data["summary"]["bounded_oracle_report_only_starts"], 1)

    def test_quarantined_oracle_reports_do_not_create_direct_or_interior_evidence(self):
        mutations = (
            ("wrong original SHA", lambda report: report.update(original_sha256="0" * 64)),
            ("failed report state", lambda report: report.update(status="comparison_failed")),
            ("nonzero mismatches", lambda report: report.update(mismatches=["mismatch"])),
        )
        for label, mutate in mutations:
            with self.subTest(case=label):
                with tempfile.TemporaryDirectory() as tmp:
                    project, evidence = self.fixture(pathlib.Path(tmp))
                    path = evidence / "A-64-original-oracle.json"
                    report = json.loads(path.read_text(encoding="utf-8"))
                    mutate(report)
                    self.write_json(path, report)
                    data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
                report_row = next(row for row in data["oracle_reports"] if row["id"] == "action64")
                mapped = [window for function in data["functions"]
                          for window in function["oracle"] + function["oracle_ranges"]
                          if window["report_id"] == "action64"]
                self.assertEqual(mapped, [])
                self.assertEqual(report_row["entrypoint_count"], 0)
                self.assertEqual(report_row["quarantined_range_count"], 2)
                self.assertTrue(report_row["status"].startswith("quarantined:"))
                self.assertEqual({row["start"] for row in report_row["quarantined_ranges"]}, {0x401008, 0x401010})

    def test_external_evidence_links_resolve_to_files_whose_hashes_are_shown(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            local_evidence = project / "work/analysis/slices"
            local_evidence.unlink()
            local_evidence.mkdir(parents=True)
            for name in ("S08-matching-report.json", "A-64-original-oracle.json", "A-64-validation.json", "S05-claim.json"):
                (local_evidence / name).write_text('{"wrong":"local collision"}\n', encoding="utf-8")
            artifact = pathlib.Path(tmp) / "canonical-artifact-root"
            artifact.mkdir()
            (artifact / "outputs").symlink_to(project / "outputs", target_is_directory=True)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z", artifact_root=artifact)
            outdir = artifact / "outputs/blackmoor-decomp/progress-map"
            a64 = next(row for row in data["oracle_reports"] if row["id"] == "action64")
            s05 = next(row for row in data["slices"] if row["id"] == "S05")["claims"][0]
            s08_binding = data["report_bindings"][2]
            linked = (
                ("S08 snapshot", data["s08"]["report_link"], data["s08"]["report_sha256"]),
                ("S08 lineage", s08_binding["link"], s08_binding["sha256"]),
                ("A64 report", a64["report_link"], a64["report_sha256"]),
                ("A64 validation", a64["binding_report_link"], a64["binding_report_sha256"]),
                ("claim receipt", s05["link"], s05["sha256"]),
                ("project source", data["report_bindings"][0]["link"], data["report_bindings"][0]["sha256"]),
            )
            for label, link, expected_hash in linked:
                with self.subTest(input=label):
                    linked_path = outdir / link
                    resolved = linked_path.resolve()
                    if label == "project source":
                        self.assertTrue(linked_path.absolute().is_relative_to(artifact.absolute()))
                    else:
                        self.assertTrue(resolved.is_relative_to(evidence.resolve()))
                    self.assertEqual(hashlib.sha256(resolved.read_bytes()).hexdigest(), expected_hash)

    def test_relocated_matching_report_link_copies_exact_source_metadata_when_artifact_differs(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            project, evidence = self.fixture(root)
            source_path = project / GEN.MATCHING_REPORT
            source_report = json.loads(source_path.read_text(encoding="utf-8"))
            source_report["source"] = str(project / "build-root" / "matching.bin")
            self.write_json(source_path, source_report)
            source_bytes = source_path.read_bytes()
            source_sha = hashlib.sha256(source_bytes).hexdigest()

            artifact = root / "collected-checkout"
            shutil.copytree(project / "outputs", artifact / "outputs")
            artifact_report_path = artifact / GEN.MATCHING_REPORT
            artifact_report = json.loads(artifact_report_path.read_text(encoding="utf-8"))
            artifact_report["source"] = "/old-managed-worktree/build/matching.bin"
            self.write_json(artifact_report_path, artifact_report)
            self.assertNotEqual(hashlib.sha256(artifact_report_path.read_bytes()).hexdigest(), source_sha)

            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z", artifact_root=artifact)
            binding = next(row for row in data["report_bindings"] if row["name"] == "matching-report.json")
            outdir = artifact / GEN.OUT
            linked_path = (outdir / binding["link"]).resolve()

            self.assertEqual(binding["sha256"], source_sha)
            self.assertEqual(binding["link"], GEN.MATCHING_REPORT_COPY.as_posix())
            self.assertTrue(linked_path.is_relative_to(outdir.resolve()))
            self.assertEqual(linked_path.read_bytes(), source_bytes)
            self.assertEqual(hashlib.sha256(linked_path.read_bytes()).hexdigest(), binding["sha256"])
            self.assertTrue(data["matching_validation"]["valid"])

    def test_source_match_does_not_hide_native_library_mismatch(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            report_path = evidence / "A-64-original-oracle.json"
            report = json.loads(report_path.read_text(encoding="utf-8"))
            report["native_library_sha256"] = "different-native"
            self.write_json(report_path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        record = next(x for x in data["oracle_reports"] if x["id"] == "action64")
        self.assertEqual(record["source_binding_reason"], "Source SHA matches; native-library SHA differs from the validation report.")
        self.assertEqual(record["source_binding"], "not source-hash-bound")
        self.assertEqual(data["summary"]["bounded_oracle_source_bound_starts"], 0)

    def test_stale_action_census_is_not_used_as_a_metric(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["census"]["included_in_metrics"])
        self.assertIn("suppressed", data["census"]["state"])

    def test_wrong_executable_matching_report_is_quarantined(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["original_sha256"] = "0" * 64
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 0)
        self.assertEqual(data["functions"][0]["exact_ranges"], [])
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertIn("quarantined", data["report_bindings"][1]["note"])

    def test_wrong_executable_manifest_cannot_pass_report_binding(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matches.json"
            manifest = json.loads(path.read_text(encoding="utf-8"))
            manifest["original_sha256"] = "0" * 64
            self.write_json(path, manifest)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertIn("manifest original SHA", data["matching_validation"]["reason"])

    def test_failed_matching_state_is_quarantined_even_with_exact_row_flags(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "comparison_failed"
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertFalse(data["matching_validation"]["valid"])

    def test_stale_matching_state_is_quarantined(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = project / "outputs/blackmoor-decomp/matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "stale"
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)

    def test_per_range_flag_and_digest_must_be_exact(self):
        mutations = (
            ("non-boolean exact flag", lambda row: row.update(exact_byte_range="true")),
            ("different per-range digest", lambda row: row.update(original_sha256="2" * 64)),
        )
        for label, mutate in mutations:
            with self.subTest(case=label):
                with tempfile.TemporaryDirectory() as tmp:
                    project, evidence = self.fixture(pathlib.Path(tmp))
                    path = project / "outputs/blackmoor-decomp/matching-report.json"
                    report = json.loads(path.read_text(encoding="utf-8"))
                    mutate(report["functions"][0])
                    self.write_json(path, report)
                    data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
                self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
                if data["matching_validation"]["valid"]:
                    self.assertEqual(len(data["matching_validation"]["rejected_ranges"]), 1)

    def test_wrong_executable_s08_report_cannot_promote_audited_extents(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = evidence / "S08-matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["original"]["sha256"] = "0" * 64
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["s08"]["validation"]["valid"])
        self.assertEqual(data["summary"]["s08_audited_extents"], 0)
        self.assertTrue(all(f["s08_audit"] is None for f in data["functions"]))
        self.assertIsNone(data["inventory"]["text_section"]["unresolved_tail_bytes"])
        self.assertIn("quarantined", data["report_bindings"][2]["note"])

    def test_out_of_function_exact_range_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"][0].update(rva=0x100F, size=2)
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["functions"][0].update(rva=0x100F, size=2, compared_bytes=2)
            report["exact_byte_range_bytes"] = 2
            report["bytes"]["exact_byte_ranges"] = 2
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertTrue(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 0)
        self.assertEqual(len(data["matching_validation"]["rejected_ranges"]), 1)

    def test_s08_out_of_bounds_range_quarantines_audit(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            path = evidence / "S08-matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["functions"][0]["end_va"] = 0x401021
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertFalse(data["s08"]["validation"]["valid"])
        self.assertEqual(data["summary"]["s08_audited_extents"], 0)

    def test_partial_report_mismatch_does_not_discard_individually_exact_range(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"].append({"rva": 0x1010, "size": 1, "symbol": "mismatch"})
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            report["status"] = "partial_comparison"
            report["functions"].append({
                "rva": 0x1010, "size": 1, "compared_bytes": 1,
                "exact_byte_range": False, "status": "byte-range-mismatch",
                "differences": [{"offset": 0}],
            })
            report.update(function_count=2, mismatch_count=1, difference_count=1,
                          mismatch_bytes=1, difference_bytes=1, all_byte_ranges_exact=False)
            report["counts"].update(functions=2, mismatches=1, differences=1)
            report["bytes"].update(mismatches=1, differences=1)
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertTrue(data["matching_validation"]["valid"])
        self.assertEqual(data["summary"]["exact_selected_bytes"], 7)
        self.assertEqual(data["functions"][0]["exact_ranges"][0]["bytes"], 7)

    def test_overlapping_exact_ranges_count_covered_bytes_once(self):
        with tempfile.TemporaryDirectory() as tmp:
            project, evidence = self.fixture(pathlib.Path(tmp))
            out = project / "outputs/blackmoor-decomp"
            manifest_path = out / "matches.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            manifest["functions"].append({"rva": 0x1004, "size": 4, "symbol": "overlap"})
            self.write_json(manifest_path, manifest)
            path = out / "matching-report.json"
            report = json.loads(path.read_text(encoding="utf-8"))
            item = dict(report["functions"][0], rva=0x1004, size=4, compared_bytes=4)
            report["functions"].append(item)
            report["function_count"] = 2
            report["exact_byte_range_count"] = 2
            report["exact_byte_range_bytes"] = 11
            report["counts"].update(functions=2, exact_byte_ranges=2)
            report["bytes"]["exact_byte_ranges"] = 11
            self.write_json(path, report)
            data = GEN.build_snapshot(project, evidence, "2026-10-13T00:00:00Z")
        self.assertEqual(data["summary"]["exact_source_ranges"], 2)
        self.assertEqual(data["summary"]["exact_selected_ranges"], 1)
        self.assertEqual(data["summary"]["exact_selected_bytes"], 8)
        self.assertEqual(data["functions"][0]["exact_ranges"][0]["size"], 8)

    def test_embedded_json_cannot_close_its_script_element(self):
        html = GEN.embed(
            '<script type="application/json">__SNAPSHOT_JSON__</script>',
            {"name": "</script><script>alert(1)</script>"},
        )
        self.assertNotIn("</script><script>alert", html)
        self.assertIn("\\u003c/script\\u003e", html)


if __name__ == "__main__":
    unittest.main()
