#!/usr/bin/env python3
"""Audit a batch of tool-assisted reconstructed assembly (packet M03).

A function enters the ``tool_assisted_reconstructed_assembly`` class only when
this auditor accepts it *and* root accepts the independent review.  For every
function in a batch manifest the auditor

* reassembles the committed ``.s`` with the pinned ``i686-w64-mingw32-as``
  2.43.1 (never with Xcode's assembler) and rejects an object that carries any
  relocation or that differs from a supplied pre-built object;
* compares the function symbol's bytes with the original *code part*, and each
  emitted data item (switch table, index table, padding) with its original
  bytes separately, through ``verify_matches.py``;
* re-derives the span split (code / tables / padding) from the original with
  the generator's control-flow analysis and requires the manifest to agree, so
  that table bytes are never counted as code;
* rejects raw byte lists and unknown directives outside the permitted forms
  (``.insn`` in the five spellings of the M0 report, ``.long`` of symbolic case
  addresses and ``.byte`` index values and ``.fill`` of ``int3``/``nop``
  inside data items only);
* rejects missing or placeholder annotation fields, unnamed ``[ebp±n]``
  frame offsets and basic blocks without a real comment;
* records source, object, assembler and original-extent hashes (never original
  byte values) in the report.

Two endings other than a terminal ``ret``/``jmp`` are accepted under the owner ruling of 2026-10-16 (a fragment counts
as matched when it reassembles byte for byte, either as a function ending in a never-returning call or bound together
with the range it falls through into): a code part whose last instruction is a ``call`` with no data after it
(``# ending: call-end``) and a code part that runs into the next range (``# ending: fall-through into <va>``).  A callee
that never returns cannot be proven from the bytes (six of the thirteen call-ends call a helper that does return), so
both are counted as the second option of the ruling, bound together with the range that follows them.  The auditor
derives the ending from the original and requires the header and the manifest to declare exactly that; the composer then
requires the following range to be bound as code as well.
"""

from __future__ import annotations

import argparse
import bisect
import hashlib
import importlib.util
import json
import re
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional

PROJECT = Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
WORK = REPOSITORY / "work"
SCRIPTS = PROJECT / "scripts"

BINUTILS_SHA512 = "20977ad17729141a2c26d358628f44a0944b84dcfefdec2ba029c2d02f40dfc41cc91c0631044560d2bd6f9a51e1f15846b4b311befbe14f1239f14ff7d57824"
ASSEMBLER_VERSION_LINE = "GNU assembler (GNU Binutils) 2.43.1"
CLASS_NAME = "tool_assisted_reconstructed_assembly"
BASELINE_MANIFESTS = (
    "matches.json",
    "matches_s08.json",
    "matches_s08_2.json",
    "matches_s08_2_x86.json",
    "matches_s08_3_x86.json",
    "matches_s08_4_x86.json",
)



def derived_evidence(image: Any, va: int) -> str:
    """Evidence id of a derived entry: code the span split found that function-index.json does not list."""

    parent = image.starts[bisect.bisect_right(image.starts, va) - 1]
    return (
        f"derived-entry: found by the span split, not in function-index.json; inside the span of FUN_{parent:08x} "
        f"(+0x{va - parent:x})"
    )


def apply_derived_evidence(image: Any, layouts: dict) -> None:
    """Give every derived layout its evidence id (the generator leaves it unfilled)."""

    for va, layout in layouts.items():
        if layout.derived:
            image.evidence[va] = derived_evidence(image, va)


REQUIRED_FIELDS = (
    "class", "va", "extent", "span", "sha256", "evidence", "region", "frame",
    "name", "arguments", "locals", "fields", "callees", "track-n", "unverified",
)
MACHINE_ANNOTATION = "machine"
ANNOTATION_FIELDS = ("name", "arguments", "locals", "fields", "callees", "track-n", "unverified")
# todo/tbd/fixme must stand alone: an import name such as FileTimeToDosDateTime is not a placeholder
PLACEHOLDER_RE = re.compile(r"(?<![a-z])(?:todo|tbd|fixme)(?![a-z])|xxx+|<\s*unfilled\s*>|placeholder|lorem|n/a|none yet|to be (?:filled|determined|written)", re.I)
# The assembler is pinned by its version line and by a self-test: a fixed source that exercises every encoding hint
# must assemble to exactly these bytes.  This works on any machine that built the pinned binutils.
SELF_TEST_SOURCE = """.intel_syntax noprefix
.code32
.text
    {load} mov ebp, esp
    {store} mov ebp, esp
    .insn 0x66, 0x05, 0x0001{:u16}
    .insn 0x66, 0x3d, 0x1234{:u16}
    .insn 0x05, 0x00000000{:u32}
    .insn 0xdc, 0xc0
    .insn 0x6681/7, ecx, 1{:s16}
    .insn 0x6681/7, dword ptr [ecx + 4], 1{:s16}
    {disp8} mov eax, dword ptr [ecx]
    {disp32} mov eax, dword ptr [ecx + 1]
    jne.d8 L_skip
    nop
L_skip:
    jmp.d32 L_end
    nop
L_end:
    ret 4
"""
SELF_TEST_BYTES = bytes.fromhex("8bec89e566050100663d34120500000000dcc06681f901006681790401008b41008b8101000000750190e90100000090c20400")
# Mnemonics that occur in the code part of the original (128 observed over all 4,729 split spans) plus a few
# control-flow and string forms; anything else on an instruction line is rejected, which closes the door to
# macros, user-defined pseudo-instructions and data smuggled onto an instruction line.
MNEMONICS = frozenset(
    "adc add and bt bts call cdq cld cmp dec div f2xm1 fabs fadd faddp fchs fcom fcomp fcompp fcos fdiv fdivp fdivr "
    "fdivrp fiadd fidiv fild fimul fistp fisub fld fld1 fldcw fldenv fldl2e fldlg2 fldln2 fldpi fldz fmul fmulp fnclex "
    "fnsave fnstcw fnstenv fnstsw fpatan fprem fprem1 fptan frndint frstor fscale fsin fsqrt fst fstp fsub fsubp fsubr "
    "fsubrp ftst fxam fxch fyl2x idiv imul inc int ja jae jb jbe je jecxz jg jge jl jle jmp jne jns jp js lea leave lock "
    "mov movsb movsd movsw movsx movzx mul neg nop not or pop push rcr rep repne ret rol sahf sar sbb sete setg setge setl "
    "setle setne shl shld shr shrd std stosb stosd stosw sub test wait xchg xlatb xor "
    "jo jno jnp loop loope loopne cwde int3 iretd retf cmpsb cmpsd scasb scasd lodsb lodsd".split()
)


def load_module(name: str, path: Path) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))
import function_names as fnames  # noqa: E402
import gen_fragments  # noqa: E402

gen = gen_fragments.extend(load_module("gen_hinted_asm_for_audit", SCRIPTS / "gen_hinted_asm.py"))
verifier = load_module("verify_matches_for_audit", SCRIPTS / "verify_matches.py")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


# ---------------------------------------------------------------------------
# Lexical audit of one .s file
# ---------------------------------------------------------------------------

_LABEL = re.compile(r"^([A-Za-z_.][\w.$]*):$")
_HINT = re.compile(r"^\{(load|store|disp8|disp32)\}$")
_ADDRESS_COMMENT = re.compile(r"^[0-9a-f]{8}$")
_INSN_SPELLINGS = (
    re.compile(r"^\.insn 0x66, 0x(?:05|0d|25|2d|3d), 0x[0-9a-f]{1,4}\{:u16\}$"),
    re.compile(r"^\.insn 0x05, 0x[0-9a-f]{1,8}\{:u32\}$"),
    re.compile(r"^\.insn 0xdc, 0xc0$"),
    re.compile(r"^\.insn 0x6681/[0-7], (?:e[a-ds][xip]|e[sd]i|ebp|esp), -?\d+\{:s16\}$"),
    re.compile(r"^\.insn 0x6681/[0-7], dword ptr \[[^\]]+\], -?\d+\{:s16\}$"),
)
_NUMBER = re.compile(r"(?<![\w.])\d")  # any numeric literal, whatever its base or case
_WEAK_NAME = re.compile(r"^(?:[a-z]\d*|(?:local|arg|var|tmp|slot|off)\d*)$", re.I)
_SYNTHETIC_FUNCTION_NAME = re.compile(r"^(?:fun|sub|loc|func|unk|dat|lab)_[0-9a-f]{6,8}$", re.I)
_SHORT_BRANCH_NOTE = re.compile(r"\. \+ \((-?\d+)\)")
_DEFAULT_FRAME_NAME = re.compile(r"^(?:local|arg|field|field_minus|stk|stk_minus)_[0-9a-f]+$")
_TERMINAL = {"ret", "retf", "lret", "iret", "iretd", "hlt", "ud2", "jmp", "ljmp"}
_NOP_LIKE = re.compile(r"^(?:nop|int3|mov (e[a-d]x|e[sd]i|e[sb]p), \1|lea (e[a-d]x|e[sd]i|e[sb]p), \[\2\])$")
_SWTAB_LONG = re.compile(r"^\.long (?:L_[0-9a-f]{8}|[A-Za-z_]\w*) - \.text \+ 0x[0-9a-f]+$")
_ORG = re.compile(r"^\.org 0x[0-9a-f]{8} - 0x[0-9a-f]+$")
_EQU = re.compile(r"^\.equ ([A-Za-z_]\w*), 0x[0-9a-f]+$")
_SET_EXTERNAL = re.compile(r"^\.set ((?:FUN|LOC)_[0-9a-f]{8}), \.text \+ \(0x[0-9a-f]{8} - 0x[0-9a-f]+\)$")
_SET_TABLE = re.compile(r"^\.set ((?:SWTAB|IDXTAB)_[0-9a-f]{8})_VA, \1 - \.text \+ 0x[0-9a-f]+$")
_FILL = re.compile(r"^\.fill (\d+), 1, 0x(cc|90)$")
_BYTE_LIST = re.compile(r"^\.byte (?:\d{1,3})(?:, \d{1,3})*$")


@dataclass
class Line:
    number: int
    raw: str
    code: str
    comment: str


def split_lines(text: str) -> list[Line]:
    out = []
    for number, raw in enumerate(text.splitlines(), 1):
        code, _, comment = raw.partition("#")
        out.append(Line(number, raw, code.strip(), comment.strip()))
    return out


def meaningful(comment: str) -> bool:
    """A comment that says something, not a generator address or stub."""

    text = comment.strip()
    if not text:
        return False
    if re.match(r"^block 0x[0-9a-f]+:", text):
        text = text.split(":", 1)[1].strip()
    if text.startswith("->"):
        return False
    text = _ADDRESS_COMMENT.sub("", text).strip()
    if PLACEHOLDER_RE.search(text):
        return False
    return len(text) >= 8 and len(text.split()) >= 2 and re.search(r"[A-Za-z]{3}", text) is not None


def parse_header(lines: list[Line]) -> dict[str, str]:
    header: dict[str, str] = {}
    for line in lines:
        if line.code:
            break
        match = re.match(r"^([a-z][a-z0-9-]*):\s*(.*)$", line.comment)
        if match:
            header.setdefault(match.group(1), match.group(2).strip())
    return header


def mnemonic_of(code: str) -> str:
    tokens = code.split()
    while tokens and _HINT.match(tokens[0]):
        tokens.pop(0)
    if not tokens:
        return ""
    return re.sub(r"\.d(?:8|32)$", "", tokens[0])


def audit_source(text: str, header_expect: dict[str, Any], code_symbol: str, allow_index_byte_lists: bool = True, text_base: int = 0x401000, index_owners: Optional[dict[str, int]] = None, names: Optional[dict[int, dict[str, Any]]] = None) -> tuple[list[str], dict[str, Any]]:
    """Lexical checks; returns (reasons, facts)."""

    reasons: list[str] = []
    lines = split_lines(text)
    header = parse_header(lines)
    facts: dict[str, Any] = {"header": header}

    if re.search(r"<\s*unfilled\s*>", text, re.I):
        reasons.append("source still contains <unfilled> placeholders")
    for key in REQUIRED_FIELDS:
        if key not in header:
            reasons.append(f"header field {key!r} is missing")
    for key in ANNOTATION_FIELDS:
        value = header.get(key, "")
        words = re.findall(r"[A-Za-z0-9_]+", value)
        if not value or PLACEHOLDER_RE.search(value) or not words:
            reasons.append(f"header field {key!r} is empty or a placeholder")
        elif key in ("arguments", "locals", "fields", "callees") and len(words) < 2 and not value.lower().startswith("none"):
            reasons.append(f"header field {key!r} is too short to describe anything")
        elif key == "unverified" and value.strip().lower() != "none" and len(words) < 3 and not value.lower().startswith("none"):
            reasons.append("header field 'unverified' must be 'none' or say what is unverified")
    # Machine-generated names are valid Track M annotation (owner ruling recorded in the project plan, 2026-10-15).
    # Only a file that declares ``annotation: machine`` may keep the generator's default symbol names, and its
    # function name must then be exactly ``fn_`` plus the function's own address.
    machine = header.get("annotation", "").split(" ")[0] == MACHINE_ANNOTATION
    facts["annotation"] = "machine" if machine else "hand"
    name = header.get("name", "")
    if machine:
        # asm/function-names.json (scripts/function_names.py) may give a function the name that committed evidence states;
        # then the source must carry exactly that name, naming line and note, and nothing else may carry them.
        named = (names or {}).get(int(code_symbol[4:], 16))
        facts["naming"] = named["basis"] if named else ""
        if named:
            if name != named["name"]:
                reasons.append(f"machine-annotated function name {name!r} is not the name {named['name']!r} that asm/function-names.json records for {code_symbol}")
            if header.get("naming") != fnames.naming_text(named):
                reasons.append("header 'naming' differs from asm/function-names.json")
            if header.get("name-note") != fnames.summary_text(named):
                reasons.append("header 'name-note' differs from asm/function-names.json")
            if fnames.unverified_clause(named) not in header.get("unverified", ""):
                reasons.append("header 'unverified' must carry the clause of the name's tier (copied from evidence; structural role; or lower-confidence inference), not a claim of reading the code")
        else:
            if name != "fn_" + code_symbol[4:]:
                reasons.append(f"machine-annotated function name {name!r} is not fn_<va> of {code_symbol}")
            for key in ("naming", "name-note"):
                if key in header:
                    reasons.append(f"header {key!r} present but asm/function-names.json has no entry for {code_symbol}")
    elif name and (
        not re.match(r"^[A-Za-z_][A-Za-z0-9_:.]*$", name)
        or re.match(r"^FUN_[0-9a-f]{8}$", name)
        or _SYNTHETIC_FUNCTION_NAME.match(name)
    ):
        reasons.append(f"function name {name!r} is not a real name")
    if not machine:
        for key in ("naming", "name-note"):
            if key in header:
                reasons.append(f"header {key!r} is only valid in a machine-annotated source whose name asm/function-names.json records")
    track = header.get("track-n", "")
    if track and track != "host-adapter: none":
        if not re.match(r"^[\w./+-]+:[\w:~]+( .*)?$", track):
            reasons.append("track-n is neither 'host-adapter: none' nor '<repo path>:<symbol>'")
    for key, expected in header_expect.items():
        if header.get(key) != expected:
            reasons.append(f"header {key!r} is {header.get(key)!r}, expected {expected!r}")
    if header.get("class", "").split(" ")[0] != CLASS_NAME:
        reasons.append("header class is not tool_assisted_reconstructed_assembly")

    state = "preamble"  # preamble | code | data
    data_kind = ""
    labels: set[str] = set()
    code_lines: list[Line] = []
    globl_seen = False
    entry_seen = False
    last_code_mnemonic = ""
    placeholder_frame_names: set[str] = set()
    def check_ebp(code: str, number: int) -> None:
        """Every register-relative displacement (frame, stack or object field) must be a named symbol.

        Absolute addresses (value >= 0x400000, array and table bases) and base-less operands stay numeric.
        """

        for operand in re.findall(r"\[([^\]]*)\]", code):
            has_register = re.search(r"\b(?:e[a-d]x|e[sd]i|e[sb]p)\b", operand) is not None
            stripped = re.sub(r"(?<![\w.])[1248]\*", "", operand)
            if has_register:
                for literal in re.findall(r"(?<![\w.])0[xXbBoO][0-9a-fA-F]+|(?<![\w.])\d+", stripped):
                    try:
                        value = int(literal, 0)
                    except ValueError:
                        value = 0
                    if value < 0x400000 or "ebp" in operand:
                        reasons.append(f"line {number}: unnamed register-relative offset in [{operand}]")
                        break
            for token in re.findall(r"[A-Za-z_]\w*", operand):
                if not machine and _DEFAULT_FRAME_NAME.match(token) and token not in placeholder_frame_names:
                    placeholder_frame_names.add(token)
                    reasons.append(f"line {number}: offset uses placeholder name {token}")

    set_symbols: set[str] = set()
    index_label_ok = False
    for line in lines:
        code = line.code
        if "/*" in line.raw or "*/" in line.raw:
            reasons.append(f"line {line.number}: C-style comment")
        if not code:
            continue
        if ";" in code or "\\" in code:
            reasons.append(f"line {line.number}: statement separator or line continuation is not permitted")
            continue
        if code in (".intel_syntax noprefix", ".code32", ".text"):
            continue
        label = _LABEL.match(code)
        if label:
            name = label.group(1)
            labels.add(name)
            if name == code_symbol:
                entry_seen = True
                state = "code"
            elif state == "code" and name.startswith(("SWTAB_", "IDXTAB_", "PAD_")):
                reasons.append(f"line {line.number}: data label {name} inside the code part (missing .org)")
            elif state == "data" or name.startswith(("SWTAB_", "IDXTAB_", "PAD_")):
                data_kind = name.split("_", 1)[0]
                state = "data"
                owner_match = re.search(
                    rf"index table of {re.escape(code_symbol)} for the switch jump at 0x([0-9a-f]{{8}})", line.comment
                )
                index_label_ok = bool(data_kind == "IDXTAB" and owner_match)
                if index_label_ok and index_owners is not None and index_owners.get(name) != int(owner_match.group(1), 16):
                    index_label_ok = False
            if state == "code":
                code_lines.append(line)
            continue
        if code.startswith("."):
            if code.startswith((".org ", ".set ", ".long ")):
                tail = re.search(r"0x([0-9a-f]+)\)?$", code)
                if tail and int(tail.group(1), 16) != text_base:
                    reasons.append(f"line {line.number}: section base 0x{tail.group(1)} is not the text base 0x{text_base:x}")
            if _EQU.match(code):
                equ = _EQU.match(code).group(1)
                if _DEFAULT_FRAME_NAME.match(equ):
                    if not machine:
                        reasons.append(f"line {line.number}: frame symbol {equ} still has the generator's default name")
                elif _WEAK_NAME.match(equ):
                    reasons.append(f"line {line.number}: frame symbol {equ} is too short to be a name")
                continue
            external = _SET_EXTERNAL.match(code)
            if external:
                target = re.search(r"\(0x([0-9a-f]{8}) -", code).group(1)
                if external.group(1)[-8:] != target:
                    reasons.append(f"line {line.number}: symbol {external.group(1)} does not name its target 0x{target}")
                set_symbols.add(external.group(1))
                continue
            if _SET_TABLE.match(code):
                set_symbols.add(code.split()[1].rstrip(","))
                continue
            if code.startswith(".globl "):
                if code != f".globl {code_symbol}":
                    reasons.append(f"line {line.number}: unexpected .globl {code}")
                globl_seen = True
                continue
            if _ORG.match(code):
                if state == "code" and entry_seen:
                    state = "data"
                    data_kind = ""
                continue
            if any(pattern.match(code) for pattern in _INSN_SPELLINGS):
                if state != "code":
                    reasons.append(f"line {line.number}: .insn outside the code part")
                else:
                    code_lines.append(line)
                    last_code_mnemonic = ".insn"
                    check_ebp(code, line.number)
                continue
            if state == "data" and data_kind == "SWTAB" and _SWTAB_LONG.match(code):
                continue
            if state == "data" and data_kind == "IDXTAB" and _BYTE_LIST.match(code):
                if not index_label_ok:
                    reasons.append(f"line {line.number}: index table is not labeled with its owning function and switch")
                elif not allow_index_byte_lists:
                    reasons.append(
                        f"line {line.number}: index table as a raw byte list needs a root ruling (AGENTS.md forbids committed byte arrays)"
                    )
                elif any(int(v) > 255 for v in re.findall(r"\d+", code)):
                    reasons.append(f"line {line.number}: index byte out of range")
                continue
            if state == "data" and data_kind == "PAD" and _FILL.match(code):
                continue
            reasons.append(f"line {line.number}: directive or raw data not permitted here: {code.split()[0]}")
            continue
        # instruction
        if re.match(r"^[A-Za-z_.][\w.$]*:", code):
            reasons.append(f"line {line.number}: label and statement on one line: {code}")
            continue
        if mnemonic_of(code) not in MNEMONICS:
            reasons.append(f"line {line.number}: {mnemonic_of(code)!r} is not an instruction mnemonic the original uses")
            continue
        if state == "data":
            if data_kind == "PAD" and _NOP_LIKE.match(re.sub(r"^(\{[a-z0-9]+\} )+", "", code)):
                continue
            reasons.append(f"line {line.number}: instruction inside a data item: {code}")
            continue
        if state != "code":
            reasons.append(f"line {line.number}: instruction before the function label")
            continue
        code_lines.append(line)
        last_code_mnemonic = mnemonic_of(code)
        if last_code_mnemonic in gen._COND_JUMPS or last_code_mnemonic in ("jmp", "call"):
            tokens = code.split()
            while tokens and _HINT.match(tokens[0]):
                tokens.pop(0)
            operand = " ".join(tokens[1:])
            if not re.fullmatch(r"[A-Za-z_]\w*", operand) and not re.fullmatch(r"\. \+ \(-?\d+\)", operand):
                if not operand.startswith(("dword ptr", "e")) or "[" not in operand and not re.fullmatch(r"e[a-z]{2}", operand):
                    reasons.append(f"line {line.number}: direct branch operand {operand!r} is neither a label nor the audited short-branch form")
        note = _SHORT_BRANCH_NOTE.search(code)
        if note:
            named = re.search(r"-> ((?:FUN|LOC)_[0-9a-f]{8})(?: # ([0-9a-f]{8}))?", line.raw)
            if not named or named.group(1) not in set_symbols:
                reasons.append(f"line {line.number}: short branch to another function names no defined .set symbol")
        check_ebp(code, line.number)
    if not entry_seen:
        reasons.append(f"function label {code_symbol} is missing")
    if not globl_seen:
        reasons.append(f"missing .globl {code_symbol}")
    facts["labels"] = sorted(labels)

    # code part must end at a terminal instruction or tail into data
    ending = header_expect.get("ending", "")
    ending_kind = ending.split(" ")[0]
    if "ending" in header and not ending:
        reasons.append("header declares an ending that the original code part does not have")
    if ending_kind == "call-end" and last_code_mnemonic != "call":
        reasons.append(f"ending call-end needs a call as the last instruction, not {last_code_mnemonic!r}")
    elif ending_kind == "fall-through" and last_code_mnemonic in _TERMINAL:
        reasons.append(f"ending fall-through but the last instruction is the terminal {last_code_mnemonic!r}")
    elif last_code_mnemonic and last_code_mnemonic not in _TERMINAL and not ending_kind:
        data_follows = any(
            _LABEL.match(l.code) and _LABEL.match(l.code).group(1).startswith(("SWTAB_", "IDXTAB_", "PAD_"))
            for l in lines
        )
        if not (data_follows and last_code_mnemonic == "call"):
            reasons.append(f"code part ends in {last_code_mnemonic!r}, not a terminal ret/jmp or a tail into data")

    # one real comment per basic block
    reasons_blocks = _block_comment_audit(lines, code_symbol)
    reasons += reasons_blocks[0]
    facts["basic_blocks"] = reasons_blocks[1]
    return reasons, facts


def _block_comment_audit(lines: list[Line], code_symbol: str) -> tuple[list[str], int]:
    """Count basic blocks of the code part and flag those with no real comment."""

    reasons: list[str] = []
    started = False
    in_code = False
    blocks: list[dict[str, Any]] = []
    current: Optional[dict[str, Any]] = None
    pending = 0
    needs_new = True
    for line in lines:
        code = line.code
        label = _LABEL.match(code) if code else None
        if label and label.group(1) == code_symbol:
            started = in_code = True
        if not started:
            continue
        if code and (_ORG.match(code) or (label and label.group(1).startswith(("SWTAB_", "IDXTAB_", "PAD_")))):
            if code.startswith(".org"):
                in_code = False
            if label:
                in_code = False
        if not in_code:
            continue
        if not code:
            if meaningful(line.comment):
                pending += 1
            continue
        if label:
            if current is None or current["insns"] or needs_new:
                current = {"comments": 0, "insns": 0, "line": line.number}
                blocks.append(current)
            current["comments"] += pending
            pending = 0
            needs_new = False
            continue
        if code.startswith(".") and not code.startswith(".insn"):
            continue
        if needs_new or current is None:
            current = {"comments": 0, "insns": 0, "line": line.number}
            blocks.append(current)
            needs_new = False
        current["comments"] += pending + (1 if meaningful(line.comment) else 0)
        pending = 0
        current["insns"] += 1
        mnem = mnemonic_of(code)
        if mnem in _TERMINAL or mnem in gen._COND_JUMPS:
            needs_new = True
    for block in blocks:
        if block["comments"] < 1:
            reasons.append(f"basic block at line {block['line']} has no comment")
    return reasons, len(blocks)


# ---------------------------------------------------------------------------
# Assembler provenance
# ---------------------------------------------------------------------------


def assembler_self_test(path: Path) -> Optional[str]:
    """Assemble a fixed source with every hint kind and require the exact expected bytes."""

    with tempfile.TemporaryDirectory(prefix="m03-selftest-") as tmp:
        source = Path(tmp) / "selftest.s"
        obj = Path(tmp) / "selftest.obj"
        source.write_text(SELF_TEST_SOURCE, encoding="utf-8")
        run = subprocess.run([str(path), "--32", "-o", str(obj), str(source)], capture_output=True, text=True)
        if run.returncode != 0 or not obj.is_file():
            return "assembler self-test failed to assemble"
        try:
            text_bytes, relocations, _symbols = gen.coff_text(obj.read_bytes())
        except (ValueError, struct.error):
            return "assembler self-test produced an unreadable object"
        padding = b"\x90" * (-len(SELF_TEST_BYTES) % 4)
        if relocations or text_bytes != SELF_TEST_BYTES + padding:
            return "assembler self-test bytes differ: this is not the pinned GNU assembler"
    return None


def check_assembler(path: Path) -> tuple[Optional[str], dict[str, Any]]:
    shown = str(path)
    for base in (REPOSITORY, WORK.resolve().parent):
        try:
            shown = path.resolve().relative_to(base.resolve()).as_posix()
            break
        except ValueError:
            continue
    info: dict[str, Any] = {"path": shown}
    if not path.is_file():
        return f"assembler {path} is missing", info
    try:
        out = subprocess.run([str(path), "--version"], capture_output=True, text=True, check=True).stdout
    except (OSError, subprocess.CalledProcessError) as exc:
        return f"assembler {path} cannot report its version: {exc}", info
    line = out.splitlines()[0] if out.splitlines() else ""
    info["version_line"] = line
    info["sha256"] = sha256(path.read_bytes())
    if line != ASSEMBLER_VERSION_LINE:
        return f"assembler is {line!r}, not the pinned {ASSEMBLER_VERSION_LINE!r}", info
    problem = assembler_self_test(path)
    info["self_test"] = "passed" if problem is None else problem
    if problem:
        return problem, info
    archive = path.parents[2] / "binutils-2.43.1.tar.xz"
    if archive.is_file():
        digest = hashlib.sha512(archive.read_bytes()).hexdigest()
        info["binutils_archive_sha512"] = digest
        if digest != BINUTILS_SHA512:
            return "binutils source archive does not match the pinned SHA-512", info
    else:
        info["binutils_archive_sha512"] = "archive not present beside the pinned prefix"
    return None, info


# ---------------------------------------------------------------------------
# Batch audit
# ---------------------------------------------------------------------------


@dataclass
class AuditConfig:
    original: Path = WORK / "original/GAME.EXE"
    index: Path = PROJECT / "function-index.json"
    assembler: Path = gen.AS_DEFAULT
    expected_sha256: str = gen.ORIGINAL_SHA256
    strict_image: bool = True
    repository: Optional[Path] = REPOSITORY
    baseline_dir: Optional[Path] = PROJECT
    image_base: int = 0x400000
    allow_index_byte_lists: bool = True
    # va -> entry of asm/function-names.json; None means no function has a recorded name
    names: Optional[dict[int, dict[str, Any]]] = None
    names_path: Optional[Path] = None


def audit_manifest(manifest_path: Path, config: AuditConfig) -> dict[str, Any]:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    report: dict[str, Any] = {
        "batch": manifest.get("batch"),
        "class_requested": manifest.get("class"),
        "manifest_sha256": sha256(manifest_path.read_bytes()),
        "all_accepted": False,
        "contains_original_byte_values": False,
        "functions": [],
        "errors": [],
    }
    if manifest.get("class") != CLASS_NAME:
        report["errors"].append("manifest class is not tool_assisted_reconstructed_assembly")
    if manifest.get("original_sha256") != config.expected_sha256:
        report["errors"].append("manifest original_sha256 is not the pinned original")
    problem, assembler_info = check_assembler(config.assembler)
    report["assembler"] = assembler_info
    if problem:
        report["errors"].append(problem)
        return report
    entries = manifest.get("functions")
    if not isinstance(entries, list) or not entries:
        report["errors"].append("manifest has no functions")
        return report

    image = gen.load_image(config.original, config.index, config.expected_sha256, config.strict_image)
    report["original_sha256"] = config.expected_sha256
    vas = [int(entry["va"], 0) for entry in entries]
    # derived entries (found by the span split, not in the index) are discovered from their parent span
    layouts, _decoded = gen.analyze_all(image, [va for va in vas if va in image.starts])
    apply_derived_evidence(image, layouts)
    base_ranges = baseline_ranges(config)
    seen_ranges: list[tuple[int, int, str]] = []

    for entry, va in zip(entries, vas):
        result = audit_function(entry, va, layouts.get(va), image, manifest_path, config)
        report["functions"].append(result)
        if result["status"] == "accepted":
            lo = va
            hi = va + result["code"]["size"]
            for slo, shi, other in seen_ranges:
                if lo < shi and slo < hi:
                    result["status"] = "rejected"
                    result["reasons"].append(f"code range overlaps {other}")
            seen_ranges.append((lo, hi, entry["function"]))

    accepted = [f for f in report["functions"] if f["status"] == "accepted"]
    report["all_accepted"] = len(accepted) == len(report["functions"]) and not report["errors"]
    by_region: dict[str, dict[str, int]] = {}
    handoff = []
    new_code = 0
    overlap_code = 0
    for result in accepted:
        region = result["region"]
        row = by_region.setdefault(region, {"functions": 0, "code_bytes": 0, "data_bytes": 0})
        row["functions"] += 1
        row["code_bytes"] += result["code"]["size"]
        row["data_bytes"] += sum(item["size"] for item in result["data_items"])
        va = result["va"]
        size = result["code"]["size"]
        covered = sum(max(0, min(va + size, bhi) - max(va, blo)) for blo, bhi in base_ranges)
        overlap_code += covered
        new_code += size - covered
        for item in result["data_items"]:
            handoff.append({"function": result["function"], **item})
    report["accepted_count"] = len(accepted)
    report["named_functions"] = sum(1 for f in accepted if f.get("naming"))
    if config.names:
        report["names_sha256"] = fnames.table_sha256(config.names_path) if config.names_path else ""
    report["code_bytes_accepted"] = sum(f["code"]["size"] for f in accepted)
    report["by_region"] = by_region
    report["data_items_for_m02"] = handoff
    report["baseline"] = {
        "manifests": [name for name in BASELINE_MANIFESTS if config.baseline_dir and (config.baseline_dir / name).exists()],
        "baseline_matched_bytes": sum(hi - lo for lo, hi in base_ranges),
        "batch_bytes_overlapping_baseline": overlap_code,
        "batch_bytes_not_in_baseline": new_code,
    }
    report["note"] = (
        "Accepted functions are candidates for the tool_assisted_reconstructed_assembly class; they count "
        "only after root accepts the independent review. No claim is made about original C++ or compiler provenance."
    )
    return report


def baseline_ranges(config: AuditConfig) -> list[tuple[int, int]]:
    ranges: list[tuple[int, int]] = []
    if not config.baseline_dir:
        return ranges
    for name in BASELINE_MANIFESTS:
        path = config.baseline_dir / name
        if not path.exists():
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        for row in data.get("functions", []):
            ranges.append((config.image_base + int(row["rva"]), config.image_base + int(row["rva"]) + int(row["size"])))
    merged: list[tuple[int, int]] = []
    for lo, hi in sorted(set(ranges)):
        if merged and lo <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], hi))
        else:
            merged.append((lo, hi))
    return merged


def audit_function(entry: dict[str, Any], va: int, layout, image, manifest_path: Path, config: AuditConfig) -> dict[str, Any]:
    name = entry.get("function", f"FUN_{va:08x}")
    result: dict[str, Any] = {
        "function": name,
        "va": va,
        "status": "rejected",
        "reasons": [],
        "region": gen.region_of(va),
        "code": {},
        "data_items": [],
        "contains_original_byte_values": False,
    }
    reasons: list[str] = result["reasons"]
    symbol = f"FUN_{va:08x}"
    if name != symbol:
        reasons.append(f"function name {name!r} does not match its VA {symbol}")
    source_path = (manifest_path.parent / entry["source"]).resolve()
    if manifest_path.parent.resolve() not in source_path.parents:
        reasons.append("source path leaves the manifest directory")
        return result
    try:
        source_bytes = source_path.read_bytes()
    except OSError as exc:
        reasons.append(f"source unreadable: {exc}")
        return result
    text = source_bytes.decode("utf-8", "strict")
    result["source"] = {"path": entry["source"], "sha256": sha256(source_bytes)}
    if entry.get("source_sha256") != result["source"]["sha256"]:
        reasons.append("source_sha256 in the manifest is stale")

    # --- expected split from the original -----------------------------------
    if layout is None:
        reasons.append("function is not in the index")
        return result
    if layout.exceptions:
        reasons.append(f"generator cannot split this span: {layout.exceptions[:3]}")
    if layout.exceptions:
        return result
    ending = getattr(layout, "ending", "")
    expected_code = {"rva": va - config.image_base, "size": layout.code_size}
    expected_items = [
        {"kind": item.kind, "rva": item.va - config.image_base, "size": item.size}
        for item in layout.data
    ]
    code = entry.get("code", {})
    if code.get("symbol") != symbol or code.get("rva") != expected_code["rva"] or code.get("size") != expected_code["size"]:
        reasons.append(
            f"manifest code part {code.get('rva')}/{code.get('size')} differs from the span split "
            f"{expected_code['rva']}/{expected_code['size']} (table or padding bytes counted as code?)"
        )
    got_items = [{"kind": i.get("kind"), "rva": i.get("rva"), "size": i.get("size")} for i in entry.get("data_items", [])]
    if got_items != expected_items:
        reasons.append("manifest data items differ from the span split of the original")
    original_hash = gen.code_hash(image, layout)
    if code.get("sha256") != original_hash:
        reasons.append("code sha256 in the manifest does not match the original extent")
    tile_end = layout.va + layout.code_size + sum(i.size for i in layout.data)
    if tile_end != layout.span_end:
        reasons.append("code part and data items do not tile the span")
    result["code"] = {"symbol": symbol, "rva": expected_code["rva"], "size": expected_code["size"], "sha256": original_hash}

    # --- lexical audit -------------------------------------------------------
    header_expect = {
        "va": f"0x{va:08x}",
        "sha256": original_hash,
        "region": gen.region_of(va),
        "extent": f"0x{va:08x}-0x{layout.code_end:08x} ({layout.code_size} code bytes)",
        "frame": "ebp" if gen.has_standard_frame(layout) else "none",
        "span": (
            f"0x{va:08x}-0x{layout.span_end:08x} (code {layout.code_size}, tables {layout.table_bytes}, "
            f"padding {layout.padding_bytes})"
        ),
        "evidence": entry.get("evidence_id", ""),
    }
    if ending:
        header_expect["ending"] = gen_fragments.ending_text(layout)
        result["ending"] = ending
    if (entry.get("ending") or "") != ending:
        reasons.append(f"manifest ending {entry.get('ending')!r} differs from the original's {ending!r}")
    if entry.get("evidence_id") != image.evidence.get(va):
        reasons.append("evidence_id in the manifest differs from function-index.json")
    index_owners = {f"IDXTAB_{i.va:08x}": i.owner_jmp for i in layout.data if i.kind == "index_table"}
    lexical, facts = audit_source(text, header_expect, symbol, config.allow_index_byte_lists, image.base, index_owners, config.names)
    reasons += lexical
    result["basic_blocks"] = facts.get("basic_blocks")
    result["annotation"] = facts.get("annotation", "hand")
    if facts.get("naming"):
        result["naming"] = facts["naming"]
    track = facts["header"].get("track-n", "")
    if config.repository and track and track != "host-adapter: none":
        match = re.match(r"^([\w./+-]+):([\w:~]+)", track)
        if match:
            target = (config.repository / match.group(1)).resolve()
            if config.repository.resolve() not in target.parents:
                reasons.append(f"track-n path {match.group(1)} leaves the repository")
            elif not target.is_file():
                reasons.append(f"track-n file {match.group(1)} does not exist")
            elif len(match.group(2)) < 6 or not re.search(
                r"(?<![\w])" + re.escape(match.group(2)) + r"(?![\w])", target.read_text(encoding="utf-8", errors="replace")
            ):
                reasons.append(f"track-n symbol {match.group(2)} is too short or not a whole word in {match.group(1)}")

    # --- reassemble with the pinned assembler ----------------------------------
    with tempfile.TemporaryDirectory(prefix="m03-audit-") as tmp:
        tmp_path = Path(tmp)
        object_path = tmp_path / f"{symbol}.obj"
        source_copy = tmp_path / f"{symbol}.s"
        source_copy.write_bytes(source_bytes)
        run = subprocess.run([str(config.assembler), "--32", "-o", str(object_path), str(source_copy)], capture_output=True, text=True)
        if run.returncode != 0:
            detail = " ".join(run.stderr.replace(str(tmp_path) + "/", "").split())
            reasons.append("pinned assembler rejected the source: " + detail[:300])
            return result
        object_bytes = object_path.read_bytes()
        result["object"] = {"sha256": sha256(object_bytes), "size": len(object_bytes)}
        try:
            text_bytes, relocations, symbols = gen.coff_text(object_bytes)
        except (ValueError, struct.error) as exc:  # pragma: no cover - defensive
            reasons.append(f"object unreadable: {exc}")
            return result
        result["relocations"] = relocations
        base = image.base
        want_len = layout.span_end - base
        if len(text_bytes) != (want_len + 3) & ~3 or set(text_bytes[want_len:]) - {0x00, 0x90}:
            reasons.append(
                f"object .text is {len(text_bytes)} bytes, expected the span end {want_len} plus section alignment only"
            )
        elif text_bytes[va - base : layout.span_end - base] != image.bytes_at(va, layout.span_end):
            reasons.append("object bytes over the whole span differ from the original")
        if any(text_bytes[: va - base]):
            reasons.append("object has non-zero bytes before the function")
        decode_problem = decode_code_part(object_path, va - base, layout.code_size, ending)
        if decode_problem:
            reasons.append(decode_problem)
        if relocations:
            reasons.append(f"object carries {relocations} relocation(s); every target must resolve at assembly time")
        supplied = entry.get("object")
        if supplied:
            supplied_path = (manifest_path.parent / supplied).resolve()
            if not supplied_path.is_file():
                reasons.append(f"supplied object {supplied} is missing")
            elif supplied_path.read_bytes() != object_bytes:
                reasons.append("supplied object is not the pinned assembler's output for this source")
        # symbol table must hold the code and data symbols at their original offsets
        verify_functions = [
            {"rva": expected_code["rva"], "size": expected_code["size"], "symbol": symbol, "object": str(object_path)}
        ]
        if symbols.get(symbol) != va - image.base:
            reasons.append(f"symbol {symbol} is not at its original section offset")
        for item, expected in zip(entry.get("data_items", []), expected_items):
            sym = item.get("symbol")
            prefix = {"switch_table": "SWTAB", "index_table": "IDXTAB", "padding": "PAD"}[expected["kind"]]
            if sym != f"{prefix}_{expected['rva'] + config.image_base:08x}":
                reasons.append(f"data symbol {sym!r} does not name its address")
                continue
            if not sym or sym not in symbols or symbols[sym] != expected["rva"] + config.image_base - image.base:
                reasons.append(f"data symbol {sym!r} is missing or misplaced")
                continue
            verify_functions.append({"rva": expected["rva"], "size": expected["size"], "symbol": sym, "object": str(object_path)})
        if len(verify_functions) != 1 + len(expected_items):
            return result
        verify_manifest = {
            "description": "M03 audit comparison (code part and data items separately)",
            "source": "audit_tool_assisted.py",
            "original_sha256": config.expected_sha256,
            "functions": verify_functions,
        }
        vm_path = tmp_path / "verify.json"
        vm_path.write_text(json.dumps(verify_manifest), encoding="utf-8")
        comparison = verifier.verify(config.original, vm_path)
        if comparison.get("error"):
            reasons.append(f"verify_matches error: {comparison['error']}")
        rows = comparison.get("functions", [])
        for row in rows:
            if row.get("status") != "exact-byte-range":
                where = "code part" if row.get("symbol") == symbol else f"data item {row.get('symbol')}"
                reasons.append(
                    f"{where} is {row.get('status')} ({len(row.get('differences', []))} differing byte(s); "
                    f"{row.get('error', '')})".strip()
                )
        result["compared_bytes"] = sum(r["size"] for r in rows if r.get("status") == "exact-byte-range")
        result["data_items"] = [
            {
                "kind": item["kind"],
                "symbol": entry["data_items"][i].get("symbol"),
                "rva": item["rva"],
                "size": item["size"],
                "sha256": hashlib.sha256(image.bytes_at(item["rva"] + config.image_base, item["rva"] + config.image_base + item["size"])).hexdigest(),
            }
            for i, item in enumerate(expected_items)
        ]
    if not reasons:
        result["status"] = "accepted"
    return result


def decode_code_part(object_path: Path, offset: int, size: int, ending: str = "") -> Optional[str]:
    """Independent plausibility check: the assembled code part decodes linearly to its last byte."""

    try:
        out = subprocess.run(
            gen.find_objdump() + ["-d", "--x86-asm-syntax=intel", f"--start-address={offset:#x}", f"--stop-address={offset + size:#x}", str(object_path)],
            capture_output=True, text=True, check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError) as exc:
        return f"llvm-objdump could not decode the code part: {exc}"
    cursor = offset
    last = ""
    for line in out.splitlines():
        match = gen._LINE.match(line)
        if not match:
            continue
        addr = int(match.group(1), 16)
        if addr != cursor:
            return f"code part does not decode contiguously at +0x{cursor - offset:x}"
        body = match.group(3).split("#")[0].strip()
        mnem = body.split("\t")[0].strip()
        if mnem in ("<unknown>", "(bad)") or mnem.startswith("."):
            return f"code part contains an undecodable instruction at +0x{addr - offset:x}"
        cursor += len(match.group(2).split())
        last = mnem
    if cursor != offset + size:
        return "code part does not decode to its last byte"
    if last not in _TERMINAL and last != "call" and ending != "fall-through":
        return f"code part decodes to a last instruction {last!r}, not a terminal ret/jmp"
    return None


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--original", type=Path, default=WORK / "original/GAME.EXE")
    parser.add_argument("--report", type=Path)
    parser.add_argument("--names", type=Path, default=fnames.NAMES,
                        help="function names table (default asm/function-names.json; a missing file means no recorded names)")
    args = parser.parse_args(argv)
    names = fnames.load(args.names) if args.names.is_file() else None
    if names:
        # the table must be supported by the committed evidence, or an invented name would pass the header comparison
        problems = fnames.check(args.names)
        if problems:
            print("function names table is not supported by the evidence:", *problems[:10], sep="\n  ")
            return 1
    config = AuditConfig(original=args.original, names=names, names_path=args.names if names else None)
    report = audit_manifest(args.manifest, config)
    encoded = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(encoded, encoding="utf-8")
    rejected = [f for f in report["functions"] if f["status"] != "accepted"]
    print(
        f"M03 audit: {report.get('accepted_count', 0)}/{len(report['functions'])} accepted, "
        f"{report.get('code_bytes_accepted', 0)} code bytes; errors={report['errors']}"
    )
    for f in rejected:
        print(f"  REJECTED {f['function']}: {f['reasons'][:4]}")
    return 0 if report["all_accepted"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
