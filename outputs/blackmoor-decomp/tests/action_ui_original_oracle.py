#!/usr/bin/env python3
"""Compare bounded phone/control state mutations with original GAME.EXE x86.

The harness enters original direct handlers 0x4e7253 and 0x4e13e4 under
Unicorn. For control cases it calls the real 0x4e1a7e initializer first.
Only the handlers and their real in-image lookup/sort/UI helpers execute; the
ASCII normalizer is selected with its original global set to zero, and debug
printing is disabled. This is selected state-family evidence, not a scene
scheduler, UI renderer, or full-game equivalence claim.

Run from the workspace root with:

    work/tools/oracle-python/bin/python \
      outputs/blackmoor-decomp/tests/action_ui_original_oracle.py
"""

from __future__ import annotations

import argparse
import ctypes as c
from dataclasses import dataclass
import hashlib
import json
import struct
import sys
from pathlib import Path
from typing import Any, Iterable

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up
from test_action_ui import (
    ActionUIWorld,
    ControlGroup,
    PHONE_SIZE,
    bytes_buffer,
    control,
    phone,
)


ROOT = Path(__file__).resolve().parents[3]
PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_EXE = ROOT / "work/original/GAME.EXE"
DEFAULT_NATIVE = PROJECT / "build/libactionui.dylib"
DEFAULT_REPORT = ROOT / "work/analysis/action-ui-validation.json"

PHONE_HANDLER_VA = 0x4E7253
CONTROL_HANDLER_VA = 0x4E13E4
CONTROL_INITIALIZER_VA = 0x4E1A7E
ACTION_PAYLOAD_POINTER_VA = 0x5BB5E5
PHONE_COUNT_VA = 0x5A1E5C
PHONE_RECORDS_VA = 0x5A1E62
CONTROL_GROUPS_VA = 0x5A1620
CONTROL_GROUP_SIZE = 0x1A4
CONTROL_GROUP_BYTES = CONTROL_GROUP_SIZE * 5
NLS_MODE_VA = 0x63CB1C
DEBUG_LOG_VA = 0x63A4CD
OWNER_ECX = 0x570508

STACK_BASE = 0x10000000
STACK_SIZE = 0x10000
STACK_TOP = STACK_BASE + STACK_SIZE - 0x100
BODY_BASE = 0x20000000
BODY_SIZE = 0x10000
RETURN_SENTINEL = 0x30000000


class OracleFailure(RuntimeError):
    pass


@dataclass(frozen=True)
class UICase:
    label: str
    action_type: int
    body: bytes
    phone_rows: tuple[bytes, ...] = ()
    control_seed: bytes | None = None


def control_seed_bytes(
    *,
    group_index: int = 0,
    state: int = 0,
    ranges: tuple[tuple[int, int, int], ...] = (),
) -> bytes:
    groups = (ControlGroup * 5)()
    for group in groups:
        group.state = 0
        group.availability = 0
        for index in range(3):
            group.flags[index] = 0
        for index in range(50):
            group.starts[index] = 9999
            group.ends[index] = 9999
            group.codes[index] = 13
    group = groups[group_index]
    group.state = state
    for index, (start, end, code_value) in enumerate(ranges):
        group.starts[index] = start
        group.ends[index] = end
        group.codes[index] = code_value
    return c.string_at(c.addressof(groups), c.sizeof(groups))


def full_control_seed() -> bytes:
    groups = (ControlGroup * 5)()
    for group in groups:
        group.state = 0
        group.availability = 0
        for flag in range(3):
            group.flags[flag] = 0
        for index in range(50):
            group.starts[index] = index
            group.ends[index] = index + 100
            group.codes[index] = 1000 + index
    return c.string_at(c.addressof(groups), c.sizeof(groups))


def cases() -> Iterable[UICase]:
    yield UICase("phone-insert", 0x82,
                 phone(b"z" * 11, "Zulu", tail=b"\xa1" * 8),
                 (phone(b"a" * 11, "Existing", tail=b"\x91" * 8),))
    yield UICase("phone-sort-ascii", 0x82,
                 phone(b"a" * 11, "amy", tail=b"\xb2" * 8),
                 (phone(b"z" * 11, "Zoe", tail=b"\xc3" * 8),))
    yield UICase("phone-duplicate-replace-and-sort", 0x82,
                 phone(b"k" * 11, "Mira", tail=b"\xd4" * 8,
                       prefix=b"\xee\xff"),
                 (phone(b"k" * 11, "Old", tail=b"\x14" * 8),
                  phone(b"x" * 11, "Other", tail=b"\x25" * 8)))
    yield UICase("phone-casefold-tie-keeps-order", 0x82,
                 phone(b"2" * 11, "Alice"),
                 (phone(b"1" * 11, "alice"),))
    yield UICase("phone-sort-restarts-after-one-swap-per-pass", 0x82,
                 phone(b"a" * 11, "Alpha"),
                 (phone(b"z" * 11, "Zulu"), phone(b"m" * 11, "Mike"),
                  phone(b"e" * 11, "Echo")))

    yield UICase("control-insert", 0x1D, control(3, 13, 1, -10, 37))
    yield UICase("control-duplicate-noop", 0x1D, control(2, 57, 1, 4, 9),
                 control_seed=control_seed_bytes(
                     group_index=2, ranges=((4, 9, 13),)))
    yield UICase("control-remove-range", 0x1D, control(1, 0, 0, 4, 9),
                 control_seed=control_seed_bytes(
                     group_index=1, ranges=((4, 9, 22), (10, 11, 23))))
    yield UICase("control-full-table-drop-first", 0x1D,
                 control(0, 42, 1, -7, 8), control_seed=full_control_seed())

    for label, before, mode, start, end in (
        ("control-mode1-enable", 0, 1, 9995, 0),
        ("control-mode1-disable", 1, 1, 1, 9996),
        ("control-mode0-state2", 0, 0, 0, 9997),
        ("control-mode0-state0", 2, 0, 9998, 0),
    ):
        yield UICase(label, 0x1D, control(4, 13, mode, start, end),
                     control_seed=control_seed_bytes(group_index=4, state=before))


def make_unicorn(pe: PEImage):
    try:
        from unicorn import UC_ARCH_X86, UC_MODE_32, Uc
    except ImportError as exc:
        raise OracleFailure("Unicorn 2.x required; use work/tools/oracle-python/bin/python") from exc
    from unicorn.x86_const import (
        UC_X86_REG_EBP,
        UC_X86_REG_ECX,
        UC_X86_REG_EFLAGS,
        UC_X86_REG_EIP,
        UC_X86_REG_ESP,
    )

    uc = Uc(UC_ARCH_X86, UC_MODE_32)
    uc.mem_map(pe.image_base, align_up(pe.size_of_image))
    uc.mem_write(pe.image_base, pe.image)
    uc.mem_map(STACK_BASE, STACK_SIZE)
    uc.mem_map(BODY_BASE, BODY_SIZE)
    uc.mem_map(RETURN_SENTINEL, 0x1000)
    uc.mem_write(RETURN_SENTINEL, b"\xCC")
    regs = (UC_X86_REG_EBP, UC_X86_REG_ECX, UC_X86_REG_EFLAGS,
            UC_X86_REG_EIP, UC_X86_REG_ESP)

    def invoke(entry: int, *, argument: int | None = None, ecx: int = OWNER_ECX) -> None:
        if argument is None:
            initial_esp = STACK_TOP - 4
            uc.mem_write(initial_esp, struct.pack("<I", RETURN_SENTINEL))
            expected_esp = STACK_TOP
        else:
            initial_esp = STACK_TOP - 8
            uc.mem_write(initial_esp, struct.pack("<II", RETURN_SENTINEL,
                                                  argument & 0xFFFFFFFF))
            # These handlers pop their short argument before returning.
            expected_esp = STACK_TOP
        uc.reg_write(UC_X86_REG_ESP, initial_esp)
        uc.reg_write(UC_X86_REG_EBP, 0)
        uc.reg_write(UC_X86_REG_ECX, ecx)
        uc.reg_write(UC_X86_REG_EFLAGS, 0x202)
        uc.reg_write(UC_X86_REG_EIP, entry)
        try:
            uc.emu_start(entry, RETURN_SENTINEL, timeout=10_000_000,
                         count=1_000_000)
        except Exception as exc:
            raise OracleFailure(f"original entry 0x{entry:x} trapped: {exc}") from exc
        eip = uc.reg_read(UC_X86_REG_EIP)
        esp = uc.reg_read(UC_X86_REG_ESP)
        if eip != RETURN_SENTINEL or esp != expected_esp:
            raise OracleFailure(
                f"original entry 0x{entry:x} returned unexpectedly: "
                f"EIP=0x{eip:08x}, ESP=0x{esp:08x}, expected ESP=0x{expected_esp:08x}"
            )

    return uc, invoke, regs


class OriginalUIOracle:
    def __init__(self, pe: PEImage):
        self.uc, self.invoke, self.regs = make_unicorn(pe)
        self.uc.mem_write(DEBUG_LOG_VA, b"\0")
        self.uc.mem_write(NLS_MODE_VA, b"\0")

    def run(self, case: UICase) -> dict[str, Any]:
        uc = self.uc
        self.invoke(CONTROL_INITIALIZER_VA)
        uc.mem_write(PHONE_COUNT_VA, struct.pack("<h", len(case.phone_rows)))
        for row, record in enumerate(case.phone_rows):
            if len(record) != PHONE_SIZE:
                raise OracleFailure("phone seed row is not 41 bytes")
            uc.mem_write(PHONE_RECORDS_VA + row * PHONE_SIZE, record)
        if case.control_seed is not None:
            if len(case.control_seed) != CONTROL_GROUP_BYTES:
                raise OracleFailure("control seed has an unexpected group-array size")
            uc.mem_write(CONTROL_GROUPS_VA, case.control_seed)

        body_address = BODY_BASE + 0x100
        uc.mem_write(body_address, case.body)
        uc.mem_write(ACTION_PAYLOAD_POINTER_VA, struct.pack("<I", body_address))
        if case.action_type == 0x82:
            self.invoke(PHONE_HANDLER_VA, argument=0)
        elif case.action_type == 0x1D:
            self.invoke(CONTROL_HANDLER_VA, argument=0, ecx=OWNER_ECX)
        else:
            raise OracleFailure(f"unexpected UI action type 0x{case.action_type:02x}")

        phone_count = struct.unpack("<h", uc.mem_read(PHONE_COUNT_VA, 2))[0]
        if phone_count < 0 or phone_count > 32:
            raise OracleFailure(f"original phone count escaped fixture bound: {phone_count}")
        return {
            "phone_count": phone_count,
            "phone_rows": [uc.mem_read(PHONE_RECORDS_VA + row * PHONE_SIZE,
                                       PHONE_SIZE).hex()
                           for row in range(phone_count)],
            "control_bytes": bytes(uc.mem_read(CONTROL_GROUPS_VA,
                                               CONTROL_GROUP_BYTES)),
        }


def bind_native(path: Path):
    library = c.CDLL(str(path.resolve()))
    library.action_ui_initialize_controls.argtypes = [c.POINTER(ActionUIWorld)]
    library.action_ui_initialize_controls.restype = c.c_int
    library.action_ui_apply_phone.argtypes = [
        c.POINTER(ActionUIWorld), c.POINTER(c.c_uint8), c.c_size_t
    ]
    library.action_ui_apply_phone.restype = c.c_int
    library.action_ui_apply_control.argtypes = [
        c.POINTER(ActionUIWorld), c.POINTER(c.c_uint8), c.c_size_t
    ]
    library.action_ui_apply_control.restype = c.c_int
    return library


def run_native(library: c.CDLL, case: UICase) -> dict[str, Any]:
    capacity = max(8, len(case.phone_rows) + (1 if case.action_type == 0x82 else 0))
    records = ((c.c_uint8 * PHONE_SIZE) * capacity)()
    world = ActionUIWorld()
    world.phone_records = c.cast(records, c.POINTER(c.c_uint8 * PHONE_SIZE))
    world.phone_capacity = capacity
    if library.action_ui_initialize_controls(c.byref(world)) != 0:
        raise OracleFailure("native control initializer failed")
    for row, record in enumerate(case.phone_rows):
        records[row][:] = record
    world.phone_count = len(case.phone_rows)
    if case.control_seed is not None:
        if len(case.control_seed) != CONTROL_GROUP_BYTES:
            raise OracleFailure("native control seed has unexpected size")
        c.memmove(c.addressof(world.controls), case.control_seed, CONTROL_GROUP_BYTES)

    body = bytes_buffer(case.body)
    if case.action_type == 0x82:
        status = library.action_ui_apply_phone(c.byref(world), body, len(case.body))
    elif case.action_type == 0x1D:
        status = library.action_ui_apply_control(c.byref(world), body, len(case.body))
    else:
        raise OracleFailure(f"unexpected native UI action type 0x{case.action_type:02x}")
    if status != 0:
        raise OracleFailure(f"native handler returned status {status} for {case.label}")
    return {
        "phone_count": world.phone_count,
        "phone_rows": [bytes(records[row]).hex() for row in range(world.phone_count)],
        "control_bytes": c.string_at(c.addressof(world.controls), CONTROL_GROUP_BYTES),
    }


def function_hash(pe: PEImage, start: int, end_exclusive: int) -> str:
    offset = pe.va_to_file_offset(start, end_exclusive - start)
    return hashlib.sha256(pe.data[offset:offset + end_exclusive - start]).hexdigest()


def run(args: argparse.Namespace) -> dict[str, Any]:
    if not args.exe.is_file():
        raise OracleFailure(f"original GAME.EXE unavailable: {args.exe}")
    if not args.native_library.is_file():
        raise OracleFailure(f"native library unavailable: {args.native_library}")
    pe = PEImage.parse_and_map(args.exe)
    original_hash = hashlib.sha256(pe.data).hexdigest()
    if original_hash != EXPECTED_EXE_SHA256:
        raise OracleFailure(f"GAME.EXE SHA-256 mismatch: {original_hash}")
    native_path = args.native_library.resolve()
    library = bind_native(native_path)
    oracle = OriginalUIOracle(pe)
    results: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []
    for case in cases():
        original = oracle.run(case)
        native = run_native(library, case)
        if original["phone_count"] != native["phone_count"] or \
                original["phone_rows"] != native["phone_rows"] or \
                original["control_bytes"] != native["control_bytes"]:
            mismatches.append({
                "case": case.label,
                "type": f"0x{case.action_type:02x}",
                "body_hex": case.body.hex(),
                "original_phone_count": original["phone_count"],
                "native_phone_count": native["phone_count"],
                "original_phone_rows": original["phone_rows"],
                "native_phone_rows": native["phone_rows"],
                "original_control_sha256": hashlib.sha256(
                    original["control_bytes"]).hexdigest(),
                "native_control_sha256": hashlib.sha256(
                    native["control_bytes"]).hexdigest(),
            })
        results.append({
            "case": case.label,
            "type": f"0x{case.action_type:02x}",
            "body_hex": case.body.hex(),
            "phone_rows_compared": original["phone_count"],
            "control_array_sha256": hashlib.sha256(
                original["control_bytes"]).hexdigest(),
        })

    code_ranges = [
        {
            "name": "0x4e7253 direct phone handler",
            "start": "0x4e7253",
            "end_exclusive": "0x4e72f9",
            "sha256": function_hash(pe, PHONE_HANDLER_VA, 0x4E72F9),
            "boundary_basis": "static trace anchor",
        },
        {
            "name": "0x4e13e4 control-handler code window",
            "start": "0x4e13e4",
            "end_exclusive": "0x4e18e5",
            "sha256": function_hash(pe, CONTROL_HANDLER_VA, 0x4E18E5),
            "boundary_basis": "window ends at next traced consumer; exact handler end was not recovered",
        },
        {
            "name": "0x4e1a7e control initializer",
            "start": "0x4e1a7e",
            "end_exclusive": "0x4e1b79",
            "sha256": function_hash(pe, CONTROL_INITIALIZER_VA, 0x4E1B79),
            "boundary_basis": "next traced function entry",
        },
    ]
    report = {
        "scope": "bounded 0x82 phone/contact and generic 0x1d control-state handlers; not a full scene or game comparison",
        "original_sha256": original_hash,
        "native_library_sha256": hashlib.sha256(native_path.read_bytes()).hexdigest(),
        "original_execution": "direct original GAME.EXE PE32 x86 handler entries under Unicorn 2.1.4",
        "native_execution": "ARM64 macOS C shared library",
        "code_ranges": code_ranges,
        "original_paths_left_real": [
            "0x4e7253 phone body lookup, full-row update/append, sort, and UI-bit helper",
            "0x4e45be exact 11-byte phone-key lookup",
            "0x4e3ade adjacent phone sort and 0x50d0bc ASCII normalization branch",
            "0x4e0559 group-3 availability/subflag update",
            "0x4e13e4 generic (code != 1) control handler",
            "0x4e1a7e five-group/50-slot control initialization",
        ],
        "controlled_globals": {
            "0x63cb1c": "zero to select original ASCII normalization branch",
            "0x63a4cd": "zero to exclude debug-print side effects on full range table",
            "ECX": "0x570508 owner fixture for the control handler's loop scratch field",
        },
        "compared_cases": len(results),
        "cases": results,
        "mismatches": mismatches,
        "native_invalid_input_policy": "phone capacity/name/table and control group bounds are validated before mutation; original table capacity is not established",
        "excluded": [
            "control code 1 immediate UI-mode branch (returns explicit native UNSUPPORTED without mutation)",
            "nonzero NLS/locale phone-name normalization (native returns explicit UNSUPPORTED)",
            "debug printing, phone-table overflow behavior, rendering, input handling, and full UI behavior",
            "scene scheduling, dependency evaluation, and direct completion-byte behavior in the outer dispatcher",
        ],
        "limitations": [
            "original phone-table capacity is unproven; oracle cases keep the table in a small bounded fixture",
            "empty-table lookup's decompiled comparison local is uninitialized when the original count is zero, so oracle insert cases seed a nonmatching row and do not claim empty-table insertion behavior",
            "control handler exact function end was not recovered; reported control range hash is an enclosing code window",
            "generic control code values are retained as observed bytes; code 13 user-facing meaning is unresolved",
            "native table count/capacity represents caller-owned storage and does not claim the original table was dynamically sized",
        ],
    }
    if mismatches:
        raise OracleFailure(json.dumps(report, indent=2))
    return report


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Action UI original-code validation",
        "",
        report["scope"],
        "",
        f"Original `GAME.EXE` SHA-256: `{report['original_sha256']}`.",
        f"Native library SHA-256: `{report['native_library_sha256']}`.",
        f"Compared cases: {report['compared_cases']}; mismatches: {len(report['mismatches'])}.",
        "",
        "The original x86 handler entries ran under Unicorn 2.1.4. Phone lookup, sorting, ASCII normalization, UI update, control handling, and the control initializer remained original code. The native implementation matched the compared phone rows and all five serialized control groups for each fixture.",
        "",
        "## Excluded paths and limits",
        "",
    ]
    lines.extend(f"- {item}." for item in report["excluded"])
    lines.extend(["", "## Limitations", ""])
    lines.extend(f"- {item}." for item in report["limitations"])
    lines.extend(["", "## Compared cases", ""])
    lines.extend(f"- `{item['case']}` (`{item['type']}`), body `{item['body_hex']}`" for item in report["cases"])
    lines.extend(["", "## Code hashes", ""])
    for item in report["code_ranges"]:
        lines.append(
            f"- `{item['start']}..{item['end_exclusive']}` {item['name']}: "
            f"`{item['sha256']}` ({item['boundary_basis']})."
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=DEFAULT_EXE)
    parser.add_argument("--native-library", type=Path, default=DEFAULT_NATIVE)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--markdown-report", type=Path,
                        default=ROOT / "work/analysis/action-ui-validation.md")
    args = parser.parse_args()
    try:
        report = run(args)
    except (OracleFailure, OSError, ValueError) as exc:
        print(str(exc), file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.markdown_report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    args.markdown_report.write_text(render_markdown(report), encoding="utf-8")
    print(f"Validated {report['compared_cases']} original x86 UI cases.")
    print(f"Wrote {args.report}")
    print(f"Wrote {args.markdown_report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
