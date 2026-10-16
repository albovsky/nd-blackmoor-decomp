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
``asm/census-summary.json``, ``function-evidence.json`` (FL-2),
``function-xrefs.json`` and ``function-ledger-overrides.json`` (FL-3). Optional,
pinned as absent (``sha256: null``) so that adding one makes the ledger stale:
the counted x86 match manifests and ``asm/batch-N.json`` with their audit
reports. The x86 match fields are orthogonal: recorded, never read by the
status rules.

Evidence caveats (FL-2 review): native_source and test pointers are LEXICAL
citations (most native_source pointers are comments), and oracle ``use`` entry
is STRUCTURAL (window start equals the function start; nothing was executed).
So pointers alone make a function a ``candidate_port`` at most and never
``ported``: only a reviewed ``port_acceptances`` entry does, re-checked
mechanically here (the VA in the symbol, a named test, a recorded-hash entry or
callee window covering the body, no uncleared blocker, every derived part
accounted for). An entry window is never counted as a test: every ported
function needs a test pointer too.

The three extractor files are consumed in their real shapes (the extractors'
own validators are the authority; this module re-checks what it relies on):

function-xrefs.json (scripts/extract_function_xrefs.py, validated with its own
``validate``): ``inputs`` pins are checked against the committed files (the
private GAME.EXE and Ghidra dump cannot be re-checked here and are reported as
notes, never as a pass), the regions must equal layout.json, and each entry's
region and span must equal the index-derived values. region, span, body_size,
derived_parts, origin (game|library|compiler_eh|import_thunk|unknown), seam and
the EH-funclet fields are taken from the entries, not recomputed.

function-evidence.json (scripts/extract_function_evidence.py): functions carry
repo-relative pointers (``outputs/blackmoor-decomp/...``; the ledger keeps them
root-relative) plus ``blockers`` and ``divergences`` as receipt-item records
(slice, text sha256, address; no text). Every committed file a pointer or the
``sources`` table names is re-hashed. Items are grouped per (slice, text
sha256) into ledger blockers/divergences with id ``<slice>:<sha256[:16]>``; a
divergence is a deliberate safety rejection only when every list that holds it
is a ``*safety_rejections`` list. A blocker is cleared for a ported function
only by a safety-rejection divergence with the same id, that is, the very same
statement recorded as a rejection.

function-ledger-overrides.json (FL-3 draft shape plus the FL-1 sections)
    schema "blackmoor-function-ledger-overrides/1"; optional status, note and
    original_sha256.
      port_acceptances: [{va, class, reviewer, date, native_source: {path,
          symbol}, tests: [{path, test_id}], oracle: null|{path, window},
          parts_accounted: [va], note (optional), blockers_reviewed (optional):
          [{id, rationale}]}]  (paths root-relative).  A receipt blocker that
          is not a recorded safety rejection clears only through
          blockers_reviewed: the id must be one of this function's blockers and
          the rationale (at least 40 characters) says why the unverified branch
          does not touch what the acceptance claims.  The ledger entry keeps the
          blocker, now carrying {reviewer, date, rationale}.  Unlocated
          unverified items of a receipt (no address) are carried as a count on
          the receipt pointer; they never block.
      not_needed_entries: [{va, reason, text, reviewer, date}]
      not_needed_rules: [{id, predicate, accepted, reason_code, rationale,
          parameters, review: {reviewer, date, n, defects, sample_sha256},
          optional documentation lists}]  (id == predicate; R-EH takes the
          parameter eh_parent_regions; a rule with accepted false is an inert
          draft)
      semantics_sensitive: [spec]  (FL-3 selector specs; the resolved set
          excludes functions from every rule)
      win32_import_allowlist (optional): {names, reviewer, date}  (DLL!Name)
"""

from __future__ import annotations

import bisect
import datetime
import hashlib
import importlib.util
import json
import re
import sys
from pathlib import Path

SCHEMA = "blackmoor-function-ledger/1"
EVIDENCE_SCHEMA = "blackmoor-function-evidence/1"
XREFS_SCHEMA = "blackmoor-function-xrefs/1"
OVERRIDES_SCHEMA = "blackmoor-function-ledger-overrides/1"
LAYOUT_SCHEMA = "blackmoor-image-layout/1"
PINNED_SHA = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
EXPECTED_FUNCTIONS = 4188
STALE_MESSAGE = "function ledger stale; rerun scripts/build_function_ledger.py --write"
SAMPLE_MIN = 59
BLOCKER_RATIONALE_MIN = 40      # a blocker review is a written reason, not a tick box

STATUSES = ("ported", "not_needed", "pending")
PORTED_CLASSES = ("native_oracle_verified", "native_tests_only", "host_adapter_tested")
NOT_NEEDED_CLASSES = ("nn_rule", "nn_reviewed")
PENDING_CLASSES = ("candidate_port", "partial_native", "static_navigation_only", "none")
CLASSES = PORTED_CLASSES + NOT_NEEDED_CLASSES + PENDING_CLASSES
CLASS_STATUS = {**{c: "ported" for c in PORTED_CLASSES}, **{c: "not_needed" for c in NOT_NEEDED_CLASSES},
                **{c: "pending" for c in PENDING_CLASSES}}
REGIONS = ("game", "vorbis", "crt_mfc")
ORIGINS = ("game", "library", "compiler_eh", "import_thunk", "unknown")
USES = ("entry", "callee", "mapped")
QUALIFYING_USES = ("entry", "callee")
USE_BASES = ("window_start", "observed_hook", "replaced_by_hook", "hook_unclassified", "static_scope",
             "containment_only", "unhashed")
VERIFIED = ("recorded_hash", "declared_only")
REVIEW_STATES = ("absent", "findings_addressed", "none", "pending", "reviewer_recorded")
MENTION_VIAS = ("citation", "window_start")
POINTER_KINDS = ("mention", "native_source", "oracle", "receipt", "test")
SOURCE_ROLES = {"native_source": "evidence-source", "test": "evidence-test", "oracle_source": "evidence-oracle"}
REASONS = ("win32_plumbing_no_observable_effect", "crt_startup_termination",
           "library_internal_unreached_by_game", "host_libc_standard_contract",
           "debug_diagnostic_only", "unreachable_no_refs", "compiler_eh_funclet")
# Predicate id -> reason code. A rule carries exactly its predicate's reason.
PREDICATES = {"R-EH": "compiler_eh_funclet", "R-LIB-INTERNAL": "library_internal_unreached_by_game"}
# Win32 debug output imports (DLL!Name, as function-xrefs lists them): the only
# imports a debug_diagnostic_only function may use.
DEBUG_IMPORTS = frozenset({"KERNEL32.dll!OutputDebugStringA", "KERNEL32.dll!OutputDebugStringW",
                           "KERNEL32.dll!IsDebuggerPresent", "KERNEL32.dll!DebugBreak"})
# Derived parts that are mechanical (thunks, EH handler stubs): they must be listed in
# parts_accounted but need not appear in the native source.
MECHANICAL_PARTS = frozenset({"import_thunk", "jump_thunk", "eh_handler_stub"})
DEFAULT_EH_PARENT_REGIONS = ("crt_mfc", "vorbis")
ROLES = ("function-index", "layout", "census", "x86-manifest", "x86-audit", "evidence", "xrefs", "overrides",
         "evidence-source", "evidence-oracle", "evidence-test", "evidence-mention", "xrefs-pin")
POINTER_ROLE = {"native_source": "evidence-source", "oracle": "evidence-oracle",
                "test": "evidence-test", "mention": "evidence-mention"}

REPO_PREFIX = "outputs/blackmoor-decomp/"       # evidence and xrefs name committed files repo-relative
PRIVATE_PREFIX = "analysis/slices/"             # private receipts, work-relative, never hashed here

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

EVIDENCE_TOP = "schema original_sha256 text_range function_index sources receipts functions unresolved counts".split()
XREFS_TOP = ("schema original_sha256 inputs tools parameters regions roots counts imports thunks eh_stubs "
             "derived_parts entries").split()
RECEIPT_ROW = "slice kind path sha256 review windows unverified divergence_items hook_addresses files".split()
ITEM_RECORD = "slice path field index text_sha256 address interior".split()

HEX64 = re.compile(r"[0-9a-f]{64}")
IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_]{0,127}")
TEST_ID = re.compile(r"[A-Za-z_][A-Za-z0-9_.]{0,127}")
IMPORT_NAME = re.compile(r"[A-Za-z0-9_.@?$#-]{1,128}![A-Za-z0-9_.@?$#-]{1,128}")
ITEM_ID = re.compile(r"[A-Za-z0-9][A-Za-z0-9._:-]{0,63}")
FIELD_NAME = re.compile(r"[A-Za-z0-9_/.-]{1,64}")
ENTRY_NAME = re.compile(r"[ -.0-\[\]-~]{1,120}")  # printable ASCII, no "/" or "\\" (a Ghidra label, informational only)
VA_TEXT = re.compile(r"0x[0-9a-fA-F]{1,8}")
SAFETY_FIELD = re.compile(r"(?:^|_)safety_rejections$")


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


def repo_to_root(path, what):
    """Committed-file path as the extractors write it -> root-relative."""
    rel_path(path, what)
    if not path.startswith(REPO_PREFIX) or len(path) == len(REPO_PREFIX):
        fail(f"{what}: {path!r} is not under {REPO_PREFIX}")
    return rel_path(path[len(REPO_PREFIX):], what)


def canon(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def sha256_bytes(raw):
    return hashlib.sha256(raw).hexdigest()


def read_json_bytes(raw, what):
    try:
        return json.loads(raw.decode("utf-8"))
    except (ValueError, UnicodeDecodeError) as exc:
        raise LedgerError(f"cannot parse {what}: {exc}") from exc


def xrefs_module():
    """FL-3's extractor module (validate, rule predicates, semantics_sensitive_set), loaded like playable.py."""
    existing = sys.modules.get("extract_function_xrefs")
    if existing is not None and hasattr(existing, "rule_candidates"):
        return existing
    path = Path(__file__).resolve().parents[1] / "scripts" / "extract_function_xrefs.py"
    spec = importlib.util.spec_from_file_location("extract_function_xrefs", path)
    if spec is None or spec.loader is None:
        fail("cannot load scripts/extract_function_xrefs.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules["extract_function_xrefs"] = module
    spec.loader.exec_module(module)
    return module


class Inputs:
    """Every file the derivation reads, pinned by hash (or by absence)."""

    def __init__(self, root: Path):
        self.root = root
        self.items = {}
        self.notes = []

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
#
# Ledger pointer shapes (all carry ``kind``; no line numbers anywhere):
#   native_source {path, symbol|null, sha256}
#   test          {path, test_id|null, sha256}
#   oracle        {path|null, window: [start, end_exclusive], window_sha256|null,
#                  use, use_basis, verified, sha256|null}
#   receipt       {slice, path (work-relative), sha256, review: state, unlocated_unverified}
#   mention       {path, symbol|null, via}
# Paths are root-relative, except receipt (and rare receipt-path mention) paths,
# which are work-relative and private.

def nullable_ident(value, pattern, what):
    if value is not None and (not isinstance(value, str) or not pattern.fullmatch(value)):
        fail(f"{what}: invalid name")


def validate_window(window, what):
    if not isinstance(window, list) or len(window) != 2:
        fail(f"{what}: oracle window must be [start, end_exclusive]")
    start, end = parse_va(window[0], what), parse_va(window[1], what)
    if end <= start:
        fail(f"{what}: oracle window must be [start, end_exclusive) with end after start")
    return start, end


def validate_pointer(p, what):
    """Strict ledger pointer shape; returns the pointer with canonical window strings."""
    if not isinstance(p, dict) or p.get("kind") not in POINTER_KINDS:
        fail(f"{what}: unknown evidence pointer kind")
    kind = p["kind"]
    if kind == "native_source":
        exact_keys(p, "kind path symbol sha256".split(), (), what)
        rel_path(p["path"], what)
        nullable_ident(p["symbol"], IDENT, what)
        sha_value(p["sha256"], what)
        return dict(p)
    if kind == "test":
        exact_keys(p, "kind path test_id sha256".split(), (), what)
        rel_path(p["path"], what)
        nullable_ident(p["test_id"], TEST_ID, what)
        sha_value(p["sha256"], what)
        return dict(p)
    if kind == "oracle":
        exact_keys(p, "kind path window window_sha256 use use_basis verified sha256".split(), (), what)
        if (p["path"] is None) != (p["sha256"] is None):
            fail(f"{what}: oracle path and sha256 are both null or both set")
        if p["path"] is not None:
            rel_path(p["path"], what)
            sha_value(p["sha256"], what)
        start, end = validate_window(p["window"], what)
        if p["use"] not in USES:
            fail(f"{what}: invalid oracle use")
        if p["use_basis"] not in USE_BASES or p["verified"] not in VERIFIED:
            fail(f"{what}: invalid oracle use_basis or verified")
        sha_value(p["window_sha256"], what, nullable=True)
        if p["verified"] == "recorded_hash" and p["window_sha256"] is None:
            fail(f"{what}: a verified window needs its hash")
        if p["use"] != "mapped" and p["verified"] != "recorded_hash":
            fail(f"{what}: only a hash-verified window can be used as entry or callee")
        return {**p, "window": [fmt(start), fmt(end)]}
    if kind == "receipt":
        exact_keys(p, "kind slice path sha256 review".split(), ["unlocated_unverified"], what)
        if "unlocated_unverified" in p and (not is_int(p["unlocated_unverified"]) or p["unlocated_unverified"] < 0):
            fail(f"{what}: invalid unlocated_unverified count")
        if not isinstance(p["slice"], str) or not ITEM_ID.fullmatch(p["slice"]):
            fail(f"{what}: invalid slice")
        rel_path(p["path"], what)
        sha_value(p["sha256"], what)
        if p["review"] not in REVIEW_STATES:
            fail(f"{what}: invalid receipt review state")
        return dict(p)
    exact_keys(p, "kind path symbol via".split(), (), what)
    rel_path(p["path"], what)
    nullable_ident(p["symbol"], TEST_ID, what)
    if p["via"] not in MENTION_VIAS:
        fail(f"{what}: invalid mention via")
    return dict(p)


def pointer_key(p):
    kind = p["kind"]
    if kind == "native_source":
        return (kind, p["path"], p["symbol"] or "")
    if kind == "test":
        return (kind, p["path"], p["test_id"] or "")
    if kind == "oracle":
        return (kind, p["path"] or "", p["window"][0], p["window"][1], p["use"], p["use_basis"])
    if kind == "receipt":
        return (kind, p["slice"], p["path"])
    return (kind, p["path"], p["symbol"] or "", p["via"])


def oracle_window(p):
    return int(p["window"][0], 16), int(p["window"][1], 16)


def covers(p, va, body_size):
    start, end = oracle_window(p)
    return body_size is not None and start <= va and va + body_size <= end


def qualifies(p):
    """An oracle pointer that can support a native_oracle_verified claim."""
    return p["kind"] == "oracle" and p["use"] in QUALIFYING_USES and p["verified"] == "recorded_hash"


def classify_pending(entry):
    evidence, va, body = entry["evidence"], int(entry["va"], 16), entry["body_size"]
    kinds = {p["kind"] for p in evidence}
    full = any(p["kind"] == "oracle" and p["verified"] == "recorded_hash" and covers(p, va, body) for p in evidence)
    if "native_source" in kinds and full:
        return "candidate_port"
    if kinds & {"native_source", "test", "oracle"}:
        return "partial_native"
    if kinds & {"mention", "receipt"}:
        return "static_navigation_only"
    return "none"


def cleared(blocker, divergences):
    """A blocker is cleared by the very same statement recorded as a deliberate safety rejection, or (ported
    entries only) by a written review carried on the blocker itself."""
    return "review" in blocker or any(d["id"] == blocker["id"] and d["safety_rejection"] is True for d in divergences)


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
        if not any(p["use"] in QUALIFYING_USES for p in oracles):
            fail(f"{what}: oracle windows used only as 'mapped' never qualify (needs entry or callee)")
        good = [p for p in oracles if qualifies(p)]
        if not good:
            fail(f"{what}: oracle windows without a recorded hash never qualify")
        if not any(covers(p, va, entry["body_size"]) for p in good):
            fail(f"{what}: no oracle window used as entry or callee covers the whole body")
    for blocker in entry["blockers"]:
        if not cleared(blocker, entry["divergences"]):
            fail(f"{what}: blocker {blocker['id']} remains; it is neither a recorded deliberate safety rejection "
                 "nor reviewed in the acceptance (blockers_reviewed)")


# ------------------------------------------------------------ ledger shape --

def validate_pointer_list(pointers, what):
    if not isinstance(pointers, list) or len(pointers) > 2000:
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
        exact_keys(b, "address id text".split(), ["review"], what)
        if "review" in b:
            if e["status"] != "ported":
                fail(f"{what}: only a ported entry can carry a reviewed blocker")
            exact_keys(b["review"], "reviewer date rationale".split(), (), what)
            text_value(b["review"]["reviewer"], what, 80)
            date_value(b["review"]["date"], what)
            text_value(b["review"]["rationale"], what, 600)
            if len(b["review"]["rationale"]) < BLOCKER_RATIONALE_MIN:
                fail(f"{what}: a blocker review needs a rationale of at least {BLOCKER_RATIONALE_MIN} characters")
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
    if [d["id"] for d in e["divergences"]] != sorted(d["id"] for d in e["divergences"]):
        fail(f"{what}: divergences are not sorted")
    # region/status rules that hold for every entry
    if e["region"] == "vorbis" and e["status"] != "pending":
        fail(f"{what}: vorbis functions stay pending until PCM parity is proven")
    if e["status"] != "pending" and any(b["id"].startswith("census_") for b in e["blockers"]):
        fail(f"{what}: census fall-through fragments and unsplit spans stay pending")
    if e["status"] != "pending" and e["origin"] == "unknown":
        fail(f"{what}: a function of unknown origin stays pending")
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
    text_value(reason["text"], what, limit=2000)    # rule rationales run to a few hundred characters
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
    def __init__(self, starts, spans, regions, boundaries, text_start, text_end, names, base, layout_regions):
        self.base = base
        self.starts, self.spans, self.regions = starts, spans, regions
        self.boundaries, self.text_start, self.text_end, self.names = boundaries, text_start, text_end, names
        self.layout_regions = layout_regions
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
    layout_regions = [(r["id"], r["start_va"], r["end_va"]) for r in regions]
    return Universe(starts, spans, region_of, [r["start_va"] for r in regions[1:]], text_start, text_end, names, base,
                    layout_regions)


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

def unpinned(inputs, pins, uni):
    """Verify the pins an xrefs/evidence file records for committed files; return the unverifiable ones."""
    skipped = []
    for item in pins:
        path = item["path"]
        if path.startswith(REPO_PREFIX):
            rel = path[len(REPO_PREFIX):]
            if (inputs.root / rel).is_file() or item["role"] in ("function_index", "layout"):
                raw = inputs.add(rel, "xrefs-pin")
                if sha256_bytes(raw) != item["sha256"]:
                    fail(f"xrefs pin {path} differs from the committed file; rerun scripts/extract_function_xrefs.py --write")
                continue
        skipped.append(item["role"])
    return skipped


def load_xrefs(inputs, uni, census):
    raw = inputs.add("function-xrefs.json", "xrefs")
    doc = read_json_bytes(raw, "function-xrefs.json")
    exact_keys(doc, XREFS_TOP, (), "xrefs")
    if doc["schema"] != XREFS_SCHEMA:
        fail(f"xrefs schema must be {XREFS_SCHEMA}")
    if doc["original_sha256"] != PINNED_SHA:
        fail("xrefs does not describe the pinned GAME.EXE")
    xm = xrefs_module()
    try:
        problems = xm.validate(doc)
    except (KeyError, TypeError, AttributeError, ValueError) as exc:
        raise LedgerError(f"xrefs is malformed: {exc!r}") from exc
    if problems:
        fail("xrefs failed its own validator: " + "; ".join(str(p) for p in problems[:3]))
    pins = doc["inputs"]
    roles = {i["role"]: i for i in pins}
    if len(roles) != len(pins) or not {"original", "function_index", "layout"} <= set(roles):
        fail("xrefs inputs must pin the original, the function index and the layout once each")
    if roles["original"]["sha256"] != PINNED_SHA:
        fail("xrefs pins a different GAME.EXE")
    skipped = unpinned(inputs, pins, uni)
    if skipped:
        inputs.notes.append("xrefs inputs not re-checked here (private, need scripts/extract_function_xrefs.py --check): "
                            + ", ".join(sorted(skipped)))
    if [(r["id"], parse_va(r["start_va"], "xrefs regions"), parse_va(r["end_va"], "xrefs regions"))
            for r in doc["regions"]] != uni.layout_regions:
        fail("xrefs regions differ from layout.json")
    entries, incomplete = {}, set()
    for e in doc["entries"]:
        va = parse_va(e["va"], "xrefs")
        if va not in uni.index:
            fail(f"xrefs {fmt(va)}: not an indexed function start")
        what = f"xrefs {fmt(va)}"
        if va in entries:
            fail(f"{what}: duplicate entry")
        if e["region"] != uni.regions[va] or e["span"] != uni.spans[va]:
            fail(f"{what}: region or span differs from the function index and layout")
        body = e["body_size"]
        if body is not None and (not is_int(body) or body < 1):
            fail(f"{what}: body_size must be null or a positive integer")
        if any(not va < parse_va(p, what) < va + e["span"] for p in e["derived_parts"]):
            fail(f"{what}: a derived part lies outside the span")
        for key in ("seam", "analysis_complete"):
            if type(e[key]) is not bool:
                fail(f"{what}: {key} must be a boolean")
        if not e["analysis_complete"]:
            incomplete.add(va)
        entries[va] = e
    if set(entries) != uni.index:
        fail("xrefs must describe every indexed function exactly once")
    if incomplete != census["unsplit"]:
        fail("xrefs analysis_complete=false functions differ from the census unsplit spans")
    total = sum(len(e["derived_parts"]) for e in entries.values())
    if total != census["derived"]:
        fail(f"xrefs derived parts total {total} but the census derived_functions is {census['derived']}")
    part_kind = {}
    for d in doc["derived_parts"]:
        part_kind[parse_va(d["va"], "xrefs")] = d["kind"]
    for t in doc["thunks"]:
        tva = parse_va(t["va"], "xrefs")
        if tva not in part_kind and tva not in uni.index:
            fail(f"xrefs thunk {t['va']} is neither a derived part nor an indexed start")
    return {"doc": doc, "entries": entries, "part_kind": part_kind}


# ------------------------------------------------------- input: evidence --

class EvidenceContext:
    def __init__(self, inputs, sources, receipts):
        self.inputs, self.sources, self.receipts = inputs, sources, receipts

    def committed(self, path, sha, role, what, *, pinned=True):
        """Root-relative path of a committed file named by a pointer; re-hashes it."""
        rel = repo_to_root(path, what)
        if pinned and path not in self.sources:
            fail(f"{what}: {path} is not among the pinned evidence sources")
        raw = self.inputs.add(rel, role)
        if sha256_bytes(raw) != sha:
            fail(f"{what}: pointer sha256 differs from {path}; rerun scripts/extract_function_evidence.py --write")
        return rel


def convert_pointer(p, what, ctx):
    """FL-2 pointer -> ledger pointer, with every FL-2 field checked."""
    if not isinstance(p, dict) or p.get("kind") not in POINTER_KINDS:
        fail(f"{what}: unknown evidence pointer kind")
    kind = p["kind"]
    if kind == "native_source":
        exact_keys(p, "kind path symbol sha256".split(), (), what)
        sha_value(p["sha256"], what)
        rel = ctx.committed(p["path"], p["sha256"], POINTER_ROLE[kind], what)
        return {"kind": kind, "path": rel, "symbol": p["symbol"], "sha256": p["sha256"]}
    if kind == "test":
        exact_keys(p, "kind path test_id sha256".split(), (), what)
        sha_value(p["sha256"], what)
        rel = ctx.committed(p["path"], p["sha256"], POINTER_ROLE[kind], what)
        return {"kind": kind, "path": rel, "test_id": p["test_id"], "sha256": p["sha256"]}
    if kind == "oracle":
        exact_keys(p, "kind path sha256 window window_sha256 reading verified use use_basis tail_gap declared_in".split(),
                   (), what)
        if p["reading"] not in ("end_exclusive", "end_inclusive", "size") or not is_int(p["tail_gap"]) or p["tail_gap"] < 0:
            fail(f"{what}: invalid oracle reading or tail_gap")
        if (not isinstance(p["declared_in"], list) or p["declared_in"] != sorted(p["declared_in"])
                or any(not isinstance(d, str) for d in p["declared_in"])):
            fail(f"{what}: invalid oracle declared_in")
        path = None
        if p["path"] is not None:
            sha_value(p["sha256"], what)
            path = ctx.committed(p["path"], p["sha256"], POINTER_ROLE[kind], what)
        return {"kind": kind, "path": path, "window": p["window"], "window_sha256": p["window_sha256"],
                "use": p["use"], "use_basis": p["use_basis"], "verified": p["verified"], "sha256": p["sha256"]}
    if kind == "receipt":
        exact_keys(p, "kind slice path sha256 review via hook unlocated_unverified".split(), (), what)
        row = ctx.receipts.get(p["path"])
        exact_keys(p["review"], ["state", "reviewer_recorded"], (), what)
        if (row is None or row["sha256"] != p["sha256"] or row["slice"] != p["slice"]
                or row["review"]["state"] != p["review"]["state"]):
            fail(f"{what}: receipt pointer {p['path']} disagrees with the receipts table")
        return {"kind": kind, "slice": p["slice"], "path": p["path"], "sha256": p["sha256"],
                "review": p["review"]["state"], "unlocated_unverified": p["unlocated_unverified"]}
    exact_keys(p, "kind path sha256 symbol addresses via".split(), (), what)
    sha_value(p["sha256"], what)
    if isinstance(p["path"], str) and p["path"].startswith(PRIVATE_PREFIX):
        row = ctx.receipts.get(p["path"])
        if row is None or row["sha256"] != p["sha256"]:
            fail(f"{what}: private mention {p['path']} disagrees with the receipts table")
        path = rel_path(p["path"], what)
    else:
        path = ctx.committed(p["path"], p["sha256"], POINTER_ROLE[kind], what, pinned=False)
    return {"kind": kind, "path": path, "symbol": p["symbol"], "via": p["via"]}


def convert_items(items, va, span, what, divergence):
    """Receipt-item records -> ledger blockers/divergences grouped per (slice, text sha256)."""
    if not isinstance(items, list):
        fail(f"{what}: blockers and divergences must be lists")
    groups = {}
    for b in items:
        exact_keys(b, ITEM_RECORD, (), what)
        addr = parse_va(b["address"], what)
        if not va <= addr < va + span:
            fail(f"{what}: blocker address {fmt(addr)} is outside the function span")
        if not isinstance(b["slice"], str) or not ITEM_ID.fullmatch(b["slice"]) or b["slice"].startswith("census_"):
            fail(f"{what}: invalid item slice")
        if (not isinstance(b["field"], str) or not FIELD_NAME.fullmatch(b["field"]) or not is_int(b["index"])
                or b["index"] < 0 or type(b["interior"]) is not bool or b["interior"] != (addr != va)):
            fail(f"{what}: invalid item record")
        rel_path(b["path"], what)
        sha_value(b["text_sha256"], what)
        g = groups.setdefault((b["slice"], b["text_sha256"]), {"addr": addr, "fields": set()})
        g["addr"] = min(g["addr"], addr)
        g["fields"].add(b["field"])
    out = []
    for (slice_, sha), g in groups.items():
        fields = ", ".join(sorted(g["fields"]))
        ident = f"{slice_}:{sha[:16]}"
        if divergence:
            safe = all(SAFETY_FIELD.search(f) for f in g["fields"])
            out.append({"id": ident, "safety_rejection": safe,
                        "text": f"{fields} item of {slice_} (receipt text sha256 {sha})"})
        else:
            out.append({"address": fmt(g["addr"]), "id": ident,
                        "text": f"{fields} item of {slice_} (receipt text sha256 {sha})"})
    key = (lambda b: (b["address"], b["id"])) if not divergence else (lambda d: d["id"])
    return sorted(out, key=key)


def load_evidence(root, inputs, uni):
    raw = inputs.add("function-evidence.json", "evidence")
    doc = read_json_bytes(raw, "function-evidence.json")
    exact_keys(doc, EVIDENCE_TOP, (), "evidence")
    if doc["schema"] != EVIDENCE_SCHEMA:
        fail(f"evidence schema must be {EVIDENCE_SCHEMA}")
    if doc["original_sha256"] != PINNED_SHA:
        fail("evidence does not describe the pinned GAME.EXE")
    if doc["text_range"] != [fmt(uni.text_start), fmt(uni.text_end)]:
        fail("evidence text_range differs from layout.json")
    fi = doc["function_index"]
    exact_keys(fi, "path sha256 functions".split(), (), "evidence function_index")
    if (repo_to_root(fi["path"], "evidence function_index") != "function-index.json"
            or fi["sha256"] != inputs.items["function-index.json"]["sha256"] or fi["functions"] != len(uni.starts)):
        fail("evidence was derived from a different function-index.json; rerun scripts/extract_function_evidence.py --write")
    for key in ("sources", "receipts", "functions", "unresolved"):
        if not isinstance(doc[key], list):
            fail(f"evidence: {key} must be a list")
    if not isinstance(doc["counts"], dict):
        fail("evidence: counts must be an object")
    sources = {}
    for s in doc["sources"]:
        exact_keys(s, "path sha256 role".split(), (), "evidence source")
        sha_value(s["sha256"], "evidence source")
        if s["role"] not in SOURCE_ROLES or s["path"] in sources:
            fail("evidence source: unknown role or duplicate path")
        sources[s["path"]] = s
    ctx = EvidenceContext(inputs, sources, {})
    for path, s in sorted(sources.items()):
        ctx.committed(path, s["sha256"], SOURCE_ROLES[s["role"]], "evidence source")
    for r in doc["receipts"]:
        exact_keys(r, RECEIPT_ROW, (), "evidence receipt")
        sha_value(r["sha256"], "evidence receipt")
        exact_keys(r["review"], ["state", "reviewer_recorded"], (), "evidence receipt")
        if (r["review"]["state"] not in REVIEW_STATES or not isinstance(r["slice"], str)
                or not ITEM_ID.fullmatch(r["slice"]) or not isinstance(r["path"], str)
                or not r["path"].startswith(PRIVATE_PREFIX) or r["path"] in ctx.receipts):
            fail("evidence receipt: invalid row")
        rel_path(r["path"], "evidence receipt")
        ctx.receipts[r["path"]] = r
    out, previous = {}, -1
    for f in doc["functions"]:
        exact_keys(f, "va evidence blockers divergences".split(), (), "evidence function")
        va = parse_va(f["va"], "evidence")
        what = f"evidence {fmt(va)}"
        if va not in uni.index:
            fail(f"{what}: not an indexed function start (interior addresses belong in a mention)")
        if va in out:
            fail(f"{what}: duplicate evidence entry")
        if va < previous:
            fail(f"{what}: evidence functions are not sorted by address")
        previous = va
        if not isinstance(f["evidence"], list):
            fail(f"{what}: evidence must be a list")
        pointers = [validate_pointer(convert_pointer(p, what, ctx), what) for p in f["evidence"]]
        keys = [pointer_key(p) for p in pointers]
        if len(set(keys)) != len(keys):
            fail(f"{what}: duplicate evidence pointer")
        out[va] = {"evidence": sorted(pointers, key=pointer_key),
                   "blockers": convert_items(f["blockers"], va, uni.spans[va], what, False),
                   "divergences": convert_items(f["divergences"], va, uni.spans[va], what, True)}
    return {"functions": out, "receipts": ctx.receipts}


# ------------------------------------------------------ input: overrides --

def eh_regions(rule):
    return tuple(rule["parameters"].get("eh_parent_regions", DEFAULT_EH_PARENT_REGIONS))


def load_overrides(inputs, uni, xrefs):
    raw = inputs.add("function-ledger-overrides.json", "overrides")
    doc = read_json_bytes(raw, "function-ledger-overrides.json")
    exact_keys(doc, ["schema", "port_acceptances", "not_needed_entries", "not_needed_rules", "semantics_sensitive"],
               ["original_sha256", "status", "note", "win32_import_allowlist"], "overrides")
    if doc["schema"] != OVERRIDES_SCHEMA:
        fail(f"overrides schema must be {OVERRIDES_SCHEMA}")
    if doc.get("original_sha256", PINNED_SHA) != PINNED_SHA:
        fail("overrides do not describe the pinned GAME.EXE")
    for key in ("status", "note"):
        if key in doc:
            text_value(doc[key], f"overrides {key}", 2000)
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
        exact_keys(a, "va class reviewer date native_source tests oracle parts_accounted".split(),
                   ["note", "blockers_reviewed"], "acceptance")
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
        reviewed = {}
        for r in a.get("blockers_reviewed", []):
            exact_keys(r, ["id", "rationale"], (), what)
            if not isinstance(r["id"], str) or not ITEM_ID.fullmatch(r["id"]):
                fail(f"{what}: invalid blockers_reviewed id")
            if r["id"] in reviewed:
                fail(f"{what}: blockers_reviewed names {r['id']} twice")
            reviewed[r["id"]] = text_value(r["rationale"], what, 600)
            if len(reviewed[r["id"]]) < BLOCKER_RATIONALE_MIN:
                fail(f"{what}: a blocker review needs a rationale of at least {BLOCKER_RATIONALE_MIN} characters")
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
                           "tests": tests, "oracle": oracle, "reviewed": reviewed,
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
        exact_keys(r, "id predicate accepted reason_code rationale".split(),
                   ["parameters", "review", "deferred_decisions", "machine_preconditions", "ledger_preconditions",
                    "caveats"], "rule")
        what = f"rule {r.get('id')}"
        if r["predicate"] not in PREDICATES or r["id"] != r["predicate"]:
            fail(f"{what}: the rule id must equal a known predicate id {sorted(PREDICATES)}")
        if r["id"] in seen:
            fail(f"{what}: duplicate rule")
        seen.add(r["id"])
        if r["reason_code"] != PREDICATES[r["predicate"]]:
            fail(f"{what}: reason_code must be {PREDICATES[r['predicate']]}")
        text_value(r["rationale"], what, 2000)
        if type(r["accepted"]) is not bool:
            fail(f"{what}: accepted must be a boolean")
        for key in ("deferred_decisions", "machine_preconditions", "ledger_preconditions", "caveats"):
            if key in r:
                if not isinstance(r[key], list):
                    fail(f"{what}: {key} must be a list")
                for item in r[key]:
                    text_value(item, what, 2000)
        params = r.get("parameters", {})
        if not isinstance(params, dict):
            fail(f"{what}: parameters must be an object")
        allowed = ["eh_parent_regions"] if r["id"] == "R-EH" else []
        exact_keys(params, (), allowed, what)
        if "eh_parent_regions" in params:
            regions = params["eh_parent_regions"]
            if not isinstance(regions, list) or any(x not in REGIONS for x in regions) or len(set(regions)) != len(regions):
                fail(f"{what}: eh_parent_regions must list distinct regions")
        review = r.get("review", {"reviewer": None, "date": None, "n": None, "defects": None, "sample_sha256": None})
        exact_keys(review, "reviewer date n defects sample_sha256".split(), (), what)
        if r["accepted"]:
            if any(review[k] is None for k in review):
                fail(f"{what}: an accepted rule needs a complete review")
            text_value(review["reviewer"], what, 80)
            date_value(review["date"], what)
            sha_value(review["sample_sha256"], what)
            if not is_int(review["n"]) or review["n"] < SAMPLE_MIN or not is_int(review["defects"]) or review["defects"] != 0:
                fail(f"{what}: the accepted sample needs n >= {SAMPLE_MIN} and zero defects")
        rules.append({**r, "parameters": params, "review": review})
    xm = xrefs_module()
    specs = doc["semantics_sensitive"]
    ids = set()
    for spec in specs:
        problems = xm.validate_sensitive_spec(spec) if isinstance(spec, dict) else ["not an object"]
        if problems:
            fail(f"semantics_sensitive {spec.get('id') if isinstance(spec, dict) else spec!r}: {'; '.join(problems)}")
        if spec["id"] in ids:
            fail(f"semantics_sensitive: duplicate id {spec['id']}")
        ids.add(spec["id"])
    sensitive = {parse_va(v, "semantics_sensitive") for v in xm.semantics_sensitive_set(xrefs["doc"], specs)}
    allowlist = None
    if "win32_import_allowlist" in doc:
        a = doc["win32_import_allowlist"]
        exact_keys(a, "names reviewer date".split(), (), "win32_import_allowlist")
        text_value(a["reviewer"], "win32_import_allowlist", 80)
        date_value(a["date"], "win32_import_allowlist")
        allowlist = set(name_list(a["names"], IMPORT_NAME, "win32_import_allowlist"))
    return {"acceptances": acceptances, "entries": entries, "rules": rules, "specs": specs, "sensitive": sensitive,
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

def derive(root, *, expected_functions=EXPECTED_FUNCTIONS, work_dir=None, verify_private=False, notes=None):
    """Derive the ledger from the pinned inputs under ``root``; any problem is a LedgerError.

    ``notes`` (optional list) receives facts that could not be re-checked here."""
    try:
        return _derive(Path(root), expected_functions, work_dir, verify_private, notes)
    except (KeyError, TypeError, AttributeError, IndexError, ValueError) as exc:
        if isinstance(exc, LedgerError):
            raise
        raise LedgerError(f"malformed input: {exc!r}") from exc


def _derive(root, expected_functions, work_dir, verify_private, notes):
    inputs = Inputs(root)
    uni = load_universe(root, inputs, expected_functions)
    census = load_census(root, inputs, uni)
    xrefs = load_xrefs(inputs, uni, census)
    evidence = load_evidence(root, inputs, uni)
    ov = load_overrides(inputs, uni, xrefs)
    x86 = load_x86(root, inputs, uni)
    if verify_private:
        verify_receipts(evidence["receipts"], work_dir)
    else:
        inputs.notes.append("private receipts not re-hashed (use --verify-private where work/ exists)")
    if notes is not None:
        notes.extend(inputs.notes)
    xf, ev = xrefs["entries"], evidence["functions"]

    def floor(va):
        """Why a function can never leave pending (census facts, vorbis, unknown origin)."""
        if uni.regions[va] == "vorbis":
            return "vorbis functions stay pending until PCM parity is proven"
        if va in census["unsplit"]:
            return "the census left this span unsplit"
        if va in census["fragments"]:
            return "the census lists a fall-through fragment inside this span"
        if xf[va]["origin"] == "unknown":
            return "its origin is unknown (a seam function without a proven origin)"
        return None

    # ---- facts per function ----
    facts, overrun = {}, []
    for va in uni.starts:
        x, e = xf[va], ev.get(va)
        blockers = list(e["blockers"]) if e else []
        for frag in sorted(census["fragments"].get(va, [])):
            blockers.append({"address": fmt(frag), "id": CENSUS_FRAGMENT,
                             "text": "fall-through fragment listed in the census; the function stays pending"})
        if va in census["unsplit"]:
            blockers.append({"address": fmt(va), "id": CENSUS_UNSPLIT,
                             "text": "span left unsplit by the census; the function stays pending"})
        body = x["body_size"]
        if body is not None and body > uni.spans[va]:
            overrun.append(fmt(va))                          # Ghidra body runs into the next function
            body = uni.spans[va]
        facts[va] = {
            "x": x, "body": body, "pointers": e["evidence"] if e else [],
            "blockers": sorted(blockers, key=lambda b: (b["address"], b["id"])),
            "divergences": e["divergences"] if e else [],
            "parts": sorted(parse_va(p, "xrefs") for p in x["derived_parts"]),
        }

    if overrun and notes is not None:
        notes.append(f"{len(overrun)} Ghidra body sizes exceed their span and are clamped to it: {', '.join(overrun[:8])}")
    # ---- rule 3: port acceptances ----
    ported = {}
    for va, a in sorted(ov["acceptances"].items()):
        ported[va] = check_acceptance(va, a, facts[va], root, uni, xrefs, floor(va))
    # ---- rule 4: per-function not_needed entries ----
    for va in sorted(ov["entries"]):
        if va in ported:
            fail(f"{fmt(va)} is both ported and not_needed")

    def parent_decided(parent):
        """A game-region parent that is itself ported or per-function not_needed."""
        return parent in ported or parent in ov["entries"]

    entries_nn = {}
    for va, e in sorted(ov["entries"].items()):
        check_not_needed_entry(va, e, facts[va], uni, ov, parent_decided, floor(va))
        entries_nn[va] = e
    # ---- rule 5: sampled predicate rules ----
    rule_hits = {}
    accepted = [r for r in ov["rules"] if r["accepted"]]
    if accepted:
        regions = list(next((eh_regions(r) for r in ov["rules"] if r["id"] == "R-EH"), DEFAULT_EH_PARENT_REGIONS))
        candidates = xrefs_module().rule_candidates(xrefs["doc"], ov["specs"], regions)
        for rule in accepted:
            for text in candidates[rule["id"]]:
                va = parse_va(text, "rule candidate")
                if not rule_applies(rule, va, facts[va], uni, floor(va), parent_decided):
                    continue
                if va in rule_hits:
                    fail(f"{fmt(va)} is selected by two rules")
                rule_hits[va] = rule
    for va, rule in rule_hits.items():
        if va in ported or va in entries_nn:
            fail(f"{fmt(va)} is decided by a per-function override and by rule {rule['id']}")

    # ---- entries ----
    out = []
    for va in uni.starts:
        f, x = facts[va], xf[va]
        e = {"va": fmt(va), "name": uni.names[va], "span": uni.spans[va], "body_size": f["body"],
             "derived_parts": [fmt(p) for p in f["parts"]], "region": uni.regions[va], "origin": x["origin"],
             "seam": x["seam"], "x86_match": x86.get(va), "evidence": f["pointers"],
             "blockers": f["blockers"], "divergences": f["divergences"], "reason": None, "review": None}
        if va in ported:
            a = ported[va]
            e.update(status="ported", review={"reviewer": a["reviewer"], "date": a["date"], "sample": None})
            e["class"] = a["class"]
            e["blockers"] = [
                {**b, "review": {"reviewer": a["reviewer"], "date": a["date"], "rationale": a["reviewed"][b["id"]]}}
                if b["id"] in a["reviewed"] else b for b in f["blockers"]]
        elif va in entries_nn:
            n = entries_nn[va]
            e.update(status="not_needed", reason={"code": n["reason"], "text": n["text"], "rule": None},
                     review={"reviewer": n["reviewer"], "date": n["date"], "sample": None})
            e["class"] = "nn_reviewed"
        elif va in rule_hits:
            r = rule_hits[va]
            e.update(status="not_needed", reason={"code": r["reason_code"], "text": r["rationale"], "rule": r["id"]},
                     review={"reviewer": r["review"]["reviewer"], "date": r["review"]["date"],
                             "sample": r["review"]["sample_sha256"]})
            e["class"] = "nn_rule"
        else:
            e.update(status="pending")
            e["class"] = classify_pending(e)
        out.append({k: e[k] for k in ENTRY_KEYS})
    ledger = {"schema": SCHEMA, "original_sha256": PINNED_SHA, "inputs": inputs.listing(),
              "counts": count_entries(out), "entries": out}
    return validate(ledger)


def verify_receipts(receipts, work_dir):
    if work_dir is None:
        fail("receipt verification needs the work directory")
    work = Path(work_dir)
    for path, row in sorted(receipts.items()):
        target = work / path
        if not target.is_file():
            fail(f"private receipt {path} is missing")
        if sha256_bytes(target.read_bytes()) != row["sha256"]:
            fail(f"private receipt {path} differs from its recorded sha256")


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
    body_size = f["body"]
    if a["class"] == "native_oracle_verified":
        opath, start, end = a["oracle"]
        match = [p for p in pointers if p["kind"] == "oracle" and p["path"] == opath and p["window"] == [start, end]]
        if not match:
            fail(f"{what}: oracle {opath} window [{start}, {end}) is not in the evidence for this function")
        good = [p for p in match if p["use"] in QUALIFYING_USES]
        if not good:
            fail(f"{what}: oracle window used as {match[0]['use']!r} never qualifies (needs entry or callee)")
        if not any(p["verified"] == "recorded_hash" for p in good):
            fail(f"{what}: oracle window without a recorded hash never qualifies")
        if body_size is None:
            fail(f"{what}: body_size from xrefs is needed to check oracle coverage")
        if not covers(good[0], va, body_size):
            fail(f"{what}: oracle window [{start}, {end}) does not cover the body "
                 f"[{fmt(va)}, {fmt(va + body_size)})")
    # (d) blockers: a deliberate safety rejection, or a written review in this acceptance (blockers_reviewed);
    # a review must name a blocker the function really has and may not duplicate a safety rejection
    open_ids = {b["id"] for b in f["blockers"]}
    for rid in sorted(a["reviewed"]):
        if rid not in open_ids:
            fail(f"{what}: blockers_reviewed names {rid}, which is not a blocker of this function")
    for b in f["blockers"]:
        safety = any(d["id"] == b["id"] and d["safety_rejection"] is True for d in f["divergences"])
        if safety and b["id"] in a["reviewed"]:
            fail(f"{what}: blocker {b['id']} is already a recorded safety rejection; it needs no review")
        if not safety and b["id"] not in a["reviewed"]:
            fail(f"{what}: blocker {b['id']} at {b['address']} remains; it is neither a deliberate safety "
                 "rejection nor reviewed in blockers_reviewed")
    # (e) derived parts (thunks and EH stubs included) are all accounted for
    needed = set(f["parts"])
    if a["parts"] != needed:
        missing, extra = sorted(needed - a["parts"]), sorted(a["parts"] - needed)
        fail(f"{what}: parts_accounted differs from the function's parts "
             f"(missing {[fmt(v) for v in missing]}, unknown {[fmt(v) for v in extra]})")
    for part in sorted(needed):
        if xrefs["part_kind"].get(part) not in MECHANICAL_PARTS and part not in addresses_in(area):
            fail(f"{what}: derived part {fmt(part)} does not appear in {symbol}")
    return a


def check_not_needed_entry(va, e, f, uni, ov, parent_decided, floor):
    reason = e["reason"]
    what = f"not_needed entry {fmt(va)} ({reason})"
    if floor:
        fail(f"{what}: {floor}")
    x = f["x"]
    region, origin = uni.regions[va], x["origin"]
    callers = [parse_va(c, what) for c in x["callers"]]
    if va in ov["sensitive"]:
        fail(f"{what}: the function is in the semantics_sensitive set (rand, __ftol, formatting, qsort, time, "
             "file I/O, malloc failure); its behaviour must be ported or adapter-tested, never waived")
    if reason == "unreachable_no_refs":
        if callers or x["address_taken"]:
            fail(f"{what}: needs zero callers and no data or address reference")
    elif reason in ("win32_plumbing_no_observable_effect", "debug_diagnostic_only"):
        allowed = ov["allowlist"] if reason.startswith("win32") else DEBUG_IMPORTS
        label = "allowlist" if reason.startswith("win32") else "debug import list"
        if allowed is None:
            fail(f"{what}: no reviewed win32_import_allowlist exists")
        if not x["imports"] or not set(x["imports"]) <= allowed:
            fail(f"{what}: imports {x['imports']} are not all within the reviewed {label}")
        if x["indirect_calls"] or x["indirect_jumps"]:
            fail(f"{what}: indirect calls or jumps leave the function's effects unproven")
        for callee in sorted(parse_va(c, what) for c in x["callees"]):
            if callee != va and uni.regions.get(callee) == "game" and callee not in ov["entries"]:
                fail(f"{what}: game-region callee {fmt(callee)} is not itself not_needed")
    elif reason == "crt_startup_termination":
        if region != "crt_mfc" or origin != "library":
            fail(f"{what}: needs a library function in the crt_mfc region")
        if any(uni.regions.get(c) == "game" for c in callers):
            fail(f"{what}: a game-region function calls it")
    elif reason == "host_libc_standard_contract":
        if region != "crt_mfc" or origin != "library":
            fail(f"{what}: needs a library function in the crt_mfc region")
    elif reason == "library_internal_unreached_by_game":
        ok, why = xrefs_module().rule_r_lib_internal(x, {})
        if region != "crt_mfc" or not ok:
            fail(f"{what}: needs a library function in the crt_mfc region that game code cannot reach ({why})")
    elif reason == "compiler_eh_funclet":
        if origin != "compiler_eh" or x["eh_kind"] is None or x["eh_parent"] is None:
            fail(f"{what}: needs a funclet proof (origin compiler_eh with one eh_parent)")
        if x["eh_parent_region"] == "game" and not parent_decided(parse_va(x["eh_parent"], what)):
            fail(f"{what}: the game-region parent {x['eh_parent']} is neither ported nor not_needed")


def rule_applies(rule, va, f, uni, floor, parent_decided):
    """Ledger-side conditions on top of FL-3's machine predicate. Never true for game code."""
    if floor or uni.regions[va] != "crt_mfc" or f["x"]["seam"] or f["pointers"] or f["blockers"]:
        return False
    if rule["id"] == "R-EH":
        x = f["x"]
        if x["eh_kind"] != "unwind":
            return False                                   # Catch@ funclets are reviewed one by one
        if x["eh_parent_region"] == "game" and not parent_decided(parse_va(x["eh_parent"], "xrefs")):
            return False                                   # a game parent must itself be ported or not_needed
    return True


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
