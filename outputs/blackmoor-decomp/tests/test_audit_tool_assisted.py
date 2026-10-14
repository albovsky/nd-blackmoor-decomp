"""Mutant tests for the tool-assisted assembly auditor (packet M03).

A synthetic ``.text`` (assembled here with the pinned assembler) is wrapped in
a minimal PE, the generator renders its functions, the functions are
"annotated" mechanically, and the auditor must accept the pristine batch and
reject every mutant: a wrong hint, a dropped label, a raw ``.byte`` run, an
unnamed frame offset, a stale hash, an object from another assembler, an
object that carries a relocation and a span whose table bytes were counted as
code.
"""

import hashlib
import importlib.util
import json
import re
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

TESTS = Path(__file__).resolve().parent
SCRIPTS = TESTS.parent / "scripts"
sys.path.insert(0, str(TESTS))

from test_verify_matches import make_pe  # noqa: E402
import test_gen_hinted_asm as fixture  # noqa: E402

gen = fixture.gen


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


audit = load("audit_tool_assisted_under_test", SCRIPTS / "audit_tool_assisted.py")

BASE = fixture.BASE
FUNCTIONS = [fixture.F_FRAME, fixture.F_SWITCH, fixture.F_LEAF]

FIELDS = {
    "name": "fixture_{}",
    "arguments": "stack arguments of the fixture",
    "locals": "fixture locals, named below",
    "fields": "none (no object fields touched)",
    "callees": "fixture callee reached through a resolved symbol",
    "track-n": "host-adapter: none",
    "unverified": "none; every branch was reassembled",
}


def annotate(source: str, va: int) -> str:
    """What an implementer does to a generated file, done mechanically."""

    for key, value in FIELDS.items():
        source = re.sub(rf"(# {key}:\s+)<unfilled>", lambda m: m.group(1) + value.format(f"{va:08x}"), source)
    source = re.sub(r"\blocal_([0-9a-f]+)\b", r"local_slot\1", source)
    source = re.sub(r"\barg_([0-9a-f]+)\b", r"arg_slot\1", source)
    source = re.sub(r"# block 0x[0-9a-f]+: <unfilled>", "# this block does the fixture's work", source)
    return source


@fixture.TOOLS
class AuditorMutants(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = tempfile.TemporaryDirectory()
        root = Path(cls.tmp.name)
        text = fixture.assemble_synthetic(root)
        cls.text = text
        pe = make_pe(text, virtual_size=len(text), raw_size=(len(text) + 0x1FF) & ~0x1FF)
        cls.original = root / "SYNTH.EXE"
        cls.original.write_bytes(pe)
        cls.pe_sha = hashlib.sha256(pe).hexdigest()
        starts = [BASE + off for off in (fixture.F_FRAME, fixture.F_LEAF, fixture.F_SWITCH, fixture.F_PAD, fixture.F_DERIVED_PARENT, fixture.F_TAIL)]
        cls.index = root / "function-index.json"
        cls.index.write_text(
            json.dumps(
                {
                    "original_sha256": cls.pe_sha,
                    "functions": [{"address": f"0x{a:08x}", "evidence_id": "ev_fixture"} for a in starts],
                }
            ),
            encoding="utf-8",
        )
        cls.image = gen.load_image(cls.original, cls.index, cls.pe_sha, strict=False)
        cls.layouts, _ = gen.analyze_all(cls.image, [BASE + off for off in FUNCTIONS])
        cls.pristine = root / "pristine"
        cls.pristine.mkdir()
        for off in FUNCTIONS:
            va = BASE + off
            source = annotate(gen.render_file(cls.image, cls.layouts[va]), va)
            (cls.pristine / f"FUN_{va:08x}.s").write_text(source, encoding="utf-8")

    @classmethod
    def tearDownClass(cls) -> None:
        cls.tmp.cleanup()

    # ------------------------------------------------------------------ helpers

    def config(self, assembler: Path = None) -> "audit.AuditConfig":
        return audit.AuditConfig(
            original=self.original,
            index=self.index,
            assembler=assembler or gen.AS_DEFAULT,
            expected_sha256=self.pe_sha,
            strict_image=False,
            repository=None,
            baseline_dir=None,
            image_base=0x400000,
        )

    def batch(self, mutate=None, manifest_edit=None, objects=None):
        """Copy the pristine batch, apply ``mutate(dir)``, rebuild the manifest, audit."""

        work = Path(tempfile.mkdtemp(dir=self.tmp.name))
        for path in self.pristine.glob("*.s"):
            shutil.copy(path, work / path.name)
        if mutate:
            mutate(work)
        vas = [BASE + off for off in FUNCTIONS]
        manifest = gen.build_manifest(self.image, self.layouts, vas, work, "test", "fixture", original_sha256=self.pe_sha)
        if manifest_edit:
            manifest_edit(manifest)
        path = work / "batch.json"
        path.write_text(json.dumps(manifest), encoding="utf-8")
        return audit.audit_manifest(path, self.config()), work, manifest

    def rejected(self, report, symbol_va: int, needle: str) -> None:
        by_name = {f["function"]: f for f in report["functions"]}
        result = by_name[f"FUN_{symbol_va:08x}"]
        self.assertEqual(result["status"], "rejected", result)
        self.assertTrue(any(needle in reason for reason in result["reasons"]), (needle, result["reasons"]))
        self.assertFalse(report["all_accepted"])

    @staticmethod
    def edit(work: Path, va: int, old: str, new: str, count: int = 1) -> None:
        path = work / f"FUN_{va:08x}.s"
        text = path.read_text(encoding="utf-8")
        assert old in text, (old, path.name)
        path.write_text(text.replace(old, new, count), encoding="utf-8")

    # ------------------------------------------------------------------ pristine

    def test_pristine_batch_is_accepted(self) -> None:
        report, _work, _manifest = self.batch()
        self.assertEqual([f["reasons"] for f in report["functions"]], [[], [], []])
        self.assertTrue(report["all_accepted"])
        self.assertEqual(report["accepted_count"], 3)
        self.assertEqual(report["contains_original_byte_values"], False)
        self.assertEqual(report["assembler"]["version_line"], audit.ASSEMBLER_VERSION_LINE)
        for result in report["functions"]:
            self.assertEqual(result["relocations"], 0)
            self.assertEqual(len(result["source"]["sha256"]), 64)
            self.assertEqual(len(result["object"]["sha256"]), 64)
        switch = next(f for f in report["functions"] if f["va"] == BASE + fixture.F_SWITCH)
        kinds = [item["kind"] for item in switch["data_items"]]
        self.assertEqual(kinds[:2], ["switch_table", "index_table"])
        self.assertGreater(len(report["data_items_for_m02"]), 0)

    def test_unannotated_generator_output_is_rejected(self) -> None:
        def revert(work: Path) -> None:
            va = BASE + fixture.F_LEAF
            (work / f"FUN_{va:08x}.s").write_text(gen.render_file(self.image, self.layouts[va]), encoding="utf-8")

        report, _w, _m = self.batch(mutate=revert)
        self.rejected(report, BASE + fixture.F_LEAF, "placeholder")

    # ------------------------------------------------------------------ mutants

    def test_wrong_hint_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "{load} mov ebp, esp", "mov ebp, esp"))
        self.rejected(report, va, "byte-range-mismatch")

    def test_dropped_label_is_rejected(self) -> None:
        va = BASE + fixture.F_SWITCH
        label = f"L_{BASE + 0x60 + 0x1c:08x}"

        def drop(work: Path) -> None:
            path = work / f"FUN_{va:08x}.s"
            lines = path.read_text(encoding="utf-8").splitlines()
            kept = [l for l in lines if not re.match(r"^L_[0-9a-f]{8}:$", l)][:]
            self.assertLess(len(kept), len(lines))
            path.write_text("\n".join(kept) + "\n", encoding="utf-8")

        report, _w, _m = self.batch(mutate=drop)
        self.assertEqual(label[:2], "L_")
        self.rejected(report, va, "")  # assembler error or relocation, both reject

    def test_raw_byte_run_in_code_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", "    .byte 0x5d ", 1))
        self.rejected(report, va, "directive or raw data")

    def test_inline_insn_outside_the_five_spellings_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", "    .insn 0x5d ", 1))
        self.rejected(report, va, "directive or raw data")

    def test_unnamed_frame_offset_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "[ebp - local_slot4]", "[ebp - 4]"))
        self.rejected(report, va, "unnamed [ebp")

    def test_frame_symbol_left_with_the_default_name_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "local_slot4", "local_4", 100))
        self.rejected(report, va, "default name")

    def test_block_without_a_comment_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(
            mutate=lambda w: self.edit(w, va, "# this block does the fixture's work", "", 1)
        )
        self.rejected(report, va, "has no comment")

    def test_stale_source_hash_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF

        def stale(manifest) -> None:
            for entry in manifest["functions"]:
                if entry["va"] == f"0x{va:08x}":
                    entry["source_sha256"] = "0" * 64

        report, _w, _m = self.batch(manifest_edit=stale)
        self.rejected(report, va, "source_sha256 in the manifest is stale")

    def test_stale_original_extent_hash_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF

        def stale(manifest) -> None:
            for entry in manifest["functions"]:
                if entry["va"] == f"0x{va:08x}":
                    entry["code"]["sha256"] = "1" * 64

        report, _w, _m = self.batch(manifest_edit=stale)
        self.rejected(report, va, "code sha256")

    def test_header_hash_must_match_the_original_extent(self) -> None:
        va = BASE + fixture.F_LEAF

        def wrong(work: Path) -> None:
            path = work / f"FUN_{va:08x}.s"
            text = path.read_text(encoding="utf-8")
            path.write_text(re.sub(r"(# sha256:\s+)[0-9a-f]{64}", r"\g<1>" + "2" * 64, text), encoding="utf-8")

        report, _w, _m = self.batch(mutate=wrong)
        self.rejected(report, va, "header 'sha256'")

    def test_object_from_another_assembler_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        # a stub that claims to be Xcode's toolchain instead of the pinned GNU as
        stub = Path(self.tmp.name) / "fake-as"
        stub.write_text("#!/bin/sh\nif [ \"$1\" = --version ]; then echo 'Apple clang version 21.0.0'; exit 0; fi\nexit 1\n")
        stub.chmod(stub.stat().st_mode | stat.S_IEXEC)
        work = Path(tempfile.mkdtemp(dir=self.tmp.name))
        for path in self.pristine.glob("*.s"):
            shutil.copy(path, work / path.name)
        manifest = gen.build_manifest(self.image, self.layouts, [BASE + off for off in FUNCTIONS], work, "test", "fixture", original_sha256=self.pe_sha)
        path = work / "batch.json"
        path.write_text(json.dumps(manifest), encoding="utf-8")
        report = audit.audit_manifest(path, self.config(assembler=stub))
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("not the pinned" in e for e in report["errors"]), report["errors"])
        # a pre-built object that the pinned assembler does not reproduce is rejected as well
        other = work / "other.obj"
        (work / "other.s").write_text(
            (work / f"FUN_{va:08x}.s").read_text(encoding="utf-8").replace("{load} mov ebp, esp", "mov ebp, esp"), encoding="utf-8"
        )
        subprocess.run([str(gen.AS_DEFAULT), "--32", "-o", str(other), str(work / "other.s")], check=True)

        def attach(m) -> None:
            for entry in m["functions"]:
                if entry["va"] == f"0x{va:08x}":
                    entry["object"] = "other.obj"

        report, _w, _m = self.batch(manifest_edit=lambda m: None)
        manifest = json.loads(path.read_text(encoding="utf-8"))
        attach(manifest)
        path.write_text(json.dumps(manifest), encoding="utf-8")
        report = audit.audit_manifest(path, self.config())
        self.rejected(report, va, "supplied object is not the pinned assembler's output")

    def test_object_with_a_relocation_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        # a numeric call target leaves a PC-relative relocation in COFF
        report, _w, _m = self.batch(
            mutate=lambda w: self.edit(w, va, "call FUN_" + f"{BASE + fixture.F_LEAF:08x}", f"call 0x{BASE + fixture.F_LEAF:08x}")
        )
        self.rejected(report, va, "relocation")

    def test_table_bytes_counted_as_code_are_rejected(self) -> None:
        va = BASE + fixture.F_SWITCH
        tables = sum(item.size for item in self.layouts[va].data if item.kind != "padding")
        self.assertGreater(tables, 0)

        def into_code(manifest) -> None:
            for entry in manifest["functions"]:
                if entry["va"] == f"0x{va:08x}":
                    entry["code"]["size"] += tables
                    entry["data_items"] = [i for i in entry["data_items"] if i["kind"] == "padding"]

        report, _w, _m = self.batch(manifest_edit=into_code)
        self.rejected(report, va, "differs from the span split")

    def test_table_directive_inside_the_code_part_is_rejected(self) -> None:
        va = BASE + fixture.F_SWITCH
        report, _w, _m = self.batch(
            mutate=lambda w: self.edit(w, va, "    ret 0x4 ", "    ret 0x4 \n    .long 0x401078 ", 1)
        )
        self.rejected(report, va, "directive or raw data")

    def test_overlapping_functions_are_rejected(self) -> None:
        va = BASE + fixture.F_FRAME

        def duplicate(manifest) -> None:
            manifest["functions"].append(dict(manifest["functions"][0]))

        work = Path(tempfile.mkdtemp(dir=self.tmp.name))
        for path in self.pristine.glob("*.s"):
            shutil.copy(path, work / path.name)
        manifest = gen.build_manifest(self.image, self.layouts, [BASE + off for off in FUNCTIONS], work, "test", "fixture", original_sha256=self.pe_sha)
        duplicate(manifest)
        path = work / "batch.json"
        path.write_text(json.dumps(manifest), encoding="utf-8")
        report = audit.audit_manifest(path, self.config())
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("overlaps" in r for f in report["functions"] for r in f["reasons"]))


@fixture.TOOLS
class CommittedBatch(unittest.TestCase):
    """The committed batch against the owner's local GAME.EXE (skipped when absent)."""

    MANIFEST = TESTS.parent / "asm" / "batch-001.json"

    def test_batch_001_is_accepted_and_matches_the_committed_report(self) -> None:
        if not gen.ORIGINAL_DEFAULT.is_file():
            self.skipTest("local GAME.EXE not available")
        report = audit.audit_manifest(self.MANIFEST, audit.AuditConfig())
        self.assertEqual(report["errors"], [])
        self.assertEqual([f["function"] for f in report["functions"] if f["status"] != "accepted"], [])
        self.assertTrue(report["all_accepted"])
        committed = json.loads((TESTS.parent / "asm" / "batch-001-report.json").read_text(encoding="utf-8"))
        self.assertEqual(report["code_bytes_accepted"], committed["code_bytes_accepted"])
        self.assertEqual(
            [f["source"]["sha256"] for f in report["functions"]],
            [f["source"]["sha256"] for f in committed["functions"]],
        )
        # a real switch table is part of the batch and is audited as a separate data item
        dispatcher = next(f for f in report["functions"] if f["function"] == "FUN_00438150")
        self.assertEqual([i["kind"] for i in dispatcher["data_items"]], ["switch_table"])


if __name__ == "__main__":
    unittest.main()
