#!/usr/bin/env python3
"""Function names for the Track M assembly sources, taken from committed evidence only.

A machine-annotated source (``# annotation:  machine``) names its function ``fn_<va>``.  This tool decides which
functions have a better name that the repository's own evidence already states, writes them to
``asm/function-names.json`` and checks that file against that evidence.  Three bases exist, strongest first:

* ``native_port``   the native symbol of a reviewed ``port_acceptances`` entry in ``function-ledger-overrides.json``
                    (the entry that makes the ledger say "ported"); the summary is the acceptance note.  The 178
                    Vorbis entries share one adapter symbol (``his_audio_decode_memory``) that names no single
                    function, so they get no native name.
* ``parity_rule``   the two libvorbisfile functions that ``vorbis_parity_rule`` names with their addresses
                    (``ov_open_callbacks``, ``ov_read``).
* ``ghidra_name``   the name Ghidra gave a statically linked library routine or compiler funclet
                    (``function-index.json``, origin ``library`` or ``compiler_eh`` in the ledger).  It is Ghidra's
                    recognition, not something this project re-derived; the summary is the reviewed ledger reason when
                    the function has one, otherwise a statement of what kind of routine the name denotes.

The three Ghidra names that sit on functions the ledger classes as game code (``CMFCPropertyPage::CommonInit`` and
two more) are left out: library names on game-region code are not trusted here.

``annotate_machine.py`` writes the name, the ``# naming:`` line and the ``# summary:`` line into the source,
``audit_tool_assisted.py`` requires a machine-annotated source to carry exactly these lines (or ``fn_<va>`` and
none), and ``check`` here requires every entry to be supported by the evidence it cites.  Nothing in this file claims
original C++ or compiler provenance, and a name is not a claim that the function was understood beyond its summary.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any, Optional

PROJECT = Path(__file__).resolve().parent.parent
REPOSITORY = PROJECT.parent.parent
NAMES = PROJECT / "asm" / "function-names.json"
LEDGER = PROJECT / "function-ledger.json"
OVERRIDES = PROJECT / "function-ledger-overrides.json"
INDEX = PROJECT / "function-index.json"
SCHEMA = "blackmoor-function-names/1"
BASES = ("native_port", "parity_rule", "ghidra_name", "ghidra_funclet")
# The clause the ``unverified`` header line of a named source must carry (auditor and annotator share it).
NAMED_CLAUSE = ("the function name and note are copied from the evidence in the naming line, not read from this code")
SHARED_ADAPTER_SYMBOL = "his_audio_decode_memory"
# Ghidra spellings: C++ scopes, destructors, templates (CMap<>), compiler-generated `scalar_deleting_destructor',
# MSVC funclets (Unwind@0050c5ee) and CRT underscores.  The name only ever appears in a header comment.
NAME_RE = re.compile(r"^[A-Za-z_~][A-Za-z0-9_:.~@$<>`']*$")
_PLACEHOLDER = re.compile(r"(?<![a-z])(?:todo|tbd|fixme)(?![a-z])|xxx+|<\s*unfilled\s*>|placeholder|lorem|n/a", re.I)
_UNWIND = re.compile(r"^Unwind@[0-9a-f]{8}$")
_CATCH = re.compile(r"^Catch@[0-9a-f]{8}$")


def va_text(va: int) -> str:
    return f"0x{va:08x}"


def is_machine_source(va: int) -> bool:
    """True when asm/FUN_<va>.s exists and carries the machine annotation header (a missing file counts as machine)."""

    path = PROJECT / "asm" / f"FUN_{va:08x}.s"
    if not path.is_file():
        return True
    with path.open(encoding="utf-8") as handle:
        return any(re.match(r"^#\s*annotation:\s*machine\b", line) for line in (next(handle, "") for _ in range(30)))


def table_sha256(path: Path = NAMES) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def one_line(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def naming_text(entry: dict[str, Any]) -> str:
    """The ``# naming:`` header line for an entry; the annotator writes it and the auditor requires it."""

    return entry["source"]


def summary_text(entry: dict[str, Any]) -> str:
    """The ``# name-note:`` header line: the evidence's one-line statement about the function (not a claim about the assembly)."""

    return entry["summary"]


def load(path: Path = NAMES) -> dict[int, dict[str, Any]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema") != SCHEMA:
        raise ValueError(f"{path} is not a {SCHEMA} file")
    return {int(e["va"], 16): e for e in data["entries"]}


def _json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def ghidra_summary(name: str, reason: Optional[dict[str, Any]]) -> tuple[str, str]:
    """(summary, source) for a Ghidra-named function."""

    if reason and reason.get("text"):
        text = re.sub(r"^\[[^\]]*\]\s*", "", one_line(reason["text"]))
        return text, (f"Ghidra name from function-index.json (not re-derived here); note is the ledger reason "
                      f"({reason.get('code')}, function-ledger-overrides.json not_needed_entries)")
    if _UNWIND.match(name):
        kind = "compiler-generated exception-unwind funclet"
    elif _CATCH.match(name):
        kind = "compiler-generated C++ catch handler funclet"
    else:
        kind = "statically linked library routine"
    return (f"{kind[0].upper()}{kind[1:]} named by Ghidra; the body was not read for intent here",
            "Ghidra name from function-index.json (not re-derived here)")


def build(ledger: Optional[dict] = None, overrides: Optional[dict] = None, index: Optional[dict] = None) -> list[dict[str, Any]]:
    ledger = _json(LEDGER) if ledger is None else ledger
    overrides = _json(OVERRIDES) if overrides is None else overrides
    index = _json(INDEX) if index is None else index
    by_va = {int(e["va"], 16): e for e in ledger["entries"]}
    ghidra = {int(f["address"], 16): f["name"] for f in index["functions"] if not f["name"].startswith("FUN_")}
    reasons = {int(e["va"], 16): e.get("reason") for e in ledger["entries"] if e.get("status") == "not_needed"}
    entries: dict[int, dict[str, Any]] = {}

    for va, name in sorted(ghidra.items()):
        ent = by_va.get(va)
        # FID_conflict: is Ghidra's marker for a Function ID match it could not resolve, not a name
        if ent is None or ent.get("origin") == "game" or not NAME_RE.match(name) or name.startswith("FID_conflict"):
            continue
        summary, source = ghidra_summary(name, reasons.get(va))
        funclet = bool(_UNWIND.match(name) or _CATCH.match(name))
        entries[va] = {"va": va_text(va), "name": name, "basis": "ghidra_funclet" if funclet else "ghidra_name",
                       "summary": summary, "source": source}

    for acc in overrides["port_acceptances"]:
        va = int(acc["va"], 16)
        native = acc["native_source"]
        symbol = native["symbol"]
        if symbol == SHARED_ADAPTER_SYMBOL:
            continue
        where = f"{native['path']}:{symbol}"
        source = (f"native port {where} (port_acceptances, ledger class {acc['class']}, reviewed {acc['date']}); "
                  "the note is the acceptance note, a statement about the native port")
        if va in entries:  # a library routine with a native counterpart keeps Ghidra's name
            entries[va]["basis"] = "ghidra_name"
            entries[va]["source"] = (f"Ghidra name from function-index.json (not re-derived here); native counterpart {where} "
                                     f"(port_acceptances, ledger class {acc['class']}, reviewed {acc['date']}); "
                                     "the note is the acceptance note")
            entries[va]["summary"] = one_line(acc["note"])
            entries[va]["native_source"] = {"path": native["path"], "symbol": symbol, "class": acc["class"]}
            continue
        entries[va] = {"va": va_text(va), "name": symbol, "basis": "native_port",
                       "summary": one_line(acc["note"]), "source": source,
                       "native_source": {"path": native["path"], "symbol": symbol, "class": acc["class"]}}

    criterion = overrides["vorbis_parity_rule"]["criterion"]
    ported = {int(a["va"], 16) for a in overrides["port_acceptances"]}
    for name, addr in re.findall(r"\b(ov_[a-z_]+) (0x[0-9a-f]+)", criterion):
        va = int(addr, 16)
        if va in ported and va not in entries:
            entries[va] = {
                "va": va_text(va), "name": name, "basis": "parity_rule",
                "summary": f"libvorbisfile {name}, one of the two original entry points the Vorbis parity rule drives under Unicorn; "
                           "credited as ported only through the output-parity rule, with no per-function port claim",
                "source": "vorbis_parity_rule.criterion in function-ledger-overrides.json (name and address are stated there)",
            }
    # a hand-annotated source has a name an implementer chose; the table only serves machine-annotated sources
    for va in [v for v in entries if not is_machine_source(v)]:
        del entries[va]
    for entry in entries.values():
        if _PLACEHOLDER.search(entry["name"]) or _PLACEHOLDER.search(entry["summary"]) or len(entry["summary"].split()) < 4:
            raise ValueError(f"{entry['va']}: name or summary is empty or a placeholder")
    return [entries[va] for va in sorted(entries)]


def document(entries: list[dict[str, Any]]) -> dict[str, Any]:
    counts = {basis: sum(1 for e in entries if e["basis"] == basis) for basis in BASES}
    return {
        "schema": SCHEMA,
        "note": ("Names that committed evidence already states for assembly functions; every other source keeps the "
                 "machine name fn_<va>. Written and checked by scripts/function_names.py; read by "
                 "scripts/annotate_machine.py and scripts/audit_tool_assisted.py. A name is not a claim that the "
                 "function is understood beyond its summary, and nothing here claims original C++ or compiler "
                 "provenance."),
        "counts": {"entries": len(entries), **counts},
        "entries": entries,
    }


def check(path: Path = NAMES, strict_count: bool = False) -> list[str]:
    """Problems: every entry must be supported by the evidence it cites.

    Entries the ledger has gained since (new port acceptances) are reported by ``eligible_unnamed`` but are not a
    failure, because a later port lands after this file was written.
    """

    problems: list[str] = []
    if not path.is_file():
        return [f"{path} is missing"]
    try:
        have = load(path)
    except ValueError as exc:
        return [str(exc)]
    want = {int(e["va"], 16): e for e in build()}
    for va, entry in have.items():
        expected = want.get(va)
        if expected is None:
            problems.append(f"{entry['va']} {entry['name']!r}: no committed evidence names this function any more")
        elif {k: expected.get(k) for k in ("name", "basis", "summary", "source", "native_source")} != {k: entry.get(k) for k in ("name", "basis", "summary", "source", "native_source")}:
            problems.append(f"{entry['va']}: differs from what the evidence states ({expected['name']!r} / {expected['basis']})")
    if strict_count:
        problems += [f"{va_text(va)} {e['name']!r}: evidence names it but the file does not" for va, e in want.items() if va not in have]
    return problems


def eligible_unnamed(path: Path = NAMES) -> list[int]:
    have = load(path)
    return sorted(int(e["va"], 16) for e in build() if int(e["va"], 16) not in have)


def count_sources(asm: Path = PROJECT / "asm") -> dict[str, Any]:
    """Annotation tiers of every ``asm/FUN_*.s`` read from the sources themselves.

    ``hand`` has no machine header (names an implementer chose); ``named`` is machine annotation whose name is not
    ``fn_<va>`` (it comes from the names table), ``funclet`` the same when the name is Ghidra's ``Unwind@``/``Catch@`` label; ``machine_only`` keeps ``fn_<va>``.
    """

    tiers = {"hand": 0, "named": 0, "funclet": 0, "machine_only": 0}
    by_basis = {basis: 0 for basis in BASES}
    table = load() if NAMES.is_file() else {}
    for path in sorted(asm.glob("FUN_*.s")):
        head = path.read_text(encoding="utf-8").split(".intel_syntax", 1)[0]
        if not re.search(r"(?m)^#\s*annotation:\s*machine\b", head):
            tiers["hand"] += 1
            continue
        name = re.search(r"(?m)^# name:\s+(\S+)", head).group(1)
        if name.startswith("fn_"):
            tiers["machine_only"] += 1
        else:
            known = table.get(int(path.stem[4:], 16))
            basis = known["basis"] if known else "unknown"
            tiers["funclet" if basis == "ghidra_funclet" else "named"] += 1
            by_basis[basis] = by_basis.get(basis, 0) + 1
    return {"sources": sum(tiers.values()), **tiers, "named_by_basis": by_basis}


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("write", help="regenerate asm/function-names.json from the committed evidence")
    chk = sub.add_parser("check", help="require every entry to be supported by the evidence it cites")
    chk.add_argument("--strict", action="store_true", help="also fail when the evidence names a function the file lacks")
    sub.add_parser("count", help="annotation tiers (hand, named, machine only) counted from the sources")
    args = parser.parse_args(argv)
    if args.command == "count":
        counts = count_sources()
        print(json.dumps(counts, indent=1))
        return 0
    if args.command == "write":
        doc = document(build())
        NAMES.write_text(json.dumps(doc, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"wrote {NAMES.relative_to(REPOSITORY)}: {doc['counts']}")
        return 0
    problems = check(strict_count=args.strict)
    for line in problems[:20]:
        print("  " + line)
    missing = eligible_unnamed()
    print(f"function names: {len(load())} entries, {len(problems)} problem(s), {len(missing)} function(s) the evidence names that the file does not yet")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
