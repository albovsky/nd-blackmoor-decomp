"""Tests for the hinted assembly generator (packet M03).

The fixtures are synthetic: a small ``.text`` assembled here with the pinned
assembler, so nothing proprietary is needed.  A final test round-trips the
owner's local ``GAME.EXE`` and is skipped when it is absent.
"""

import importlib.util
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"
SPEC = importlib.util.spec_from_file_location("gen_hinted_asm", SCRIPTS / "gen_hinted_asm.py")
assert SPEC and SPEC.loader
gen = importlib.util.module_from_spec(SPEC)
sys.modules["gen_hinted_asm"] = gen
SPEC.loader.exec_module(gen)

AS = gen.AS_DEFAULT
HAVE_AS = AS.is_file()
try:
    OBJDUMP = gen.find_objdump()
    HAVE_OBJDUMP = subprocess.run(OBJDUMP + ["--version"], capture_output=True).returncode == 0
except OSError:
    HAVE_OBJDUMP = False
TOOLS = unittest.skipUnless(HAVE_AS and HAVE_OBJDUMP, "pinned assembler or llvm-objdump unavailable")

BASE = 0x401000

# Offsets (section-relative) of the synthetic functions.
F_FRAME, F_LEAF, F_SWITCH, F_PAD, F_DERIVED_PARENT, F_TAIL = 0x00, 0x40, 0x60, 0x140, 0x180, 0x1C0

SYNTHETIC = r"""
.intel_syntax noprefix
.code32
.text
.org 0x00
F_FRAME:
    push ebp
    {load} mov ebp, esp
    {load} sub esp, 8
    mov dword ptr [ebp - 4], 0
L_loop:
    mov eax, dword ptr [ebp - 4]
    cmp eax, dword ptr [ebp + 8]
    jge.d8 L_done
    inc dword ptr [ebp - 4]
    push dword ptr [ebp - 4]
    call F_LEAF
    jmp.d8 L_loop
L_done:
    {load} mov esp, ebp
    pop ebp
    ret 4
E_FRAME:
.org 0x40, 0xcc
F_LEAF:
    push ebp
    {load} mov ebp, esp
    mov eax, dword ptr [ebp + 8]
    pop ebp
    ret 4
E_LEAF:
.org 0x60, 0xcc
F_SWITCH:
    push ebp
    {load} mov ebp, esp
    push ecx
    mov eax, dword ptr [ebp + 8]
    sub eax, 1
    mov dword ptr [ebp - 4], eax
    cmp dword ptr [ebp - 4], 3
    ja.d8 L_default
    mov ecx, dword ptr [ebp - 4]
    xor edx, edx
    mov dl, byte ptr [ecx + (IDXTAB - .text + 0x401000)]
    jmp dword ptr [4*edx + (SWTAB - .text + 0x401000)]
L_c0:
    mov eax, 10
    jmp.d8 L_end
L_c1:
    mov eax, 20
    jmp.d8 L_end
L_default:
    xor eax, eax
L_end:
    {load} mov esp, ebp
    pop ebp
    ret 4
E_SWITCH:
SWTAB:
    .long L_c0 - .text + 0x401000
    .long L_c1 - .text + 0x401000
    .long L_default - .text + 0x401000
IDXTAB:
    .byte 0, 1, 1, 2
.org 0x140, 0xcc
F_PAD:
    xor eax, eax
    ret
    nop
    nop
    lea esi, [esi]
.org 0x180, 0xcc
F_DERIVED_PARENT:
    mov eax, 1
    ret
    {disp8} lea ecx, [ecx]
F_DERIVED:
    push ebp
    {load} mov ebp, esp
    pop ebp
    ret
.org 0x1c0, 0xcc
F_TAIL:
    mov eax, dword ptr [ebp + 8]
    jmp.d8 F_LEAF
    jmp F_LEAF
"""


SYMBOLS: dict = {}


def assemble_synthetic(directory: Path) -> bytes:
    source = directory / "synthetic.s"
    source.write_text(SYNTHETIC, encoding="utf-8")
    obj = directory / "synthetic.obj"
    result = subprocess.run([str(AS), "--32", "-o", str(obj), str(source)], capture_output=True, text=True)
    if result.returncode != 0:
        raise AssertionError(result.stderr)
    text, relocations, symbols = gen.coff_text(obj.read_bytes())
    assert relocations == 0
    SYMBOLS.update(symbols)
    return text


class SyntheticMixin:
    @classmethod
    def setUpClass(cls) -> None:
        cls.tmp = tempfile.TemporaryDirectory()
        text = assemble_synthetic(Path(cls.tmp.name))
        cls.text = text.rstrip(b"\0") + b"\0" * 0
        # F_TAIL is the last function; pad the section end so its span is well defined
        cls.image = gen.Image(
            text=cls.text,
            base=BASE,
            starts=[BASE + off for off in (F_FRAME, F_LEAF, F_SWITCH, F_PAD, F_DERIVED_PARENT, F_TAIL)],
        )
        cls.layouts, cls.decoded = gen.analyze_all(cls.image)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.tmp.cleanup()


@TOOLS
class SpanSplitTests(SyntheticMixin, unittest.TestCase):
    def test_frame_function_is_one_code_part(self) -> None:
        layout = self.layouts[BASE + F_FRAME]
        self.assertEqual(layout.exceptions, [])
        self.assertEqual(layout.code_end, BASE + SYMBOLS["E_FRAME"])
        self.assertEqual([item.kind for item in layout.data], ["padding"])
        self.assertEqual(layout.data[0].fill, 0xCC)
        self.assertEqual(layout.code_size + sum(i.size for i in layout.data), layout.span_end - layout.va)

    def test_switch_tables_are_data_not_code(self) -> None:
        layout = self.layouts[BASE + F_SWITCH]
        self.assertEqual(layout.exceptions, [])
        kinds = [item.kind for item in layout.data]
        self.assertEqual(kinds[:2], ["switch_table", "index_table"])
        switch, index = layout.data[0], layout.data[1]
        self.assertEqual(switch.size, 12)
        self.assertEqual(switch.count, 3)
        self.assertEqual(index.size, 4)
        self.assertEqual(index.values, [0, 1, 1, 2])
        # the code part ends exactly at the first table
        self.assertEqual(layout.code_end, switch.va)
        # case targets were followed: every case body is part of the code part
        self.assertTrue(all(layout.va <= target < layout.code_end for target in switch.targets))
        self.assertEqual(layout.insns[-1].mnem, "ret")

    def test_alignment_instructions_are_padding_and_extra_code_is_derived(self) -> None:
        pad = self.layouts[BASE + F_PAD]
        self.assertEqual(pad.exceptions, [])
        padding = [item for item in pad.data if item.kind == "padding"]
        self.assertTrue(any(item.lines for item in padding), "nop/lea alignment should be padding instructions")
        parent = self.layouts[BASE + F_DERIVED_PARENT]
        self.assertEqual(parent.exceptions, [])
        self.assertNotEqual(parent.next_entry, 0)
        derived = self.layouts[parent.next_entry]
        self.assertTrue(derived.derived)
        self.assertEqual(derived.insns[-1].mnem, "ret")
        self.assertEqual(parent.code_size + sum(i.size for i in parent.data), parent.next_entry - parent.va)

    def test_unreachable_tail_jump_is_terminal(self) -> None:
        layout = self.layouts[BASE + F_TAIL]
        self.assertEqual(layout.exceptions, [])
        self.assertEqual(layout.insns[-1].mnem, "jmp")
        self.assertIn(BASE + F_LEAF, layout.external_targets)


@TOOLS
class RenderTests(SyntheticMixin, unittest.TestCase):
    def render(self, off: int) -> str:
        return gen.render_file(self.image, self.layouts[BASE + off])

    def test_hints_labels_and_frame_symbols(self) -> None:
        source = self.render(F_FRAME)
        self.assertIn("{load} mov ebp, esp", source)
        self.assertIn(".d8", source)
        self.assertIn("[ebp - local_4]", source)
        self.assertIn("[ebp + arg_8]", source)
        self.assertIn(".equ local_4, 0x4", source)
        self.assertIn(f"L_{BASE + SYMBOLS['L_loop'] if 'L_loop' in SYMBOLS else BASE + 0x0d:08x}:", source)
        self.assertIn(".set FUN_", source)  # call target resolved without a relocation
        self.assertIn(f".org 0x{BASE:08x} - 0x{BASE:x}", source)
        self.assertIn(f".globl FUN_{BASE:08x}", source)

    def test_no_raw_bytes_in_code(self) -> None:
        for off in (F_FRAME, F_LEAF, F_SWITCH, F_PAD, F_DERIVED_PARENT, F_TAIL):
            code = self.render(off).split("\n")
            for line in code:
                stripped = line.split("#")[0].strip()
                self.assertIsNone(re.match(r"^\.(word|int|quad|ascii|incbin|short|string)\b", stripped), line)

    def test_switch_data_items_are_symbolic(self) -> None:
        source = self.render(F_SWITCH)
        self.assertIn("SWTAB_", source)
        self.assertIn("IDXTAB_", source)
        self.assertIn(".long L_", source)
        self.assertIn("[4*edx + SWTAB_", source)

    def test_header_has_the_annotation_fields(self) -> None:
        source = self.render(F_LEAF)
        for key in ("va", "extent", "sha256", "region", "name", "arguments", "locals", "fields", "callees", "track-n", "unverified"):
            self.assertRegex(source, rf"# {key}:")
        self.assertEqual(source.count("<unfilled>"), 8 + 1)  # eight header fields + one basic-block comment

    def test_every_rendered_function_reassembles_exactly_without_relocations(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            report = gen.run_census(self.image, Path(tmp))
        self.assertEqual(report["relocations"], 0)
        self.assertEqual(report["mismatches"], [])
        self.assertEqual(report["exceptions"], {})
        totals = report["totals"]
        self.assertEqual(totals["code_bytes"], totals["code_exact_bytes"])
        accounted = (
            totals["code_bytes"]
            + totals.get("switch_table_bytes", 0)
            + totals.get("index_table_bytes", 0)
            + totals.get("padding_bytes", 0)
        )
        self.assertEqual(accounted, totals["span_bytes"])


class HintTests(unittest.TestCase):
    def insn(self, raw: str, mnem: str, ops: str, addr: int = 0x401000):
        return gen.Insn(addr, bytes.fromhex(raw), mnem, ops)

    def hinted(self, raw: str, mnem: str, ops: str) -> str:
        ins = self.insn(raw, mnem, ops)
        return gen.encode_hints(ins, ins.text)

    def test_load_store_forms(self) -> None:
        self.assertEqual(self.hinted("8bec", "mov", "ebp, esp"), "{load} mov ebp, esp")
        self.assertEqual(self.hinted("89e5", "mov", "ebp, esp"), "{store} mov ebp, esp")
        self.assertEqual(self.hinted("33c0", "xor", "eax, eax"), "{load} xor eax, eax")
        self.assertEqual(self.hinted("85c0", "test", "eax, eax"), "test eax, eax")

    def test_displacement_hints(self) -> None:
        self.assertEqual(self.hinted("8b8001000000", "mov", "eax, dword ptr [eax + 0x1]"), "{disp32} mov eax, dword ptr [eax + 0x1]")
        self.assertEqual(self.hinted("8b4500", "mov", "eax, dword ptr [ebp]"), "{disp8} mov eax, dword ptr [ebp]")

    def test_insn_spellings(self) -> None:
        self.assertEqual(self.hinted("66050100", "add", "ax, 0x1"), ".insn 0x66, 0x05, 0x0001{:u16}")
        self.assertEqual(self.hinted("663d3412", "cmp", "ax, 0x1234"), ".insn 0x66, 0x3d, 0x1234{:u16}")
        self.assertEqual(self.hinted("0500000000", "add", "eax, 0x0"), ".insn 0x05, 0x00000000{:u32}")
        self.assertEqual(self.hinted("dcc0", "fadd", "st(0), st"), ".insn 0xdc, 0xc0")
        self.assertEqual(self.hinted("6681f90100", "cmp", "cx, 0x1"), ".insn 0x6681/7, ecx, 1{:s16}")

    def test_nop_like_padding_forms(self) -> None:
        self.assertEqual(gen.nop_like(bytes.fromhex("90"), 0), (1, "nop"))
        self.assertEqual(gen.nop_like(bytes.fromhex("8bff"), 0), (2, "{load} mov edi, edi"))
        self.assertEqual(gen.nop_like(bytes.fromhex("8d4900"), 0), (3, "{disp8} lea ecx, [ecx]"))
        self.assertEqual(gen.nop_like(bytes.fromhex("8da42400000000"), 0), (7, "{disp32} lea esp, [esp]"))
        self.assertIsNone(gen.nop_like(bytes.fromhex("8b45fc"), 0))


@TOOLS
class OriginalRoundTrip(unittest.TestCase):
    """Whole-binary census against the owner's local GAME.EXE (skipped when absent)."""

    def test_census_reproduces_every_classified_code_byte(self) -> None:
        if not gen.ORIGINAL_DEFAULT.is_file():
            self.skipTest("local GAME.EXE not available")
        image = gen.load_image()
        with tempfile.TemporaryDirectory() as tmp:
            report = gen.run_census(image, Path(tmp))
        self.assertEqual(report["relocations"], 0)
        self.assertEqual(report["mismatches"], [])
        totals = report["totals"]
        self.assertEqual(totals["code_bytes"], totals["code_exact_bytes"])
        accounted = (
            totals["code_bytes"]
            + totals["switch_table_bytes"]
            + totals["index_table_bytes"]
            + totals["padding_bytes"]
            + totals["exception_span_bytes"]
        )
        self.assertEqual(accounted, gen.TEXT_SIZE)
        # the only functions outside the 100% gate are the CRT block copiers with interleaved tables
        self.assertEqual(sorted(report["exceptions"]), ["0x0050ed50", "0x0050fa90"])


if __name__ == "__main__":
    unittest.main()
