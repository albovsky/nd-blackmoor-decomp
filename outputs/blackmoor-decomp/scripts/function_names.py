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

Two further tiers sit below those, never mixed with them (the name carries the tier and so does the header):

* ``structural``      a role that ``function-xrefs.json`` states as a fact about the bytes: an import thunk
                      (``import_thunk_<DLL>_<API>``), a jump thunk (``jump_thunk_to_<va>``) or the compiler's exception
                      handler stub of one owner (``eh_handler_stub_of_<va>``).  Rebuilt by ``build`` like the others.
* ``inferred_*``      a LOWER-CONFIDENCE name, always ``inferred_<role>``, that a reader proposed from evidence the
                      repository holds and that a mechanical check keeps tied to that evidence: ``inferred_prose`` quotes a
                      repository text that states what the function does (the quote must still occur in the file and
                      contain the function's address), ``inferred_strings`` cites Ghidra string labels that occur in the
                      function's committed pseudocode, ``inferred_import`` is the rule "no direct callee, one import, at
                      most 48 bytes" (``inferred_only_call_<API>``).  Nothing verifies that the role is true; the
                      ``write`` command keeps these entries, ``add-inferred`` merges proposals after ``validate_inferred``.
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
BASES = ("native_port", "parity_rule", "ghidra_name", "ghidra_funclet", "structural",
         "inferred_prose", "inferred_strings", "inferred_import")
INFERRED_BASES = ("inferred_prose", "inferred_strings", "inferred_import")
INFERRED_PREFIX = "inferred_"
XREFS = PROJECT / "function-xrefs.json"
PSEUDOCODE = PROJECT / "unverified-pseudocode"
# The clause the ``unverified`` header line of an inferred-tier source must carry instead of NAMED_CLAUSE.
INFERRED_CLAUSE = ("the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; "
                   "it is not verified, not read from this code, and not a recovered name")
STRUCTURAL_CLAUSE = ("the function name states a structural role that function-xrefs.json records about the bytes; "
                     "it is not read from this code and not a recovered name")
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


def unverified_clause(entry: dict[str, Any]) -> str:
    """The clause of the ``unverified`` header line that matches the entry's tier (annotator writes it, auditor requires it)."""

    if entry["basis"] in INFERRED_BASES:
        return INFERRED_CLAUSE
    return STRUCTURAL_CLAUSE if entry["basis"] == "structural" else NAMED_CLAUSE


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


_API_WORD = re.compile(r"[^A-Za-z0-9]+")


def _import_word(import_name: str) -> str:
    """``DDRAW.dll!DirectDrawCreateEx`` -> ``DDRAW_DirectDrawCreateEx``; ``DSOUND.dll!#1`` -> ``DSOUND_ordinal_1``."""

    dll, _, api = import_name.partition("!")
    api = f"ordinal_{api[1:]}" if api.startswith("#") else api
    return _API_WORD.sub("_", f"{dll.rsplit('.', 1)[0]}_{api}").strip("_")


def _api_word(import_name: str) -> str:
    """The API part alone (``KERNEL32.dll!GlobalFree`` -> ``GlobalFree``)."""

    api = import_name.partition("!")[2]
    return _API_WORD.sub("_", f"ordinal_{api[1:]}" if api.startswith("#") else api).strip("_")


def structural_entries(xrefs: dict) -> dict[int, dict[str, Any]]:
    """Import thunks, jump thunks and exception-handler stubs, named by the role ``function-xrefs.json`` records."""

    out: dict[int, dict[str, Any]] = {}
    where = "function-xrefs.json"
    for t in xrefs["thunks"]:
        va = int(t["va"], 16)
        if t["kind"] == "import":
            out[va] = {"va": va_text(va), "name": "import_thunk_" + _import_word(t["import"]), "basis": "structural",
                       "summary": f"A {t['size']}-byte indirect jump through the import address table slot of {t['import']}",
                       "source": f"{where} thunks entry (kind import, container {t['container']}); a structural fact about the bytes"}
        elif t["kind"] == "jump":
            out[va] = {"va": va_text(va), "name": f"jump_thunk_to_{int(t['target'], 16):08x}", "basis": "structural",
                       "summary": f"A {t['size']}-byte direct jump to {t['target']}, the whole body of the entry",
                       "source": f"{where} thunks entry (kind jump, container {t['container']}); a structural fact about the bytes"}
    for stub in xrefs["eh_stubs"]:
        va = int(stub["va"], 16)
        owner = int(stub["owners"][0], 16)
        out[va] = {"va": va_text(va), "name": f"eh_handler_stub_of_{owner:08x}", "basis": "structural",
                   "summary": (f"The compiler's exception handler stub (loads the FuncInfo at {stub['funcinfo']} and jumps to the shared "
                               f"handler) of the function at {stub['owners'][0]}"),
                   "source": f"{where} eh_stubs entry (container {stub['container']}); a structural fact about the bytes"}
    return out


def _flat(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def _address_in(text: str, va: int) -> bool:
    return any(int(m.group(1), 16) == va for m in re.finditer(r"(?i)(?:0x0*|FUN_0*)([0-9a-f]{6})\b", text))


_XREFS_CACHE: dict[int, dict] = {}


def _xrefs_by_va() -> dict[int, dict]:
    if not _XREFS_CACHE:
        _XREFS_CACHE.update({int(e["va"], 16): e for e in _json(XREFS)["entries"]})
    return _XREFS_CACHE


def _first_address(text: str) -> Optional[int]:
    m = re.search(r"(?i)(?:0x0*|FUN_0*)([0-9a-f]{6})\b", text)
    return int(m.group(1), 16) if m else None


ROLE_RE = re.compile(r"^[a-z][a-z0-9_]{2,39}$")
STRING_LABEL_RE = re.compile(r"^s_[A-Za-z0-9_]+_[0-9a-f]{8}$")


def inferred_problems(entry: dict[str, Any], xrefs_entry: Optional[dict] = None) -> list[str]:
    """Why an inferred entry is not supported by the committed evidence it cites (empty list: it is)."""

    problems: list[str] = []
    va = int(entry["va"], 16)
    basis = entry.get("basis")
    name = entry.get("name", "")
    role = name[len(INFERRED_PREFIX):] if name.startswith(INFERRED_PREFIX) else ""
    if basis not in INFERRED_BASES:
        return [f"basis {basis!r} is not an inferred basis"]
    if not role or not (ROLE_RE.match(role) or basis == "inferred_import"):
        problems.append(f"name {name!r} is not inferred_<role> with a lowercase role of 3 to 40 characters")
    if basis == "inferred_prose" and re.search(r"_[a-d]$", role):
        problems.append("a single-letter suffix role guesses between twin functions the quote does not tell apart")
    if re.search(r"[0-9a-f]{6}", role) and re.search(r"\d", role):
        problems.append(f"name {name!r} contains an address-like digit run")
    if _PLACEHOLDER.search(name) or _PLACEHOLDER.search(entry.get("summary", "")) or len(entry.get("summary", "").split()) < 4:
        problems.append("name or summary is empty or a placeholder")
    if "/*" in entry.get("source", "") + entry.get("summary", "") or "*/" in entry.get("source", "") + entry.get("summary", ""):
        problems.append("source or summary contains a C comment delimiter")
    if entry.get("confidence") != "low":
        problems.append("an inferred entry must say confidence: low")
    evidence = entry.get("evidence") or []
    if not evidence:
        problems.append("an inferred entry must cite evidence")
    for item in evidence:
        path = PROJECT / str(item.get("path", ""))
        try:
            path.resolve().relative_to(PROJECT.resolve())
        except ValueError:
            problems.append(f"evidence path {item.get('path')!r} is outside outputs/blackmoor-decomp")
            continue
        if not path.is_file():
            problems.append(f"evidence file {item.get('path')!r} does not exist")
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        if basis == "inferred_prose":
            quote = _flat(str(item.get("quote", "")))
            if not quote or len(quote) > 300:
                problems.append(f"{item['path']}: quote is empty or longer than 300 characters")
            elif quote not in _flat(text):
                problems.append(f"{item['path']}: the quote no longer occurs in the file")
            elif not _address_in(quote, va):
                problems.append(f"{item['path']}: the quote does not contain the address {va_text(va)}")
            elif len(quote) < 24:
                problems.append(f"{item['path']}: the quote is too short to state a role")
            elif _first_address(quote) != va:
                problems.append(f"{item['path']}: the quote names another address before {va_text(va)}, so the function is not its subject")
            if not (item["path"].startswith(("src/", "tasks/")) or item["path"].endswith(".md")) or item["path"].endswith(".json"):
                problems.append(f"{item['path']}: not prose (source comments and notes only)")
        elif basis == "inferred_strings":
            if item["path"] != f"unverified-pseudocode/{va:x}.c.txt":
                problems.append(f"{item['path']}: not the committed pseudocode of {va_text(va)}")
            labels = item.get("strings") or []
            if not labels:
                problems.append("no string label cited")
            for label in labels:
                if not STRING_LABEL_RE.match(label) or label not in text:
                    problems.append(f"{item['path']}: string label {label!r} does not occur in the pseudocode")
        elif basis == "inferred_import":
            if item["path"] != XREFS.name:
                problems.append(f"{item['path']}: import evidence is function-xrefs.json")
    if basis in CURATED_BASES and not problems:
        item = {"va": entry["va"], "role": role, "summary": entry["summary"], "evidence": evidence,
                "strings": (evidence[0].get("strings") or []) if evidence else []}
        if proposal_entry(item, basis)["source"] != entry.get("source"):
            problems.append("source (the header's naming line) is not what the evidence regenerates")
    if basis == "inferred_import":
        if xrefs_entry is None:
            xrefs_entry = _xrefs_by_va().get(va)
        want = import_wrapper_entries({"entries": [xrefs_entry] if xrefs_entry else []}).get(va)
        if want is None:
            problems.append("function-xrefs.json does not show a leaf function with one import and at most 48 bytes")
        elif want["name"] != name:
            problems.append(f"name differs from the rule's name {want['name']!r}")
    return problems


def import_wrapper_entries(xrefs: dict) -> dict[int, dict[str, Any]]:
    """The rule ``inferred_import``: no direct or tail callee, exactly one import, no indirect call, at most 48 bytes."""

    out: dict[int, dict[str, Any]] = {}
    for e in xrefs["entries"]:
        if (len(e["imports"]) == 1 and not e["callees"] and not e["tail_callees"] and e["indirect_calls"] == 0
                and e["body_size"] <= 48 and not e["derived_parts"]):
            api = e["imports"][0]
            va = int(e["va"], 16)
            out[va] = {"va": va_text(va), "name": INFERRED_PREFIX + "only_call_" + _api_word(api),
                       "basis": "inferred_import", "confidence": "low",
                       "summary": f"A {e['body_size']}-byte leaf function with no direct callee whose only external call is {api}",
                       "source": (f"INFERRED (lower confidence, not verified): function-xrefs.json lists {api} as the only import of the "
                                  f"{e['body_size']}-byte function and no callee"),
                       "evidence": [{"path": XREFS.name, "import": api, "body_size": e["body_size"]}]}
    return out


def build(ledger: Optional[dict] = None, overrides: Optional[dict] = None, index: Optional[dict] = None,
          xrefs: Optional[dict] = None) -> list[dict[str, Any]]:
    ledger = _json(LEDGER) if ledger is None else ledger
    overrides = _json(OVERRIDES) if overrides is None else overrides
    index = _json(INDEX) if index is None else index
    xrefs = _json(XREFS) if xrefs is None else xrefs
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
    # lower tiers never replace a stronger name: structural roles first, then the import-wrapper rule
    for extra in (structural_entries(xrefs), import_wrapper_entries(xrefs)):
        for va, entry in extra.items():
            entries.setdefault(va, entry)
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


_COMPARED = ("name", "basis", "summary", "source", "native_source", "confidence", "evidence")
CURATED_BASES = ("inferred_prose", "inferred_strings")


def check(path: Path = NAMES, strict_count: bool = False) -> list[str]:
    """Problems: every entry must be supported by the evidence it cites.

    Entries the ledger has gained since (new port acceptances) are reported by ``eligible_unnamed`` but are not a
    failure, because a later port lands after this file was written.  Curated inferred entries (``inferred_prose``,
    ``inferred_strings``) cannot be rebuilt; they are checked against the files they cite instead, and never
    stand where a stronger tier names the function.
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
        if entry["basis"] in CURATED_BASES:
            if expected is not None:
                problems.append(f"{entry['va']} {entry['name']!r}: a stronger tier ({expected['basis']}) names this function")
            elif not is_machine_source(va):
                problems.append(f"{entry['va']} {entry['name']!r}: the source is hand-annotated and keeps its own name")
            problems += [f"{entry['va']} {entry['name']!r}: {why}" for why in inferred_problems(entry)]
        elif expected is None:
            problems.append(f"{entry['va']} {entry['name']!r}: no committed evidence names this function any more")
        elif {k: expected.get(k) for k in _COMPARED} != {k: entry.get(k) for k in _COMPARED}:
            problems.append(f"{entry['va']}: differs from what the evidence states ({expected['name']!r} / {expected['basis']})")
    if strict_count:
        problems += [f"{va_text(va)} {e['name']!r}: evidence names it but the file does not" for va, e in want.items() if va not in have]
    return problems


def curated_entries(path: Path = NAMES) -> list[dict[str, Any]]:
    """The inferred entries a ``write`` must keep (the others are rebuilt from evidence)."""

    return [e for e in (load(path).values() if path.is_file() else ()) if e["basis"] in CURATED_BASES]


def defang(text: str) -> str:
    """Header comments may not contain C comment delimiters (the auditor rejects them anywhere in a line)."""

    return text.replace("/*", "/ *").replace("*/", "* /")


def proposal_entry(item: dict[str, Any], basis: str) -> dict[str, Any]:
    """An inferred entry from a reader's proposal ``{va, role, summary, evidence | strings}``; not yet validated."""

    va = int(item["va"], 16)
    role = str(item["role"]).strip()
    summary = one_line(str(item["summary"]))
    if basis == "inferred_prose":
        evidence = [{"path": e["path"], "line": int(e["line"]), "quote": one_line(e["quote"])} for e in item["evidence"]]
        source = ("INFERRED (lower confidence, not verified): the repository text " +
                  "; ".join(f"{e['path']}:{e['line']} says \"{e['quote']}\"" for e in evidence))
    else:
        labels = sorted(set(item["strings"]))
        evidence = [{"path": f"unverified-pseudocode/{va:x}.c.txt", "strings": labels}]
        source = (f"INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/{va:x}.c.txt, "
                  f"not original source) refers to the data labelled {', '.join(labels)}")
    return {"va": va_text(va), "name": INFERRED_PREFIX + role, "basis": basis, "confidence": "low",
            "summary": defang(summary), "source": defang(source), "evidence": evidence}


def merge_proposals(files: list[Path], basis: str, path: Path = NAMES) -> tuple[int, list[str]]:
    """Validate the readers' proposals and add the sound ones to the table; returns (added, rejections)."""

    doc = json.loads(path.read_text(encoding="utf-8"))
    have = {int(e["va"], 16): e for e in doc["entries"]}
    stronger = {int(e["va"], 16) for e in build()}
    rejected: list[str] = []
    added = 0
    for file in files:
        for item in json.loads(file.read_text(encoding="utf-8")):
            try:
                entry = proposal_entry(item, basis)
            except (KeyError, ValueError, TypeError) as exc:
                rejected.append(f"{item.get('va', '?')}: malformed proposal ({exc})")
                continue
            va = int(entry["va"], 16)
            problems = inferred_problems(entry)
            if va in stronger:
                problems.append("a stronger tier already names this function")
            elif not is_machine_source(va):
                problems.append("hand-annotated source keeps its own name")
            elif va in have:
                problems.append("already named")
            if problems:
                rejected.append(f"{entry['va']} {entry['name']}: " + "; ".join(problems))
                continue
            have[va] = entry
            added += 1
    entries = [have[va] for va in sorted(have)]
    path.write_text(json.dumps(document(entries), indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    return added, rejected


def eligible_unnamed(path: Path = NAMES) -> list[int]:
    have = load(path)
    return sorted(int(e["va"], 16) for e in build() if int(e["va"], 16) not in have)


def tier_of_basis(basis: str) -> str:
    """The annotation tier a naming basis belongs to (the map generator repeats this mapping)."""

    return ("funclet" if basis == "ghidra_funclet" else "structural" if basis == "structural"
            else "inferred" if basis in INFERRED_BASES else "named")


def count_sources(asm: Path = PROJECT / "asm") -> dict[str, Any]:
    """Annotation tiers of every ``asm/FUN_*.s`` read from the sources themselves.

    ``hand`` has no machine header (names an implementer chose); ``named`` is machine annotation whose name is not
    ``fn_<va>`` (it comes from the names table), ``funclet`` the same when the name is Ghidra's ``Unwind@``/``Catch@`` label; ``structural`` and ``inferred`` are the two lower tiers (a structural role from ``function-xrefs.json``; a lower-confidence ``inferred_<role>``); ``machine_only`` keeps ``fn_<va>``.
    """

    tiers = {"hand": 0, "named": 0, "funclet": 0, "structural": 0, "inferred": 0, "machine_only": 0}
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
            tiers[tier_of_basis(basis)] += 1
            by_basis[basis] = by_basis.get(basis, 0) + 1
    return {"sources": sum(tiers.values()), **tiers, "named_by_basis": by_basis}


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("write", help="regenerate asm/function-names.json from the committed evidence")
    chk = sub.add_parser("check", help="require every entry to be supported by the evidence it cites")
    chk.add_argument("--strict", action="store_true", help="also fail when the evidence names a function the file lacks")
    inf = sub.add_parser("add-inferred", help="validate reader proposals (JSON arrays) and add the sound ones as inferred entries")
    inf.add_argument("--basis", choices=CURATED_BASES, required=True)
    inf.add_argument("files", nargs="+", type=Path)
    sub.add_parser("count", help="annotation tiers (hand, named, machine only) counted from the sources")
    args = parser.parse_args(argv)
    if args.command == "count":
        counts = count_sources()
        print(json.dumps(counts, indent=1))
        return 0
    if args.command == "add-inferred":
        added, rejected = merge_proposals(args.files, args.basis)
        for line in rejected[:60]:
            print("  rejected:", line)
        print(f"added {added} {args.basis} entries, rejected {len(rejected)}")
        return 0
    if args.command == "write":
        keep = {}
        for e in curated_entries():
            why = inferred_problems(e)
            if why:
                print(f"  dropped {e['va']} {e['name']}: {why[0]}")
            else:
                keep[int(e["va"], 16)] = e
        stronger = build()
        stronger_vas = {int(e["va"], 16) for e in stronger}
        entries = stronger + [e for va, e in sorted(keep.items()) if va not in stronger_vas and is_machine_source(va)]
        doc = document(sorted(entries, key=lambda e: int(e["va"], 16)))
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
