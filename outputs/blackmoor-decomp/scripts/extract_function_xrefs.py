#!/usr/bin/env python3
"""Derive ``function-xrefs.json`` for the function ledger (packet FL-3).

For each of the 4,188 starts in ``function-index.json`` this records, from the
owner's local ``GAME.EXE`` and the private Ghidra census dump only:

* region (``layout.json`` code bands), span, Ghidra body size, M03 code size and
  derived parts (code the span split finds after a function's last reachable
  instruction);
* direct callers/callees (VA pairs at function-start level; an edge from a
  derived part belongs to the containing indexed function), tail jumps out of
  the span, imported API names referenced, indirect call counts;
* data references to the entry or a derived part (aligned and unaligned dwords
  in the non-code sections), immediate address references in code
  (``code_addr_refs``) and the derived ``address_taken`` flag;
* import thunks (``jmp dword ptr [IAT slot]``) and jump thunks (lone
  ``jmp rel32``), each with the indexed function whose span contains it;
* C++ exception funclets: ``__ehhandler`` stubs (``mov eax, FuncInfo; jmp``)
  whose FuncInfo (magic 0x19930520) names the unwind actions and catch
  handlers; the parent is the function whose code references the stub;
* ``origin`` (game|library|compiler_eh|import_thunk|unknown), set only from
  structural evidence (see ``classify_origin``); names are never consulted;
* ``reach`` (static reachability from the CRT entry, game code and
  address-taken functions) and ``reaches_game``;
* ``fingerprints`` from a closed vocabulary (``lcg_rand``, ``x87_ftol``).

Everything published is an address, count, hash, imported API name or enum; no
original bytes and no game strings.  ``--write`` regenerates, ``--check``
re-derives from the pinned inputs and fails (exit 1, "stale") on any
difference.

Schema ``blackmoor-function-xrefs/1`` (FL-1 validates it with ``validate``):

top level
  schema, original_sha256, inputs [{path, sha256, role}], tools (informational,
  ignored by --check), parameters {seam_distance, boundaries}, regions
  [{id, start_va, end_va}], roots {image_base, entry_point, entry_function},
  counts, imports [ "DLL!Name" ... ] (the import table), thunks, eh_stubs,
  derived_parts, entries.
thunks[]      {va, size, kind: import|jump, import|target, container, ghidra_thunk}
eh_stubs[]    {va, container, funcinfo, owners}
derived_parts[] {va, parent, size, kind, direct_refs (call/jump sites outside the parent span), data_refs, code_addr_refs}
entries[]     one per indexed start, sorted by VA, one JSON object per line,
              fields exactly ``ENTRY_FIELDS``:
  va ("0x%08x"), name (Ghidra label, informational only), region, span,
  body_size (Ghidra, or null), code_size (M03 code bytes of the entry's own
  part, null when the span is unsplit), analysis_complete (false for the two
  unsplit spans: edges are a linear-sweep over-approximation, never proof),
  derived_parts [va], contains_thunks [va], thunk (the entry itself is a lone
  jump), std_frame (starts push ebp; mov ebp, esp), seam, origin, origin_basis,
  callers, callees, tail_callees (callees reached by jmp/jcc leaving the span),
  indirect_calls, indirect_jumps (non-switch), imports ["DLL!Name"],
  data_refs, data_refs_unaligned, has_data_ref (data_refs > 0), code_addr_refs,
  address_taken (any of the three > 0), eh_kind (unwind|catch|null), eh_parent,
  eh_parents, eh_parent_region, eh_funclets, fingerprints, reach, reaches_game.

Rule predicates (``RULE_PREDICATES``) implement the machine-checkable
preconditions of the candidate ``not_needed_rules`` in
``function-ledger-overrides.json``; conditions that need ledger state (src
mentions, receipts, parent status, accepted sample review) stay with FL-1.
"""

from __future__ import annotations

import argparse
import bisect
import collections
import hashlib
import importlib.util
import json
import re
import struct
import subprocess
import sys
from pathlib import Path
from typing import Any, Optional

SCRIPTS = Path(__file__).resolve().parent
PROJECT = SCRIPTS.parent
REPO = PROJECT.parents[1]

SCHEMA = "blackmoor-function-xrefs/1"
ORIGINAL_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
SEAM_DISTANCE = 0x400
FUNCINFO_MAGIC = 0x19930520
ORIGINS = ("game", "library", "compiler_eh", "import_thunk", "unknown")
REACH = ("entry", "game", "unknown_origin", "address_taken", "reachable", "unreached")
FINGERPRINTS = ("lcg_rand", "x87_ftol")
DERIVED_KINDS = ("import_thunk", "jump_thunk", "eh_handler_stub", "eh_funclet", "fallthrough_fragment", "code")

ENTRY_FIELDS = (
    "va", "name", "region", "span", "body_size", "code_size", "analysis_complete", "derived_parts",
    "contains_thunks", "thunk", "std_frame", "seam", "origin", "origin_basis", "callers", "callees",
    "tail_callees", "indirect_calls", "indirect_jumps", "imports", "data_refs", "data_refs_unaligned",
    "has_data_ref", "code_addr_refs", "address_taken", "eh_kind", "eh_parent", "eh_parents",
    "eh_parent_region", "eh_funclets", "fingerprints", "reach", "reaches_game",
)

_HEX = re.compile(r"0x([0-9a-f]+)")
_VA = re.compile(r"^0x[0-9a-f]{8}$")
_SHA = re.compile(r"^[0-9a-f]{64}$")
_IMPORT_NAME = re.compile(r"^[A-Za-z0-9_.@?$#-]+![A-Za-z0-9_.@?$#-]+$")


def _load_gen():
    existing = sys.modules.get("gen_hinted_asm")
    if existing is not None and hasattr(existing, "analyze_all"):
        return existing
    spec = importlib.util.spec_from_file_location("gen_hinted_asm", SCRIPTS / "gen_hinted_asm.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules["gen_hinted_asm"] = module
    spec.loader.exec_module(module)
    return module


def hx(value: int) -> str:
    return f"0x{value:08x}"


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


# ---------------------------------------------------------------------------
# PE facts
# ---------------------------------------------------------------------------


class PE:
    """Sections, entry point and import table of the original (read only)."""

    def __init__(self, data: bytes) -> None:
        self.data = data
        pe = struct.unpack_from("<I", data, 0x3C)[0]
        nsec = struct.unpack_from("<H", data, pe + 6)[0]
        opt_size = struct.unpack_from("<H", data, pe + 20)[0]
        opt = pe + 24
        self.entry_rva = struct.unpack_from("<I", data, opt + 16)[0]
        self.image_base = struct.unpack_from("<I", data, opt + 28)[0]
        self.dirs = [struct.unpack_from("<II", data, opt + 96 + 8 * i) for i in range(16)]
        self.sections: list[dict[str, Any]] = []
        table = opt + opt_size
        for i in range(nsec):
            name, vsize, rva, rsize, rptr = struct.unpack_from("<8sIIII", data, table + 40 * i)
            self.sections.append(
                {"name": name.rstrip(b"\0").decode("ascii", "replace"), "va": self.image_base + rva,
                 "size": min(vsize, rsize), "rptr": rptr}
            )

    @property
    def entry_va(self) -> int:
        return self.image_base + self.entry_rva

    def read(self, va: int, size: int) -> Optional[bytes]:
        for sec in self.sections:
            if sec["va"] <= va and va + size <= sec["va"] + sec["size"]:
                o = sec["rptr"] + va - sec["va"]
                return self.data[o : o + size]
        return None

    def u32(self, va: int) -> Optional[int]:
        raw = self.read(va, 4)
        return struct.unpack("<I", raw)[0] if raw else None

    def cstring(self, va: int, limit: int = 256) -> Optional[str]:
        out = bytearray()
        for i in range(limit):
            b = self.read(va + i, 1)
            if b is None:
                return None
            if b == b"\0":
                return out.decode("ascii", "replace")
            out += b
        return None

    def imports(self) -> dict[int, str]:
        """IAT slot VA -> ``DLL!Name`` (``DLL!#n`` for ordinals)."""

        slots: dict[int, str] = {}
        rva, size = self.dirs[1]
        if not rva:
            return slots
        va = self.image_base + rva
        while True:
            raw = self.read(va, 20)
            if raw is None:
                break
            oft, _, _, name_rva, ft = struct.unpack("<IIIII", raw)
            if not (oft or name_rva or ft):
                break
            dll = self.cstring(self.image_base + name_rva) or "?"
            thunks = self.image_base + (oft or ft)
            i = 0
            while True:
                entry = self.u32(thunks + 4 * i)
                if not entry:
                    break
                if entry & 0x80000000:
                    name = f"#{entry & 0xFFFF}"
                else:
                    name = self.cstring(self.image_base + entry + 2) or "?"
                slots[self.image_base + ft + 4 * i] = f"{dll}!{name}"
                i += 1
            va += 20
        return slots

    def data_blobs(self) -> list[tuple[int, bytes]]:
        out = []
        for sec in self.sections:
            if sec["name"] in (".text", ".rsrc"):
                continue
            out.append((sec["va"], self.data[sec["rptr"] : sec["rptr"] + sec["size"]]))
        return out


# ---------------------------------------------------------------------------
# Derivation
# ---------------------------------------------------------------------------


def load_regions(layout_path: Path) -> list[dict[str, Any]]:
    layout = json.loads(layout_path.read_text(encoding="utf-8"))
    regions = [{"id": r["id"], "start_va": int(r["start_va"]), "end_va": int(r["end_va"])} for r in layout["code_regions"]]
    regions.sort(key=lambda r: r["start_va"])
    return regions


def load_ghidra(path: Path) -> dict[int, dict[str, Any]]:
    rows: dict[int, dict[str, Any]] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            row = json.loads(line)
            rows[int(row["addr"], 16)] = row
    return rows


def display_path(path: Path, display_paths: Optional[dict[Path, str]]) -> str:
    if display_paths and path in display_paths:
        return display_paths[path]
    for candidate in (path, path.resolve()):
        for root in (REPO, REPO.resolve()):
            try:
                return str(candidate.relative_to(root))
            except ValueError:
                continue
    return path.name


def derive(
    original: Path,
    index: Path,
    layout: Path,
    ghidra: Path,
    expected_sha256: str = ORIGINAL_SHA256,
    strict: bool = True,
    seam_distance: int = SEAM_DISTANCE,
    display_paths: Optional[dict[Path, str]] = None,
) -> dict[str, Any]:
    gen = _load_gen()
    image = gen.load_image(original, index, expected_sha256, strict)
    pe = PE(original.read_bytes())
    regions = load_regions(layout)
    ghidra_rows = load_ghidra(ghidra)
    index_doc = json.loads(index.read_text(encoding="utf-8"))
    names = {int(f["address"], 16): f["name"] for f in index_doc["functions"]}
    starts = sorted(image.starts)
    start_set = set(starts)
    text_lo, text_hi = image.base, image.end

    def owner(addr: int) -> int:
        return starts[bisect.bisect_right(starts, addr) - 1]

    def region_of(addr: int) -> str:
        for r in regions:
            if r["start_va"] <= addr < r["end_va"]:
                return r["id"]
        raise SystemExit(f"0x{addr:08x} is outside every code region")

    boundaries = [r["start_va"] for r in regions[1:]]
    slots = pe.imports()
    import_names = sorted(set(slots.values()))

    layouts, decoded = gen.analyze_all(image)
    derived = sorted(v for v, l in layouts.items() if l.derived)
    part_set = start_set | set(derived)

    # ---- per layout facts -------------------------------------------------
    def span_bounds(s: int) -> tuple[int, int]:
        return image.span(s)

    insns_by_owner: dict[int, list[tuple[Any, Any]]] = collections.defaultdict(list)  # owner -> [(layout, insn)]
    incomplete: set[int] = set()
    for v, lay in layouts.items():
        o = owner(v)
        if lay.exceptions:
            incomplete.add(o)
            lo, hi = span_bounds(o) if not lay.derived else (v, lay.span_end)
            for ins in _linear(decoded, lo, hi):
                insns_by_owner[o].append((lay, ins))
        else:
            for ins in lay.insns:
                insns_by_owner[o].append((lay, ins))

    callees: dict[int, set[int]] = collections.defaultdict(set)
    tails: dict[int, set[int]] = collections.defaultdict(set)
    direct_refs: dict[int, int] = collections.Counter()  # derived part -> refs from other spans
    imports_of: dict[int, set[str]] = collections.defaultdict(set)
    indirect_calls: dict[int, int] = collections.Counter()
    indirect_jumps: dict[int, int] = collections.Counter()
    code_addr_refs: dict[int, int] = collections.Counter()  # owner -> immediate refs to its entry/parts
    code_addr_by_part: dict[int, int] = collections.Counter()
    tokens_of: dict[int, set[int]] = collections.defaultdict(set)
    mnems_of: dict[int, set[str]] = collections.defaultdict(set)
    stub_ref_sites: dict[int, set[int]] = collections.defaultdict(set)  # hex constant -> owners (resolved later)
    constants_to_owner: dict[int, set[int]] = collections.defaultdict(set)

    for o, items in insns_by_owner.items():
        for lay, ins in items:
            mnems_of[o].add(ins.mnem)
            target = gen.direct_target(ins)
            tokens = [int(t, 16) for t in _HEX.findall(ins.ops)]
            tokens_of[o].update(tokens)
            if target is not None:
                if text_lo <= target < text_hi:
                    t_owner = owner(target)
                    if t_owner != o:
                        callees[o].add(t_owner)
                        if ins.mnem != "call":
                            tails[o].add(t_owner)
                        if target in part_set and target not in start_set:
                            direct_refs[target] += 1
                continue
            hit_slots = [t for t in tokens if t in slots]
            for t in hit_slots:
                imports_of[o].add(slots[t])
            if ins.mnem in ("call", "jmp") and target is None:
                if hit_slots:
                    continue
                if ins.mnem == "call":
                    indirect_calls[o] += 1
                elif not _is_switch_jump(gen, lay, ins):
                    indirect_jumps[o] += 1
            for t in tokens:
                if t in part_set:
                    code_addr_by_part[t] += 1
                    code_addr_refs[owner(t)] += 1
                constants_to_owner[t].add(o)

    # ---- data references --------------------------------------------------
    data_refs: dict[int, int] = collections.Counter()
    data_unaligned: dict[int, int] = collections.Counter()
    data_by_part: dict[int, int] = collections.Counter()
    blobs = pe.data_blobs()
    for target in sorted(part_set):
        pattern = struct.pack("<I", target)
        for base, blob in blobs:
            pos = blob.find(pattern)
            while pos != -1:
                if (base + pos) % 4 == 0:
                    data_refs[owner(target)] += 1
                    data_by_part[target] += 1
                else:
                    data_unaligned[owner(target)] += 1
                pos = blob.find(pattern, pos + 1)

    # ---- thunks and derived parts ----------------------------------------
    def lone_jump(lay) -> Optional[tuple[str, Any]]:
        if lay.exceptions or len(lay.insns) != 1:
            return None
        ins = lay.insns[0]
        if ins.mnem != "jmp":
            return None
        slot_hits = [int(t, 16) for t in _HEX.findall(ins.ops) if int(t, 16) in slots]
        if slot_hits and ins.ops.startswith("dword ptr ["):
            return "import", slots[slot_hits[0]]
        target = gen.direct_target(ins)
        if target is not None:
            return "jump", target
        return None

    thunk_rows: list[dict[str, Any]] = []
    thunk_of: dict[int, str] = {}
    for v in sorted(layouts):
        lay = layouts[v]
        found = lone_jump(lay)
        if found is None:
            continue
        kind, what = found
        thunk_of[v] = kind
        row: dict[str, Any] = {"va": hx(v), "size": lay.code_size, "kind": kind}
        if kind == "import":
            row["import"] = what
        else:
            row["target"] = hx(what)
        row["container"] = hx(owner(v))
        row["ghidra_thunk"] = bool(ghidra_rows.get(v, {}).get("thunk"))
        thunk_rows.append(row)
    ghidra_thunk_vas = {a for a, r in ghidra_rows.items() if r.get("thunk")}

    # ---- exception handling ----------------------------------------------
    stubs: dict[int, int] = {}  # stub va -> FuncInfo va
    for v, lay in layouts.items():
        if lay.exceptions or len(lay.insns) != 2:
            continue
        first, second = lay.insns
        if first.mnem == "mov" and first.raw[:1] == b"\xb8" and len(first.raw) == 5 and second.raw[:1] == b"\xe9":
            funcinfo = struct.unpack_from("<I", first.raw, 1)[0]
            if pe.u32(funcinfo) == FUNCINFO_MAGIC:
                stubs[v] = funcinfo
    stub_owners: dict[int, set[int]] = {s: set(constants_to_owner.get(s, ())) - {owner(s)} for s in stubs}
    funclet_roles: dict[int, dict[str, set[int]]] = collections.defaultdict(lambda: {"unwind": set(), "catch": set()})
    funclet_info: dict[int, set[int]] = collections.defaultdict(set)
    eh_errors = 0
    for stub, funcinfo in sorted(stubs.items()):
        owners = stub_owners[stub]
        if not owners:
            continue
        max_state, unwind_map, n_try, try_map = (pe.u32(funcinfo + 4 * k) for k in (1, 2, 3, 4))
        if None in (max_state, unwind_map, n_try, try_map) or max_state > 4096 or n_try > 4096:
            eh_errors += 1
            continue
        for state in range(max_state):
            action = pe.u32(unwind_map + 8 * state + 4)
            if action:
                funclet_roles[action]["unwind"].update(owners)
                funclet_info[action].add(funcinfo)
        for k in range(n_try):
            n_catch, handlers = pe.u32(try_map + 20 * k + 12), pe.u32(try_map + 20 * k + 16)
            if n_catch is None or handlers is None or n_catch > 4096:
                eh_errors += 1
                continue
            for c in range(n_catch):
                addr = pe.u32(handlers + 16 * c + 12)
                if addr:
                    funclet_roles[addr]["catch"].update(owners)
                    funclet_info[addr].add(funcinfo)
    funclet_kind: dict[int, str] = {}
    funclet_parents: dict[int, list[int]] = {}
    eh_conflicts = 0
    for f, roles in funclet_roles.items():
        if f not in part_set:
            eh_errors += 1
            continue
        if roles["unwind"] and roles["catch"]:
            eh_conflicts += 1
            continue
        kind = "unwind" if roles["unwind"] else "catch"
        funclet_kind[f] = kind
        funclet_parents[f] = sorted({owner(p) for p in roles[kind]})

    # ---- derived part table -----------------------------------------------
    derived_rows = []
    for v in derived:
        lay = layouts[v]
        if v in stubs:
            kind = "eh_handler_stub"
        elif v in thunk_of:
            kind = f"{thunk_of[v]}_thunk"
        elif v in funclet_kind:
            kind = "eh_funclet"
        elif lay.falls_through:
            kind = "fallthrough_fragment"
        else:
            kind = "code"
        derived_rows.append(
            {"va": hx(v), "parent": hx(owner(v)), "size": lay.code_size, "kind": kind,
             "direct_refs": direct_refs.get(v, 0), "data_refs": data_by_part.get(v, 0),
             "code_addr_refs": code_addr_by_part.get(v, 0)}
        )
    derived_of: dict[int, list[int]] = collections.defaultdict(list)
    for v in derived:
        derived_of[owner(v)].append(v)
    stub_rows = [
        {"va": hx(s), "container": hx(owner(s)), "funcinfo": hx(f), "owners": [hx(owner(x)) for x in sorted(stub_owners[s])]}
        for s, f in sorted(stubs.items())
        if stub_owners[s]
    ]

    # ---- fingerprints -----------------------------------------------------
    def fingerprints(o: int) -> list[str]:
        out = []
        if {0x343FD, 0x269EC3} <= tokens_of[o]:
            out.append("lcg_rand")
        if {"fnstcw", "fldcw", "fistp"} <= mnems_of[o]:
            out.append("x87_ftol")
        return out

    # ---- entries ----------------------------------------------------------
    region = {s: region_of(s) for s in starts}
    seam = {s: any(abs(s - b) <= seam_distance for b in boundaries) for s in starts}
    callers: dict[int, set[int]] = collections.defaultdict(set)
    for s, ts in callees.items():
        for t in ts:
            callers[t].add(s)
    funclets_of: dict[int, list[int]] = collections.defaultdict(list)
    for f, parents in funclet_parents.items():
        if f in start_set:
            for p in parents:
                funclets_of[p].append(f)

    def std_frame(s: int) -> bool:
        ins = layouts[s].insns
        return len(ins) > 1 and ins[0].text == "push ebp" and ins[1].text == "mov ebp, esp"

    def classify_origin(s: int) -> tuple[str, str]:
        if s in funclet_kind and s in start_set:
            return "compiler_eh", "eh_funclet_funcinfo"
        if s in stubs:
            return "compiler_eh", "eh_handler_stub"
        if thunk_of.get(s) == "import":
            return "import_thunk", "lone_iat_jump"
        game = region[s] == "game"
        if not game and any(region[t] == "game" for t in callees.get(s, ())):
            return "unknown", "contradiction_library_calls_game"
        if game and not std_frame(s):
            return "unknown", "game_band_without_standard_frame"
        kind = "game" if game else "library"
        if seam[s]:
            ok = any(
                n != s and not seam[n] and (region[n] == "game" if game else region[n] == region[s])
                for n in callers.get(s, set()) | callees.get(s, set())
            )
            if not ok:
                return "unknown", "seam_uncorroborated"
            return kind, f"band_{kind}_seam_corroborated"
        return kind, f"band_{kind}"

    origin: dict[int, tuple[str, str]] = {s: classify_origin(s) for s in starts}

    # reachability
    entry_fn = owner(pe.entry_va)
    edges: dict[int, set[int]] = {s: set(callees.get(s, ())) for s in starts}
    for p, fs in funclets_of.items():
        edges[p].update(fs)
    reach: dict[int, str] = {}
    for s in starts:
        o = origin[s][0]
        addr_taken = (data_refs.get(s, 0) + data_unaligned.get(s, 0) + code_addr_refs.get(s, 0)) > 0
        if s == entry_fn:
            reach[s] = "entry"
        elif o == "game":
            reach[s] = "game"
        elif o == "unknown":
            reach[s] = "unknown_origin"
        elif addr_taken and o != "compiler_eh":
            reach[s] = "address_taken"
    stack = list(reach)
    seen = set(reach)
    while stack:
        cur = stack.pop()
        for t in edges[cur]:
            if t not in seen:
                seen.add(t)
                reach[t] = "reachable"
                stack.append(t)
    for s in starts:
        reach.setdefault(s, "unreached")

    # reaches_game: some game-origin function is reachable through >= 1 direct edges
    reverse: dict[int, set[int]] = collections.defaultdict(set)
    for s, ts in callees.items():
        for t in ts:
            reverse[t].add(s)
    reaches: set[int] = set()
    stack = [p for g in starts if origin[g][0] == "game" for p in reverse.get(g, ())]
    while stack:
        cur = stack.pop()
        if cur in reaches:
            continue
        reaches.add(cur)
        stack.extend(reverse.get(cur, ()))

    entries = []
    for s in starts:
        lay = layouts[s]
        complete = s not in incomplete
        parents = funclet_parents.get(s, []) if s in funclet_kind else []
        body = ghidra_rows.get(s, {}).get("size")
        entry = {
            "va": hx(s),
            "name": names[s],
            "region": region[s],
            "span": image.span(s)[1] - s,
            "body_size": body,
            "code_size": lay.code_size if complete else None,
            "analysis_complete": complete,
            "derived_parts": [hx(v) for v in derived_of.get(s, [])],
            "contains_thunks": [hx(v) for v in derived_of.get(s, []) if v in thunk_of],
            "thunk": s in thunk_of,
            "std_frame": std_frame(s),
            "seam": seam[s],
            "origin": origin[s][0],
            "origin_basis": origin[s][1],
            "callers": [hx(x) for x in sorted(callers.get(s, ()))],
            "callees": [hx(x) for x in sorted(callees.get(s, ()))],
            "tail_callees": [hx(x) for x in sorted(tails.get(s, ()))],
            "indirect_calls": indirect_calls.get(s, 0),
            "indirect_jumps": indirect_jumps.get(s, 0),
            "imports": sorted(imports_of.get(s, ())),
            "data_refs": data_refs.get(s, 0),
            "data_refs_unaligned": data_unaligned.get(s, 0),
            "has_data_ref": data_refs.get(s, 0) > 0,
            "code_addr_refs": code_addr_refs.get(s, 0),
            "address_taken": (data_refs.get(s, 0) + data_unaligned.get(s, 0) + code_addr_refs.get(s, 0)) > 0,
            "eh_kind": funclet_kind.get(s),
            "eh_parent": hx(parents[0]) if len(parents) == 1 else None,
            "eh_parents": [hx(p) for p in parents],
            "eh_parent_region": region[parents[0]] if len(parents) == 1 else None,
            "eh_funclets": [hx(f) for f in sorted(funclets_of.get(s, ()))],
            "fingerprints": fingerprints(s),
            "reach": reach[s],
            "reaches_game": s in reaches,
        }
        entries.append(entry)

    inputs = [
        {"path": display_path(original, display_paths) if display_paths and original in display_paths else "GAME.EXE",
         "sha256": hashlib.sha256(original.read_bytes()).hexdigest(), "role": "original"},
        {"path": display_path(index, display_paths), "sha256": sha256_file(index), "role": "function_index"},
        {"path": display_path(layout, display_paths), "sha256": sha256_file(layout), "role": "layout"},
        {"path": display_path(ghidra, display_paths), "sha256": sha256_file(ghidra), "role": "ghidra_census"},
        {"path": "outputs/blackmoor-decomp/scripts/gen_hinted_asm.py", "sha256": sha256_file(Path(gen.__file__)), "role": "span_split_tool"},
    ]
    doc: dict[str, Any] = {
        "schema": SCHEMA,
        "original_sha256": expected_sha256,
        "inputs": inputs,
        "tools": {"disassembler": _objdump_version(gen), "note": "informational; ignored by --check"},
        "parameters": {"seam_distance": seam_distance, "boundaries": [hx(b) for b in boundaries]},
        "regions": [{"id": r["id"], "start_va": hx(r["start_va"]), "end_va": hx(r["end_va"])} for r in regions],
        "roots": {"image_base": hx(pe.image_base), "entry_point": hx(pe.entry_va), "entry_function": hx(entry_fn)},
        "imports": import_names,
        "thunks": thunk_rows,
        "eh_stubs": stub_rows,
        "derived_parts": derived_rows,
        "entries": entries,
    }
    doc["counts"] = compute_counts(doc)
    doc["counts"]["thunks_not_flagged_by_ghidra"] = sum(1 for t in thunk_rows if not t["ghidra_thunk"])
    doc["counts"]["ghidra_thunks_not_listed"] = len(ghidra_thunk_vas - {int(t["va"], 16) for t in thunk_rows})
    doc["counts"]["eh_conflicts"] = eh_conflicts
    doc["counts"]["eh_unresolved"] = eh_errors
    doc["counts"]["stubs_without_owner"] = sum(1 for s in stubs if not stub_owners[s])
    doc = _order(doc)
    return doc


def _order(doc: dict[str, Any]) -> dict[str, Any]:
    order = ["schema", "original_sha256", "inputs", "tools", "parameters", "regions", "roots", "counts", "imports",
             "thunks", "eh_stubs", "derived_parts", "entries"]
    return {k: doc[k] for k in order}


def _objdump_version(gen) -> str:
    try:
        out = subprocess.run(gen.find_objdump() + ["--version"], capture_output=True, text=True, check=True).stdout
        for line in out.splitlines():
            if "version" in line.lower():
                return line.strip()
    except (OSError, subprocess.CalledProcessError):
        pass
    return "unknown"


def _linear(decoded, lo: int, hi: int):
    """Linear sweep of a span the splitter could not model (over-approximation)."""

    cur = lo
    while cur < hi:
        ins = decoded.get(cur)
        if ins is None:
            cur += 1
            continue
        yield ins
        cur = ins.end


def _is_switch_jump(gen, lay, ins) -> bool:
    m = gen._TABLE_JUMP.match(ins.ops)
    if not m:
        return False
    table = int(m.group(3), 16)
    return any(item.kind == "switch_table" and item.va == table for item in lay.data)


def compute_counts(doc: dict[str, Any]) -> dict[str, Any]:
    entries = doc["entries"]
    counts: dict[str, Any] = {
        "entries": len(entries),
        "span_bytes": sum(e["span"] for e in entries),
        "origin": {o: sum(1 for e in entries if e["origin"] == o) for o in ORIGINS},
        "region": dict(sorted(collections.Counter(e["region"] for e in entries).items())),
        "origin_by_region": {
            r: {o: sum(1 for e in entries if e["region"] == r and e["origin"] == o) for o in ORIGINS}
            for r in sorted({e["region"] for e in entries})
        },
        "eh_funclets": {k: sum(1 for e in entries if e["eh_kind"] == k) for k in ("unwind", "catch")},
        "eh_funclets_by_parent_region": {
            k: dict(sorted(collections.Counter(e["eh_parent_region"] for e in entries if e["eh_kind"] == k).items(), key=lambda kv: str(kv[0])))
            for k in ("unwind", "catch")
        },
        "thunks": {
            "total": len(doc["thunks"]),
            "import": sum(1 for t in doc["thunks"] if t["kind"] == "import"),
            "jump": sum(1 for t in doc["thunks"] if t["kind"] == "jump"),
        },
        "eh_stubs": len(doc["eh_stubs"]),
        "derived_parts": {
            "total": len(doc["derived_parts"]),
            **{k: sum(1 for d in doc["derived_parts"] if d["kind"] == k) for k in DERIVED_KINDS},
        },
        "reach": {r: sum(1 for e in entries if e["reach"] == r) for r in REACH},
        "seam": sum(1 for e in entries if e["seam"]),
        "analysis_incomplete": sum(1 for e in entries if not e["analysis_complete"]),
        "address_taken": sum(1 for e in entries if e["address_taken"]),
        "reaches_game": sum(1 for e in entries if e["reaches_game"]),
        "edges": sum(len(e["callees"]) for e in entries),
        "functions_with_imports": sum(1 for e in entries if e["imports"]),
    }
    return counts


# ---------------------------------------------------------------------------
# Serialisation
# ---------------------------------------------------------------------------


def dump(doc: dict[str, Any]) -> str:
    lines = ["{"]
    keys = list(doc)
    for n, key in enumerate(keys):
        value = doc[key]
        comma = "," if n < len(keys) - 1 else ""
        if isinstance(value, list) and value and isinstance(value[0], dict):
            lines.append(f' "{key}": [')
            for j, item in enumerate(value):
                lines.append("  " + json.dumps(item) + ("," if j < len(value) - 1 else ""))
            lines.append(" ]" + comma)
        elif isinstance(value, (dict, list)):
            body = json.dumps(value, indent=1).splitlines()
            lines.append(f' "{key}": ' + body[0])
            lines.extend(" " + b for b in body[1:])
            lines[-1] += comma
        else:
            lines.append(f' "{key}": ' + json.dumps(value) + comma)
    lines.append("}")
    return "\n".join(lines) + "\n"


# ---------------------------------------------------------------------------
# Validation (strict; FL-1 imports this)
# ---------------------------------------------------------------------------


def validate(doc: dict[str, Any]) -> list[str]:
    err: list[str] = []
    if not isinstance(doc, dict) or doc.get("schema") != SCHEMA:
        return ["schema is not " + SCHEMA]
    for key in ("original_sha256", "inputs", "parameters", "regions", "roots", "counts", "imports", "thunks", "eh_stubs", "derived_parts", "entries"):
        if key not in doc:
            err.append(f"missing top-level {key}")
    if err:
        return err
    if not _SHA.match(str(doc["original_sha256"])):
        err.append("original_sha256 is not a SHA-256")
    for item in doc["inputs"]:
        if not (_SHA.match(str(item.get("sha256", ""))) and item.get("role") and item.get("path")):
            err.append(f"bad input {item}")
        if str(item.get("path", "")).startswith("/") or "\\" in str(item.get("path", "")):
            err.append(f"absolute path in inputs: {item.get('path')}")
    entries = doc["entries"]
    vas = [e.get("va") for e in entries]
    if vas != sorted(set(vas)):
        err.append("entries are not unique and sorted by VA")
    by_va = {e["va"]: e for e in entries if "va" in e}
    region_ids = {r["id"] for r in doc["regions"]}
    for e in entries:
        if set(e) != set(ENTRY_FIELDS):
            err.append(f"{e.get('va')}: fields differ from ENTRY_FIELDS: {sorted(set(e) ^ set(ENTRY_FIELDS))}")
            continue
        va = e["va"]
        if not _VA.match(va):
            err.append(f"{va}: bad va")
        if e["origin"] not in ORIGINS:
            err.append(f"{va}: bad origin {e['origin']}")
        if e["region"] not in region_ids:
            err.append(f"{va}: bad region")
        if e["reach"] not in REACH:
            err.append(f"{va}: bad reach")
        if not isinstance(e["span"], int) or e["span"] <= 0:
            err.append(f"{va}: bad span")
        for key in ("callers", "callees", "tail_callees", "derived_parts", "contains_thunks", "eh_parents", "eh_funclets"):
            seq = e[key]
            if seq != sorted(set(seq)) or not all(_VA.match(x) for x in seq):
                err.append(f"{va}: {key} is not a sorted unique VA list")
        for key in ("imports", "fingerprints"):
            if e[key] != sorted(set(e[key])):
                err.append(f"{va}: {key} not sorted unique")
        for name in e["imports"]:
            if not _IMPORT_NAME.match(name):
                err.append(f"{va}: bad import name")
        for name in e["fingerprints"]:
            if name not in FINGERPRINTS:
                err.append(f"{va}: bad fingerprint {name}")
        if not set(e["tail_callees"]) <= set(e["callees"]):
            err.append(f"{va}: tail_callees not a subset of callees")
        for t in e["callees"]:
            if t not in by_va:
                err.append(f"{va}: callee {t} is not an entry")
            elif va not in by_va[t]["callers"]:
                err.append(f"{va}: callee {t} does not list it as a caller")
        for s in e["callers"]:
            if s not in by_va:
                err.append(f"{va}: caller {s} is not an entry")
            elif va not in by_va[s]["callees"]:
                err.append(f"{va}: caller {s} does not list it as a callee")
        if e["has_data_ref"] != (e["data_refs"] > 0):
            err.append(f"{va}: has_data_ref disagrees with data_refs")
        if e["address_taken"] != (e["data_refs"] + e["data_refs_unaligned"] + e["code_addr_refs"] > 0):
            err.append(f"{va}: address_taken disagrees with the counts")
        if e["eh_kind"] is not None:
            if e["eh_kind"] not in ("unwind", "catch") or not e["eh_parents"]:
                err.append(f"{va}: eh_kind without parents")
            if e["eh_parent"] != (e["eh_parents"][0] if len(e["eh_parents"]) == 1 else None):
                err.append(f"{va}: eh_parent disagrees with eh_parents")
            if e["origin"] != "compiler_eh" and e["eh_kind"]:
                err.append(f"{va}: funclet with origin {e['origin']}")
            for p in e["eh_parents"]:
                if p in by_va and va not in by_va[p]["eh_funclets"]:
                    err.append(f"{va}: parent {p} does not list the funclet")
            if e["eh_parent"] and e["eh_parent_region"] != by_va.get(e["eh_parent"], {}).get("region"):
                err.append(f"{va}: eh_parent_region wrong")
        elif e["eh_parent"] or e["eh_parents"] or e["eh_parent_region"]:
            err.append(f"{va}: eh parent without eh_kind")
        if e["origin"] == "compiler_eh" and e["eh_kind"] is None and e["origin_basis"] != "eh_handler_stub":
            err.append(f"{va}: compiler_eh without funclet evidence")
        for f in e["eh_funclets"]:
            if f not in by_va or by_va[f]["eh_kind"] is None or va not in by_va[f]["eh_parents"]:
                err.append(f"{va}: eh_funclet {f} not backed by the funclet entry")
    # tables
    starts = sorted(int(v, 16) for v in by_va if _VA.match(v))

    def contained(container: str, va: str) -> bool:
        if container not in by_va:
            return False
        lo = int(container, 16)
        return lo <= int(va, 16) < lo + by_va[container]["span"]

    for t in doc["thunks"]:
        if not contained(t["container"], t["va"]):
            err.append(f"thunk {t['va']}: container {t['container']} does not hold it")
        elif t["va"] != t["container"] and t["va"] not in by_va[t["container"]]["contains_thunks"]:
            err.append(f"thunk {t['va']}: not listed in contains_thunks")
        if t["kind"] not in ("import", "jump") or (t["kind"] == "import") != ("import" in t):
            err.append(f"thunk {t['va']}: bad kind")
    for d in doc["derived_parts"]:
        if d["kind"] not in DERIVED_KINDS or not contained(d["parent"], d["va"]) or d["va"] not in by_va[d["parent"]]["derived_parts"]:
            err.append(f"derived part {d['va']}: inconsistent")
    for s in doc["eh_stubs"]:
        if not contained(s["container"], s["va"]):
            err.append(f"stub {s['va']}: container does not hold it")
    if len(doc["derived_parts"]) != sum(len(e["derived_parts"]) for e in entries):
        err.append("derived_parts table disagrees with the entries")
    if not doc["parameters"].get("boundaries") == [r["start_va"] for r in doc["regions"][1:]]:
        err.append("boundaries disagree with the regions")
    # counts
    try:
        fresh = compute_counts(doc)
    except Exception as exc:  # malformed entries already reported
        err.append(f"counts cannot be recomputed: {exc}")
        fresh = {}
    for key, value in fresh.items():
        if doc["counts"].get(key) != value:
            err.append(f"counts.{key} is stale or wrong")
    return err


# ---------------------------------------------------------------------------
# Rule predicates and semantics-sensitive helper (FL-1 and the sampler import these)
# ---------------------------------------------------------------------------

SELECTOR_KINDS = ("fingerprint", "import", "ghidra_name_regex")
PROPAGATE = ("callers", "none")


def validate_sensitive_spec(spec: dict[str, Any]) -> list[str]:
    err = []
    for key in ("id", "category"):
        if not isinstance(spec.get(key), str) or not spec.get(key):
            err.append(f"missing {key}")
    if spec.get("propagate") not in PROPAGATE:
        err.append("propagate must be callers|none")
    selectors = spec.get("selectors")
    if not isinstance(selectors, list) or not selectors:
        err.append("selectors must be a non-empty list")
        return err
    for sel in selectors:
        kind = sel.get("kind") if isinstance(sel, dict) else None
        if kind == "fingerprint":
            if sel.get("value") not in FINGERPRINTS:
                err.append(f"unknown fingerprint {sel.get('value')}")
        elif kind == "import":
            names = sel.get("names")
            if not isinstance(names, list) or not names or not all(isinstance(n, str) and _IMPORT_NAME.match(n) for n in names):
                err.append("import selector needs DLL!Name entries")
        elif kind == "ghidra_name_regex":
            try:
                re.compile(sel.get("pattern", ""))
            except (re.error, TypeError):
                err.append(f"bad regex {sel.get('pattern')!r}")
        else:
            err.append(f"unknown selector kind {kind}")
    return err


def semantics_sensitive_set(doc: dict[str, Any], specs: list[dict[str, Any]]) -> dict[str, list[str]]:
    """VA -> sorted categories.  Names are used only to widen the exclusion."""

    by_va = {e["va"]: e for e in doc["entries"]}
    marked: dict[str, set[str]] = collections.defaultdict(set)
    for spec in specs:
        if validate_sensitive_spec(spec):
            raise ValueError(f"invalid semantics_sensitive spec {spec.get('id')}: {validate_sensitive_spec(spec)}")
        seeds = set()
        for e in doc["entries"]:
            for sel in spec["selectors"]:
                if sel["kind"] == "fingerprint" and sel["value"] in e["fingerprints"]:
                    seeds.add(e["va"])
                elif sel["kind"] == "import" and set(sel["names"]) & set(e["imports"]):
                    seeds.add(e["va"])
                elif sel["kind"] == "ghidra_name_regex" and re.search(sel["pattern"], e["name"]):
                    seeds.add(e["va"])
        result = set(seeds)
        if spec["propagate"] == "callers":
            stack = list(seeds)
            while stack:
                cur = stack.pop()
                for caller in by_va[cur]["callers"]:
                    if caller not in result:
                        result.add(caller)
                        stack.append(caller)
        for va in result:
            marked[va].add(spec["category"])
    return {va: sorted(cats) for va, cats in sorted(marked.items())}


def rule_r_eh(entry: dict[str, Any], sensitive: dict[str, list[str]], parent_regions: Optional[list[str]] = None) -> tuple[bool, str]:
    """Unwind funclet with exactly one known parent.  Catch funclets are never rule-covered."""

    if entry["origin"] != "compiler_eh" or entry["eh_kind"] != "unwind":
        return False, "not an unwind funclet"
    if entry["eh_parent"] is None:
        return False, "parent unknown or ambiguous"
    if entry["seam"]:
        return False, "seam function"
    if not entry["analysis_complete"]:
        return False, "analysis incomplete"
    if entry["va"] in sensitive or entry["eh_parent"] in sensitive:
        return False, "semantics sensitive"
    if parent_regions is not None and entry["eh_parent_region"] not in parent_regions:
        return False, "parent region not covered by the rule"
    return True, "unwind funclet with a single FuncInfo parent"


def rule_r_lib_internal(entry: dict[str, Any], sensitive: dict[str, list[str]]) -> tuple[bool, str]:
    """Library function nothing can reach and that cannot reach game code."""

    if entry["origin"] != "library":
        return False, "origin is not library"
    if entry["seam"]:
        return False, "seam function"
    if not entry["analysis_complete"]:
        return False, "analysis incomplete"
    if entry["reach"] != "unreached":
        return False, f"reach is {entry['reach']}"
    if entry["reaches_game"]:
        return False, "path back into game code"
    if entry["address_taken"] or entry["callers"]:
        return False, "referenced"
    if entry["va"] in sensitive:
        return False, "semantics sensitive"
    return True, "library function unreachable from game, entry and address-taken roots"


RULE_PREDICATES = {"R-EH": rule_r_eh, "R-LIB-INTERNAL": rule_r_lib_internal}


def rule_candidates(
    doc: dict[str, Any],
    sensitive_specs: list[dict[str, Any]],
    eh_parent_regions: Optional[list[str]] = None,
) -> dict[str, list[str]]:
    sensitive = semantics_sensitive_set(doc, sensitive_specs)
    out: dict[str, list[str]] = {name: [] for name in RULE_PREDICATES}
    for e in doc["entries"]:
        if rule_r_eh(e, sensitive, eh_parent_regions)[0]:
            out["R-EH"].append(e["va"])
        if rule_r_lib_internal(e, sensitive)[0]:
            out["R-LIB-INTERNAL"].append(e["va"])
    return out


def load_xrefs(path: Path) -> dict[str, Any]:
    doc = json.loads(path.read_text(encoding="utf-8"))
    problems = validate(doc)
    if problems:
        raise SystemExit("invalid function-xrefs: " + "; ".join(problems[:5]))
    return doc


# ---------------------------------------------------------------------------
# Command line
# ---------------------------------------------------------------------------


def resolve_original() -> Path:
    try:
        source = json.loads((REPO / "work/analysis/game-source.json").read_text(encoding="utf-8"))
        candidate = Path(source["game_dir"]) / "GAME.EXE"
        if candidate.is_file():
            return candidate
    except (OSError, KeyError, ValueError):
        pass
    return REPO / "work/original/GAME.EXE"


def comparable(doc: dict[str, Any]) -> dict[str, Any]:
    return {k: v for k, v in doc.items() if k != "tools"}


def main(argv: Optional[list[str]] = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true", help="regenerate and write the file")
    mode.add_argument("--check", action="store_true", help="re-derive and fail if the file differs (default)")
    ap.add_argument("--original", type=Path, default=None)
    ap.add_argument("--index", type=Path, default=PROJECT / "function-index.json")
    ap.add_argument("--layout", type=Path, default=PROJECT / "decomp-progress/layout.json")
    ap.add_argument("--ghidra", type=Path, default=REPO / "work/analysis/m0/fable-census/functions.jsonl")
    ap.add_argument("--out", type=Path, default=PROJECT / "function-xrefs.json")
    ap.add_argument("--expected-sha256", default=ORIGINAL_SHA256)
    ap.add_argument("--no-strict", action="store_true", help="tests: do not pin the real .text layout")
    ap.add_argument("--seam-distance", type=lambda s: int(s, 0), default=SEAM_DISTANCE)
    args = ap.parse_args(argv)
    original = args.original or resolve_original()
    display = {original: "GAME.EXE"}
    doc = derive(original, args.index, args.layout, args.ghidra, args.expected_sha256, not args.no_strict, args.seam_distance, display)
    problems = validate(doc)
    if problems:
        print("error: derived document fails validation: " + "; ".join(problems[:5]), file=sys.stderr)
        return 1
    text = dump(doc)
    if args.write:
        args.out.write_text(text, encoding="utf-8")
        c = doc["counts"]
        print(f"wrote {args.out.name}: {c['entries']} entries, origin {c['origin']}, funclets {c['eh_funclets']}, thunks {c['thunks']}")
        return 0
    if not args.out.is_file():
        print(f"error: {args.out.name} stale: file missing; rerun scripts/extract_function_xrefs.py --write", file=sys.stderr)
        return 1
    file_text = args.out.read_text(encoding="utf-8")
    try:
        on_disk = json.loads(file_text)
    except ValueError:
        print(f"error: {args.out.name} stale: not valid JSON; rerun --write", file=sys.stderr)
        return 1
    if comparable(on_disk) != comparable(doc):
        diff = [k for k in doc if comparable(on_disk).get(k) != comparable(doc).get(k)]
        print(f"error: {args.out.name} stale (differs in {', '.join(diff)}); rerun scripts/extract_function_xrefs.py --write", file=sys.stderr)
        return 1
    if dump(on_disk) != file_text:
        print(f"error: {args.out.name} stale (not in canonical form); rerun --write", file=sys.stderr)
        return 1
    c = doc["counts"]
    print(f"ok: {args.out.name} matches re-derivation ({c['entries']} entries)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
