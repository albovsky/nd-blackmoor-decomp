#!/usr/bin/env python3
"""RT-11.1 original-x86 oracle for the completed-channel restart.

Runs the pinned GAME.EXE's own sound pump 0x4f52a9 (which drains the stop
notifications and calls the channel update 0x4f55d5, then the delayed-repeat
pass 0x4f7207, the scan 0x4f572b and the fade passes 0x4f79ce / 0x4f842f), the
Play wrapper 0x4f6059 and the Stop wrapper 0x4f61e7 under Unicorn, and drives
the native live_audio provider through the identical scripted scenario. After
every step the ordered effects (Play calls, CRT rand draws) and the update
state (marker, delay, due tick, stop gate, loaded, playing) must agree.

Hooks (OS and host boundaries only; no decision of the original is replaced):
  0x52a23c  GetTickCount            -> scripted tick
  0x52a250  WaitForMultipleObjects  -> the queued stop-notification indices
                                       (lowest first, auto-reset), then WAIT_TIMEOUT
  0x50cd50  CRT rand                -> scripted value
  vtable +0x30 DirectSound Play     -> recorded, HRESULT 0
  vtable +0x48 DirectSound Stop     -> recorded
Everything else (gates, flag tests, the fade-engine passes' skip conditions,
modulo and 32-bit tick arithmetic, the Play-flag selection) is original x86.

Environment emulation (not original code, labelled in the report): `unload`
calls the original Stop wrapper for a playing channel, queues its stop
notification and then clears slot+0x162/+0x28f as the original unload does;
the original unload 0x4f356e itself (COM release, heap frees) is not run.
The stream-class decision (`cmp [slot+0x15e], 0x56220; jle` at 0x4f3b49) is
static evidence plus the HIS header bytes, not an executed comparison: the
HIS loader 0x4f379c performs file I/O and is not isolable.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
import subprocess
import sys
import tempfile
from collections import Counter
from pathlib import Path
from typing import Any

import sound_control_original_oracle as base
from cif_original_oracle import EXPECTED_EXE_SHA256, PEImage, sha256

ROOT = base.ROOT
PROJECT = base.PROJECT
DEFAULT_REPORT = ROOT / "work/analysis/slices/RT-11.1.oracle.json"
DRIVER = PROJECT / "build/live_audio_restart_driver"

PUMP = 0x4F52A9
PLAY_WRAPPER = 0x4F6059
STOP_WRAPPER = 0x4F61E7
WAIT_IAT = 0x52A250
WAIT_STUB = base.STUB + 0x1040
STOP_STUB = base.STUB + 0x1030
VTABLE_STOP = 0x48
WAIT_TIMEOUT = 0x102

WINDOWS = {
    "pump_event_drain_and_tail": (0x4F52A9, 0x4F55D5),
    "channel_update": (0x4F55D5, 0x4F572B),
    "slot_scan_0x4f572b": (0x4F572B, 0x4F57E3),
    "stream_refill_0x4f57e3": (0x4F57E3, 0x4F594D),
    "stream_fill_chunk_0x4f594d": (0x4F594D, 0x4F5B50),
    "stream_read_and_rewind_0x4f5b50": (0x4F5B50, 0x4F5E35),
    "play_wrapper": (0x4F6059, 0x4F61E7),
    "stop_wrapper": (0x4F61E7, 0x4F6334),
    "playing_query": (0x4F6334, 0x4F646C),
    "delayed_repeat_and_fade_pass": (0x4F7207, 0x4F79CE),
    "his_load_and_stream_select": (0x4F379C, 0x4F3C26),
    "whole_buffer_loader_stop_notify": (0x4F3C26, 0x4F438F),
    "stream_loader_stop_notify": (0x4F438F, 0x4F4B9F),
    "event_creation_0x40": (0x4F32D0, 0x4F333D),
    "runtime_record_init_0x410f99": (0x410F99, 0x41107F),
    "action_9f_phase_handler": (0x432D1A, 0x4336AD),
}

# Exact flag words that engage the unmodelled fade-ramp passes: excluded from
# the pump-level comparison (the Play-flag derivation for 0x100 is covered by
# the S04-1 oracle).
RAMP_FLAGS = {0x3, 0x7, 0x100, 0x300, 0x500}

STEMS = {"Tone": 0, "Big": 1}   # stem -> original slot+0x166 (stream class)


class RestartOracle(base.OriginalSoundControlOracle):
    def __init__(self, pe: PEImage):
        super().__init__(pe)
        from unicorn import UC_HOOK_CODE
        self.waiting: set[int] = set()
        self.native_playing: dict[int, bool] = {}
        self.streams: dict[int, int] = {}
        self.controls: dict[int, int] = {}
        table = bytearray(self.uc.mem_read(base.VTABLE, 0x54))
        struct.pack_into("<I", table, VTABLE_STOP, STOP_STUB)
        self.uc.mem_write(base.VTABLE, bytes(table))
        self.uc.mem_write(WAIT_IAT, struct.pack("<I", WAIT_STUB))
        self.uc.hook_add(UC_HOOK_CODE, self._hook_restart)

    def _hook_restart(self, machine: Any, address: int, _size: int, _user: Any) -> None:
        if address == STOP_STUB:
            esp = machine.reg_read(self.esp)
            buffer = base.u32(machine, esp + 4)
            channel = next((c for c in range(32)
                            if base.u32(machine, base.slot_address(c) + 0x28F) == buffer), None)
            if channel is None:
                raise base.OracleFailure("DirectSound Stop received an unknown buffer")
            self.trace.append(("stop", channel))
            machine.reg_write(self.eax, 0)
            self._return_hook(4)
        elif address == WAIT_STUB:
            esp = machine.reg_read(self.esp)
            count = base.u32(machine, esp + 4)
            wait_all = base.u32(machine, esp + 12)
            timeout = base.u32(machine, esp + 16)
            if count != 0x40 or wait_all != 0 or timeout != 0:
                raise base.OracleFailure("unexpected WaitForMultipleObjects arguments")
            if self.waiting:
                index = min(self.waiting)
                self.waiting.discard(index)
                self.trace.append(("event", index))
                machine.reg_write(self.eax, index)
            else:
                machine.reg_write(self.eax, WAIT_TIMEOUT)
            self._return_hook(16)

    def reset(self) -> None:
        """Back to the state of a fresh process for the next scenario: the
        32 channel slots zeroed, device words idle, no pending notification."""
        self.uc.mem_write(base.CSOUND + 4, bytes(32 * base.SLOT_STRIDE))
        for offset in (0x3BE, 0x3C2, 0x3CA):
            base.put_u32(self.uc, base.CDIRECTSOUND + offset, 0)
        self.waiting.clear()
        self.native_playing.clear()
        self.streams.clear()
        self.controls.clear()
        self.trace.clear()
        self.tick_value = 0
        self.random_value = 0

    def seed(self, channel: int, control: int, flags: int, stream: int) -> None:
        self.seed_slot(channel, control=control, flags=flags, stream=stream,
                       resource_ready=1, buffer=False, repeat_min=500, repeat_max=2000)
        buffer = base.BUFFER + 0x10 * channel
        base.put_u32(self.uc, buffer, base.VTABLE)
        base.put_u32(self.uc, base.slot_address(channel) + 0x28F, buffer)
        self.streams[channel] = stream
        self.controls[channel] = control


def hash_windows(pe: PEImage) -> dict[str, Any]:
    out = {}
    for name, (start, end) in WINDOWS.items():
        offset = pe.va_to_file_offset(start, end - start)
        out[name] = {
            "start_va": f"0x{start:08x}", "end_va_exclusive": f"0x{end:08x}",
            "length": end - start,
            "sha256": hashlib.sha256(pe.data[offset:offset + end - start]).hexdigest(),
        }
    return out


# ---- scenario model --------------------------------------------------------
# Each step is a tuple: ("load", ch, control, stem) ("flags", ch, flags)
# ("rand", value) ("play", ch) ("complete", ch) ("stop", ch) ("unload", ch)
# ("pump", tick)

def step_text(step: tuple) -> str:
    verb = step[0]
    if verb == "load":
        return f"load {step[1]} {step[2]} {step[3]}"
    if verb == "flags":
        return f"flags {step[1]} {step[2]:x}"
    return " ".join([verb, *[str(v) for v in step[1:]]])


def run_native(script: list[tuple], tree: Path, driver: Path) -> list[dict[str, Any]]:
    text = "".join(step_text(step) + "\n" for step in script)
    result = subprocess.run([str(driver), str(tree)], input=text, capture_output=True, text=True,
                            timeout=120)
    if result.returncode != 0:
        raise base.OracleFailure(f"driver failed: {result.stderr[-500:]}")
    steps: list[dict[str, Any]] = []
    current: dict[str, Any] = {"effects": [], "state": {}}
    for line in result.stdout.splitlines():
        parts = line.split()
        if parts[0] == "E":
            if parts[1] == "play":
                current["effects"].append(("play", int(parts[2]), int(parts[3])))
            else:
                current["effects"].append(("random", int(parts[2])))
        elif parts[0] == "S":
            channel, marker, delay, due, gate, loaded, playing = (int(v) for v in parts[1:])
            current["state"][channel] = (marker, delay & 0xFFFFFFFF, due & 0xFFFFFFFF, gate,
                                         loaded, playing)
        elif parts[0] == "R":
            current["status"] = int(parts[1])
        elif parts[0] == "END":
            steps.append(current)
            current = {"effects": [], "state": {}}
    if len(steps) != len(script):
        raise base.OracleFailure("driver step count mismatch")
    return steps


def run_original(oracle: RestartOracle, script: list[tuple]) -> list[dict[str, Any]]:
    steps: list[dict[str, Any]] = []
    loaded: set[int] = set()
    for step in script:
        oracle.trace.clear()
        verb = step[0]
        if verb == "load":
            _, channel, control, stem = step
            oracle.seed(channel, control, 0, STEMS[stem])
            loaded.add(channel)
            oracle.native_playing[channel] = False
        elif verb == "flags":
            base.put_u16(oracle.uc, base.slot_address(step[1]) + 0x12C, step[2])
        elif verb == "rand":
            oracle.random_value = step[1]
        elif verb == "play":
            oracle.call_this(PLAY_WRAPPER, base.CDIRECTSOUND, (step[1],))
        elif verb == "complete":
            oracle.native_playing[step[1]] = False
            oracle.waiting.add(2 * step[1] + 1)
        elif verb == "stop":
            oracle.call_this(STOP_WRAPPER, base.CDIRECTSOUND, (step[1],))
            oracle.native_playing[step[1]] = False
            oracle.waiting.add(2 * step[1] + 1)
        elif verb == "unload":
            channel = step[1]
            if oracle.native_playing.get(channel):
                oracle.call_this(STOP_WRAPPER, base.CDIRECTSOUND, (channel,))
                oracle.waiting.add(2 * channel + 1)
            oracle.native_playing[channel] = False
            base.put_u32(oracle.uc, base.slot_address(channel) + 0x162, 0)
            base.put_u32(oracle.uc, base.slot_address(channel) + 0x28F, 0)
            loaded.discard(channel)
        elif verb == "pump":
            oracle.tick_value = step[1]
            oracle.call_this(PUMP, base.CDIRECTSOUND, ())
        else:
            raise base.OracleFailure(f"unknown step {step}")
        effects = []
        for event in oracle.trace:
            if event[0] == "play":
                channel, flags = event[1], event[2]
                oracle.native_playing[channel] = True
                # The native host loop flag: a plain buffer follows the
                # DirectSound flag; a stream-class ring is looped by the
                # filler exactly when raw control is 0 (0x4f5a5e).
                loop = int(oracle.controls[channel] == 0) if oracle.streams[channel] else flags & 1
                effects.append(("play", channel, loop))
            elif event[0] == "random":
                effects.append(("random", event[1]))
        state = {}
        for channel in sorted(loaded):
            slot = base.slot_address(channel)
            state[channel] = (base.u32(oracle.uc, slot + 0x19E) & 1,
                              base.u32(oracle.uc, slot + 0x1A2),
                              base.u32(oracle.uc, slot + 0x1A6),
                              base.u32(oracle.uc, slot + 0x287),
                              1, int(oracle.native_playing.get(channel, False)))
        steps.append({"effects": effects, "state": state,
                      "raw_trace": list(oracle.trace)})
    return steps


def compare(name: str, script: list[tuple], original: list[dict[str, Any]],
            native: list[dict[str, Any]]) -> int:
    for index, (step, ours, theirs) in enumerate(zip(script, original, native)):
        # the native `load` of a stem and `unload` clear everything; the
        # original only re-seeds, so compare loaded channels only
        if ours["effects"] != theirs["effects"]:
            raise base.OracleFailure(
                f"{name} step {index} {step}: effects original={ours['effects']} "
                f"native={theirs['effects']}")
        if ours["state"] != theirs["state"]:
            raise base.OracleFailure(
                f"{name} step {index} {step}: state original={ours['state']} "
                f"native={theirs['state']}")
    return len(script)


def delay_for(rand: int, minimum: int = 500, maximum: int = 2000) -> int:
    return rand % (maximum - minimum) + minimum


def scenarios() -> list[tuple[str, list[tuple]]]:
    out: list[tuple[str, list[tuple]]] = []
    flag_sets = [0x0, 0x1, 0x10, 0x11, 0x101, 0x110, 0x111]
    for stem in STEMS:
        for control in (0, 1, 2, 0x80000000):
            for flags in flag_sets:
                for rand in (0, 1233, 1499, 32767):
                    if flags & 0x10 == 0 and rand != 0:
                        continue          # no draw happens without flag 0x10
                    name = f"{stem}-c{control:#x}-f{flags:#x}-r{rand}"
                    script: list[tuple] = [
                        ("load", 4, control, stem), ("flags", 4, flags), ("rand", rand),
                        ("play", 4), ("pump", 1000),
                        ("complete", 4), ("pump", 2000), ("pump", 2001),
                    ]
                    if flags & 0x10:
                        due = 2000 + delay_for(rand)
                        script += [("pump", due - 1), ("pump", due), ("pump", due + 1),
                                   ("pump", due + 2)]
                    else:
                        script += [("complete", 4), ("pump", 3000), ("pump", 4000)]
                    out.append((name, script))
    # explicit stop gates the update; a later play re-opens it
    for stem in STEMS:
        out.append((f"{stem}-stop-gates-update", [
            ("load", 5, 0, stem), ("flags", 5, 0), ("play", 5), ("stop", 5), ("pump", 100),
            ("play", 5), ("complete", 5), ("pump", 200), ("pump", 300)]))
        out.append((f"{stem}-unload-gates-update", [
            ("load", 5, 0, stem), ("flags", 5, 0), ("play", 5), ("unload", 5), ("pump", 100),
            ("pump", 200)]))
        out.append((f"{stem}-stopped-then-completes-in-one-pump", [
            ("load", 5, 0, stem), ("flags", 5, 0), ("play", 5), ("stop", 5),
            ("complete", 5), ("pump", 100)]))
    # several channels complete in one pump: ascending order, one drain
    out.append(("ordering", [
        ("load", 9, 0, "Tone"), ("flags", 9, 0), ("load", 2, 0, "Tone"), ("flags", 2, 0),
        ("load", 7, 1, "Tone"), ("flags", 7, 0), ("load", 21, 0, "Tone"), ("flags", 21, 0),
        ("play", 9), ("play", 2), ("play", 7), ("play", 21),
        ("complete", 21), ("complete", 9), ("complete", 7), ("complete", 2),
        ("pump", 500), ("pump", 600)]))
    # tick arithmetic around the 32-bit wrap with the unsigned compare
    for tick in (0xFFFFFFF8, 0xFFFFFE00, 0xFFFFFFFF, 0):
        out.append((f"tick-wrap-{tick:#x}", [
            ("load", 4, 0, "Tone"), ("flags", 4, 0x10), ("rand", 23), ("play", 4),
            ("complete", 4), ("pump", tick), ("pump", (tick + 1) & 0xFFFFFFFF),
            ("pump", (tick + 523) & 0xFFFFFFFF), ("pump", (tick + 524) & 0xFFFFFFFF)]))
    # armed repeat with a reload in between: the load clears the marker
    out.append(("reload-clears-armed-repeat", [
        ("load", 4, 0, "Tone"), ("flags", 4, 0x10), ("rand", 700), ("play", 4),
        ("complete", 4), ("pump", 1000), ("load", 4, 0, "Tone"), ("play", 4),
        ("pump", 5000), ("pump", 9000)]))
    return out


def header_decoded(stem: str) -> int | None:
    game_source = json.loads((ROOT / "work/analysis/game-source.json").read_text())
    for path in (Path(game_source["game_dir"]) / "CDSound").glob("*"):
        if path.stem.lower() == stem.lower() and path.suffix.lower() == ".his":
            header = path.read_bytes()[:30]
            if len(header) == 30 and header[:4] == b"HIS\0":
                return struct.unpack_from("<I", header, 24)[0]
    return None


def census(tree: Path | None) -> dict[str, Any]:
    """Which control-0 scene sounds are stream-class (loop forever) and which
    are plain buffers (restart on completion)? Reads the owner's local data in
    place; only counts and stem names are reported."""
    import ctypes as C
    game_source = json.loads((ROOT / "work/analysis/game-source.json").read_text())
    sound_dir = Path(game_source["game_dir"]) / "CDSound"
    resource_library = PROJECT / "build/libsceneresource.dylib"
    if not resource_library.is_file():
        subprocess.run([str(PROJECT / "scripts/build_scene_resource.sh")], check=True)

    class Info(C.Structure):
        _fields_ = [("description", C.c_char * 49), ("type", C.c_uint8), ("subtype", C.c_uint8),
                    ("payload_kind", C.c_int), ("raw_body", C.POINTER(C.c_uint8)),
                    ("raw_body_length", C.c_size_t), ("typed_body", C.POINTER(C.c_uint8)),
                    ("typed_body_length", C.c_size_t), ("dependency_records", C.POINTER(C.c_uint8)),
                    ("dependency_count", C.c_size_t)]

    lib = C.CDLL(str(resource_library))
    lib.scene_resource_open_memory.argtypes = [C.c_void_p, C.c_size_t, C.c_char_p, C.c_size_t]
    lib.scene_resource_open_memory.restype = C.c_void_p
    lib.scene_resource_close.argtypes = [C.c_void_p]
    lib.scene_resource_action_count.argtypes = [C.c_void_p]
    lib.scene_resource_action_count.restype = C.c_size_t
    lib.scene_resource_action_at.argtypes = [C.c_void_p, C.c_size_t, C.POINTER(Info)]
    lib.scene_resource_action_at.restype = C.c_int

    sizes: dict[str, int | None] = {}

    def decoded_bytes(stem: str) -> int | None:
        if stem in sizes:
            return sizes[stem]
        match = [p for p in sound_dir.glob("*") if p.stem.lower() == stem.lower()
                 and p.suffix.lower() == ".his"]
        value = None
        if len(match) == 1:
            header = match[0].read_bytes()[:30]
            if len(header) == 30 and header[:4] == b"HIS\0":
                value = struct.unpack_from("<I", header, 24)[0]
        sizes[stem] = value
        return value

    totals: Counter[str] = Counter()
    stems: dict[str, set[str]] = {"stream": set(), "buffer": set(), "missing": set()}
    commands_by_class: Counter[str] = Counter()
    for path in sorted((ROOT / "work/analysis/hiff-resources").glob("*.bin")):
        data = path.read_bytes()
        raw = C.create_string_buffer(data)
        error = C.create_string_buffer(256)
        scene = lib.scene_resource_open_memory(raw, len(data), error, len(error))
        if not scene:
            continue
        for index in range(lib.scene_resource_action_count(scene)):
            action = Info()
            if lib.scene_resource_action_at(scene, index, C.byref(action)) != 0 or action.type != 0x9F:
                continue
            body = C.string_at(action.typed_body, action.typed_body_length)
            stem = body[:33].split(b"\0")[0].decode("latin-1")
            control = struct.unpack_from("<I", body, 35)[0]
            if control != 0:
                totals["control_nonzero"] += 1
                continue
            totals["control_zero"] += 1
            size = decoded_bytes(stem)
            kind = "missing" if size is None else ("stream" if size > 0x56220 else "buffer")
            commands_by_class[kind] += 1
            stems[kind].add(stem.lower())
        lib.scene_resource_close(scene)
    return {
        "control_zero_commands": totals["control_zero"],
        "control_nonzero_commands": totals["control_nonzero"],
        "control_zero_by_class": dict(commands_by_class),
        "distinct_control_zero_stems": {k: len(v) for k, v in stems.items()},
        "stream_class_stems": sorted(stems["stream"])[:80],
        "buffer_class_stems": sorted(stems["buffer"])[:80],
        "missing_asset_stems": sorted(stems["missing"])[:80],
        "clock_ticking_grandfather01_decoded_bytes": decoded_bytes("ClockTicking_Grandfather01"),
    }


def load_pe(exe: Path) -> PEImage:
    pe = PEImage.parse_and_map(exe)
    if sha256(pe.data) != EXPECTED_EXE_SHA256:
        raise base.OracleFailure("pinned original GAME.EXE SHA-256 does not match")
    return pe


def compare_all(pe: PEImage, tree: Path, driver: Path, *, only: str | None = None) -> tuple[Counter, list[str]]:
    """Every scenario against the original; raises OracleFailure on the first
    disagreement. `only` restricts to scenario names containing the text."""
    oracle = RestartOracle(pe)
    compared: Counter = Counter()
    names: list[str] = []
    for name, script in scenarios():
        if only is not None and only not in name:
            continue
        oracle.reset()
        original = run_original(oracle, script)
        native = run_native(script, tree, driver)
        compared["steps"] += compare(name, script, original, native)
        compared["scenarios"] += 1
        names.append(name)
        for step_original in original:
            compared["play_effects"] += sum(1 for e in step_original["effects"] if e[0] == "play")
            compared["rand_effects"] += sum(1 for e in step_original["effects"] if e[0] == "random")
    return compared, names


def run(args: argparse.Namespace) -> dict[str, Any]:
    pe = load_pe(args.exe)
    import test_live_audio_restart as restart_tests
    with tempfile.TemporaryDirectory(prefix="rt111-oracle-") as tmp:
        tree = Path(tmp) / "game"
        restart_tests.build_tree(tree)
        built = restart_tests.build("fixture")
        if built.returncode != 0:
            raise base.OracleFailure("driver build failed: " + built.stderr[-1500:])
        compared, names = compare_all(pe, tree, args.driver)
        clock_decoded = header_decoded("ClockTicking_Grandfather01")
    report = {
        "original_sha256": sha256(pe.data),
        "code_windows": hash_windows(pe),
        "comparison_counts": dict(compared),
        "scenario_names_sample": names[:12],
        "hook_list": [
            {"address": "0x52a23c", "meaning": "GetTickCount, scripted"},
            {"address": "0x52a250", "meaning": "WaitForMultipleObjects: queued stop-notification indices, then WAIT_TIMEOUT"},
            {"address": "0x50cd50", "meaning": "CRT rand, scripted"},
            {"address": "DirectSound vtable +0x30", "meaning": "Play, recorded, HRESULT 0"},
            {"address": "DirectSound vtable +0x48", "meaning": "Stop, recorded"},
        ],
        "environment_emulation": [
            "unload: original Stop wrapper for a playing channel + queued notification + slot+0x162/+0x28f cleared; 0x4f356e itself is not run",
            "the stream-class compare at 0x4f3b49 is static evidence plus the HIS header bytes, not executed",
        ],
        "excluded_flag_words": sorted(RAMP_FLAGS),
        "clock_ticking_grandfather01_decoded_bytes": clock_decoded,
    }
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exe", type=Path, default=base.DEFAULT_EXE)
    parser.add_argument("--driver", type=Path, default=DRIVER)
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--census", action="store_true", help="add the control-0 corpus census")
    args = parser.parse_args()
    try:
        report = run(args)
        if args.census:
            report["control_zero_census"] = census(None)
    except (base.OracleFailure, OSError, ValueError, struct.error) as exc:
        print(f"restart oracle failure: {exc}", file=sys.stderr)
        return 1
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps({"counts": report["comparison_counts"],
                      "original_sha256": report["original_sha256"],
                      "windows": len(report["code_windows"]), "report": str(args.report)},
                     sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
