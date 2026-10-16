#!/usr/bin/env python3
"""Machine annotation of generated assembly (Track M, bulk method).

``gen_hinted_asm.py`` emits byte-exact Intel-syntax GNU assembly with empty annotation fields.  Owner ruling of
2026-10-15: machine-generated names are valid Track M annotation, so the fields can be filled by script and a
human renames them later without touching the bytes.  This tool fills them from facts that the instruction bytes
and the committed project evidence state, nothing else:

* ``name``        ``fn_<va>``;
* ``arguments``   ``[ebp+n]`` argument slots, the ``ret n`` pop size and whether ``ecx`` is read before it is written;
* ``locals``      ``[ebp-n]`` slots;
* ``fields``      register-relative displacements per base register (``field_n``, ``stk_n``);
* ``callees``     direct call and tail-jump targets (``FUN_<va>``), import-table calls by DLL and symbol,
                  indirect calls by operand;
* ``track-n``     the native source symbol the function ledger records for the function, only for the ledger classes
                  that claim a counterpart; otherwise ``host-adapter: none``;
* ``unverified``  what a machine pass cannot know;
* one comment per basic block: how the block is entered, its call targets and how it ends.

A machine-annotated file carries ``# annotation:  machine``; ``audit_tool_assisted.py`` accepts the generator's
default symbol names and the ``fn_<va>`` function name only under that header.  ``check`` regenerates every
machine-annotated file from the original and requires the committed text to be identical, so a machine header
cannot hide a hand edit.  Nothing here claims original C++ or compiler provenance and no original bytes are written.
"""

from __future__ import annotations

import argparse
import collections
import json
import re
import sys
from pathlib import Path
from typing import Any, Optional

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gen_hinted_asm as gen  # noqa: E402

PROJECT = gen.PROJECT
ASM = PROJECT / "asm"
LEDGER = PROJECT / "function-ledger.json"
IMPORTS = PROJECT / "image" / "imports.json"
REPOSITORY = gen.REPOSITORY
MARKER = "machine"
HEADER_LINE = (
    "machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the "
    "function ledger, not from recovered intent)"
)
# Ledger classes whose native source is a counterpart claim rather than "native code touches this".
COUNTERPART_CLASSES = {"native_oracle_verified", "native_tests_only", "host_adapter_tested", "candidate_port"}

_SYMBOL_OPERAND = re.compile(
    r"\[(?:(?P<base>e[a-d]x|e[sd]i|esp|ebp)(?P<index>(?: \+ (?:[248]\*)?e[a-z]{2})?)|[248]\*e[a-z]{2}) (?P<sign>[+-]) "
    r"(?P<sym>(?:arg|local|field|field_minus|stk|stk_minus)_[0-9a-f]+)\]"
)
_ECX = re.compile(r"\b(?:ecx|cx|cl|ch)\b")
_BLOCK_LINE = re.compile(r"^    # block 0x([0-9a-f]{8}): " + re.escape(gen.UNFILLED) + r"$")
_IMPORT_CALL = re.compile(r"^(?:call|jmp) dword ptr \[0x([0-9a-f]+)\]$")


def machine_name(va: int) -> str:
    return f"fn_{va:08x}"


def import_table() -> dict[int, str]:
    """IAT slot address -> ``DLL!Symbol`` from the committed import description."""

    data = json.loads(IMPORTS.read_text(encoding="utf-8"))
    slots: dict[int, str] = {}
    for dll in data["dlls"]:
        base = 0x400000 + int(dll["iat_rva"], 16)
        for index, symbol in enumerate(dll["symbols"]):
            slots[base + 4 * index] = f"{dll['name']}!{symbol['name']}"
    return slots


def ledger_links() -> dict[int, dict[str, Any]]:
    entries = json.loads(LEDGER.read_text(encoding="utf-8"))["entries"]
    return {int(e["va"], 16): e for e in entries}


def counterpart(entry: Optional[dict[str, Any]]) -> Optional[tuple[str, str, str]]:
    """(repo path, symbol, ledger class) of the ledger's native source for a function, if it claims a counterpart."""

    if not entry or entry.get("class") not in COUNTERPART_CLASSES:
        return None
    for item in entry.get("evidence", []):
        symbol = item.get("symbol")
        path = item.get("path")
        if item.get("kind") != "native_source" or not symbol or not path or len(symbol) < 6:
            continue
        repo_path = f"outputs/blackmoor-decomp/{path}"
        target = REPOSITORY / repo_path
        if target.is_file() and re.search(r"(?<![\w])" + re.escape(symbol) + r"(?![\w])",
                                          target.read_text(encoding="utf-8", errors="replace")):
            return repo_path, symbol, entry["class"]
    return None


def split_ops(ops: str) -> list[str]:
    return ops.split(", ", 1) if ", " in ops else [ops]


def ecx_read_first(insns: list[gen.Insn]) -> bool:
    """True when the entry block reads ecx (or a part of it) before anything writes it."""

    for ins in insns:
        mnem = ins.mnem
        if mnem == "call" or mnem == "jmp" or mnem in gen._COND_JUMPS or mnem.startswith("ret"):
            return False
        if mnem == "push":
            continue
        if mnem == "pop":
            if _ECX.search(ins.ops):
                return False
            continue
        if mnem.startswith("rep"):
            return True
        parts = split_ops(ins.ops)
        dest = parts[0]
        src = parts[1] if len(parts) > 1 else ""
        bare_ecx = re.fullmatch(r"(?:ecx|cx|cl|ch)", dest) is not None
        if mnem in ("mov", "movzx", "movsx", "lea"):
            if _ECX.search(src):
                return True
            if bare_ecx:
                return False
            if "[" in dest and _ECX.search(dest):
                return True
        elif mnem in ("xor", "sub") and bare_ecx and dest == src:
            return False
        elif _ECX.search(ins.ops):
            return True
    return False


def describe_symbols(names: list[str], limit: int = 12) -> str:
    names = sorted(set(names), key=lambda n: (n.rsplit("_", 1)[0], int(n.rsplit("_", 1)[1], 16)))
    shown = ", ".join(names[:limit])
    return shown + (f" and {len(names) - limit} more" if len(names) > limit else "")


class Annotator:
    def __init__(self, image: gen.Image, ledger: Optional[dict] = None, imports: Optional[dict] = None) -> None:
        self.image = image
        self.imports = import_table() if imports is None else imports
        self.ledger = ledger_links() if ledger is None else ledger

    # -- control-flow facts ------------------------------------------------

    def blocks(self, layout: gen.Layout) -> dict[int, dict[str, Any]]:
        """Basic blocks keyed by start address, partitioned exactly as ``render_function`` does."""

        insns = layout.insns
        labels = set(layout.internal_targets) | {t for item in layout.data_by_kind("switch_table") for t in item.targets}
        entries: dict[int, list[str]] = {layout.va: ["entry"]}
        for ins in insns:
            target = gen.direct_target(ins)
            if target is not None and layout.va <= target < layout.code_end:
                labels.add(target)
                if ins.mnem != "call":
                    entries.setdefault(target, []).append(f"{ins.mnem} at 0x{ins.addr:08x}")
        for item in layout.data_by_kind("switch_table"):
            for target in item.targets:
                entries.setdefault(target, []).append("switch case")
        starts = {layout.va} | labels
        previous: Optional[gen.Insn] = None
        for ins in insns:
            if previous is not None and (gen.is_cond_jump(previous) or gen.is_terminal(previous)):
                starts.add(ins.addr)
                if gen.is_cond_jump(previous):
                    entries.setdefault(ins.addr, []).append(f"fall-through of {previous.mnem} at 0x{previous.addr:08x}")
                elif ins.addr not in labels:
                    entries.setdefault(ins.addr, []).append(f"follows {previous.mnem} at 0x{previous.addr:08x}")
            previous = ins
        blocks: dict[int, dict[str, Any]] = {}
        current: Optional[dict[str, Any]] = None
        for ins in insns:
            if ins.addr in starts:
                current = {"start": ins.addr, "insns": [], "entered": entries.get(ins.addr, ["fall-through"])}
                blocks[ins.addr] = current
            assert current is not None
            current["insns"].append(ins)
        return blocks

    def call_name(self, ins: gen.Insn) -> Optional[str]:
        target = gen.direct_target(ins)
        if target is not None:
            return gen.external_symbol(self.image, target)
        match = _IMPORT_CALL.match(ins.text)
        if match and int(match.group(1), 16) in self.imports:
            return self.imports[int(match.group(1), 16)]
        return None

    def block_comment(self, layout: gen.Layout, block: dict[str, Any]) -> str:
        insns: list[gen.Insn] = block["insns"]
        entered = "; ".join(dict.fromkeys(block["entered"]))
        if len(entered) > 90:
            entered = entered[:87].rsplit(";", 1)[0] + "; more"
        parts = [f"entered by {entered}" if block["entered"][0] != "entry" else "entry", f"{len(insns)} instruction(s)"]
        calls = []
        for ins in insns:
            if ins.mnem == "call":
                calls.append(self.call_name(ins) or f"indirect {ins.ops}")
        if calls:
            shown = ", ".join(dict.fromkeys(calls))
            parts.append("calls " + (shown if len(shown) < 100 else shown[:97] + "..."))
        last = insns[-1]
        target = gen.direct_target(last)
        if last.mnem.startswith("ret"):
            parts.append(f"ends with {last.text}")
        elif last.mnem == "jmp" and target is not None:
            where = "backward jump" if target <= last.addr else "forward jump"
            parts.append(f"ends with {where} to 0x{target:08x}")
        elif last.mnem == "jmp":
            parts.append(f"ends with indirect jump {last.ops}")
        elif gen.is_cond_jump(last) and target is not None:
            parts.append(f"ends with {last.mnem} to 0x{target:08x} ({'backward' if target <= last.addr else 'forward'})")
        elif gen.is_terminal(last):
            parts.append(f"ends with {last.text}")
        else:
            parts.append(f"falls into the block at 0x{last.end:08x}")
        return ", ".join(parts)

    # -- header fields -----------------------------------------------------

    def fields(self, layout: gen.Layout, rendered_text: str, frame: bool) -> dict[str, str]:
        insns = layout.insns
        va = layout.va
        args: list[str] = []
        local: list[str] = []
        bases: dict[str, list[str]] = {}
        for match in _SYMBOL_OPERAND.finditer(rendered_text):
            sym, base = match.group("sym"), match.group("base") or "scaled index"
            if sym.startswith("arg_"):
                args.append(sym)
            elif sym.startswith("local_"):
                local.append(sym)
            else:
                bases.setdefault(base, []).append(sym)
        pops = sorted({ins.ops for ins in insns if ins.mnem == "ret"}, key=lambda o: (o != "", o))
        returns = []
        for ops in pops:
            returns.append(f"ret {ops} (callee pops {int(ops, 0)} bytes)" if ops else "plain ret (caller pops any stack arguments)")
        first_block = next(iter(self.blocks(layout).values()))
        this_hint = "ecx is read before it is written, a probable this pointer in the thiscall style" if ecx_read_first(
            first_block["insns"]) else "ecx is not read in the entry block before being written"
        if frame:
            arg_text = (f"{len(set(args))} ebp-relative stack slot(s) referenced: {describe_symbols(args)}"
                        if args else "no [ebp+n] stack argument slot referenced")
            local_text = (f"{len(set(local))} ebp-relative slot(s): {describe_symbols(local)}"
                          if local else "none: no [ebp-n] slot referenced")
        else:
            arg_text = "no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass"
            local_text = "none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols"
        arguments = f"{arg_text}; {'; '.join(returns) if returns else 'no ret instruction in the code part'}; {this_hint}"
        field_text = ("; ".join(f"[{base} + n] {describe_symbols(names)}" for base, names in sorted(bases.items()))
                      or "none: no register-relative displacement below 0x400000 other than frame slots")
        callees = []
        indirect = []
        for ins in insns:
            if ins.mnem in ("call", "jmp"):
                target = gen.direct_target(ins)
                name = self.call_name(ins)
                if ins.mnem == "call" or (target is not None and not (va <= target < layout.code_end)):
                    if name:
                        callees.append(("tail jump " if ins.mnem == "jmp" else "") + name)
                    elif target is None:
                        indirect.append(f"{ins.mnem} {ins.ops}")
        unique = list(dict.fromkeys(callees))
        shown = ", ".join(unique[:16]) + (f" and {len(unique) - 16} more" if len(unique) > 16 else "")
        if unique and indirect:
            callee_text = f"calls {shown}; plus {len(indirect)} indirect transfer(s) whose target is not resolved"
        elif unique:
            callee_text = f"calls {shown}"
        elif indirect:
            callee_text = f"none direct; {len(indirect)} indirect transfer(s) whose target is not resolved"
        else:
            callee_text = "none: no call or outward jump"
        entry = self.ledger.get(va)
        link = counterpart(entry)
        if link:
            track = f"{link[0]}:{link[1]} (function ledger class {link[2]}; this machine pass does not re-verify the equivalence)"
        else:
            track = "host-adapter: none"
        conditional = sum(1 for ins in insns if gen.is_cond_jump(ins))
        tables = len(layout.data_by_kind("switch_table")) + len(layout.data_by_kind("index_table"))
        unverified = (
            f"machine annotation only: the {len(layout.insns)} instruction(s), {conditional} conditional branch(es) and {tables} jump table(s) "
            "are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; "
            "names are generated from offsets and addresses"
        )
        if indirect:
            unverified += "; indirect transfers are not followed"
        if entry and entry.get("class") not in COUNTERPART_CLASSES and entry.get("class") != "none":
            unverified += f"; function ledger class {entry['class']} is a native-touch record, not a counterpart claim"
        return {"name": machine_name(va), "arguments": arguments, "locals": local_text, "fields": field_text,
                "callees": callee_text, "track-n": track, "unverified": unverified}

    # -- file --------------------------------------------------------------

    def render(self, layout: gen.Layout) -> str:
        text = gen.render_file(self.image, layout)
        rendered = gen.render_function(self.image, layout)
        fields = self.fields(layout, rendered.text, gen.has_standard_frame(layout))
        blocks = self.blocks(layout)
        out: list[str] = []
        for line in text.split("\n"):
            match = re.match(r"^# (name|arguments|locals|fields|callees|track-n|unverified): +" + re.escape(gen.UNFILLED) + r"$", line)
            if match:
                key = match.group(1)
                if key == "name":
                    out.append(f"# annotation:  {HEADER_LINE}")
                out.append(f"# {key + ':':<13} {fields[key]}")
                continue
            block = _BLOCK_LINE.match(line)
            if block:
                start = int(block.group(1), 16)
                out.append(f"    # block 0x{start:08x}: {self.block_comment(layout, blocks[start])}")
                continue
            out.append(line)
        return "\n".join(out)


def selected_vas(image: gen.Image, args: argparse.Namespace) -> list[int]:
    existing = set()
    if args.exclude_manifests:
        for path in sorted(ASM.glob("batch-[0-9]*.json")):
            if path.name.endswith("-report.json"):
                continue
            existing |= {int(f["va"], 0) for f in json.loads(path.read_text(encoding="utf-8"))["functions"]}
    vas = []
    for va in sorted(image.starts):
        if va in existing:
            continue
        region = gen.region_of(va)
        if args.region and region not in args.region:
            continue
        if args.lo is not None and va < args.lo:
            continue
        if args.hi is not None and va >= args.hi:
            continue
        vas.append(va)
    return vas


def cmd_annotate(args: argparse.Namespace) -> int:
    image = gen.load_image(args.original)
    vas = selected_vas(image, args)
    layouts, _decoded = gen.analyze_all(image, vas)
    annotator = Annotator(image)
    args.out.mkdir(parents=True, exist_ok=True)
    written, skipped = [], {}
    for va in vas:
        layout = layouts[va]
        if layout.exceptions:
            skipped[f"0x{va:08x}"] = layout.exceptions[:3]
            continue
        last = layout.insns[-1]
        if layout.falls_through or not (gen.is_terminal(last) or (last.mnem == "call" and layout.data)):
            # the auditor refuses a code part that does not end in a terminal instruction (open question for the owner)
            skipped[f"0x{va:08x}"] = [f"code part ends in {last.mnem}, not a terminal ret/jmp"]
            continue
        (args.out / f"FUN_{va:08x}.s").write_text(annotator.render(layout) + "\n", encoding="utf-8")
        written.append(va)
    print(f"annotated {len(written)} function(s) into {args.out}; skipped {len(skipped)}")
    for va, why in skipped.items():
        print(f"  skipped {va}: {why}")
    if args.batch_size:
        write_manifests(image, layouts, written, args.out, args.batch_size, args.first_batch)
    return 0


def write_manifests(image: gen.Image, layouts: dict, vas: list[int], out: Path, size: int, first: int) -> None:
    number = first
    for start in range(0, len(vas), size):
        chunk = vas[start : start + size]
        regions = collections.Counter(gen.region_of(v) for v in chunk)
        mix = ", ".join(f"{count} {name}" for name, count in sorted(regions.items()))
        description = (
            f"Machine-annotated tool-assisted assembly: {len(chunk)} functions ({mix}) from 0x{chunk[0]:08x} to "
            f"0x{chunk[-1]:08x}. Generated by scripts/gen_hinted_asm.py and "
            "filled by scripts/annotate_machine.py (machine names, valid under the owner ruling of 2026-10-15); "
            "audited and sample-reviewed; no claim about original C++ or compiler provenance."
        )
        manifest = gen.build_manifest(image, layouts, chunk, out, f"{number:03d}", description, manifest_dir=out.resolve())
        path = out / f"batch-{number:03d}.json"
        path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        print(f"wrote {path} ({len(chunk)} functions)")
        number += 1


def cmd_manifests(args: argparse.Namespace) -> int:
    """Batch manifests for every machine-annotated source in a directory, in address order."""

    image = gen.load_image(args.original)
    vas = sorted(int(p.stem.split("_")[1], 16) for p in args.dir.glob("FUN_*.s")
                 if re.search(r"^# annotation:  machine", p.read_text(encoding="utf-8"), re.M))
    layouts, _decoded = gen.analyze_all(image, vas)
    write_manifests(image, layouts, vas, args.dir, args.batch_size, args.first_batch)
    return 0


def cmd_check(args: argparse.Namespace) -> int:
    """Regenerate every committed machine-annotated source and require identical text."""

    image = gen.load_image(args.original)
    files = sorted(args.dir.glob("FUN_*.s"))
    machine = [p for p in files if re.search(r"^# annotation:  machine", p.read_text(encoding="utf-8"), re.M)]
    vas = [int(p.stem.split("_")[1], 16) for p in machine]
    if args.sample and len(vas) > args.sample:
        step = len(vas) / args.sample
        picks = [int(i * step) for i in range(args.sample)]
        vas = [vas[i] for i in picks]
        machine = [machine[i] for i in picks]
    layouts, _decoded = gen.analyze_all(image, vas)
    annotator = Annotator(image)
    bad = [p.name for p, va in zip(machine, vas) if annotator.render(layouts[va]) + "\n" != p.read_text(encoding="utf-8")]
    print(f"checked {len(vas)} machine-annotated source(s) of {len(files)}; differing: {len(bad)}")
    for name in bad[:20]:
        print("  differs:", name)
    return 1 if bad else 0


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--original", type=Path, default=gen.ORIGINAL_DEFAULT)
    sub = parser.add_subparsers(dest="command", required=True)
    run = sub.add_parser("annotate", help="write machine-annotated .s files (and batch manifests)")
    run.add_argument("--out", type=Path, default=ASM)
    run.add_argument("--region", action="append", choices=["game", "vorbis", "crt_mfc"])
    run.add_argument("--lo", type=gen.parse_va)
    run.add_argument("--hi", type=gen.parse_va)
    run.add_argument("--exclude-manifests", action="store_true", help="skip functions already in asm/batch-*.json")
    run.add_argument("--batch-size", type=int, default=0, help="also write batch manifests of this many functions")
    run.add_argument("--first-batch", type=int, default=3)
    man = sub.add_parser("manifests", help="write batch manifests for the machine-annotated sources in a directory")
    man.add_argument("--dir", type=Path, default=ASM)
    man.add_argument("--batch-size", type=int, default=700)
    man.add_argument("--first-batch", type=int, default=3)
    chk = sub.add_parser("check", help="regenerate committed machine-annotated files and compare")
    chk.add_argument("--dir", type=Path, default=ASM)
    chk.add_argument("--sample", type=int, default=0, help="check an even sample instead of every file")
    args = parser.parse_args(argv)
    return {"annotate": cmd_annotate, "manifests": cmd_manifests, "check": cmd_check}[args.command](args)


if __name__ == "__main__":
    raise SystemExit(main())
