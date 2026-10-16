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
import importlib.util  # noqa: E402

import gen_fragments  # noqa: E402


def _private_generator() -> Any:
    """A private copy of ``gen_hinted_asm`` extended with the fragment support (owner ruling of 2026-10-16).

    The shared module is left alone so that nothing else in the process (the census, the generator's own tests)
    sees the extension.
    """

    spec = importlib.util.spec_from_file_location("gen_hinted_asm_for_annotate", Path(__file__).resolve().parent / "gen_hinted_asm.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return gen_fragments.extend(module)


gen = _private_generator()
import audit_tool_assisted as auditor  # noqa: E402

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
_SCALED_DISP = re.compile(r"\[(?P<scaled>[248]\*e[a-z]{2}) (?P<sign>[+-]) 0x(?P<mag>[0-9a-f]+)\]")
# tolerant like the auditor's header parser, so a one-space variant cannot dodge `check`
MACHINE_HEADER = re.compile(r"^#\s*annotation:\s*machine\b", re.M)
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


def counterpart(entry: Optional[dict[str, Any]]) -> Optional[tuple[str, list[str], str]]:
    """(repo path, symbols, ledger class) of the ledger's native source for a function, if it claims a counterpart.

    A symbol counts only when the file defines it (a line that starts a declaration and names it before an
    opening parenthesis), not when it merely occurs in a comment; every such symbol of the first source is listed.
    """

    if not entry or entry.get("class") not in COUNTERPART_CLASSES:
        return None
    by_path: dict[str, list[str]] = {}
    for item in entry.get("evidence", []):
        symbol, path = item.get("symbol"), item.get("path")
        if item.get("kind") == "native_source" and symbol and path and len(symbol) >= 6:
            by_path.setdefault(path, []).append(symbol)
    for path, symbols in by_path.items():
        repo_path = f"outputs/blackmoor-decomp/{path}"
        target = REPOSITORY / repo_path
        if not target.is_file():
            continue
        text = target.read_text(encoding="utf-8", errors="replace")
        defined = [s for s in dict.fromkeys(symbols)
                   if re.search(r"^[A-Za-z_][\w \t\*]*[ \t\*]" + re.escape(s) + r"[ \t]*\(", text, re.M)]
        if defined:
            return repo_path, defined, entry["class"]
    return None


def is_table_jump(ins: gen.Insn) -> bool:
    """``jmp dword ptr [4*reg + table]``: a switch dispatch, not a transfer out of the function."""

    return ins.mnem == "jmp" and gen._TABLE_JUMP.match(ins.ops) is not None


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
        elif getattr(layout, "ending", "") == "call-end" and last is layout.insns[-1]:
            parts.append(
                f"ends with {last.text} and no instruction after it in this entry; if the call returns, execution continues "
                f"in the entry at 0x{last.end:08x}, which is bound together with this one"
            )
        elif getattr(layout, "ending", "") == "fall-through" and last is layout.insns[-1]:
            parts.append(f"falls through into the entry at 0x{last.end:08x}, which is bound together with this one")
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
            first_block["insns"]) else "ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)"
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
                elif target is None and not is_table_jump(ins):
                    # an indirect or import jump out of the function: a tail transfer, not a switch
                    if name:
                        callees.append("tail jump " + name)
                    else:
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
            more = f"; also {', '.join(link[1][1:])}" if len(link[1]) > 1 else ""
            track = (f"{link[0]}:{link[1][0]} (function ledger class {link[2]}{more}; "
                     "this machine pass does not re-verify the equivalence)")
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
        if getattr(layout, "ending", "") == "call-end":
            unverified += (
                f"; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, "
                f"and the entry is counted only bound together with the range at 0x{layout.span_end:08x} that follows it "
                "(owner ruling of 2026-10-16)"
            )
        elif getattr(layout, "ending", "") == "fall-through":
            unverified += (
                f"; the code part is a fragment that falls through into 0x{layout.span_end:08x} and is counted only bound "
                "together with that range (owner ruling of 2026-10-16)"
            )
        if layout.notes and any(n.startswith("inline_table_follows:") for n in layout.notes):
            unverified += "; a jump table of the owning routine follows this code run and is generated by the composer, not by this entry"
        if entry and entry.get("class") not in COUNTERPART_CLASSES and entry.get("class") != "none":
            unverified += f"; function ledger class {entry['class']} is a native-touch record, not a counterpart claim"
        return {"name": machine_name(va), "arguments": arguments, "locals": local_text, "fields": field_text,
                "callees": callee_text, "track-n": track, "unverified": unverified}

    # -- file --------------------------------------------------------------

    @staticmethod
    def name_scaled_displacements(text: str) -> str:
        """Name base-less scaled-index displacements (``[4*eax + 0x4]``) the generator leaves numeric.

        Absolute table bases (0x400000 and up) stay numeric, as everywhere else.
        """

        lines = text.split("\n")
        start = next(i for i, line in enumerate(lines) if re.match(r"^FUN_[0-9a-f]{8}:$", line))
        end = next((i for i in range(start, len(lines)) if lines[i].startswith(".org ")), len(lines))
        names: dict[str, tuple[str, int]] = {}

        def repl(m: re.Match) -> str:
            mag = int(m.group("mag"), 16)
            if mag >= 0x400000:
                return m.group(0)
            name = gen.field_symbol("idx", m.group("sign"), mag)
            names[name] = (m.group("sign"), mag)
            return f"[{m.group('scaled')} {m.group('sign')} {name}]"

        for i in range(start, end):
            code, hash_, comment = lines[i].partition("#")
            if code.strip().startswith(".") and not code.strip().startswith(".insn"):
                continue
            renamed = _SCALED_DISP.sub(repl, code)
            if renamed != code:  # keep the generator's comment column
                renamed = "    " + renamed.strip().ljust(44) + " "
            lines[i] = renamed + hash_ + comment
        existing = {m.group(1) for line in lines if (m := re.match(r"^\.equ (\w+),", line))}
        equs = [f".equ {n}, 0x{mag:x}  # offset {sign}0x{mag:x}" for n, (sign, mag) in sorted(names.items(), key=lambda kv: kv[1][1])
                if n not in existing]
        if equs:
            anchor = next(i for i, line in enumerate(lines) if line.startswith("# --- external targets"))
            lines[anchor - 1 : anchor - 1] = equs
        return "\n".join(lines)

    def render(self, layout: gen.Layout) -> str:
        text = self.name_scaled_displacements(gen.render_file(self.image, layout))
        fields = self.fields(layout, text, gen.has_standard_frame(layout))
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


def derived_vas(image: gen.Image, layouts: dict, args: argparse.Namespace) -> list[int]:
    """Entries the span split found (code reachable only from other code, not in function-index.json)."""

    taken = indexed_in_batches() if args.exclude_manifests else set()
    return sorted(
        va for va, layout in layouts.items()
        if layout.derived and va not in taken and (not args.region or gen.region_of(va) in args.region)
        and (args.lo is None or va >= args.lo) and (args.hi is None or va < args.hi)
    )


def indexed_in_batches(below: Optional[int] = None) -> set[int]:
    """Entries held by the batch manifests (only those numbered under ``below`` when given)."""

    taken: set[int] = set()
    for path in sorted(ASM.glob("batch-[0-9]*.json")):
        if below is not None and int(path.stem.split("-")[1]) >= below:
            continue
        if not path.name.endswith("-report.json"):
            taken |= {int(f["va"], 0) for f in json.loads(path.read_text(encoding="utf-8"))["functions"]}
    return taken


def cmd_annotate(args: argparse.Namespace) -> int:
    image = gen.load_image(args.original)
    if args.fragments:
        # entries no batch holds: the indexed functions and derived entries left for the 2026-10-16 ruling
        layouts, _decoded = gen.analyze_all(image)
        auditor.apply_derived_evidence(image, layouts)
        taken = indexed_in_batches(below=args.first_batch)
        vas = sorted(va for va in layouts if va not in taken)
    elif args.derived:
        layouts, _decoded = gen.analyze_all(image)
        auditor.apply_derived_evidence(image, layouts)
        vas = derived_vas(image, layouts, args)
    else:
        vas = selected_vas(image, args)
        layouts, _decoded = gen.analyze_all(image, [va for va in vas if va in image.starts])
        auditor.apply_derived_evidence(image, layouts)
    annotator = Annotator(image)
    args.out.mkdir(parents=True, exist_ok=True)
    written, skipped = [], {}
    for va in vas:
        layout = layouts[va]
        if layout.exceptions:
            skipped[f"0x{va:08x}"] = layout.exceptions[:3]
            continue
        last = layout.insns[-1]
        if not getattr(layout, "ending", "") and not (gen.is_terminal(last) or (last.mnem == "call" and layout.data)):
            # the auditor refuses a code part that does not end in a terminal instruction (open question for the owner)
            skipped[f"0x{va:08x}"] = [f"code part ends in {last.mnem}, not a terminal ret/jmp"]
            continue
        target = args.out / f"FUN_{va:08x}.s"
        if target.is_file() and not MACHINE_HEADER.search(target.read_text(encoding="utf-8")):
            skipped[f"0x{va:08x}"] = ["existing hand-annotated source is never overwritten"]
            continue
        target.write_text(annotator.render(layout) + "\n", encoding="utf-8")
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
            "audited by scripts/audit_tool_assisted.py; no claim about original C++ or compiler provenance."
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
                 if MACHINE_HEADER.search(p.read_text(encoding="utf-8")))
    layouts, _decoded = gen.analyze_all(image, [va for va in vas if va in image.starts])
    auditor.apply_derived_evidence(image, layouts)
    write_manifests(image, layouts, vas, args.dir, args.batch_size, args.first_batch)
    return 0


def cmd_check(args: argparse.Namespace) -> int:
    """Regenerate every committed machine-annotated source and require identical text."""

    image = gen.load_image(args.original)
    files = sorted(args.dir.glob("FUN_*.s"))
    machine = [p for p in files if MACHINE_HEADER.search(p.read_text(encoding="utf-8"))]
    vas = [int(p.stem.split("_")[1], 16) for p in machine]
    if args.sample and len(vas) > args.sample:
        step = len(vas) / args.sample
        picks = [int(i * step) for i in range(args.sample)]
        vas = [vas[i] for i in picks]
        machine = [machine[i] for i in picks]
    layouts, _decoded = gen.analyze_all(image, [va for va in vas if va in image.starts])
    auditor.apply_derived_evidence(image, layouts)
    annotator = Annotator(image)
    # The track-n line follows the function ledger, which every slice refreshes; it is excluded here and
    # validated by the auditor (the file must exist and define the symbol), so a ledger refresh does not
    # force a re-annotation and re-audit of thousands of sources.
    track = re.compile(r"^# track-n:.*$", re.M)
    # the same holds for the ledger-class clause of the unverified line (it names the class the ledger had when the
    # source was annotated; a later ledger refresh can change it without touching a single instruction)
    clause = re.compile(r"; function ledger class \w+ is a native-touch record, not a counterpart claim")

    def normal(text: str) -> str:
        return clause.sub("", track.sub("# track-n:", text))

    bad = [p.name for p, va in zip(machine, vas)
           if normal(annotator.render(layouts[va]) + "\n") != normal(p.read_text(encoding="utf-8"))]
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
    run.add_argument("--derived", action="store_true", help="annotate the derived entries (found by the span split) instead of the indexed functions")
    run.add_argument("--fragments", action="store_true", help="annotate every entry that no batch holds (the 2026-10-16 ruling: call endings, fall-through fragments, block-copy code runs)")
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
