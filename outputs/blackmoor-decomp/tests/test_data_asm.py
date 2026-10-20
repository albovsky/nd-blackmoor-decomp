"""Tests for the Track M data sources (packet M-C): scripts/data_asm.py and the committed asm_data/ batches.

The classifier and renderer run on synthetic bytes; the committed batches (manifest, layout, report; the full source
is regenerated at build time) are audited against the owner's local ``GAME.EXE`` with the pinned GNU assembler and
skip when either is absent.
"""

import importlib.util
import json
import re
import shutil
import struct
import sys
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SCRIPTS = PROJECT / "scripts"
ASM_DATA = PROJECT / "asm_data"


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


data_asm = load("data_asm")
HAVE_ORIGINAL = data_asm.DEFAULT_ORIGINAL.is_file()
HAVE_ASSEMBLER = data_asm.DEFAULT_ASSEMBLER.is_file()
needs_toolchain = unittest.skipUnless(HAVE_ORIGINAL and HAVE_ASSEMBLER, "original GAME.EXE or pinned GNU as not present")
needs_assembler = unittest.skipUnless(HAVE_ASSEMBLER, "pinned GNU as not present")

BASE = data_asm.IMAGE_BASE
# a synthetic .text far away from the real image, so that no test value reads as an address of the real program
FAKE_TEXT = 0x41424000
FAKE_ENTRY = 0x41424100  # a function entry: its bytes are all printable or zero, and it is still a pointer
FAKE_CODE = 0x41424A05  # a code address that is not an entry
FAKE_TEXT_LIKE = 0x41424344  # inside the fake .text, all four bytes printable, not an entry: numeric
LO = 0x137000  # a file offset inside the real .data section
HI = LO + 0x100


def synthetic(chunks):
    """A fake original: zeros with the given (offset, bytes) chunks laid in."""
    image = bytearray(HI + 0x1000)
    for offset, blob in chunks:
        image[offset : offset + len(blob)] = blob
    return bytes(image)


def kinds(atoms):
    return [(a.start - LO, a.length, a.kind) for a in atoms]


class ClassifierTests(unittest.TestCase):
    def test_strings_wide_strings_zero_runs_dwords_and_bytes(self):
        blob = (
            b"Hello\x00"  # 0x00 string (6 bytes), then two NULs of padding up to the next dword boundary
            + b"\x00\x00"
            + struct.pack("<I", 0x12345678)  # 0x08 aligned dword
            + bytes(16)  # 0x0c aligned zero run
            + "Wide".encode("utf-16-le") + b"\x00\x00"  # 0x1c wide string (10 bytes)
            + b"\x00\x00"  # 0x26 padding to 0x28
            + b"ab\x00"  # 0x28: too short for a string, and a dword does not fit: three bytes
        )
        original = synthetic([(LO, blob)])
        atoms = data_asm.split_range(original, LO, LO + len(blob))
        self.assertEqual(
            kinds(atoms),
            [(0, 6, "str"), (6, 2, "zero"), (8, 4, "dword"), (12, 16, "zero"), (28, 10, "wstr"), (38, 2, "zero"), (40, 3, "byte")],
        )

    def test_a_short_printable_run_is_not_a_string(self):
        original = synthetic([(LO, b"abc\x00")])
        self.assertEqual(kinds(data_asm.split_range(original, LO, LO + 4)), [(0, 4, "dword")])

    def test_a_tail_shorter_than_a_dword_is_bytes(self):
        original = synthetic([(LO, struct.pack("<I", 0xDEADBEEF) + b"\x01\x02")])
        self.assertEqual(kinds(data_asm.split_range(original, LO, LO + 6)), [(0, 4, "dword"), (4, 2, "byte")])


def analysis_for(original, ranges, pointers=True, starts=()):
    sections = [
        data_asm.Section(".text", FAKE_TEXT, 0x1000, 0x1000, 0x1000),
        data_asm.Section(".data", BASE + 0x137000, 0x10000, 0x137000, 0x1000),
    ]
    return data_asm.Analysis(original, ranges, sections, set(starts), BASE, pointers), sections


class RenderTests(unittest.TestCase):
    def blob(self):
        s0 = BASE + LO + 0x10  # a string in the range
        d0 = BASE + LO + 0x20  # a dword table entry in the range
        return b"".join(
            [
                struct.pack("<IIII", s0, d0, FAKE_ENTRY, FAKE_CODE),  # in-range string, in-range data, code entry, code address
                b"Label\x00\x00\x00\x00\x00\x00",
                bytes(0),
            ]
        ).ljust(0x20, b"\x00") + struct.pack("<II", 7, FAKE_TEXT_LIKE)

    def test_pointers_become_labels_or_named_constants_and_text_like_values_stay_numeric(self):
        original = synthetic([(LO, self.blob())])
        analysis, sections = analysis_for(original, ((LO, LO + 0x28),), starts={FAKE_ENTRY})
        text = data_asm.render(analysis, (BASE + LO) & ~0xFFF, sections)
        self.assertIn(f".long STR_{BASE + LO + 0x10:08x} - IMG + 0x{(BASE + LO) & ~0xFFF:x}", text)
        self.assertIn(f"STR_{BASE + LO + 0x10:08x}:", text)
        self.assertIn(f".long DAT_{BASE + LO + 0x20:08x} - IMG", text)
        self.assertIn(f".long FUN_{FAKE_ENTRY:08x}", text)
        self.assertIn(f".set FUN_{FAKE_ENTRY:08x}, 0x{FAKE_ENTRY:x}", text)
        self.assertIn(f".long CODE_{FAKE_CODE:08x}", text)
        self.assertIn(f".long 0x7, 0x{FAKE_TEXT_LIKE:x}", text)  # all printable bytes, not an entry: numeric, not a code pointer
        self.assertIn('.asciz "Label"', text)

    def test_a_pointer_into_a_string_interior_stays_numeric(self):
        s0 = BASE + LO + 0x10
        original = synthetic([(LO, struct.pack("<I", s0 + 2).ljust(0x10, b"\x00") + b"Label\x00")])
        analysis, _ = analysis_for(original, ((LO, LO + 0x18),))
        self.assertEqual([a.pointer for a in analysis.atoms if a.kind == "dword"], [None])

    def test_no_pointers_in_resource_mode(self):
        original = synthetic([(LO, struct.pack("<I", BASE + LO))])
        analysis, _ = analysis_for(original, ((LO, LO + 4),), pointers=False)
        self.assertTrue(all(a.pointer is None for a in analysis.atoms))

    @needs_assembler
    def test_rendered_source_reassembles_to_the_same_bytes(self):
        original = synthetic([(LO, self.blob())])
        analysis, sections = analysis_for(original, ((LO, LO + 0x28),), starts={FAKE_ENTRY})
        origin = (BASE + LO) & ~0xFFF
        text = data_asm.render(analysis, origin, sections)
        with tempfile.TemporaryDirectory() as tmp:
            source = Path(tmp) / "t.s"
            source.write_text(text, encoding="utf-8")
            data, relocations, symbols = data_asm.assemble(data_asm.DEFAULT_ASSEMBLER, source)
        self.assertEqual(relocations, 0)
        self.assertEqual(data[BASE + LO - origin : BASE + LO - origin + 0x28], original[LO : LO + 0x28])
        self.assertEqual(symbols[f"STR_{BASE + LO + 0x10:08x}"], BASE + LO + 0x10 - origin)


class LexicalAuditTests(unittest.TestCase):
    def expect(self):
        sections = data_asm.load_sections()
        ranges = ((LO, HI),)
        return {"ranges": ranges, "sections": sections, "origin_va": (BASE + LO) & ~0xFFF, "bias": BASE, "pointers": True, "max_fill": HI - LO}

    def source(self, body):
        e = self.expect()
        head = data_asm.header_lines(e["ranges"], e["sections"], e["origin_va"], e["bias"], True)
        return "\n".join(head + [".intel_syntax noprefix", ".data", "IMG:"] + body) + "\n"

    def test_the_generated_forms_are_accepted(self):
        body = [
            f"STR_{BASE + LO:08x}:",
            '.asciz "a \\"quoted\\" \\\\ line\\n"',
            ".fill 12, 1, 0",
            ".long 0x1, 0x2",
            f".long STR_{BASE + LO:08x} - IMG + 0x{(BASE + LO) & ~0xFFF:x}",
            ".byte 0x01, 0x02",
        ]
        problems, counts = data_asm.audit_source(self.source(body), self.expect())
        self.assertEqual(problems, [])
        self.assertEqual((counts["strings"], counts["pointers"], counts["zero_runs"], counts["numeric_dwords"]), (1, 1, 1, 2))

    def test_a_hash_inside_a_quoted_string_is_not_a_comment_and_an_absurd_fill_is_rejected(self):
        problems, _ = data_asm.audit_source(self.source(['.string16 "a#b"', '.asciz "x#y"']), self.expect())
        self.assertEqual(problems, [])
        problems, _ = data_asm.audit_source(self.source([".fill 4000000000, 1, 0"]), self.expect())
        self.assertTrue(any("larger than any claimed range" in p for p in problems))

    def test_forbidden_directives_are_rejected(self):
        for line in (
            '.incbin "GAME.EXE"',
            '.include "other.s"',
            ".macro m",
            ".byte 1, 2",  # not the 0x%02x form the generator writes
            ".long 0x1; .long 0x2",
            ".long some_symbol + 4",
            ".fill 4, 1, 0xcc",
            ".section .text",
            "mov eax, 1",
        ):
            problems, _ = data_asm.audit_source(self.source([line]), self.expect())
            self.assertTrue(any("not permitted" in p for p in problems), line)

    def test_a_tampered_header_or_a_missing_anchor_is_rejected(self):
        text = self.source([]).replace("# ranges:", "# ranges: (edited)", 1)
        self.assertTrue(data_asm.audit_source(text, self.expect())[0])
        text = self.source([]).replace("IMG:\n", "")
        self.assertIn("the IMG anchor label is missing", data_asm.audit_source(text, self.expect())[0])

    def test_a_constant_must_equal_the_address_in_its_name(self):
        problems, _ = data_asm.audit_source(self.source([f".set FUN_{FAKE_ENTRY:08x}, 0x{FAKE_ENTRY + 4:x}"]), self.expect())
        self.assertTrue(any("does not equal" in p for p in problems))


class LayoutTests(unittest.TestCase):
    def test_the_layout_masks_every_value_and_keeps_labels_and_structure(self):
        text = "\n".join([
            "# header",
            "IMG:",
            "STR_00537000:",
            '.asciz "a \\"q\\" \\\\ x\\n"',
            '.string16 "Wide"',
            ".fill 12, 1, 0",
            ".long 0x1, 0x2, 0x3",
            ".long STR_00537000 - IMG + 0x537000",
            ".long FUN_00401000",
            ".byte 0x01, 0x02",
        ]) + "\n"
        layout = data_asm.layout_of(text).splitlines()[len(data_asm.LAYOUT_HEADER):]
        self.assertEqual(layout, [
            "# header", "IMG:", "STR_00537000:", ".asciz [10]", ".string16 [4]", ".fill 12, 1, 0", ".long [3]",
            ".long STR_00537000 - IMG + 0x537000", ".long FUN_00401000", ".byte [2]",
        ])
        self.assertEqual(len(data_asm.audit_layout(data_asm.layout_of(text))), 1)  # only the made-up "# header" comment

    def test_a_layout_carrying_a_value_is_rejected(self):
        for line in (
            '.asciz "Hello"', '.string16 "Hi there"', ".long 0x12345678", "  .byte 0x41", ".long  0x41424344", ".long\t0x41",
            ".byte 65", '.ascii "ABCD"', '.string "AB"', ".word 0x4142", ".quad 5", ".long 0x1, 0x2",
        ):
            self.assertTrue(data_asm.audit_layout(f"IMG:\n{line}\n"), line)

    def test_a_generated_layout_is_accepted_and_only_generator_shapes_pass(self):
        generated = data_asm.layout_of(
            "\n".join(data_asm.header_lines(((LO, HI),), data_asm.load_sections(), (BASE + LO) & ~0xFFF, BASE, True) + [
                ".intel_syntax noprefix", ".data", f".set FUN_{FAKE_ENTRY:08x}, 0x{FAKE_ENTRY:x}", "IMG:", f"STR_{BASE + LO:08x}:", '.asciz "x"',
                ".fill 4, 1, 0", f".long STR_{BASE + LO:08x} - IMG + 0x{(BASE + LO) & ~0xFFF:x}", f".long FUN_{FAKE_ENTRY:08x}", ".long 0x5", ".org 0x20",
            ]) + "\n"
        )
        self.assertEqual(data_asm.audit_layout(generated), [])
        self.assertTrue(data_asm.audit_layout(generated + "# a comment that is not a header line\n"))

    def test_manifest_names_must_be_plain_files(self):
        self.assertTrue(data_asm.safe_batch_names({"source": "data-001.s", "layout": "data-001.layout"}))
        for bad in ({"source": "../data-001.s", "layout": "data-001.layout"}, {"source": "data-001.s", "layout": "x/data-001.layout"}, {"source": "data-001.s"}):
            self.assertFalse(data_asm.safe_batch_names(bad), bad)


class StructureBatchTests(unittest.TestCase):
    """Batches 003 and 004 (profile ``structures``): the bytes the composer's structured groups also generate."""

    def test_structure_ranges_are_the_complement_of_the_payload_batches(self):
        payload = list(data_asm.DEFAULT_RANGES) + list(data_asm.resource_ranges())
        pe, resource = data_asm.structure_ranges("pe"), data_asm.structure_ranges("resource")
        self.assertEqual(sum(hi - lo for lo, hi in pe), 18914)
        self.assertEqual(sum(hi - lo for lo, hi in resource), 4516)
        everything = sorted(payload + list(pe) + list(resource))
        for (_, end), (start, _) in zip(everything, everything[1:]):
            self.assertLessEqual(end, start)  # disjoint
        # together with the payloads they tile the file apart from the function spans of .text
        text = next(s for s in data_asm.load_sections() if s.name == ".text")
        self.assertEqual(everything[0][0], 0)
        covered = sum(hi - lo for lo, hi in everything)
        self.assertEqual(covered, 1511424 - text.virtual_size)
        self.assertRaises(data_asm.DataAsmError, data_asm.structure_ranges, "nope")

    def test_the_file_headers_are_a_pseudo_section(self):
        sections = data_asm.load_sections()
        self.assertEqual(data_asm.containing_section(sections, 0, 0x1000).name, data_asm.HEADERS)
        self.assertEqual(data_asm.bias_of(sections, ((0, 0x1000), (0x12925A, 0x12A000))), 0x400000)
        self.assertIsNone(data_asm.containing_section(sections, 0, 0x2000))  # headers and .text are not one range
        self.assertEqual(data_asm.section_name_at(sections, 0x10), data_asm.HEADERS)

    def test_the_structures_header_names_the_profile_and_is_accepted_by_the_layout_audit(self):
        sections = data_asm.load_sections()
        lines = data_asm.header_lines(((0, 0x1000),), sections, 0x400000, 0x400000, False, data_asm.PROFILE_STRUCTURES)
        self.assertIn("# pointers: not detected (PE structures)", lines)
        self.assertIn("# ranges: 0x00400000-0x00401000 (<headers>)", lines)
        layout = data_asm.layout_of("\n".join(lines) + "\n.intel_syntax noprefix\n.data\nIMG:\nDAT_00400000:\n.long 0x905a4d\n")
        self.assertEqual(data_asm.audit_layout(layout), [])


class CommittedBatchTests(unittest.TestCase):
    """The committed asm_data/ batches against the local original (skipped without it)."""

    def manifests(self):
        return sorted(p for p in ASM_DATA.glob("data-[0-9][0-9][0-9].json"))

    def test_the_committed_batches_cover_the_non_code_sections_and_carry_no_payload(self):
        manifests = self.manifests()
        self.assertEqual([m.name for m in manifests], ["data-001.json", "data-002.json", "data-003.json", "data-004.json"])
        self.assertEqual(sorted(ASM_DATA.glob("*.s")), [])  # the full sources are build outputs, never committed
        total = 0
        for path in manifests:
            manifest = json.loads(path.read_text())
            self.assertEqual(manifest["class"], data_asm.DATA_CLASS)
            self.assertEqual(manifest["original_sha256"], data_asm.ORIGINAL_SHA256)
            total += sum(r["length"] for r in manifest["ranges"])
            layout = (path.parent / manifest["layout"]).read_text()
            self.assertEqual(data_asm.sha256(layout.encode()), manifest["layout_sha256"])
            self.assertEqual(data_asm.audit_layout(layout), [])
            report = json.loads(path.with_name(path.stem + "-report.json").read_text())
            self.assertTrue(report["all_accepted"])
            self.assertEqual(report["relocations"], 0)
            self.assertEqual(report["manifest_sha256"], data_asm.file_sha256(path))
            self.assertEqual(report["source"]["sha256"], manifest["source_sha256"])
            self.assertEqual(report["layout"]["sha256"], manifest["layout_sha256"])
        # .rdata 41,924 + .data 208,896 + resource payloads 24,156 + headers/IAT/imports/padding 18,914 + resource tree and padding 4,516
        self.assertEqual(total, 298406)

    @needs_toolchain
    def test_every_committed_batch_audits_clean_and_regenerates_identically(self):
        for path in self.manifests():
            report = data_asm.audit_manifest(path, data_asm.DEFAULT_ORIGINAL, data_asm.DEFAULT_ASSEMBLER)
            self.assertEqual(report["errors"], [], path.name)
            self.assertTrue(report["all_accepted"])
            self.assertEqual(report["compared_bytes"], report["bytes_total"])
        original = data_asm.DEFAULT_ORIGINAL.read_bytes()
        for path in self.manifests():
            manifest = json.loads(path.read_text())
            text = data_asm.regenerate_source(manifest, original)
            self.assertEqual(data_asm.sha256(text.encode()), manifest["source_sha256"], path.name)
            self.assertEqual(data_asm.layout_of(text), (ASM_DATA / manifest["layout"]).read_text(), path.name)


@needs_toolchain
class MutantTests(unittest.TestCase):
    """A one-line edit of the regenerated resource source, or of the committed layout, must be caught by the audit."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.dir = Path(self.tmp.name)
        for name in ("data-002.json", "data-002.layout"):
            shutil.copy(ASM_DATA / name, self.dir / name)
        manifest = json.loads((self.dir / "data-002.json").read_text())
        self.text = data_asm.regenerate_source(manifest, data_asm.DEFAULT_ORIGINAL.read_bytes())

    def tearDown(self):
        self.tmp.cleanup()

    def audit(self, edit, rehash=True):
        source = self.dir / "data-002.s"
        text = edit(self.text)
        source.write_text(text)
        manifest_path = self.dir / "data-002.json"
        manifest = json.loads(manifest_path.read_text())
        if rehash:
            layout = data_asm.layout_of(text)
            (self.dir / "data-002.layout").write_text(layout)
            manifest["source_sha256"] = data_asm.sha256(text.encode())
            manifest["layout_sha256"] = data_asm.sha256(layout.encode())
            manifest_path.write_text(json.dumps(manifest))
        return data_asm.audit_manifest(manifest_path, data_asm.DEFAULT_ORIGINAL, data_asm.DEFAULT_ASSEMBLER, source_path=source)

    def test_the_unedited_regenerated_source_is_accepted(self):
        report = self.audit(lambda text: text, rehash=False)
        self.assertEqual(report["errors"], [])
        self.assertTrue(report["all_accepted"])

    def test_an_edited_layout_is_rejected(self):
        layout = self.dir / "data-002.layout"
        layout.write_text(layout.read_text().replace(".long [4]", ".long [3]", 1))
        report = self.audit(lambda text: text, rehash=False)
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("layout" in e for e in report["errors"]))

    def test_a_changed_value_is_rejected(self):
        def edit(text):
            return re.sub(r"(?m)^\.long 0x([0-9a-f]{1,6})(?=,|$)", lambda m: ".long 0x1" + m.group(1), text, count=1)

        report = self.audit(edit)
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("differs from the original" in e for e in report["errors"]))

    def test_a_misnamed_label_is_rejected(self):
        def edit(text):
            return re.sub(r"(?m)^(DAT|STR|WSTR)_([0-9a-f]{8}):$", lambda m: f"{m.group(1)}_{int(m.group(2), 16) + 4:08x}:", text, count=1)

        report = self.audit(edit)
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("not at the address in its name" in e for e in report["errors"]))

    def test_an_edit_after_the_audit_is_rejected_by_the_hash(self):
        report = self.audit(lambda text: text + "# edited\n", rehash=False)
        self.assertFalse(report["all_accepted"])
        self.assertTrue(any("manifest hash" in e for e in report["errors"]))

    def test_an_incbin_is_rejected(self):
        report = self.audit(lambda text: text + '.incbin "GAME.EXE"\n')
        self.assertFalse(report["all_accepted"])


if __name__ == "__main__":
    unittest.main()
