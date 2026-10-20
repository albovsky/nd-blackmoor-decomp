"""Tests for the single GAME.EXE build step (packet M-D): scripts/link_image.py and scripts/build_game_exe.sh.

The rewriting and tiling checks run on synthetic text.  The end-to-end tests need the owner's local ``GAME.EXE`` and
the pinned binutils 2.43.1 (as, ld, objcopy) and skip when either is absent; they run the real build into a temporary
directory.  Original bytes are only held in memory and compared, never written.
"""

import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SCRIPTS = PROJECT / "scripts"


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


link_image = load("link_image")
HAVE_ORIGINAL = link_image.DEFAULT_ORIGINAL.is_file()
HAVE_TOOLS = all(link_image.tool_path(link_image.DEFAULT_PREFIX, name).is_file() for name in ("as", "ld", "objcopy"))
needs_toolchain = unittest.skipUnless(HAVE_ORIGINAL and HAVE_TOOLS, "original GAME.EXE or pinned binutils (as, ld, objcopy) not present")

FAKE = 0x41424000  # far away from the real image, so that no test value reads as an address of the real program
BASE = link_image.TEXT_BASE


def code_source():
    f = f"{FAKE:08x}"
    return f"""\
# FUN_{f}
.intel_syntax noprefix
.code32
.text

.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_{FAKE + 0x300:08x}, .text + (0x{FAKE + 0x300:08x} - {BASE:#x})
.set LOC_{FAKE + 0x20:08x}, .text + (0x{FAKE + 0x20:08x} - {BASE:#x})

.org 0x{f} - {BASE:#x}
.globl FUN_{f}
FUN_{f}:
    # block 0x{f}: entry
    call FUN_{FAKE + 0x300:08x}                  # 0040100a
    jmp dword ptr [4*edx + SWTAB_{FAKE + 0x10:08x}_VA]    # 0040100f
    ret

.org 0x{FAKE + 0x10:08x} - {BASE:#x}
SWTAB_{FAKE + 0x10:08x}:  # 2 case address(es)
    .long FUN_{f} - .text + {BASE:#x}
    .long FUN_{f} - .text + {BASE:#x}
.set SWTAB_{FAKE + 0x10:08x}_VA, SWTAB_{FAKE + 0x10:08x} - .text + {BASE:#x}
"""


DATA = """\
# annotation:  machine
.intel_syntax noprefix
.data
.set CODE_00401234, 0x41424234
.set FUN_00401238, 0x41424238
IMG:
.org 0x40
DAT_41500040:
.long DAT_41500048 - IMG + 0x41500000
DAT_41500048:
.asciz "four"
.org 0x100
DAT_41500100:
.long CODE_00401234, 0x12345678
"""


class RewriteCodeTests(unittest.TestCase):
    def test_link_form_of_a_function_source(self):
        text, start, externals = link_image.rewrite_code(code_source(), "FUN_41424000.s")
        self.assertEqual(start, FAKE)
        self.assertEqual(externals, {f"FUN_{FAKE + 0x300:08x}": FAKE + 0x300, f"LOC_{FAKE + 0x20:08x}": FAKE + 0x20})
        lines = text.splitlines()
        self.assertIn('.section .fn,"xr0"', lines)  # alignment 1: the linker may place a section at any address
        self.assertNotIn(".text", lines)
        self.assertFalse([l for l in lines if l.startswith(".set FUN_") or l.startswith(".set LOC_")])
        self.assertEqual([l for l in lines if l.startswith(".org")], [".org 0x10"])  # offsets from the function start, the first .org is gone
        self.assertIn(f"    .long FUN_{FAKE:08x}", lines)  # a relocation the linker resolves, not a folded constant
        self.assertIn(f".set SWTAB_{FAKE + 0x10:08x}_VA, SWTAB_{FAKE + 0x10:08x}", lines)
        self.assertNotIn(f"{BASE:#x}", " ".join(l for l in lines if not l.startswith("#")))

    def test_an_unrewritten_text_reference_is_an_error(self):
        bad = code_source().replace("    ret\n", "    mov eax, offset .text + 4\n    ret\n")
        with self.assertRaisesRegex(link_image.LinkError, r"\.text reference"):
            link_image.rewrite_code(bad, "x.s")

    def test_conflicting_external_addresses_are_an_error(self):
        name = f"FUN_{FAKE + 0x300:08x}"
        bad = code_source().replace(f".set LOC_{FAKE + 0x20:08x}, .text + (0x{FAKE + 0x20:08x}", f".set {name}, .text + (0x{FAKE + 0x304:08x}")
        with self.assertRaisesRegex(link_image.LinkError, "twice with different addresses"):
            link_image.rewrite_code(bad, "x.s")

    def test_a_source_without_org_is_an_error(self):
        with self.assertRaises(link_image.LinkError):
            link_image.rewrite_code(".text\nret\n", "x.s")


class RewriteDataTests(unittest.TestCase):
    def test_link_form_of_a_data_source(self):
        text, sections = link_image.rewrite_data(DATA, "009", 0x41500000)
        self.assertEqual(sections, [(".d009_0", 0x41500040), (".d009_1", 0x41500100)])
        lines = text.splitlines()
        self.assertNotIn(".data", lines)
        self.assertNotIn("IMG:", lines)
        self.assertEqual([l for l in lines if l.startswith(".section")], ['.section .d009_0,"dw0"', '.section .d009_1,"dw0"'])
        self.assertIn(".long DAT_41500048", lines)
        self.assertIn(".set CODE_00401234, 0x41424234", lines)  # absolute constants stay
        self.assertFalse([l for l in lines if "IMG" in l])

    def test_a_label_pointer_with_another_base_is_an_error(self):
        with self.assertRaisesRegex(link_image.LinkError, "base other than the batch origin"):
            link_image.rewrite_data(DATA, "009", 0x41400000)

    def test_content_before_the_first_org_is_an_error(self):
        with self.assertRaisesRegex(link_image.LinkError, "before the first .org"):
            link_image.rewrite_data(".intel_syntax noprefix\n.data\nIMG:\n.long 1\n.org 0x4\n", "009", 0x41500000)


class GeometryTests(unittest.TestCase):
    def test_output_sections_follow_the_file_and_the_virtual_layout(self):
        geometry = link_image.Geometry()
        self.assertEqual([(o["vma"], o["offset"], o["size"]) for o in geometry.out], [(0x400000, 0, 0x16A000), (0x63F000, 0x16A000, 0x7000)])
        self.assertEqual(geometry.file_size, link_image.ORIGINAL_SIZE)
        self.assertEqual(geometry.offset_of_va(link_image.TEXT_BASE), 0x1000)
        self.assertEqual(geometry.offset_of_va(0x63F820), 0x16A820)  # .rsrc: file offset and virtual address differ in bias

    def test_tiling_rejects_gaps_and_overlaps(self):
        geometry = link_image.Geometry()
        section = geometry.out[1]

        def place(offset, length):
            return {"name": f"p{offset:x}", "section": section, "offset": offset, "length": length}

        link_image.tile_check(geometry, [dict(place(0, 0x16A000), section=geometry.out[0]), place(0x16A000, 0x7000)])
        with self.assertRaisesRegex(link_image.LinkError, "gap"):
            link_image.tile_check(geometry, [dict(place(0, 0x16A000), section=geometry.out[0]), place(0x16A000, 0x100), place(0x16A200, 0x6E00)])
        with self.assertRaisesRegex(link_image.LinkError, "overlap"):
            link_image.tile_check(geometry, [dict(place(0, 0x16A000), section=geometry.out[0]), place(0x16A000, 0x200), place(0x16A100, 0x6F00)])
        with self.assertRaisesRegex(link_image.LinkError, "end"):
            link_image.tile_check(geometry, [dict(place(0, 0x16A000), section=geometry.out[0]), place(0x16A000, 0x6000)])


@needs_toolchain
class BuildTests(unittest.TestCase):
    """The real build into a temporary directory (about ten seconds)."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.out = Path(cls.tmp.name) / "game"
        cls.build = subprocess.run(
            [str(SCRIPTS / "build_game_exe.sh"), "--out", str(cls.out), "--data-build", str(Path(cls.tmp.name) / "asm_data")], capture_output=True, text=True, check=False
        )
        cls.original = link_image.DEFAULT_ORIGINAL.read_bytes()

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_the_build_succeeds_and_the_linked_file_equals_the_original(self):
        self.assertEqual(self.build.returncode, 0, self.build.stdout + self.build.stderr)
        linked = (self.out / "GAME.linked.exe").read_bytes()
        self.assertEqual(len(linked), link_image.ORIGINAL_SIZE)
        self.assertEqual(hashlib.sha256(linked).hexdigest(), link_image.ORIGINAL_SHA256)
        self.assertEqual(linked, self.original)

    def placements(self):
        """[(offset in the output section, function name)] of the generated linker script, in address order."""
        script = (self.out / "link.ld").read_text()
        return [(int(m.group(1), 16), m.group(2)) for m in re.finditer(r"\. = (0x[0-9a-f]+); \*/(FUN_[0-9a-f]{8})\.o\(\.fn\)", script)]

    def objdump_relocations(self, stem):
        objdump = link_image.tool_path(link_image.DEFAULT_PREFIX, "objdump")
        return subprocess.run([str(objdump), "-r", str(self.out / "obj" / f"{stem}.o")], capture_output=True, text=True, check=True).stdout

    def test_the_linker_resolves_cross_references(self):
        # calls between functions and switch-table entries are relocations that ld, not the assembler, resolves
        calls = tables = 0
        for _, name in self.placements()[:100]:
            calls += self.objdump_relocations(name).count("DISP32")
        with_table = next(p.stem for p in sorted((self.out / "src").glob("FUN_*.s")) if "    .long L_" in p.read_text())
        tables = self.objdump_relocations(with_table).count("dir32")
        self.assertGreater(calls, 10)
        self.assertGreater(tables, 0)

    def test_every_function_symbol_is_at_the_address_in_its_name(self):
        # the generated linker script asserts it for all functions; a failed assertion would have failed the link
        script = (self.out / "link.ld").read_text()
        asserted = re.findall(r"ASSERT\((FUN_[0-9a-f]{8}) == (0x[0-9a-f]+),", script)
        self.assertEqual(len(asserted), len(self.placements()))
        self.assertTrue(all(int(name[4:], 16) == int(address, 16) for name, address in asserted))

    def test_a_changed_source_instruction_changes_the_image(self):
        prefix = link_image.DEFAULT_PREFIX
        work = Path(self.tmp.name) / "mutant"
        shutil.copytree(self.out, work)
        placements = self.placements()
        # the first function that starts with push ebp (55): change it to push ebx (53) and nothing else
        for index, (offset, name) in enumerate(placements):
            source = work / "src" / f"{name}.s"
            text = source.read_text()
            first = next(l for l in text.splitlines() if l.startswith("    ") and not l.lstrip().startswith("#"))
            if first.startswith("    push ebp "):
                break
        else:
            self.fail("no function starts with push ebp")
        source.write_text(text.replace(first, first.replace("push ebp", "push ebx", 1), 1))
        run = lambda command: subprocess.run(command, cwd=work, capture_output=True, text=True, check=True)
        run([str(link_image.tool_path(prefix, "as")), "--32", "-o", f"obj/{name}.o", f"src/{name}.s"])
        run([str(link_image.tool_path(prefix, "ld")), "@link.rsp"])
        run([str(link_image.tool_path(prefix, "objcopy")), "@objcopy.rsp"])
        mutant = (work / "GAME.linked.exe").read_bytes()
        self.assertEqual(len(mutant), link_image.ORIGINAL_SIZE)
        differing = [i for i, (a, b) in enumerate(zip(mutant, self.original)) if a != b]
        self.assertEqual(differing, [offset])  # the offset in the first output section is the file offset  # push ebp -> push ebx, nothing else moves

    def test_a_source_smaller_than_its_slot_breaks_the_image(self):
        # a trailing zero fill removed from a data source must not read as linker zero fill
        prefix = link_image.DEFAULT_PREFIX
        work = Path(self.tmp.name) / "short"
        shutil.copytree(self.out, work)
        source = work / "src" / "data-004.s"
        lines = source.read_text().splitlines()
        last = max(i for i, l in enumerate(lines) if re.fullmatch(r"\.fill \d+, 1, 0", l))
        del lines[last]
        source.write_text("\n".join(lines) + "\n")
        run = lambda command: subprocess.run(command, cwd=work, capture_output=True, text=True, check=True)
        run([str(link_image.tool_path(prefix, "as")), "--32", "-o", "obj/data-004.o", "src/data-004.s"])
        run([str(link_image.tool_path(prefix, "ld")), "@link.rsp"])
        run([str(link_image.tool_path(prefix, "objcopy")), "@objcopy.rsp"])
        mutant = (work / "GAME.linked.exe").read_bytes()
        self.assertNotEqual(mutant, self.original)
        self.assertIn(0xDB, mutant[0x16A000:])

    def test_verify_fails_on_a_different_file(self):
        other = Path(self.tmp.name) / "other.exe"
        other.write_bytes(self.original[:-1] + b"\x00" if self.original[-1] else self.original[:-1] + b"\x01")
        result = subprocess.run([sys.executable, str(SCRIPTS / "link_image.py"), "verify", str(other)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertIn("False", result.stdout)

    def _relink(self, name, old, new):
        prefix = link_image.DEFAULT_PREFIX
        work = Path(self.tmp.name) / name
        shutil.copytree(self.out, work)
        script = work / "link.ld"
        text = script.read_text()
        self.assertIn(old, text)
        script.write_text(text.replace(old, new, 1))
        return subprocess.run([str(link_image.tool_path(prefix, "ld")), "@link.rsp"], cwd=work, capture_output=True, text=True)

    def test_a_function_placed_at_the_wrong_address_fails_the_link(self):
        (first_offset, first), (second_offset, second) = self.placements()[:2]
        run = self._relink("misplaced", f". = {second_offset:#x}; */{second}.o(.fn)", f". = {second_offset + 1:#x}; */{second}.o(.fn)")
        self.assertNotEqual(run.returncode, 0)  # the location counter would have to move backwards
        address = int(first[4:], 16)
        run = self._relink("asserted", f"ASSERT({first} == {address:#x},", f"ASSERT({first} == {address + 1:#x},")
        self.assertNotEqual(run.returncode, 0)
        self.assertIn(f"{first} is not at its address", run.stdout + run.stderr)

    def test_the_composer_image_is_byte_identical(self):
        compose_image = load("compose_image")
        comp = compose_image.compose(compose_image.DEFAULT_IMAGE_DIR, link_image.DEFAULT_ORIGINAL, Path(self.tmp.name) / "composer")
        self.assertEqual(comp.data, (self.out / "GAME.linked.exe").read_bytes())

    def test_the_report_counts_what_was_linked(self):
        report = json.loads((self.out / "link-report.json").read_text())
        self.assertEqual(report["functions"], len(self.placements()))
        self.assertEqual(report["data_sources"], 5)
        self.assertEqual(report["function_bytes"] + report["data_bytes"], link_image.ORIGINAL_SIZE)


if __name__ == "__main__":
    unittest.main()
