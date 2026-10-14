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
    source = re.sub(r"\bfield_minus_([0-9a-f]+)\b", r"member_minus_\1", source)
    source = re.sub(r"\bfield_([0-9a-f]+)\b", r"member_\1", source)
    source = re.sub(r"\bstk_minus_([0-9a-f]+)\b", r"stackslot_minus_\1", source)
    source = re.sub(r"\bstk_([0-9a-f]+)\b", r"stackslot_\1", source)
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

    def config(self, assembler: Path = None, allow_index_byte_lists: bool = True) -> "audit.AuditConfig":
        return audit.AuditConfig(
            allow_index_byte_lists=allow_index_byte_lists,
            original=self.original,
            index=self.index,
            assembler=assembler or gen.AS_DEFAULT,
            expected_sha256=self.pe_sha,
            strict_image=False,
            repository=None,
            baseline_dir=None,
            image_base=0x400000,
        )

    def batch(self, mutate=None, manifest_edit=None, config=None):
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
        return audit.audit_manifest(path, config or self.config()), work, manifest

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
        self.rejected(report, va, "unnamed register-relative offset")

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

    # ------------------------------------------------------- reviewer-found bypasses

    def test_statement_separator_on_an_instruction_line_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", "    pop ebp; .byte 0x5d ", 1))
        self.rejected(report, va, "statement separator")

    def test_label_followed_by_a_directive_is_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", "lbl1: .byte 0x5d ", 1))
        self.rejected(report, va, "label and statement on one line")

    def test_incbin_and_macro_style_lines_are_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", '    .incbin "/tmp/x.bin" ', 1))
        self.rejected(report, va, "directive or raw data")
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "    pop ebp ", "    mypop ebp ", 1))
        self.rejected(report, va, "not an instruction mnemonic")

    def test_extra_code_after_the_final_ret_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME

        def append(work: Path) -> None:
            path = work / f"FUN_{va:08x}.s"
            path.write_text(path.read_text(encoding="utf-8") + "    nop\n    nop\n    nop\n    nop\n    nop\n", encoding="utf-8")

        report, _w, _m = self.batch(mutate=append)
        self.rejected(report, va, "object .text is")

    def test_extra_data_after_the_switch_table_is_rejected(self) -> None:
        va = BASE + fixture.F_SWITCH

        def append(work: Path) -> None:
            path = work / f"FUN_{va:08x}.s"
            text = path.read_text(encoding="utf-8")
            label = re.search(r"^(L_[0-9a-f]{8}|\w+):$", text, re.M | re.S)
            label = re.findall(r"^(\w+):$", text, re.M)[1]
            path.write_text(text + f"    .long {label} - .text + 0x401000\n", encoding="utf-8")

        report, _w, _m = self.batch(mutate=append)
        self.rejected(report, va, "")

    def test_numeric_ebp_offsets_in_any_spelling_are_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        for spelling in ("[ebp - 0X4]", "[ebp - 0b100]", "[ebp-4]"):
            report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "[ebp - local_slot4]", spelling))
            self.rejected(report, va, "unnamed register-relative offset")

    def test_short_frame_names_are_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "local_slot4", "a", 100))
        self.rejected(report, va, "too short to be a name")

    def test_placeholder_dodges_are_rejected(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "none; every branch was reassembled", "TBD."))
        self.rejected(report, va, "placeholder")
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "# this block does the fixture's work", "# TODO fill this in later"))
        self.rejected(report, va, "has no comment")
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "fixture_00401040", f"sub_{va:08x}"))
        self.rejected(report, va, "not a real name")
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "<unfilled>", "< unfilled >") if False else self.edit(w, va, "stack arguments of the fixture", "< unfilled >"))
        self.rejected(report, va, "placeholder")

    def test_header_evidence_and_span_are_checked(self) -> None:
        va = BASE + fixture.F_LEAF
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "# evidence:     ev_fixture", "# evidence:     ev_bogus"))
        self.rejected(report, va, "header 'evidence'")
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "# span:         ", "# span:         nothing "))
        self.rejected(report, va, "header 'span'")

    def test_a_wrapper_that_forges_the_version_line_is_rejected(self) -> None:
        # prints the pinned version but silently drops the {load} hint: the self-test must catch it
        shim = Path(self.tmp.name) / "shim-as"
        shim.write_text(
            "#!/bin/sh\n"
            "out=; src=; prev=\n"
            "for a in \"$@\"; do if [ \"$prev\" = -o ]; then out=$a; fi; prev=$a; src=$a; done\n"
            f"sed 's/{{load}} //' \"$src\" > \"$src.tmp\"\n"
            f"exec {gen.AS_DEFAULT} --32 -o \"$out\" \"$src.tmp\"\n"
        )
        shim.chmod(shim.stat().st_mode | stat.S_IEXEC)
        work = Path(tempfile.mkdtemp(dir=self.tmp.name))
        for path in self.pristine.glob("*.s"):
            shutil.copy(path, work / path.name)
        manifest = gen.build_manifest(self.image, self.layouts, [BASE + off for off in FUNCTIONS], work, "test", "fixture", original_sha256=self.pe_sha)
        path = work / "batch.json"
        path.write_text(json.dumps(manifest), encoding="utf-8")
        report = audit.audit_manifest(path, self.config(assembler=shim))
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("self-test" in e or "version" in e for e in report["errors"]), report["errors"])

    def test_source_path_cannot_leave_the_manifest_directory(self) -> None:
        va = BASE + fixture.F_LEAF

        def escape(manifest) -> None:
            for entry in manifest["functions"]:
                if entry["va"] == f"0x{va:08x}":
                    entry["source"] = "../" + Path(self.tmp.name).name + "/pristine/" + Path(entry["source"]).name

        report, _w, _m = self.batch(manifest_edit=escape)
        self.rejected(report, va, "leaves the manifest directory")

    def test_external_symbol_must_name_its_target_address(self) -> None:
        va = BASE + fixture.F_FRAME
        leaf = f"{BASE + fixture.F_LEAF:08x}"
        def rename(w: Path) -> None:
            path = w / f"FUN_{va:08x}.s"
            path.write_text(path.read_text(encoding="utf-8").replace(f"FUN_{leaf}", "FUN_deadbeef"), encoding="utf-8")
        report, _w, _m = self.batch(mutate=rename)
        self.rejected(report, va, "does not name its target")

    def test_external_set_base_must_be_the_text_base(self) -> None:
        va = BASE + fixture.F_FRAME
        leaf = f"{BASE + fixture.F_LEAF:08x}"
        def shift(w: Path) -> None:
            path = w / f"FUN_{va:08x}.s"
            text = path.read_text(encoding="utf-8")
            text = text.replace(f"FUN_{leaf}, .text + (0x{leaf} - 0x401000)", f"FUN_{leaf}, .text + (0x{leaf} - 0x402000)")
            path.write_text(text, encoding="utf-8")
        report, _w, _m = self.batch(mutate=shift)
        self.rejected(report, va, "is not the text base")

    def test_location_relative_branch_operand_is_rejected(self) -> None:
        va = BASE + fixture.F_FRAME
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, "jmp.d8 L_", "jmp.d8 . + 0x0 + L_") if False else self.edit(w, va, "call FUN_" + f"{BASE + fixture.F_LEAF:08x}", "call . + 0x20"))
        self.rejected(report, va, "direct branch operand")

    def test_unnamed_frame_offset_in_an_insn_line_is_rejected(self) -> None:
        reasons, _facts = audit.audit_source(
            "# FUN_00401000\n# frame:        ebp\nFUN_00401000:\n    .insn 0x6681/7, dword ptr [ebp - 0x4], 1{:s16}\n    ret\n", {}, "FUN_00401000"
        )
        self.assertTrue(any("unnamed register-relative offset" in r for r in reasons), reasons)

    def test_track_n_path_cannot_leave_the_repository(self) -> None:
        va = BASE + fixture.F_LEAF
        outside = Path(self.tmp.name) / "outside.c"
        outside.write_text("int outside_symbol_name;\n", encoding="utf-8")
        config = self.config()
        config.repository = Path(self.tmp.name) / "pristine"
        report, _w, _m = self.batch(
            mutate=lambda w: self.edit(w, va, "host-adapter: none", "../outside.c:outside_symbol_name"), config=config
        )
        self.rejected(report, va, "leaves the repository")

    def test_ebp_offsets_are_audited_even_when_the_header_says_no_frame(self) -> None:
        reasons, _facts = audit.audit_source(
            "# FUN_00401000\n# frame:        none\nFUN_00401000:\n    mov edi, edi\n    push ebp\n    {load} mov ebp, esp\n"
            "    mov eax, dword ptr [ebp - 0x4]\n    ret\n", {}, "FUN_00401000"
        )
        self.assertTrue(any("unnamed register-relative offset" in r for r in reasons), reasons)

    def test_raw_and_default_named_field_offsets_are_rejected(self) -> None:
        body = "# FUN_00401000\n# frame:        none\nFUN_00401000:\n    {operand}\n    ret\n"
        for operand, needle in (
            ("mov eax, dword ptr [ecx + 0x18]", "unnamed register-relative offset"),
            ("mov eax, dword ptr [esp + 4]", "unnamed register-relative offset"),
            ("mov eax, dword ptr [ecx + field_18]", "placeholder name"),
        ):
            reasons, _ = audit.audit_source(body.format(operand=operand), {}, "FUN_00401000")
            self.assertTrue(any(needle in r for r in reasons), (operand, reasons))
        ok, _ = audit.audit_source(body.format(operand="mov eax, dword ptr [ecx + 0x5c3a00]"), {}, "FUN_00401000")
        self.assertFalse(any("register-relative" in r for r in ok), ok)

    def test_index_table_must_name_its_owner_and_switch(self) -> None:
        va = BASE + fixture.F_SWITCH
        label_comment = f"index table of FUN_{va:08x} for the switch jump at"
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, label_comment, "index table of someone else for the switch jump at"))
        self.rejected(report, va, "not labeled with its owning function and switch")

    def test_table_symbol_must_name_its_table(self) -> None:
        va = BASE + fixture.F_SWITCH
        tab = re.search(r"SWTAB_([0-9a-f]{8})_VA", (self.pristine / f"FUN_{va:08x}.s").read_text(encoding="utf-8")).group(1)
        report, _w, _m = self.batch(mutate=lambda w: self.edit(w, va, f"SWTAB_{tab}_VA", "SWTAB_deadbeef_VA", 10))
        self.rejected(report, va, "")

    def test_index_table_byte_lists_need_a_ruling_by_default(self) -> None:
        va = BASE + fixture.F_SWITCH
        report, _w, _m = self.batch(config=self.config(allow_index_byte_lists=False))
        self.rejected(report, va, "needs a root ruling")

    def test_short_branch_to_another_function_must_name_a_defined_symbol(self) -> None:
        # the generator writes F_TAIL's short jump as '. + (n)  # -> FUN_x'; the note must name a .set symbol
        source = gen.render_file(self.image, gen.analyze_all(self.image, [BASE + fixture.F_TAIL])[0][BASE + fixture.F_TAIL])
        self.assertRegex(source, r"jmp\.d8 \. \+ \(-?\d+\)\s+# -> FUN_[0-9a-f]{8}")
        broken = re.sub(r"(# -> )FUN_([0-9a-f]{8})", r"\g<1>FUN_deadbeef", source, count=1)
        reasons, _facts = audit.audit_source(annotate(broken, BASE + fixture.F_TAIL), {}, f"FUN_{BASE + fixture.F_TAIL:08x}", True)
        self.assertTrue(any("short branch to another function" in r for r in reasons), reasons)


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
