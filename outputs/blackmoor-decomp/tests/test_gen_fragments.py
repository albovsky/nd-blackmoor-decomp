"""Tests for the fragment endings and block-copy cutting (Track M slice 4, owner ruling of 2026-10-16).

A synthetic ``.text`` assembled with the pinned assembler: a function that ends in a call with no data after it, a
fragment that falls through into the next function, and a routine whose jump table sits between two code runs.
"""

import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import tempfile
import unittest
from unittest import mock
from pathlib import Path

TESTS = Path(__file__).resolve().parent
SCRIPTS = TESTS.parent / "scripts"
sys.path.insert(0, str(TESTS))
sys.path.insert(0, str(SCRIPTS))

from test_verify_matches import make_pe  # noqa: E402
import test_gen_hinted_asm as fixture  # noqa: E402
import gen_fragments  # noqa: E402


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


audit = load("audit_tool_assisted_for_fragments", SCRIPTS / "audit_tool_assisted.py")
machine = load("annotate_machine_for_fragments", SCRIPTS / "annotate_machine.py")

BASE = 0x401000
SOURCE = """.intel_syntax noprefix
.code32
.text
.org 0x00, 0xcc
G_RET:
    mov eax, 1
    ret
.org 0x20, 0xcc
G_CALL:
    push 0
    push 0
    call G_RET
G_FALL:
    inc eax
G_NEXT:
    xor eax, eax
    ret
.org 0x40, 0xcc
H_CUT:
    jmp dword ptr [4*eax + 0x401050]
.org 0x50, 0xcc
H_TABLE:
    .long 0x401058, 0x40105b
H_CASE0:
    xor eax, eax
    ret
H_CASE1:
    mov eax, 1
    ret
"""
STARTS = [BASE + off for off in (0x00, 0x20, 0x29, 0x2A, 0x40)]
CUT = ([(BASE + 0x40, BASE + 0x61)], [(BASE + 0x50, BASE + 0x58)])


def gen_module(name: str):
    return gen_fragments.extend(load(name, SCRIPTS / "gen_hinted_asm.py"))


@fixture.TOOLS
class FragmentEndings(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        # the synthetic image is not the real .text, so tell the generator where its inline table is
        cls.patch = mock.patch.object(gen_fragments, "fragment_tables", lambda image: CUT)
        cls.patch.start()
        cls.tmp = tempfile.TemporaryDirectory()
        root = Path(cls.tmp.name)
        cls.gen = gen_module("gen_hinted_asm_fragments_under_test")
        source = root / "synthetic.s"
        source.write_text(SOURCE, encoding="utf-8")
        obj = root / "synthetic.obj"
        run = subprocess.run([str(cls.gen.AS_DEFAULT), "--32", "-o", str(obj), str(source)], capture_output=True, text=True)
        assert run.returncode == 0, run.stderr
        text, relocations, _symbols = cls.gen.coff_text(obj.read_bytes())
        assert relocations == 0
        pe = make_pe(text, virtual_size=len(text), raw_size=(len(text) + 0x1FF) & ~0x1FF)
        cls.original = root / "SYNTH.EXE"
        cls.original.write_bytes(pe)
        cls.pe_sha = hashlib.sha256(pe).hexdigest()
        cls.index = root / "function-index.json"
        cls.index.write_text(
            json.dumps({"original_sha256": cls.pe_sha, "functions": [{"address": f"0x{a:08x}", "evidence_id": "ev_fixture"} for a in STARTS]}),
            encoding="utf-8",
        )
        cls.image = cls.gen.load_image(cls.original, cls.index, cls.pe_sha, strict=False)
        cls.layouts, _ = cls.gen.analyze_all(cls.image)
        audit.apply_derived_evidence(cls.image, cls.layouts)
        cls.annotator = machine.Annotator(cls.image, ledger={}, imports={})

    @classmethod
    def tearDownClass(cls) -> None:
        cls.patch.stop()
        cls.tmp.cleanup()

    # ------------------------------------------------------------------ analysis

    def test_endings_are_derived_from_the_original(self) -> None:
        endings = {va - BASE: layout.ending for va, layout in self.layouts.items()}
        self.assertEqual(endings[0x00], "")
        self.assertEqual(endings[0x20], "call-end")
        self.assertEqual(endings[0x29], "fall-through")
        self.assertEqual(endings[0x2A], "")
        self.assertEqual(self.layouts[BASE + 0x29].span_end, BASE + 0x2A)

    def test_a_call_followed_by_data_is_not_a_call_ending(self) -> None:
        # the ordinary case the auditor already accepted: a code part that ends in a call and has padding after it
        layout = self.layouts[BASE + 0x20]
        self.assertFalse(layout.data)
        self.assertEqual(gen_fragments.classify_ending(layout), "call-end")
        layout.data.append(self.gen.DataItem("padding", layout.code_end, 1))
        try:
            self.assertEqual(gen_fragments.classify_ending(layout), "")
        finally:
            layout.data.pop()

    def test_a_span_with_an_inline_table_is_cut_into_entries(self) -> None:
        cut = self.layouts[BASE + 0x40]
        self.assertEqual(cut.exceptions, [])
        self.assertEqual((cut.span_end, cut.next_entry), (BASE + 0x50, BASE + 0x58))
        self.assertIn(f"inline_table_follows:0x{BASE + 0x50:08x}-0x{BASE + 0x58:08x}", cut.notes)
        first, second = self.layouts[BASE + 0x58], self.layouts[BASE + 0x5B]
        self.assertTrue(first.derived and second.derived)
        self.assertEqual([first.exceptions, second.exceptions], [[], []])
        self.assertEqual((first.code_end, second.code_end), (BASE + 0x5B, BASE + 0x61))
        # the table bytes belong to nobody: no entry's span covers them
        spans = [(layout.va, layout.span_end) for layout in self.layouts.values() if layout.va >= BASE + 0x40]
        self.assertFalse(any(lo <= BASE + 0x50 < hi for lo, hi in spans))

    def test_the_unextended_generator_cannot_split_the_same_span(self) -> None:
        plain = load("gen_hinted_asm_plain_for_fragments", SCRIPTS / "gen_hinted_asm.py")
        image = plain.load_image(self.original, self.index, self.pe_sha, strict=False)
        layouts, _ = plain.analyze_all(image)
        self.assertTrue(layouts[BASE + 0x40].exceptions)

    # ------------------------------------------------------------------ audit

    def audit_batch(self, vas, mutate=None, manifest_edit=None):
        work = Path(tempfile.mkdtemp(dir=self.tmp.name))
        for va in vas:
            (work / f"FUN_{va:08x}.s").write_text(self.annotator.render(self.layouts[va]) + "\n", encoding="utf-8")
        if mutate:
            mutate(work)
        manifest = self.gen.build_manifest(self.image, self.layouts, vas, work, "test", "fixture", original_sha256=self.pe_sha)
        if manifest_edit:
            manifest_edit(manifest)
        path = work / "batch.json"
        path.write_text(json.dumps(manifest), encoding="utf-8")
        config = audit.AuditConfig(
            allow_index_byte_lists=True, original=self.original, index=self.index, assembler=self.gen.AS_DEFAULT,
            expected_sha256=self.pe_sha, strict_image=False, repository=None, baseline_dir=None, image_base=0x400000,
        )
        return audit.audit_manifest(path, config), work

    def reasons(self, report, va):
        return next(f for f in report["functions"] if f["function"] == f"FUN_{va:08x}")["reasons"]

    def test_call_ending_and_fall_through_fragment_are_accepted(self) -> None:
        vas = [BASE + 0x20, BASE + 0x29, BASE + 0x2A]
        report, work = self.audit_batch(vas)
        self.assertEqual([f["reasons"] for f in report["functions"]], [[], [], []], report["errors"])
        self.assertEqual({f["function"]: f.get("ending", "") for f in report["functions"]},
                         {f"FUN_{BASE + 0x20:08x}": "call-end", f"FUN_{BASE + 0x29:08x}": "fall-through", f"FUN_{BASE + 0x2A:08x}": ""})
        text = (work / f"FUN_{BASE + 0x29:08x}.s").read_text(encoding="utf-8")
        self.assertRegex(text, rf"# ending:\s+fall-through into 0x{BASE + 0x2A:08x}")

    def test_the_cut_block_copy_entries_are_accepted_without_the_table_bytes(self) -> None:
        vas = [BASE + 0x40, BASE + 0x58, BASE + 0x5B]
        report, _work = self.audit_batch(vas)
        self.assertEqual([f["reasons"] for f in report["functions"]], [[], [], []], report["errors"])
        first = report["functions"][0]
        self.assertEqual(first["code"]["size"], 7)  # the jump; the int3 padding up to the table is a data item
        self.assertEqual([i["kind"] for i in first["data_items"]], ["padding"])

    def test_a_missing_or_wrong_ending_header_is_rejected(self) -> None:
        va = BASE + 0x20
        path = lambda work: work / f"FUN_{va:08x}.s"  # noqa: E731

        def drop(work: Path) -> None:
            path(work).write_text(re.sub(r"^# ending:.*\n", "", path(work).read_text(encoding="utf-8"), flags=re.M), encoding="utf-8")

        def swap(work: Path) -> None:
            path(work).write_text(path(work).read_text(encoding="utf-8").replace("# ending:       call-end", "# ending:       fall-through"), encoding="utf-8")

        for mutate in (drop, swap):
            report, _ = self.audit_batch([va], mutate)
            self.assertFalse(report["all_accepted"])
            self.assertTrue(any("'ending'" in r for r in self.reasons(report, va)), self.reasons(report, va))

    def test_an_ending_the_original_does_not_have_is_rejected(self) -> None:
        va = BASE + 0x00

        def add(work: Path) -> None:
            path = work / f"FUN_{va:08x}.s"
            path.write_text(path.read_text(encoding="utf-8").replace("# frame:", "# ending:       call-end (claimed)\n# frame:", 1), encoding="utf-8")

        report, _ = self.audit_batch([va], add)
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("ending" in r for r in self.reasons(report, va)), self.reasons(report, va))

    def test_the_manifest_must_declare_the_same_ending(self) -> None:
        va = BASE + 0x29

        def drop(manifest) -> None:
            del manifest["functions"][0]["ending"]

        report, _ = self.audit_batch([va], manifest_edit=drop)
        self.assertTrue(any("manifest ending" in r for r in self.reasons(report, va)), self.reasons(report, va))


if __name__ == "__main__":
    unittest.main()
