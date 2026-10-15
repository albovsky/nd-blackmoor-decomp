"""Function ledger: one status per GAME.EXE function, derived from pinned inputs.

Pure derivation and strict validation, standard library only. No original bytes,
game assets or private receipts are read (private receipt hashes are only
re-checked on request). This is not the whole-file range ledger in generate.py
(``--ledger``, ``blackmoor-range-ledger/1``) and shares nothing with it.

Statuses
    ported      a reviewed claim that native code or a test demonstrably covers
                the function; never the same thing as an x86 match.
    not_needed  a reviewed reason (closed enum), per function, or a sampled
                predicate rule that never covers game code.
    pending     everything unproven; the default.

Inputs, relative to ``root`` (outputs/blackmoor-decomp; a fixture tree has the
same layout). Required: ``function-index.json``, ``decomp-progress/layout.json``,
``asm/census-summary.json``. Optional, treated as empty when absent and pinned
as absent (``sha256: null``) so that adding one makes the ledger stale:
``function-evidence.json`` (FL-2), ``function-xrefs.json`` and
``function-ledger-overrides.json`` (FL-3), the counted x86 match manifests and
``asm/batch-N.json`` with their audit reports. The x86 match fields are
orthogonal: they are recorded, never read by the status rules.

Schemas (every unknown key is an error; ``original_sha256`` is optional in the
three optional inputs but must be the pinned hash when present; addresses are
``0x`` hex strings, any zero padding accepted on input, canonical on output)

function-evidence.json
    schema "blackmoor-function-evidence/1", functions (sorted by va, unique):
    {va, evidence: [pointer], blockers: [{address, id, text}] (optional),
     divergences: [{id, text, safety_rejection: bool}] (optional)}
    optional top-level ``counts`` (object) and ``inputs`` (list) are ignored.
    A blocker address lies anywhere in [va, va + span). Pointers (all carry
    ``kind``; no line numbers anywhere):
      native_source {path, symbol, sha256}
      oracle        {path, window: [start, end_exclusive], window_sha256,
                     use: entry|callee|mapped, sha256}
      test          {path, test_id, sha256}
      receipt       {slice, path (work-relative), sha256, review: str|null}
      mention       {path, symbol: str|null}
    ``sha256`` of native_source, oracle and test pointers is the hash of the
    file at ``path`` (checked here); a mention path is also hashed.

function-xrefs.json
    schema "blackmoor-function-xrefs/1", functions: [{va, body_size: int|null,
    derived_parts: [va], callers: [va], callees: [va], imports: [name],
    data_ref: bool, eh_parent: va|null, thunk: bool,
    eh_kind: "unwind"|"catch" (optional; required with eh_parent),
    origin: game|library|compiler_eh|import_thunk (optional)}], optional
    inner_thunks: [{va, parent, import}] (import thunks that sit inside a
    parent span and are not index starts). ``derived_parts`` are the M03
    derived starts (their total must equal the census ``derived_functions``).

function-ledger-overrides.json
    schema "blackmoor-function-ledger-overrides/1":
      port_acceptances: [{va, class, reviewer, date, native_source: {path,
          symbol}, tests: [{path, test_id}], oracle: null|{path, window},
          parts_accounted: [va], note (optional)}]
      not_needed_entries: [{va, reason, text, reviewer, date}]
      not_needed_rules: [{id, predicate, reason, rationale, accepted, reviewer,
          date, sample_review: {sample_sha256, n, defects}}] (id == predicate;
          R-EH may add parents_without_native_exception_path: [va]); a rule
          with accepted false is an inert draft
      semantics_sensitive: [{va, why}]
      win32_import_allowlist (optional): {names, reviewer, date}
"""

from __future__ import annotations

import bisect
import datetime
import hashlib
import json
import re
from pathlib import Path

SCHEMA = "blackmoor-function-ledger/1"
EVIDENCE_SCHEMA = "blackmoor-function-evidence/1"
XREFS_SCHEMA = "blackmoor-function-xrefs/1"
OVERRIDES_SCHEMA = "blackmoor-function-ledger-overrides/1"
LAYOUT_SCHEMA = "blackmoor-image-layout/1"
PINNED_SHA = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_FUNCTIONS = 4188
STALE_MESSAGE = "function ledger stale; rerun scripts/build_function_ledger.py --write"
SEAM_BYTES = 0x400
SAMPLE_MIN = 59

STATUSES = ("ported", "not_needed", "pending")
PORTED_CLASSES = ("native_oracle_verified", "native_tests_only", "host_adapter_tested")
NOT_NEEDED_CLASSES = ("nn_rule", "nn_reviewed")
PENDING_CLASSES = ("candidate_port", "partial_native", "static_navigation_only", "none")
CLASSES = PORTED_CLASSES + NOT_NEEDED_CLASSES + PENDING_CLASSES
CLASS_STATUS = {**{c: "ported" for c in PORTED_CLASSES}, **{c: "not_needed" for c in NOT_NEEDED_CLASSES},
                **{c: "pending" for c in PENDING_CLASSES}}
REGIONS = ("game", "vorbis", "crt_mfc")
ORIGINS = ("game", "library", "compiler_eh", "import_thunk", "unknown")
XREF_ORIGINS = ("game", "library", "compiler_eh", "import_thunk")
EH_KINDS = ("unwind", "catch")
USES = ("entry", "callee", "mapped")
QUALIFYING_USES = ("entry", "callee")
POINTER_KINDS = ("mention", "native_source", "oracle", "receipt", "test")
REASONS = ("win32_plumbing_no_observable_effect", "crt_startup_termination",
           "library_internal_unreached_by_game", "host_libc_standard_contract",
           "debug_diagnostic_only", "unreachable_no_refs", "compiler_eh_funclet")
# Predicate id -> reason code. A rule carries exactly its predicate's reason.
PREDICATES = {"R-EH": "compiler_eh_funclet", "R-LIB-INTERNAL": "library_internal_unreached_by_game"}
# Win32 debug output imports: the only imports a debug_diagnostic_only function may use.
DEBUG_IMPORTS = frozenset({"OutputDebugStringA", "OutputDebugStringW", "IsDebuggerPresent", "DebugBreak"})
ROLES = ("function-index", "layout", "census", "x86-manifest", "x86-audit", "evidence", "xrefs", "overrides",
         "evidence-source", "evidence-oracle", "evidence-test", "evidence-mention")
POINTER_ROLE = {"native_source": "evidence-source", "oracle": "evidence-oracle",
                "test": "evidence-test", "mention": "evidence-mention"}

COUNTED_MANIFESTS = ("matches.json", "matches_s08_2_x86.json", "matches_s08_3_x86.json", "matches_s08_4_x86.json")
MANIFEST_PROVENANCE = {
    "matches.json": "exact_range_compiled_c_partial",
    "matches_s08_2_x86.json": "explicit_reconstructed_assembly_source",
    "matches_s08_3_x86.json": "explicit_reconstructed_assembly_source",
    "matches_s08_4_x86.json": "explicit_reconstructed_assembly_source",
}
PARTIAL_PROVENANCE = "exact_range_compiled_c_partial"
TOOL_ASSISTED = "tool_assisted_reconstructed_assembly"

ENTRY_KEYS = ("va", "name", "span", "body_size", "derived_parts", "region", "origin", "seam", "status", "class",
              "x86_match", "evidence", "blockers", "divergences", "reason", "review")
CENSUS_FRAGMENT = "census_fall_through_fragment"
CENSUS_UNSPLIT = "census_unsplit_span"

HEX64 = re.compile(r"[0-9a-f]{64}")
IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_]{0,127}")
TEST_ID = re.compile(r"[A-Za-z_][A-Za-z0-9_.]{0,127}")
IMPORT_NAME = re.compile(r"[A-Za-z_@?$][A-Za-z0-9_@?$.]{0,127}")
ITEM_ID = re.compile(r"[A-Za-z0-9][A-Za-z0-9._:-]{0,63}")
ENTRY_NAME = re.compile(r"[ -.0-\[\]-~]{1,120}")  # printable ASCII, no "/" or "\\" (a Ghidra label, informational only)
VA_TEXT = re.compile(r"0x[0-9a-fA-F]{1,8}")


class LedgerError(ValueError):
    pass


def fail(message):
    raise LedgerError(message)


# --------------------------------------------------------------- primitives --

def is_int(value):
    return type(value) is int


def fmt(va):
    return f"0x{va:x}"


def parse_va(value, what):
    if not isinstance(value, str) or not VA_TEXT.fullmatch(value):
        fail(f"{what}: invalid address {value!r}")
    return int(value, 16)


def exact_keys(obj, required, optional, what):
    if not isinstance(obj, dict):
        fail(f"{what}: expected an object")
    keys = set(obj)
    if not set(required) <= keys or not keys <= set(required) | set(optional):
        fail(f"{what}: unexpected or missing fields "
             f"(extra {sorted(keys - set(required) - set(optional))}, missing {sorted(set(required) - keys)})")


def text_value(value, what, limit=240):
    if (not isinstance(value, str) or not 0 < len(value) <= limit
            or any(ord(c) < 32 or ord(c) == 127 for c in value)):
        fail(f"{what}: invalid text")
    return value


def sha_value(value, what, nullable=False):
    if value is None and nullable:
        return None
    if not isinstance(value, str) or not HEX64.fullmatch(value):
        fail(f"{what}: invalid sha256")
    return value


def date_value(value, what):
    if not isinstance(value, str) or not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        fail(f"{what}: invalid date")
    try:
        datetime.date.fromisoformat(value)
    except ValueError:
        fail(f"{what}: invalid date")
    return value


def rel_path(value, what):
    """Relative, forward-slash, no absolute or drive paths, no traversal."""
    if (not isinstance(value, str) or not 0 < len(value) <= 200 or value.startswith("/") or ":" in value
            or "\\" in value or any(ord(c) < 32 for c in value)
            or any(seg in ("", ".", "..") for seg in value.split("/"))):
        fail(f"{what}: invalid relative path {value!r}")
    return value


def name_list(value, pattern, what):
    if not isinstance(value, list) or len(value) > 512:
        fail(f"{what}: expected a list")
    for item in value:
        if not isinstance(item, str) or not pattern.fullmatch(item):
            fail(f"{what}: invalid name {item!r}")
    if len(set(value)) != len(value):
        fail(f"{what}: duplicate name")
    return list(value)


def va_list(value, what):
    if not isinstance(value, list) or len(value) > 4096:
        fail(f"{what}: expected a list of addresses")
    out = [parse_va(v, what) for v in value]
    if len(set(out)) != len(out):
        fail(f"{what}: duplicate address")
    return out


def canon(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def sha256_bytes(raw):
    return hashlib.sha256(raw).hexdigest()


def read_json_bytes(raw, what):
    try:
        return json.loads(raw.decode("utf-8"))
    except (ValueError, UnicodeDecodeError) as exc:
        raise LedgerError(f"cannot parse {what}: {exc}") from exc


class Inputs:
    """Every file the derivation reads, pinned by hash (or by absence)."""

    def __init__(self, root: Path):
        self.root = root
        self.items = {}

    def add(self, rel, role, required=True):
        rel_path(rel, "input path")
        path = self.root / rel
        try:
            raw = path.read_bytes() if path.is_file() else None
        except OSError as exc:
            raise LedgerError(f"cannot read {rel}: {exc}") from exc
        if raw is None and required:
            fail(f"missing required input: {rel}")
        sha = None if raw is None else sha256_bytes(raw)
        old = self.items.get(rel)
        if old is None or ROLES.index(role) < ROLES.index(old["role"]):
            self.items[rel] = {"path": rel, "sha256": sha, "role": role}
        return raw

    def listing(self):
        return [self.items[k] for k in sorted(self.items)]


# ------------------------------------------------------------------- source --

def mask_source(text):
    """Blank comments and literals, keeping offsets and newlines."""
    pattern = re.compile(r"/\*.*?\*/|//[^\n]*|\"(?:\\.|[^\"\\\n])*\"|'(?:\\.|[^'\\\n])*'", re.S)
    return pattern.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), text)


def match_brace(masked, open_index):
    depth = 0
    for i in range(open_index, len(masked)):
        if masked[i] == "{":
            depth += 1
        elif masked[i] == "}":
            depth -= 1
            if depth == 0:
                return i
    fail("source function body is unterminated")


def symbol_area(text, symbol, path):
    """Leading comments plus body of the single definition of ``symbol``."""
    masked = mask_source(text)
    found = list(re.finditer(r"\b" + re.escape(symbol) + r"\s*\([^;{}]*\)\s*\{", masked))
    if not found:
        fail(f"source symbol {symbol} not found in {path}")
    if len(found) > 1:
        fail(f"source symbol {symbol} is ambiguous in {path}")
    m = found[0]
    end = match_brace(masked, m.end() - 1)
    if re.search(r"^[ \t]*#[ \t]*(?:if|ifdef|ifndef|elif|else)\b", masked[m.end():end], re.M):
        fail(f"preprocessor conditional in scanned function {symbol}")
    boundary = max(masked.rfind(";", 0, m.start()), masked.rfind("}", 0, m.start()), masked.rfind("{", 0, m.start()))
    return text[boundary + 1:end + 1]


def addresses_in(area):
    found = {int(m, 16) for m in re.findall(r"\b0[xX]([0-9a-fA-F]{1,8})\b", area)}
    found |= {int(m, 16) for m in re.findall(r"\bFUN_([0-9a-fA-F]{8})\b", area)}
    return found


def test_area(text, test_id, path):
    name = test_id.split(".")[-1]
    if path.endswith(".py"):
        lines = text.splitlines()
        for i, line in enumerate(lines):
            m = re.match(r"([ \t]*)(?:async[ \t]+)?def[ \t]+" + re.escape(name) + r"[ \t]*\(", line)
            if m:
                indent = len(m.group(1).expandtabs(4))
                body = [line]
                for later in lines[i + 1:]:
                    if later.strip() and len(later) - len(later.lstrip()) <= indent and not later.lstrip().startswith(("#", ")")):
                        break
                    body.append(later)
                return "\n".join(body)
        fail(f"test {test_id} is not defined in {path}")
    if not re.search(r"\b" + re.escape(name) + r"\b", text):
        fail(f"test {test_id} does not appear in {path}")
    return text


# ----------------------------------------------------------------- pointers --

def validate_pointer(p, what, *, check_window=True):
    """Strict pointer shape; returns the pointer with canonical window strings."""
    if not isinstance(p, dict) or p.get("kind") not in POINTER_KINDS:
        fail(f"{what}: unknown evidence pointer kind")
    kind = p["kind"]
    if kind == "native_source":
        exact_keys(p, "kind path symbol sha256".split(), (), what)
        rel_path(p["path"], what)
        if not isinstance(p["symbol"], str) or not IDENT.fullmatch(p["symbol"]):
            fail(f"{what}: invalid symbol")
        sha_value(p["sha256"], what)
        return dict(p)
    if kind == "test":
        exact_keys(p, "kind path test_id sha256".split(), (), what)
        rel_path(p["path"], what)
        if not isinstance(p["test_id"], str) or not TEST_ID.fullmatch(p["test_id"]):
            fail(f"{what}: invalid test_id")
        sha_value(p["sha256"], what)
        return dict(p)
    if kind == "oracle":
        exact_keys(p, "kind path window window_sha256 use sha256".split(), (), what)
        rel_path(p["path"], what)
        window = p["window"]
        if not isinstance(window, list) or len(window) != 2:
            fail(f"{what}: oracle window must be [start, end_exclusive]")
        start, end = parse_va(window[0], what), parse_va(window[1], what)
        if end <= start:
            fail(f"{what}: oracle window must be [start, end_exclusive) with end after start")
        if p["use"] not in USES:
            fail(f"{what}: invalid oracle use")
        sha_value(p["window_sha256"], what)
        sha_value(p["sha256"], what)
        return {**p, "window": [fmt(start), fmt(end)]}
    if kind == "receipt":
        exact_keys(p, "kind slice path sha256 review".split(), (), what)
        if not isinstance(p["slice"], str) or not ITEM_ID.fullmatch(p["slice"]):
            fail(f"{what}: invalid slice")
        rel_path(p["path"], what)
        sha_value(p["sha256"], what)
        if p["review"] is not None:
            text_value(p["review"], what, 120)
        return dict(p)
    exact_keys(p, "kind path symbol".split(), (), what)
    rel_path(p["path"], what)
    if p["symbol"] is not None and (not isinstance(p["symbol"], str) or not IDENT.fullmatch(p["symbol"])):
        fail(f"{what}: invalid symbol")
    return dict(p)


def pointer_key(p):
    detail = p.get("symbol") or p.get("test_id") or p.get("slice") or ""
    return (p["kind"], p["path"], detail, tuple(p.get("window", ())), p.get("use", ""))


def oracle_window(p):
    return int(p["window"][0], 16), int(p["window"][1], 16)


def covers(p, va, body_size):
    start, end = oracle_window(p)
    return body_size is not None and start <= va and va + body_size <= end


def classify_pending(entry):
    evidence, va, body = entry["evidence"], int(entry["va"], 16), entry["body_size"]
    kinds = {p["kind"] for p in evidence}
    full = any(p["kind"] == "oracle" and covers(p, va, body) for p in evidence)
    if "native_source" in kinds and full:
        return "candidate_port"
    if kinds & {"native_source", "test", "oracle"}:
        return "partial_native"
    if kinds & {"mention", "receipt"}:
        return "static_navigation_only"
    return "none"


def cleared(blocker, divergences):
    return any(d["id"] == blocker["id"] and d["safety_rejection"] is True for d in divergences)


def check_ported_evidence(entry, what):
    """Mechanical checks a ported entry must satisfy in the ledger itself."""
    cls, evidence, va = entry["class"], entry["evidence"], int(entry["va"], 16)
    kinds = {p["kind"] for p in evidence}
    for need in ("native_source", "test"):
        if need not in kinds:
            fail(f"{what}: ported entry has no {need} pointer")
    if cls == "native_oracle_verified":
        oracles = [p for p in evidence if p["kind"] == "oracle"]
        if not oracles:
            fail(f"{what}: native_oracle_verified needs an oracle pointer")
        good = [p for p in oracles if p["use"] in QUALIFYING_USES]
        if not good:
            fail(f"{what}: oracle windows used only as 'mapped' never qualify (needs entry or callee)")
        if not any(covers(p, va, entry["body_size"]) for p in good):
            fail(f"{what}: no oracle window used as entry or callee covers the whole body")
    for blocker in entry["blockers"]:
        if not cleared(blocker, entry["divergences"]):
            fail(f"{what}: blocker {blocker['id']} remains and is not a recorded deliberate safety rejection")


# ------------------------------------------------------------ ledger shape --

def validate_pointer_list(pointers, what):
    if not isinstance(pointers, list) or len(pointers) > 400:
        fail(f"{what}: expected a list of evidence pointers")
    out = [validate_pointer(p, what) for p in pointers]
    keys = [pointer_key(p) for p in out]
    if len(set(keys)) != len(keys):
        fail(f"{what}: duplicate evidence pointer")
    if keys != sorted(keys):
        fail(f"{what}: evidence pointers are not sorted")
    return out


def empty_counts():
    return {
        "total": 0,
        "status": {s: 0 for s in STATUSES},
        "class": {c: 0 for c in CLASSES},
        "region": {r: {s: 0 for s in STATUSES} for r in REGIONS},
        "reason": {r: 0 for r in REASONS},
        "origin": {o: 0 for o in ORIGINS},
        "seam": 0,
        "x86": {"matched": 0, "complete": 0, "matched_ported": 0, "complete_ported": 0},
        "span_bytes": {s: 0 for s in STATUSES},
    }


def count_entries(entries):
    c = empty_counts()
    for e in entries:
        c["total"] += 1
        c["status"][e["status"]] += 1
        c["class"][e["class"]] += 1
        c["region"][e["region"]][e["status"]] += 1
        if e["reason"]:
            c["reason"][e["reason"]["code"]] += 1
        c["origin"][e["origin"]] += 1
        c["seam"] += 1 if e["seam"] else 0
        c["span_bytes"][e["status"]] += e["span"]
        x = e["x86_match"]
        if x:
            c["x86"]["matched"] += 1
            c["x86"]["complete"] += 1 if x["complete"] else 0
            if e["status"] == "ported":
                c["x86"]["matched_ported"] += 1
                c["x86"]["complete_ported"] += 1 if x["complete"] else 0
    return c


def validate_entry(e, index):
    what = f"entry {index}"
    exact_keys(e, ENTRY_KEYS, (), what)
    va = parse_va(e["va"], what)
    if e["va"] != fmt(va):
        fail(f"{what}: address is not canonical")
    what = f"entry {e['va']}"
    if not isinstance(e["name"], str) or not ENTRY_NAME.fullmatch(e["name"]):
        fail(f"{what}: invalid name")
    if not is_int(e["span"]) or e["span"] < 1:
        fail(f"{what}: invalid span")
    span = e["span"]
    if e["body_size"] is not None and (not is_int(e["body_size"]) or not 1 <= e["body_size"] <= span):
        fail(f"{what}: body_size must be null or within the span")
    if not isinstance(e["derived_parts"], list):
        fail(f"{what}: derived_parts must be a list")
    parts = [parse_va(p, what) for p in e["derived_parts"]]
    if parts != sorted(set(parts)):
        fail(f"{what}: derived_parts are not sorted and unique")
    if any(not va < p < va + span for p in parts) or [fmt(p) for p in parts] != e["derived_parts"]:
        fail(f"{what}: a derived part lies outside the span or is not canonical")
    if e["region"] not in REGIONS:
        fail(f"{what}: invalid region")
    if e["origin"] not in ORIGINS:
        fail(f"{what}: invalid origin")
    if type(e["seam"]) is not bool:
        fail(f"{what}: seam must be a boolean")
    if e["status"] not in STATUSES:
        fail(f"{what}: invalid status")
    if e["class"] not in CLASS_STATUS or CLASS_STATUS[e["class"]] != e["status"]:
        fail(f"{what}: class {e['class']!r} does not belong to status {e['status']!r}")
    x = e["x86_match"]
    if x is not None:
        exact_keys(x, "provenance complete manifest".split(), (), what)
        if (not isinstance(x["provenance"], str) or not re.fullmatch(r"[a-z][a-z0-9_]*", x["provenance"])
                or type(x["complete"]) is not bool):
            fail(f"{what}: invalid x86_match")
        rel_path(x["manifest"], what)
    e["evidence"] = validate_pointer_list(e["evidence"], what)
    # blockers: addresses anywhere inside [va, va + span); sorted by (address, id)
    if not isinstance(e["blockers"], list) or not isinstance(e["divergences"], list):
        fail(f"{what}: blockers and divergences must be lists")
    seen = set()
    for b in e["blockers"]:
        exact_keys(b, "address id text".split(), (), what)
        addr = parse_va(b["address"], what)
        if b["address"] != fmt(addr) or not va <= addr < va + span:
            fail(f"{what}: blocker address is not inside the function span")
        if not isinstance(b["id"], str) or not ITEM_ID.fullmatch(b["id"]):
            fail(f"{what}: invalid blocker id")
        text_value(b["text"], what)
        if b["id"] in seen:
            fail(f"{what}: duplicate blocker id")
        seen.add(b["id"])
    if [(b["address"], b["id"]) for b in e["blockers"]] != sorted((b["address"], b["id"]) for b in e["blockers"]):
        fail(f"{what}: blockers are not sorted")
    seen = set()
    for d in e["divergences"]:
        exact_keys(d, "id text safety_rejection".split(), (), what)
        if not isinstance(d["id"], str) or not ITEM_ID.fullmatch(d["id"]):
            fail(f"{what}: invalid divergence id")
        text_value(d["text"], what)
        if type(d["safety_rejection"]) is not bool:
            fail(f"{what}: safety_rejection must be a boolean")
        if d["id"] in seen:
            fail(f"{what}: duplicate divergence id")
        seen.add(d["id"])
    # region/status rules that hold for every entry
    if e["region"] == "vorbis" and e["status"] != "pending":
        fail(f"{what}: vorbis functions stay pending until PCM parity is proven")
    if e["status"] != "pending" and any(b["id"].startswith("census_") for b in e["blockers"]):
        fail(f"{what}: census fall-through fragments and unsplit spans stay pending")
    reason, review = e["reason"], e["review"]
    if e["status"] == "pending":
        if reason is not None or review is not None:
            fail(f"{what}: a pending entry has no reason or review")
        if e["class"] != classify_pending(e):
            fail(f"{what}: pending class does not follow from the evidence")
        return
    exact_keys(review, "reviewer date sample".split(), (), what)
    text_value(review["reviewer"], what, 80)
    date_value(review["date"], what)
    if e["status"] == "ported":
        if reason is not None or review["sample"] is not None:
            fail(f"{what}: a ported entry has no reason and no rule sample")
        check_ported_evidence(e, what)
        return
    exact_keys(reason, "code text rule".split(), (), what)
    if reason["code"] not in REASONS:
        fail(f"{what}: reason {reason['code']!r} is not in the closed enum")
    text_value(reason["text"], what)
    if e["class"] == "nn_reviewed":
        if reason["rule"] is not None or review["sample"] is not None:
            fail(f"{what}: a per-function not_needed entry carries no rule or sample")
        return
    # nn_rule
    if e["region"] == "game":
        fail(f"{what}: a rule never decides game-region code")
    if e["seam"]:
        fail(f"{what}: a rule never decides a seam function")
    if e["evidence"]:
        fail(f"{what}: a rule never decides a function that has evidence")
    rule = reason["rule"]
    if rule not in PREDICATES:
        fail(f"{what}: unknown rule {rule!r}")
    if reason["code"] != PREDICATES[rule]:
        fail(f"{what}: rule {rule} does not carry reason {reason['code']}")
    sha_value(review["sample"], what)
    wanted = "compiler_eh" if rule == "R-EH" else "library"
    if e["origin"] != wanted:
        fail(f"{what}: rule {rule} needs origin {wanted}")


def validate(ledger):
    """Strict schema and invariant check of a ledger; reads no other file."""
    exact_keys(ledger, "schema original_sha256 inputs counts entries".split(), (), "ledger")
    if ledger["schema"] != SCHEMA:
        fail(f"ledger schema must be {SCHEMA}")
    if ledger["original_sha256"] != PINNED_SHA:
        fail("ledger does not describe the pinned GAME.EXE")
    inputs = ledger["inputs"]
    if not isinstance(inputs, list):
        fail("inputs: expected a list")
    for item in inputs:
        exact_keys(item, "path sha256 role".split(), (), "input")
        rel_path(item["path"], "input")
        sha_value(item["sha256"], "input", nullable=True)
        if item["role"] not in ROLES:
            fail("input: unknown role")
    paths = [i["path"] for i in inputs]
    if len(set(paths)) != len(paths):
        fail("inputs: duplicate path")
    if paths != sorted(paths):
        fail("inputs: not sorted by path")
    entries = ledger["entries"]
    if not isinstance(entries, list) or not entries:
        fail("entries: expected a non-empty list")
    prev, order = None, {r: i for i, r in enumerate(REGIONS)}
    for i, e in enumerate(entries):
        validate_entry(e, i)
        va = int(e["va"], 16)
        if prev is not None:
            if va <= int(prev["va"], 16):
                fail(f"entry {e['va']}: entries are not sorted and unique by address")
            if int(prev["va"], 16) + prev["span"] != va:
                fail(f"entry {prev['va']}: span does not reach the next function")
            if order[e["region"]] < order[prev["region"]]:
                fail(f"entry {e['va']}: region order is not game, vorbis, crt_mfc")
        prev = e
    if canon(ledger["counts"]) != canon(count_entries(entries)):
        fail("counts differ from the entries")
    return ledger


def render(ledger):
    """Stable text: header, inputs and counts, then one entry per line."""
    dump = lambda v: json.dumps(v, separators=(", ", ": "))
    lines = ["{", f'"schema": {dump(ledger["schema"])},', f'"original_sha256": {dump(ledger["original_sha256"])},',
             '"inputs": [']
    lines += [dump(i) + ("," if k + 1 < len(ledger["inputs"]) else "") for k, i in enumerate(ledger["inputs"])]
    lines += ["],", f'"counts": {dump(ledger["counts"])},', '"entries": [']
    lines += [dump({k: e[k] for k in ENTRY_KEYS}) + ("," if k + 1 < len(ledger["entries"]) else "")
              for k, e in enumerate(ledger["entries"])]
    lines += ["]", "}"]
    return "\n".join(lines) + "\n"


# ------------------------------------------------------- input: universe --

class Universe:
    def __init__(self, starts, spans, regions, boundaries, text_start, text_end, names, base):
        self.base = base
        self.starts, self.spans, self.regions = starts, spans, regions
        self.boundaries, self.text_start, self.text_end, self.names = boundaries, text_start, text_end, names
        self.index = set(starts)

    def containing(self, va):
        if not self.text_start <= va < self.text_end:
            return None
        return self.starts[bisect.bisect_right(self.starts, va) - 1]

    def end(self, va):
        return va + self.spans[va]


def load_universe(root, inputs, expected):
    index = read_json_bytes(inputs.add("function-index.json", "function-index"), "function-index.json")
    layout = read_json_bytes(inputs.add("decomp-progress/layout.json", "layout"), "layout.json")
    if not isinstance(index, dict) or index.get("original_sha256") != PINNED_SHA:
        fail("function-index.json does not describe the pinned GAME.EXE")
    if not isinstance(layout, dict) or layout.get("schema") != LAYOUT_SCHEMA or layout.get("original_sha256") != PINNED_SHA:
        fail("layout.json does not describe the pinned GAME.EXE")
    funcs = index.get("functions")
    if not isinstance(funcs, list) or index.get("failures") != []:
        fail("function-index.json: unexpected functions or failures")
    expected = index.get("pseudocode_functions") if expected is None else expected
    if len(funcs) != expected or index.get("pseudocode_functions") != len(funcs):
        fail(f"function count {len(funcs)} differs from the expected {expected}")
    names, starts = {}, []
    for f in funcs:
        if not isinstance(f, dict) or not isinstance(f.get("name"), str):
            fail("function-index.json: malformed function record")
        va = parse_va(f.get("address"), "function-index.json")
        if va in names:
            fail(f"function index has a duplicate start {fmt(va)}")
        names[va] = f["name"]
        starts.append(va)
    starts.sort()
    base = layout.get("image_base")
    sections = {s.get("name"): s for s in layout.get("sections", []) if isinstance(s, dict)}
    text = sections.get(".text")
    if not is_int(base) or text is None or not is_int(text.get("rva")) or not is_int(text.get("virt_size")):
        fail("layout.json: no usable .text section")
    text_start, text_end = base + text["rva"], base + text["rva"] + text["virt_size"]
    regions = layout.get("code_regions")
    if (not isinstance(regions, list) or [r.get("id") for r in regions] != list(REGIONS)
            or regions[0]["start_va"] != text_start or regions[-1]["end_va"] != text_end
            or any(a["end_va"] != b["start_va"] for a, b in zip(regions, regions[1:]))):
        fail("layout.json: code regions do not tile .text")
    if starts[0] != text_start or starts[-1] >= text_end:
        fail("function starts do not span .text")
    spans = {va: (starts[i + 1] if i + 1 < len(starts) else text_end) - va for i, va in enumerate(starts)}
    edges = [r["start_va"] for r in regions]
    region_of = {}
    for va in starts:
        r = regions[bisect.bisect_right(edges, va) - 1]
        if va + spans[va] > r["end_va"]:
            fail(f"function {fmt(va)} crosses the {r['id']} region seam")
        region_of[va] = r["id"]
    return Universe(starts, spans, region_of, [r["start_va"] for r in regions[1:]], text_start, text_end, names, base)


def load_census(root, inputs, uni):
    census = read_json_bytes(inputs.add("asm/census-summary.json", "census"), "census-summary.json")
    try:
        by_region = census["by_region"]
        derived = census["derived_functions"]
        fragments = census["fall_through_fragments"]
        unsplit = census["unsplit_spans"]
        span_totals = {r: by_region[r]["span_bytes"] for r in REGIONS}
    except (KeyError, TypeError) as exc:
        raise LedgerError(f"census-summary.json is malformed: {exc!r}") from exc
    computed = {r: sum(uni.spans[v] for v in uni.starts if uni.regions[v] == r) for r in REGIONS}
    if span_totals != computed:
        fail(f"census region span bytes {span_totals} differ from the index spans {computed}")
    if not is_int(derived) or not isinstance(fragments, list) or not isinstance(unsplit, list):
        fail("census-summary.json: malformed counts")
    frag_blockers, unsplit_vas = {}, set()
    for f in fragments:
        va = parse_va(f, "census fragment")
        owner = uni.containing(va)
        if owner is None:
            fail(f"census fragment {fmt(va)} is outside .text")
        frag_blockers.setdefault(owner, []).append(va)
    for u in unsplit:
        va = u.get("va") if isinstance(u, dict) else None
        if not is_int(va) or va not in uni.index:
            fail("census unsplit span is not an indexed function start")
        unsplit_vas.add(va)
    return {"derived": derived, "fragments": frag_blockers, "unsplit": unsplit_vas}


# --------------------------------------------------------- input: xrefs --

def load_xrefs(inputs, uni):
    raw = inputs.add("function-xrefs.json", "xrefs", required=False)
    if raw is None:
        return None
    doc = read_json_bytes(raw, "function-xrefs.json")
    exact_keys(doc, ["schema", "functions"], ["original_sha256", "inner_thunks", "counts", "inputs"], "xrefs")
    if doc["schema"] != XREFS_SCHEMA:
        fail(f"xrefs schema must be {XREFS_SCHEMA}")
    if doc.get("original_sha256", PINNED_SHA) != PINNED_SHA:
        fail("xrefs does not describe the pinned GAME.EXE")
    if not isinstance(doc["functions"], list):
        fail("xrefs: functions must be a list")
    out = {}
    for f in doc["functions"]:
        exact_keys(f, "va body_size derived_parts callers callees imports data_ref eh_parent thunk".split(),
                   ["eh_kind", "origin"], "xrefs function")
        va = parse_va(f["va"], "xrefs")
        what = f"xrefs {fmt(va)}"
        if va not in uni.index:
            fail(f"{what}: not an indexed function start")
        if va in out:
            fail(f"{what}: duplicate xrefs entry")
        span = uni.spans[va]
        body = f["body_size"]
        if body is not None and (not is_int(body) or not 1 <= body <= span):
            fail(f"{what}: body_size must be null or within the span")
        parts = va_list(f["derived_parts"], what)
        if parts != sorted(parts) or any(not va < p < va + span for p in parts):
            fail(f"{what}: derived parts must be sorted, unique and inside the span")
        callers, callees = va_list(f["callers"], what), va_list(f["callees"], what)
        for v in callers + callees:
            if not uni.text_start <= v < uni.text_end:
                fail(f"{what}: caller or callee outside .text")
        imports = name_list(f["imports"], IMPORT_NAME, what)
        if type(f["data_ref"]) is not bool or type(f["thunk"]) is not bool:
            fail(f"{what}: data_ref and thunk must be booleans")
        parent = None
        if f["eh_parent"] is not None:
            parent = parse_va(f["eh_parent"], what)
            if parent not in uni.index or parent == va:
                fail(f"{what}: eh_parent is not another indexed function")
            if f.get("eh_kind") not in EH_KINDS:
                fail(f"{what}: a funclet needs eh_kind unwind or catch")
        elif f.get("eh_kind") is not None:
            fail(f"{what}: eh_kind without eh_parent")
        origin = f.get("origin")
        if "origin" in f and origin not in XREF_ORIGINS:
            fail(f"{what}: invalid origin")
        if f["thunk"] and origin not in (None, "import_thunk"):
            fail(f"{what}: a thunk has origin import_thunk")
        if parent is not None and origin not in (None, "compiler_eh"):
            fail(f"{what}: a funclet has origin compiler_eh")
        if origin == "import_thunk" and not f["thunk"] or origin == "compiler_eh" and parent is None:
            fail(f"{what}: origin {origin} lacks its proof (thunk flag or eh_parent)")
        if origin is None:
            origin = "import_thunk" if f["thunk"] else "compiler_eh" if parent is not None else "unknown"
        out[va] = {"va": va, "body_size": body, "parts": parts, "callers": callers, "callees": callees,
                   "imports": imports, "data_ref": f["data_ref"], "eh_parent": parent,
                   "eh_kind": f.get("eh_kind"), "thunk": f["thunk"], "origin": origin}
    thunks = {}
    for t in doc.get("inner_thunks", []):
        exact_keys(t, "va parent import".split(), (), "inner thunk")
        va, parent = parse_va(t["va"], "inner thunk"), parse_va(t["parent"], "inner thunk")
        if parent not in uni.index or not parent < va < parent + uni.spans[parent] or va in uni.index:
            fail(f"inner thunk {fmt(va)} is not inside the span of indexed parent {fmt(parent)}")
        if not isinstance(t["import"], str) or not IMPORT_NAME.fullmatch(t["import"]):
            fail("inner thunk: invalid import name")
        if va in thunks or parent in out and va in out[parent]["parts"]:
            fail(f"inner thunk {fmt(va)} is duplicated")
        thunks[va] = parent
    return {"functions": out, "thunks": thunks}


# ------------------------------------------------------- input: evidence --

def load_evidence(root, inputs, uni):
    raw = inputs.add("function-evidence.json", "evidence", required=False)
    if raw is None:
        return {}
    doc = read_json_bytes(raw, "function-evidence.json")
    exact_keys(doc, ["schema", "functions"], ["original_sha256", "counts", "inputs"], "evidence")
    if doc["schema"] != EVIDENCE_SCHEMA:
        fail(f"evidence schema must be {EVIDENCE_SCHEMA}")
    if doc.get("original_sha256", PINNED_SHA) != PINNED_SHA:
        fail("evidence does not describe the pinned GAME.EXE")
    if not isinstance(doc["functions"], list):
        fail("evidence: functions must be a list")
    out, previous = {}, -1
    for f in doc["functions"]:
        exact_keys(f, ["va", "evidence"], ["blockers", "divergences"], "evidence function")
        va = parse_va(f["va"], "evidence")
        what = f"evidence {fmt(va)}"
        if va not in uni.index:
            fail(f"{what}: not an indexed function start (interior addresses belong in a mention)")
        if va in out:
            fail(f"{what}: duplicate evidence entry")
        if va < previous:
            fail(f"{what}: evidence functions are not sorted by address")
        previous = va
        pointers = [validate_pointer(p, what) for p in f["evidence"]]
        keys = [pointer_key(p) for p in pointers]
        if len(set(keys)) != len(keys):
            fail(f"{what}: duplicate evidence pointer")
        for p in pointers:
            if p["kind"] in POINTER_ROLE:
                data = inputs.add(p["path"], POINTER_ROLE[p["kind"]])
                if "sha256" in p and sha256_bytes(data) != p["sha256"]:
                    fail(f"{what}: {p['kind']} pointer sha256 differs from {p['path']}; rerun the extractor")
        blockers, seen = [], set()
        for b in f.get("blockers", []):
            exact_keys(b, "address id text".split(), (), what)
            addr = parse_va(b["address"], what)
            if not va <= addr < va + uni.spans[va]:
                fail(f"{what}: blocker address {fmt(addr)} is outside the function span")
            if not isinstance(b["id"], str) or not ITEM_ID.fullmatch(b["id"]) or b["id"].startswith("census_"):
                fail(f"{what}: invalid blocker id")
            if b["id"] in seen:
                fail(f"{what}: duplicate blocker id")
            seen.add(b["id"])
            blockers.append({"address": fmt(addr), "id": b["id"], "text": text_value(b["text"], what)})
        divergences, seen = [], set()
        for d in f.get("divergences", []):
            exact_keys(d, "id text safety_rejection".split(), (), what)
            if not isinstance(d["id"], str) or not ITEM_ID.fullmatch(d["id"]) or d["id"] in seen:
                fail(f"{what}: invalid or duplicate divergence id")
            if type(d["safety_rejection"]) is not bool:
                fail(f"{what}: safety_rejection must be a boolean")
            seen.add(d["id"])
            divergences.append({"id": d["id"], "text": text_value(d["text"], what),
                                "safety_rejection": d["safety_rejection"]})
        out[va] = {"evidence": sorted(pointers, key=pointer_key),
                   "blockers": sorted(blockers, key=lambda b: (b["address"], b["id"])),
                   "divergences": sorted(divergences, key=lambda d: d["id"])}
    return out


# ------------------------------------------------------ input: overrides --

def load_overrides(inputs, uni):
    empty = {"acceptances": {}, "entries": {}, "rules": [], "sensitive": set(), "allowlist": None}
    raw = inputs.add("function-ledger-overrides.json", "overrides", required=False)
    if raw is None:
        return empty
    doc = read_json_bytes(raw, "function-ledger-overrides.json")
    exact_keys(doc, ["schema", "port_acceptances", "not_needed_entries", "not_needed_rules", "semantics_sensitive"],
               ["original_sha256", "win32_import_allowlist"], "overrides")
    if doc["schema"] != OVERRIDES_SCHEMA:
        fail(f"overrides schema must be {OVERRIDES_SCHEMA}")
    if doc.get("original_sha256", PINNED_SHA) != PINNED_SHA:
        fail("overrides do not describe the pinned GAME.EXE")
    for key in ("port_acceptances", "not_needed_entries", "not_needed_rules", "semantics_sensitive"):
        if not isinstance(doc[key], list):
            fail(f"overrides: {key} must be a list")

    def index_va(value, what):
        va = parse_va(value, what)
        if va not in uni.index:
            fail(f"{what}: {fmt(va)} is not an indexed function start")
        return va

    acceptances = {}
    for a in doc["port_acceptances"]:
        exact_keys(a, "va class reviewer date native_source tests oracle parts_accounted".split(), ["note"], "acceptance")
        va = index_va(a["va"], "acceptance")
        what = f"acceptance {fmt(va)}"
        if va in acceptances:
            fail(f"{what}: duplicate acceptance")
        if a["class"] not in PORTED_CLASSES:
            fail(f"{what}: class must be one of {PORTED_CLASSES}")
        text_value(a["reviewer"], what, 80)
        date_value(a["date"], what)
        if "note" in a:
            text_value(a["note"], what)
        exact_keys(a["native_source"], ["path", "symbol"], (), what)
        rel_path(a["native_source"]["path"], what)
        if not isinstance(a["native_source"]["symbol"], str) or not IDENT.fullmatch(a["native_source"]["symbol"]):
            fail(f"{what}: invalid symbol")
        if not isinstance(a["tests"], list) or not a["tests"]:
            fail(f"{what}: at least one test is required")
        tests = []
        for t in a["tests"]:
            exact_keys(t, ["path", "test_id"], (), what)
            rel_path(t["path"], what)
            if not isinstance(t["test_id"], str) or not TEST_ID.fullmatch(t["test_id"]):
                fail(f"{what}: invalid test_id")
            tests.append((t["path"], t["test_id"]))
        oracle = None
        if a["oracle"] is not None:
            exact_keys(a["oracle"], ["path", "window"], (), what)
            rel_path(a["oracle"]["path"], what)
            w = a["oracle"]["window"]
            if not isinstance(w, list) or len(w) != 2:
                fail(f"{what}: oracle window must be [start, end_exclusive]")
            oracle = (a["oracle"]["path"], fmt(parse_va(w[0], what)), fmt(parse_va(w[1], what)))
        if a["class"] == "native_oracle_verified" and oracle is None:
            fail(f"{what}: native_oracle_verified needs an oracle")
        if a["class"] != "native_oracle_verified" and oracle is not None:
            fail(f"{what}: only native_oracle_verified names an oracle")
        acceptances[va] = {"va": va, "class": a["class"], "reviewer": a["reviewer"], "date": a["date"],
                           "symbol": (a["native_source"]["path"], a["native_source"]["symbol"]),
                           "tests": tests, "oracle": oracle,
                           "parts": set(va_list(a["parts_accounted"], what))}
    entries = {}
    for e in doc["not_needed_entries"]:
        exact_keys(e, "va reason text reviewer date".split(), (), "not_needed entry")
        va = index_va(e["va"], "not_needed entry")
        what = f"not_needed entry {fmt(va)}"
        if va in entries:
            fail(f"{what}: duplicate entry")
        if e["reason"] not in REASONS:
            fail(f"{what}: reason is not in the closed enum")
        entries[va] = {"va": va, "reason": e["reason"], "text": text_value(e["text"], what),
                       "reviewer": text_value(e["reviewer"], what, 80), "date": date_value(e["date"], what)}
    rules, seen = [], set()
    for r in doc["not_needed_rules"]:
        exact_keys(r, "id predicate reason rationale accepted".split(),
                   ["reviewer", "date", "sample_review", "parents_without_native_exception_path"], "rule")
        what = f"rule {r.get('id')}"
        if r["predicate"] not in PREDICATES or r["id"] != r["predicate"]:
            fail(f"{what}: the rule id must equal a known predicate id {sorted(PREDICATES)}")
        if r["id"] in seen:
            fail(f"{what}: duplicate rule")
        seen.add(r["id"])
        if r["reason"] != PREDICATES[r["predicate"]]:
            fail(f"{what}: reason must be {PREDICATES[r['predicate']]}")
        text_value(r["rationale"], what)
        if type(r["accepted"]) is not bool:
            fail(f"{what}: accepted must be a boolean")
        parents = set()
        if "parents_without_native_exception_path" in r:
            if r["id"] != "R-EH":
                fail(f"{what}: parents_without_native_exception_path belongs to R-EH only")
            parents = {index_va(v, what) for v in r["parents_without_native_exception_path"]}
        if r["accepted"]:
            for key in ("reviewer", "date", "sample_review"):
                if r.get(key) is None:
                    fail(f"{what}: an accepted rule needs {key}")
            text_value(r["reviewer"], what, 80)
            date_value(r["date"], what)
            s = r["sample_review"]
            exact_keys(s, "sample_sha256 n defects".split(), (), what)
            sha_value(s["sample_sha256"], what)
            if not is_int(s["n"]) or s["n"] < SAMPLE_MIN or not is_int(s["defects"]) or s["defects"] != 0:
                fail(f"{what}: the accepted sample needs n >= {SAMPLE_MIN} and zero defects")
        elif r.get("sample_review") is not None:
            exact_keys(r["sample_review"], "sample_sha256 n defects".split(), (), what)
        rules.append({**r, "parents": parents})
    sensitive = set()
    for s in doc["semantics_sensitive"]:
        exact_keys(s, ["va", "why"], (), "semantics_sensitive")
        va = index_va(s["va"], "semantics_sensitive")
        text_value(s["why"], "semantics_sensitive")
        if va in sensitive:
            fail(f"semantics_sensitive: duplicate {fmt(va)}")
        sensitive.add(va)
    allowlist = None
    if "win32_import_allowlist" in doc:
        a = doc["win32_import_allowlist"]
        exact_keys(a, "names reviewer date".split(), (), "win32_import_allowlist")
        text_value(a["reviewer"], "win32_import_allowlist", 80)
        date_value(a["date"], "win32_import_allowlist")
        allowlist = set(name_list(a["names"], IMPORT_NAME, "win32_import_allowlist"))
    return {"acceptances": acceptances, "entries": entries, "rules": rules, "sensitive": sensitive,
            "allowlist": allowlist}


# --------------------------------------------------------- input: x86 ----

def load_x86(root, inputs, uni):
    claims = []
    base = uni.base
    for name in COUNTED_MANIFESTS:
        raw = inputs.add(name, "x86-manifest", required=False)
        if raw is None:
            continue
        man = read_json_bytes(raw, name)
        if not isinstance(man, dict) or man.get("original_sha256") != PINNED_SHA or not isinstance(man.get("functions"), list):
            fail(f"{name}: does not describe the pinned GAME.EXE")
        for fn in man["functions"]:
            rva, size = fn.get("rva"), fn.get("size")
            if not is_int(rva) or not is_int(size) or size <= 0:
                fail(f"{name}: malformed function record")
            claims.append((base + rva, size, 0, MANIFEST_PROVENANCE[name], name))
    asm = root / "asm"
    batches = sorted(p.name for p in asm.glob("batch-*.json")) if asm.is_dir() else []
    for name in batches:
        if not re.fullmatch(r"batch-[0-9]+\.json", name):
            continue
        rel, rel_report = f"asm/{name}", f"asm/{name[:-5]}-report.json"
        man = read_json_bytes(inputs.add(rel, "x86-manifest"), rel)
        raw_report = inputs.add(rel_report, "x86-audit", required=False)
        if raw_report is None:
            fail(f"{rel}: batch has no audit report {rel_report}")
        report = read_json_bytes(raw_report, rel_report)
        try:
            ok = (man["original_sha256"] == report["original_sha256"] == PINNED_SHA
                  and man["class"] == report["class_requested"] == TOOL_ASSISTED
                  and report["manifest_sha256"] == inputs.items[rel]["sha256"]
                  and report["all_accepted"] is True and report["errors"] == [])
        except (KeyError, TypeError):
            ok = False
        if not ok:
            fail(f"{rel}: batch is not an accepted audit of this manifest")
        for fn in man["functions"]:
            try:
                va, rva, size = int(fn["va"], 16), fn["code"]["rva"], fn["code"]["size"]
                data = sum(item["size"] for item in fn["data_items"])
            except (KeyError, TypeError, ValueError):
                fail(f"{rel}: malformed function record")
            if not is_int(rva) or not is_int(size) or size <= 0 or not is_int(data) or va != base + rva:
                fail(f"{rel}: function address and rva disagree")
            claims.append((va, size, data, TOOL_ASSISTED, rel))
    best = {}
    for va, size, data, prov, manifest in claims:
        if va not in uni.index:
            continue
        complete = prov != PARTIAL_PROVENANCE and size + data == uni.spans[va]
        row = (not complete, -size, manifest, prov)
        if va not in best or row < best[va][0]:
            best[va] = (row, {"provenance": prov, "complete": complete, "manifest": manifest})
    return {va: v[1] for va, v in best.items()}


# ------------------------------------------------------- derivation -------

class Graph:
    """Call graph over index functions, from xrefs (both directions)."""

    def __init__(self, uni, xrefs):
        self.succ = {va: set() for va in uni.starts}
        self.preds = {va: set() for va in uni.starts}
        self.complete = xrefs is not None and set(xrefs["functions"]) == uni.index
        if xrefs is None:
            return
        for va, x in xrefs["functions"].items():
            for c in x["callees"]:
                owner = uni.containing(c)
                if owner is not None:
                    self.succ[va].add(owner)
                    self.preds[owner].add(va)
            for p in x["callers"]:
                owner = uni.containing(p)
                if owner is not None:
                    self.succ[owner].add(va)
                    self.preds[va].add(owner)

    @staticmethod
    def closure(seeds, edges):
        seen, stack = set(seeds), list(seeds)
        while stack:
            for nxt in edges[stack.pop()]:
                if nxt not in seen:
                    seen.add(nxt)
                    stack.append(nxt)
        return seen


def derive(root, *, expected_functions=EXPECTED_FUNCTIONS, work_dir=None, verify_private=False):
    """Derive the ledger from the pinned inputs under ``root``; any problem is a LedgerError."""
    try:
        return _derive(Path(root), expected_functions, work_dir, verify_private)
    except (KeyError, TypeError, AttributeError, IndexError, ValueError) as exc:
        if isinstance(exc, LedgerError):
            raise
        raise LedgerError(f"malformed input: {exc!r}") from exc


def _derive(root, expected_functions, work_dir, verify_private):
    inputs = Inputs(root)
    uni = load_universe(root, inputs, expected_functions)
    census = load_census(root, inputs, uni)
    xrefs = load_xrefs(inputs, uni)
    evidence = load_evidence(root, inputs, uni)
    ov = load_overrides(inputs, uni)
    x86 = load_x86(root, inputs, uni)
    if verify_private:
        verify_receipts(evidence, work_dir)
    xf = xrefs["functions"] if xrefs else {}
    if xrefs:
        total = sum(len(x["parts"]) for x in xf.values())
        if total != census["derived"]:
            fail(f"xrefs derived parts total {total} but the census derived_functions is {census['derived']}")
    graph = Graph(uni, xrefs)

    def pending_floor(va):
        """Why a function can never leave pending (census facts, vorbis)."""
        if uni.regions[va] == "vorbis":
            return "vorbis functions stay pending until PCM parity is proven"
        if va in census["unsplit"]:
            return "the census left this span unsplit"
        if va in census["fragments"]:
            return "the census lists a fall-through fragment inside this span"
        return None

    # ---- facts per function ----
    def seam(va):
        end = uni.end(va)
        for b in uni.boundaries:
            d = 0 if va <= b < end else b - end + 1 if end <= b else va - b
            if d <= SEAM_BYTES:
                return True
        return False

    thunks_of = {}
    if xrefs:
        for t, parent in xrefs["thunks"].items():
            thunks_of.setdefault(parent, set()).add(t)
    facts = {}
    for va in uni.starts:
        x, ev = xf.get(va), evidence.get(va)
        blockers = list(ev["blockers"]) if ev else []
        for frag in sorted(census["fragments"].get(va, [])):
            blockers.append({"address": fmt(frag), "id": CENSUS_FRAGMENT,
                             "text": "fall-through fragment listed in the census; the function stays pending"})
        if va in census["unsplit"]:
            blockers.append({"address": fmt(va), "id": CENSUS_UNSPLIT,
                             "text": "span left unsplit by the census; the function stays pending"})
        facts[va] = {
            "x": x, "pointers": ev["evidence"] if ev else [],
            "blockers": sorted(blockers, key=lambda b: (b["address"], b["id"])),
            "divergences": ev["divergences"] if ev else [],
            "origin": x["origin"] if x else "unknown", "seam": seam(va),
            "body": x["body_size"] if x else None,
            "parts": sorted(set(x["parts"] if x else []) | thunks_of.get(va, set())),
        }

    # ---- rule 3: port acceptances ----
    ported = {}
    for va, a in sorted(ov["acceptances"].items()):
        ported[va] = check_acceptance(va, a, facts[va], root, uni, xrefs, pending_floor(va))
    # ---- rule 4: per-function not_needed entries ----
    for va in sorted(ov["entries"]):
        if va in ported:
            fail(f"{fmt(va)} is both ported and not_needed")
    reached_game = None
    roots = None
    if xrefs:
        game = {v for v in uni.starts if uni.regions[v] == "game"}
        roots = game | {v for v, x in xf.items() if x["data_ref"]}
        reached = Graph.closure(roots, graph.succ)
        back_to_game = Graph.closure(game, graph.preds)
    else:
        reached = back_to_game = set()
    entries_nn = {}
    for va, e in sorted(ov["entries"].items()):
        check_not_needed_entry(va, e, facts[va], uni, graph, ov, reached, back_to_game, pending_floor(va))
        entries_nn[va] = e
    # ---- rule 5: sampled predicate rules ----
    rule_hits = {}
    for rule in ov["rules"]:
        if not rule["accepted"]:
            continue
        if not graph.complete:
            fail(f"rule {rule['id']}: accepted rules need function-xrefs.json to cover every function")
        for va in uni.starts:
            if rule_matches(rule, va, facts[va], uni, ov, ported, reached, back_to_game, pending_floor(va)):
                if va in rule_hits:
                    fail(f"{fmt(va)} is selected by two rules")
                rule_hits[va] = rule
    for va, rule in rule_hits.items():
        if va in ported or va in entries_nn:
            fail(f"{fmt(va)} is decided by a per-function override and by rule {rule['id']}")

    # ---- entries ----
    out = []
    for va in uni.starts:
        f = facts[va]
        e = {"va": fmt(va), "name": uni.names[va], "span": uni.spans[va], "body_size": f["body"],
             "derived_parts": [fmt(p) for p in f["parts"]], "region": uni.regions[va], "origin": f["origin"],
             "seam": f["seam"], "x86_match": x86.get(va), "evidence": f["pointers"],
             "blockers": f["blockers"], "divergences": f["divergences"], "reason": None, "review": None}
        if va in ported:
            a = ported[va]
            e.update(status="ported", review={"reviewer": a["reviewer"], "date": a["date"], "sample": None})
            e["class"] = a["class"]
        elif va in entries_nn:
            n = entries_nn[va]
            e.update(status="not_needed", reason={"code": n["reason"], "text": n["text"], "rule": None},
                     review={"reviewer": n["reviewer"], "date": n["date"], "sample": None})
            e["class"] = "nn_reviewed"
        elif va in rule_hits:
            r = rule_hits[va]
            e.update(status="not_needed", reason={"code": r["reason"], "text": r["rationale"], "rule": r["id"]},
                     review={"reviewer": r["reviewer"], "date": r["date"], "sample": r["sample_review"]["sample_sha256"]})
            e["class"] = "nn_rule"
        else:
            e.update(status="pending")
            e["class"] = classify_pending(e)
        out.append({k: e[k] for k in ENTRY_KEYS})
    ledger = {"schema": SCHEMA, "original_sha256": PINNED_SHA, "inputs": inputs.listing(),
              "counts": count_entries(out), "entries": out}
    return validate(ledger)


def verify_receipts(evidence, work_dir):
    if work_dir is None:
        fail("receipt verification needs the work directory")
    work = Path(work_dir)
    for va, ev in sorted(evidence.items()):
        for p in ev["evidence"]:
            if p["kind"] != "receipt":
                continue
            path = work / p["path"]
            if not path.is_file():
                fail(f"{fmt(va)}: private receipt {p['path']} is missing")
            if sha256_bytes(path.read_bytes()) != p["sha256"]:
                fail(f"{fmt(va)}: private receipt {p['path']} differs from its recorded sha256")


def read_text_input(root, rel, what):
    """Text of a file that load_evidence already pinned (the pointer named it)."""
    try:
        return (Path(root) / rel).read_bytes().decode("utf-8")
    except (OSError, UnicodeDecodeError) as exc:
        raise LedgerError(f"{what}: cannot read {rel} as UTF-8 text") from exc


def check_acceptance(va, a, f, root, uni, xrefs, floor):
    what = f"acceptance {fmt(va)}"
    if floor:
        fail(f"{what}: {floor}")
    pointers = f["pointers"]
    path, symbol = a["symbol"]
    if not any(p["kind"] == "native_source" and p["path"] == path and p["symbol"] == symbol for p in pointers):
        fail(f"{what}: native_source {path}:{symbol} is not in the evidence for this function")
    for tpath, tid in a["tests"]:
        if not any(p["kind"] == "test" and p["path"] == tpath and p["test_id"] == tid for p in pointers):
            fail(f"{what}: test {tpath}:{tid} is not in the evidence for this function")
    # (a) the VA appears in the symbol's body or leading comment
    source = read_text_input(root, path, what)
    area = symbol_area(source, symbol, path)
    if va not in addresses_in(area):
        fail(f"{what}: address {fmt(va)} does not appear in the body or leading comment of {symbol}")
    # (b) named tests exist and reference the symbol or module
    module = Path(path).stem
    for tpath, tid in a["tests"]:
        body = test_area(read_text_input(root, tpath, what), tid, tpath)
        if not re.search(r"\b" + re.escape(symbol) + r"\b", body) and not re.search(r"\b" + re.escape(module) + r"\b", body):
            fail(f"{what}: test {tid} does not reference {symbol} or module {module}")
    # (c) oracle coverage
    if a["class"] == "native_oracle_verified":
        opath, start, end = a["oracle"]
        match = [p for p in pointers if p["kind"] == "oracle" and p["path"] == opath and p["window"] == [start, end]]
        if not match:
            fail(f"{what}: oracle {opath} window [{start}, {end}) is not in the evidence for this function")
        if match[0]["use"] not in QUALIFYING_USES:
            fail(f"{what}: oracle window used as {match[0]['use']!r} never qualifies (needs entry or callee)")
        if f["body"] is None:
            fail(f"{what}: body_size from xrefs is needed to check oracle coverage")
        if not covers(match[0], va, f["body"]):
            fail(f"{what}: oracle window [{start}, {end}) does not cover the body "
                 f"[{fmt(va)}, {fmt(va + f['body'])})")
    # (d) blockers
    for b in f["blockers"]:
        if not cleared(b, f["divergences"]):
            fail(f"{what}: blocker {b['id']} at {b['address']} remains and is not a deliberate safety rejection")
    # (e) derived parts and inner thunks are all accounted for
    thunks = set(xrefs["thunks"]) if xrefs else set()
    needed = set(f["parts"])
    if a["parts"] != needed:
        missing, extra = sorted(needed - a["parts"]), sorted(a["parts"] - needed)
        fail(f"{what}: parts_accounted differs from the function's parts "
             f"(missing {[fmt(v) for v in missing]}, unknown {[fmt(v) for v in extra]})")
    for part in sorted(needed - thunks):
        if part not in addresses_in(area):
            fail(f"{what}: derived part {fmt(part)} does not appear in {symbol}")
    return a


def callee_functions(x, va, uni):
    out = set()
    for c in x["callees"]:
        owner = uni.containing(c)
        if owner is not None and owner != va:
            out.add(owner)
    return out


def check_not_needed_entry(va, e, f, uni, graph, ov, reached, back_to_game, floor):
    reason = e["reason"]
    what = f"not_needed entry {fmt(va)} ({reason})"
    if floor:
        fail(f"{what}: {floor}")
    x = f["x"]
    if x is None:
        fail(f"{what}: function-xrefs.json must describe this function to prove the precondition")
    region = uni.regions[va]
    if reason == "unreachable_no_refs":
        if x["callers"] or graph.preds[va] or x["data_ref"]:
            fail(f"{what}: needs zero callers and no data reference")
    elif reason in ("win32_plumbing_no_observable_effect", "debug_diagnostic_only"):
        allowed = ov["allowlist"] if reason.startswith("win32") else DEBUG_IMPORTS
        label = "allowlist" if reason.startswith("win32") else "debug import list"
        if allowed is None:
            fail(f"{what}: no reviewed win32_import_allowlist exists")
        if not x["imports"] or not set(x["imports"]) <= allowed:
            fail(f"{what}: imports {x['imports']} are not all within the reviewed {label}")
        for callee in sorted(callee_functions(x, va, uni)):
            if uni.regions[callee] == "game" and callee not in ov["entries"]:
                fail(f"{what}: game-region callee {fmt(callee)} is not itself not_needed")
    elif reason == "crt_startup_termination":
        if region != "crt_mfc" or f["origin"] != "library":
            fail(f"{what}: needs a library function in the crt_mfc region")
        if any(uni.regions[p] == "game" for p in graph.preds[va]):
            fail(f"{what}: a game-region function calls it")
    elif reason == "host_libc_standard_contract":
        if region != "crt_mfc" or f["origin"] != "library":
            fail(f"{what}: needs a library function in the crt_mfc region")
    elif reason == "library_internal_unreached_by_game":
        if not graph.complete:
            fail(f"{what}: needs function-xrefs.json to cover every function")
        if region != "crt_mfc" or f["origin"] != "library" or x["data_ref"] or x["thunk"]:
            fail(f"{what}: needs a library function in the crt_mfc region with no data reference")
        if va in reached or va in back_to_game:
            fail(f"{what}: game code reaches it or it reaches game code")
    elif reason == "compiler_eh_funclet":
        if f["origin"] != "compiler_eh" or x["eh_parent"] is None:
            fail(f"{what}: needs a funclet proof (origin compiler_eh with an eh_parent)")


def rule_matches(rule, va, f, uni, ov, ported, reached, back_to_game, floor):
    """Predicate plus the exclusions every rule shares. Never true for game code."""
    if floor or uni.regions[va] != "crt_mfc" or f["seam"] or f["pointers"] or va in ov["sensitive"]:
        return False
    x = f["x"]
    if x is None or f["blockers"]:
        return False
    if rule["id"] == "R-LIB-INTERNAL":
        return (f["origin"] == "library" and not x["data_ref"] and not x["thunk"] and x["eh_parent"] is None
                and va not in reached and va not in back_to_game)
    if rule["id"] == "R-EH":
        parent = x["eh_parent"]
        return (f["origin"] == "compiler_eh" and x["eh_kind"] == "unwind" and parent is not None
                and (parent in ported or parent in rule["parents"]))
    return False


# ------------------------------------------------------------------ check --

def load_ledger(path):
    path = Path(path)
    try:
        raw = path.read_text(encoding="utf-8")
    except OSError as exc:
        raise LedgerError(f"cannot read {path.name}: {exc}") from exc
    return raw, read_json_bytes(raw.encode("utf-8"), path.name)


def check(root, ledger_path=None, **kwargs):
    """Validate the committed ledger and prove it equals a fresh derivation."""
    root = Path(root)
    path = Path(ledger_path) if ledger_path else root / "function-ledger.json"
    raw, committed = load_ledger(path)
    validate(committed)
    fresh = derive(root, **kwargs)
    if raw != render(fresh):
        fail(STALE_MESSAGE)
    return fresh
