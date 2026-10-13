#!/usr/bin/env python3
"""Compare supported dependency leaves with original x86 function 0x424346.

This maps the identified GAME.EXE PE image and calls the integer-only leaf
evaluator directly. It does not run the game, Windows APIs, or ScummVM. The
comparison covers leaf opcodes 0 through 6 and 9; nested record construction is
separately traced from loader 0x424aa8 and exercised by native structure tests.
"""

import argparse
import ctypes as c
import hashlib
import json
from pathlib import Path
import random
import struct

from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, align_up


class SceneDependencyInfo(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("or_after", c.c_int16),
        ("raw_bytes", c.POINTER(c.c_uint8)),
        ("fields", c.c_int16 * 8),
    ]


class SceneConditionState(c.Structure):
    _fields_ = [
        ("inventory_presence", c.POINTER(c.c_int32)),
        ("inventory_count", c.c_size_t),
        ("selected_inventory_item", c.c_int32),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
        ("value_table", c.POINTER(c.c_int32)),
        ("value_count", c.c_size_t),
        ("scene_visit_counts", c.POINTER(c.c_int16)),
        ("scene_visit_count", c.c_size_t),
        ("timer_4_value", c.c_int32),
        ("timer_5_value", c.c_int32),
        ("time_of_day_minutes", c.c_int32),
    ]


def signed32(value):
    value &= 0xffffffff
    return value if value < 0x80000000 else value - 0x100000000


def milliseconds(fields):
    return signed32(fields[0] * 3600000 + fields[1] * 60000 +
                    fields[2] * 1000 + fields[3])


def minutes(first, second):
    return signed32(first * 60 + second)


def c_array(ctype, values, minimum_size=0):
    values = list(values)
    values.extend([0] * max(0, minimum_size - len(values)))
    return (ctype * len(values))(*values)


def make_case(opcode, index=0, condition=0, time_fields=(0, 0, 0, 0),
              inventory=None, selected=-1, flags=None, values=None,
              visits=None, timer4=0, timer5=0, clock=0, or_after=0, initial_status=0):
    inventory = list(inventory or [])
    flags = list(flags or [])
    values = list(values or [])
    visits = list(visits or [])
    inventory_array = c_array(c.c_int32, inventory, max(index + 1, 0))
    flags_array = c_array(c.c_int32, flags, max(index + 1, 0))
    values_array = c_array(c.c_int32, values, max(index + 1, 0))
    visit_index = time_fields[0] if opcode == 9 else 0
    visits_array = c_array(c.c_int16, visits, max(visit_index + 1, 0))
    record = SceneDependencyInfo()
    record.opcode = opcode
    record.or_after = or_after
    record.fields[:] = (opcode, index, condition, or_after, *time_fields)
    state = SceneConditionState(
        inventory_array, len(inventory_array), selected,
        flags_array, len(flags_array), values_array, len(values_array),
        visits_array, len(visits_array), timer4, timer5, clock
    )

    node = bytearray(0x60)
    struct.pack_into("<i", node, 4, initial_status)
    struct.pack_into("<hhh", node, 0x10, opcode, index, condition)
    struct.pack_into("<h", node, 0x16, or_after)
    struct.pack_into("<4h", node, 0x18, *time_fields)
    if opcode in (4, 5):
        struct.pack_into("<i", node, 0x20, milliseconds(time_fields))
    elif opcode == 6:
        if condition == 3:
            struct.pack_into("<i", node, 0x24, minutes(time_fields[0], time_fields[1]))
            struct.pack_into("<i", node, 0x28, minutes(time_fields[2], time_fields[3]))
        else:
            struct.pack_into("<i", node, 0x20, minutes(time_fields[0], time_fields[1]))
    return record, state, node, (inventory_array, flags_array, values_array, visits_array)


def make_original_machine(executable):
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_32

    pe = PEImage.parse_and_map(executable)
    digest = hashlib.sha256(pe.data).hexdigest()
    if digest != EXPECTED_EXE_SHA256:
        raise ValueError("Original executable identity mismatch")
    machine = Uc(UC_ARCH_X86, UC_MODE_32)
    machine.mem_map(pe.image_base, align_up(pe.size_of_image))
    machine.mem_write(pe.image_base, pe.image)
    machine.mem_map(0x10000000, 0x10000)
    machine.mem_map(0x20000000, 0x40000)
    machine.mem_map(0x30000000, 0x1000)
    return pe, machine, digest


def invoke_original(machine, node_bytes, globals_state):
    from unicorn.x86_const import (
        UC_X86_REG_EBP, UC_X86_REG_ECX, UC_X86_REG_EFLAGS,
        UC_X86_REG_EIP, UC_X86_REG_ESP,
    )

    node = 0x20010000
    stack = 0x10008000
    sentinel = 0x30000000
    machine.mem_write(node, bytes(node_bytes))
    machine.mem_write(stack, struct.pack("<II", sentinel, node))
    machine.mem_write(0x00583bd5, struct.pack("<" + "i" * len(globals_state["inventory"]),
                                               *globals_state["inventory"]))
    machine.mem_write(0x00583a29, struct.pack("<i", globals_state["selected"]))
    machine.mem_write(0x00585801, struct.pack("<" + "i" * len(globals_state["flags"]),
                                               *globals_state["flags"]))
    machine.mem_write(0x00581a71, struct.pack("<" + "i" * len(globals_state["values"]),
                                               *globals_state["values"]))
    machine.mem_write(0x00587b2d, struct.pack("<" + "h" * len(globals_state["visits"]),
                                               *globals_state["visits"]))
    machine.mem_write(0x00585d37, struct.pack("<i", globals_state["timer4"]))
    machine.mem_write(0x00585d41, struct.pack("<i", globals_state["timer5"]))
    machine.mem_write(0x00585d4b, struct.pack("<i", globals_state["clock"]))
    machine.reg_write(UC_X86_REG_ESP, stack)
    machine.reg_write(UC_X86_REG_EBP, 0)
    machine.reg_write(UC_X86_REG_ECX, 0)
    machine.reg_write(UC_X86_REG_EFLAGS, 0x202)
    machine.emu_start(0x424346, sentinel, timeout=5_000_000, count=1_000_000)
    if machine.reg_read(UC_X86_REG_EIP) != sentinel or machine.reg_read(UC_X86_REG_ESP) != stack + 8:
        raise AssertionError(
            "Original leaf evaluator did not return normally: "
            f"EIP=0x{machine.reg_read(UC_X86_REG_EIP):x}, "
            f"ESP=0x{machine.reg_read(UC_X86_REG_ESP):x}"
        )
    return struct.unpack("<i", machine.mem_read(node + 4, 4))[0]


def invoke_native(library, record, state):
    tree = c.c_void_p()
    status = library.scene_conditions_build(c.byref(record), 1, c.byref(tree))
    if status != 0:
        raise AssertionError(f"Native tree build failed: status={status}")
    try:
        output = c.c_int(-1)
        unsupported = c.c_uint16(0)
        status = library.scene_conditions_evaluate(tree, c.byref(state),
                                                   c.byref(output), c.byref(unsupported))
        if status != 0:
            raise AssertionError(f"Native evaluation failed: status={status}, opcode={unsupported.value}")
        return output.value
    finally:
        library.scene_conditions_destroy(tree)


def cases():
    fixed = [
        make_case(0),
        make_case(1, index=2, condition=1, inventory=[0, 0, 0], selected=2),
        make_case(1, index=2, condition=0, inventory=[0, 0, 0], selected=2),
        make_case(1, index=1, condition=1, inventory=[0, 1, 0]),
        make_case(2, index=1, condition=-7, flags=[0, -7]),
        make_case(3, index=2, condition=4, values=[0, 0, 4]),
        make_case(4, time_fields=(1, 2, 3, 4), timer4=3_723_004),
        make_case(5, time_fields=(-1, 0, 0, 0), timer5=-3_600_000),
        make_case(6, condition=0, time_fields=(8, 30, 0, 0), clock=510),
        make_case(6, condition=1, time_fields=(8, 30, 0, 0), clock=511),
        make_case(6, condition=2, time_fields=(8, 30, 0, 0), clock=510),
        make_case(6, condition=3, time_fields=(8, 30, 17, 0), clock=720),
        make_case(6, condition=3, time_fields=(22, 0, 2, 0), clock=1380),
        make_case(6, condition=3, time_fields=(22, 0, 2, 0), clock=720),
        make_case(9, time_fields=(6400, 1, 0, 1), visits=[0] * 6401),
        make_case(9, time_fields=(6400, 1, 0, 1), visits=[0] * 6400 + [1]),
        make_case(9, time_fields=(6400, 2, 0, 2), visits=[0] * 6400 + [3]),
        make_case(9, time_fields=(6400, 2, 0, 3), visits=[0] * 6400 + [2]),
    ]
    yield from ((case, "fixed-boundary") for case in fixed)

    rng = random.Random(20261013)
    for opcode in (0, 1, 2, 3, 4, 5, 6, 9):
        for _ in range(96):
            index = rng.randrange(8)
            fields = tuple(rng.choice((-32768, -1500, -1, 0, 1, 500, 32767))
                           for _ in range(4))
            if opcode == 0:
                case = make_case(0, initial_status=rng.choice((-7, 0, 2)))
            elif opcode == 1:
                case = make_case(1, index=index, condition=rng.choice((-1, 0, 1, 2)),
                                 inventory=[rng.choice((0, 1, 2)) for _ in range(8)],
                                 selected=rng.randrange(-1, 8))
            elif opcode == 2:
                case = make_case(2, index=index,
                                 condition=rng.choice((-32768, -7, 0, 1, 32767)),
                                 flags=[rng.choice((-2147483648, -7, 0, 1, 2147483647))
                                        for _ in range(8)])
            elif opcode == 3:
                case = make_case(3, index=index,
                                 condition=rng.choice((-32768, -7, 0, 1, 32767)),
                                 values=[rng.choice((-2147483648, -7, 0, 1, 2147483647))
                                         for _ in range(8)])
            elif opcode in (4, 5):
                case = make_case(opcode, time_fields=fields,
                                 timer4=rng.randrange(-2147483648, 2147483648),
                                 timer5=rng.randrange(-2147483648, 2147483648))
            elif opcode == 6:
                case = make_case(6, condition=rng.randrange(4), time_fields=fields,
                                 clock=rng.randrange(-20, 1480))
            else:
                visit_index = rng.randrange(16)
                case = make_case(9, time_fields=(visit_index, rng.randrange(-32768, 32768),
                                                 0, rng.randrange(1, 4)),
                                 visits=[rng.randrange(-32768, 32768) for _ in range(16)])
            yield case, "seeded-opcode-random"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path,
                        default=Path(__file__).resolve().parents[3] / "work/original/GAME.EXE")
    parser.add_argument("--native-library", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()

    pe, machine, exe_hash = make_original_machine(args.exe)
    library = c.CDLL(str(args.native_library.resolve()))
    library.scene_conditions_build.argtypes = [
        c.POINTER(SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)
    ]
    library.scene_conditions_build.restype = c.c_int
    library.scene_conditions_destroy.argtypes = [c.c_void_p]
    library.scene_conditions_evaluate.argtypes = [
        c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(c.c_int),
        c.POINTER(c.c_uint16)
    ]
    library.scene_conditions_evaluate.restype = c.c_int

    compared = 0
    mismatches = []
    results_hash = hashlib.sha256()
    by_opcode = {str(opcode): 0 for opcode in (0, 1, 2, 3, 4, 5, 6, 9)}
    for (record, state, node, arrays), label in cases():
        globals_state = {
            "inventory": list(arrays[0]),
            "selected": state.selected_inventory_item,
            "flags": list(arrays[1]),
            "values": list(arrays[2]),
            "visits": list(arrays[3]),
            "timer4": state.timer_4_value,
            "timer5": state.timer_5_value,
            "clock": state.time_of_day_minutes,
        }
        original = invoke_original(machine, node, globals_state)
        native = invoke_native(library, record, state)
        compared += 1
        by_opcode[str(record.opcode)] += 1
        results_hash.update(struct.pack("<Hii", record.opcode, original, native))
        if original != native:
            mismatches.append({"case": compared, "group": label, "opcode": record.opcode,
                               "original": original, "native": native})
            if len(mismatches) >= 20:
                break

    code_offset = pe.va_to_file_offset(0x424346, 0x424aa8 - 0x424346)
    report = {
        "scope": "original leaf evaluator 0x424346 for opcodes 0..6 and 9; nested loader 0x424aa8 is not executed here",
        "original_sha256": exe_hash,
        "function_va": "0x424346",
        "code_sha256": hashlib.sha256(pe.data[code_offset:code_offset + (0x424aa8 - 0x424346)]).hexdigest(),
        "native_library_sha256": hashlib.sha256(args.native_library.read_bytes()).hexdigest(),
        "compared_leaves": compared,
        "by_opcode": by_opcode,
        "mismatches": mismatches,
        "result_digest": results_hash.hexdigest(),
        "grouping_evidence": {
            "loader_va": "0x424aa8",
            "open_record": "0x12 adds a kind-1 branch child and descends into it",
            "close_record": "0x13 returns to the parent after matching opener/closer OR markers normalized by ==1",
            "operator_scope": "0x42406d reduces only the current branch's linked child siblings",
            "validation": "native tests cover nested groups, close-marker mismatch, and empty groups",
        },
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({key: value for key, value in report.items()
                      if key not in ("grouping_evidence", "mismatches")}))
    if mismatches:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
