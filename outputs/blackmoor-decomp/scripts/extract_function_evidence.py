#!/usr/bin/env python3
"""Function-ledger evidence extractor (packet FL-2).

Walks the committed native sources, the committed oracle/test sources and the
private slice receipts, maps every original address they mention onto the
4,188 function starts of ``function-index.json`` and writes the sanitized
``function-evidence.json`` that the ledger core (FL-1) consumes.  Nothing here
decides a status: the output is a list of evidence pointers.  ``ported`` is
still a reviewed claim made elsewhere; a pointer here only says that some file
cites, windows or hooks an address.

Usage (standard library only, scratch under /private/tmp, never writes next to
GAME.EXE)::

    scripts/extract_function_evidence.py            # derive, print counts
    scripts/extract_function_evidence.py --write    # also (re)write function-evidence.json
    scripts/extract_function_evidence.py --check    # re-derive and diff; exit 1 when stale

Address resolution (plan FL-0, rule 2)
--------------------------------------
* Only an exact function start is a function citation.  An interior address is
  a ``mention`` on the containing function (span = bytes to the next indexed
  start; the last span ends at ``text_range[1]``).  Addresses at or above
  ``text_range[1]`` (data, IAT, globals) are counted in ``unresolved`` and
  dropped.  M03-derived parts are not known here; FL-1 maps them to parents.
* Windows: a recorded ``(start,end)`` / ``(start,size)`` / ``(start,end
  inclusive)`` is settled by hashing the local original (path from
  ``work/analysis/game-source.json``, read-only; SHA-256 pinned): exactly one
  reading must reproduce the recorded sha256, otherwise the run fails and lists
  every window that did not.  Windows with no recorded hash are ``declared_only``.

Output ``blackmoor-function-evidence/1``
----------------------------------------
Top level keys (rendered in this order, arrays one element per line)::

  schema            "blackmoor-function-evidence/1"
  original_sha256   hash of the local GAME.EXE that every window was checked against
  text_range        ["0x401000", "0x52925a"]
  function_index    {path, sha256, functions}
  sources           [{path, sha256, role}]  committed files scanned; role is
                    native_source | test | oracle_source (repo-relative paths)
  receipts          [{slice, kind, path, sha256, review{state,reviewer_recorded},
                    windows{declared,hashed,verified}, unverified{items,located},
                    divergence_items, hook_addresses, files}]
                    private receipts, pinned by hash; ``path`` is work-relative
                    (analysis/slices/NAME).  review.state is never an acceptance.
  functions         [{va, evidence[], blockers[], divergences[]}] sorted by va;
                    only functions with something to say appear
  unresolved        [{address, reason, references, sources[<=5], kinds[]}]
  counts            see ``derive``; also holds the numbers behind the summary line

Evidence pointers (``evidence``; sorted by kind then content)::

  native_source {kind, path, symbol|null, sha256}
      exact start cited in src/*.c|h|mm; symbol = enclosing (or, for a leading
      comment, the following) C function or prototype, null at file level.
  test          {kind, path, test_id|null, sha256}
      exact start as a hex literal/comment in tests/test_*.py (test_id =
      Class.method or function) or in a tests/*.c|mm harness (test_id = function).
      Also one pointer per test case that mentions the symbol of one of the function's
      native_source pointers: a ``test*`` function or method of a tests/test_*.py file
      (identifiers in its body, plus string literals that are one bare identifier), or any
      function of a tests/*.c|mm harness (comments and strings blanked).  Lexical, like
      every pointer here: it names the test case a reviewer should read, not proof that
      the test exercises the function.
  oracle        {kind, path|null, sha256|null, window[start,end_excl],
                 window_sha256, reading, verified, use, use_basis, tail_gap,
                 declared_in[]}
      one per (function, window, use, use_basis).  The function's start lies in
      [start,end).  ``path``/``sha256`` name the committed oracle script that
      declares the window (null when only private receipts declare it).
      ``reading``: end_exclusive | end_inclusive | size, whichever reproduced the
      hash.  ``verified``: recorded_hash (the hash was recorded and reproduced)
      or declared_only (no recorded hash; window_sha256 is of the end-exclusive
      reading and the pointer never qualifies).  ``tail_gap`` = bytes of the
      function's span beyond window end (0 means the span is inside the window;
      FL-1 may use body_size instead).  ``declared_in`` = sorted repo-relative
      oracle source paths and work-relative receipt paths.
      ``use`` (entry | callee | mapped) and ``use_basis``:
        entry   window start == function start, the context is an oracle run
                (not a "follow-up"/"navigation"/"static" field) and the function
                is not hooked in any declaring receipt         [window_start]
        callee  function start is an ``observed`` (non-replacing) hook address
                of a declaring receipt, inside the window       [observed_hook]
        mapped  everything else: replaced_by_hook, hook_unclassified,
                static_scope, containment_only, unhashed
      A hook is ``replaced`` when its text says replace/return/stub/malloc/...,
      ``observed`` when it only observes/counts, else ``unclassified``; unknown
      is treated as replaced.  An oracle source gets the hooks of the receipts
      whose ``files`` list names it.  This is structure, not execution: FL-8 must
      later replace ``use`` with executed instruction ranges.
  receipt       {kind, slice, path, sha256, review, via[], hook|null,
                 unlocated_unverified}
      the private receipt touches the function by window / blocker / divergence
      / hook; ``hook`` = replaced | observed | unclassified when this receipt
      lists the function start in a hook list.
  mention       {kind, path, sha256, symbol|null, addresses[], via}
      interior addresses (grouped per path/symbol/via); via = citation |
      window_start.  No line numbers.

``blockers`` / ``divergences`` items (unverified / deliberate-rejection list
entries of a receipt whose text names an address inside the function)::

  {slice, path, field, index, text_sha256, address, interior}

Only a hash of the item text is kept; read the private receipt for the prose.

Checking: ``--check`` re-derives and compares byte-for-byte.  Private receipts
are pinned by sha256; when none are present (clean checkout) the receipt-derived
parts are not re-derived (a note is printed) while sources, native/test/mention
pointers, and every committed window hash are still re-verified.
"""

from __future__ import annotations

import argparse
import ast
import bisect
import dataclasses
import hashlib
import io
import json
import posixpath
import re
import struct
import sys
import tokenize
from pathlib import Path
from typing import Iterable, Optional

SCHEMA = "blackmoor-function-evidence/1"
PINNED_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
TEXT_START = 0x401000
TEXT_END = 0x52925A
PLAUSIBLE_LO = 0x401000
PLAUSIBLE_HI = 0x700000
SHA_RE = re.compile(r"[0-9a-f]{64}")
HEX_RE = re.compile(r"(?<![0-9A-Za-z])0[xX]([0-9a-fA-F]{6,8})[uUlL]{0,3}(?![0-9A-Za-z])")
FUN_RE = re.compile(r"(?<![0-9A-Za-z])FUN_?([0-9a-fA-F]{8})(?![0-9A-Za-z])")
RANGE_RE = re.compile(r"0[xX]([0-9a-fA-F]{6,8})\s*\.\.\s*0[xX]([0-9a-fA-F]{6,8})")
REPO_NAME = "nd-blackmoor-decomp"
KIND_ORDER = {"native_source": 0, "test": 1, "oracle": 2, "receipt": 3, "mention": 4}
READINGS = ("end_exclusive", "end_inclusive", "size")
USES = {"entry", "callee", "mapped"}
USE_BASES = {"window_start", "observed_hook", "replaced_by_hook", "hook_unclassified",
             "static_scope", "containment_only", "unhashed", "executed", "executed_partial"}
BASIS_PRIORITY = ["observed_hook", "window_start", "replaced_by_hook", "hook_unclassified", "static_scope",
                  "containment_only", "unhashed"]
EXECUTION_FILE = "function-execution.json"     # FL-8: scripts/record_function_execution.py
MENTION_VIAS = {"citation", "window_start"}
RECEIPT_VIAS = {"window", "blocker", "divergence", "hook"}
UNRESOLVED_KINDS = {"citation", "window_start", "blocker", "divergence", "hook"}
REVIEW_STATES = {"absent", "none", "pending", "findings_addressed", "reviewer_recorded"}
HOOK_KINDS = {"replaced", "observed", "unclassified"}
VERIFIED = {"recorded_hash", "declared_only"}
SOURCE_ROLES = {"native_source", "test", "oracle_source"}
TOP_ORDER = ["schema", "original_sha256", "text_range", "function_index", "sources", "receipts",
             "functions", "unresolved", "counts"]

UNVERIFIED_KEY = re.compile(r"^(?:tail_)?unverified(?:_branches)?(?:_and_scope)?$")
DIVERGENCE_KEY = re.compile(
    r"^(?:deliberate_|intentional_|native_)*(?:safety_rejections|divergences|safety_divergences)$")
STATIC_RE = re.compile(r"follow.?up|navigation|static|not.?oracle", re.I)
WINDOW_NAME_RE = re.compile(r"CODE|WINDOW|RANGE|SPAN", re.I)
REPLACED_RE = re.compile(
    r"replac|return|stub|trampoline|malloc|alloc|skip|seeded|sentinel|stand[- ]?in|deterministic|"
    r"synthetic|fake|substitut|models?\b|inject|force|fixed", re.I)
MUTATING_RE = re.compile(
    r"(?<!no )(?<!never )\bwrites?\b|\bstop\b|\bEAX\b|\bpatch|\bNOP\b|redirect|increment|\bset\b|\bforce", re.I)
OBSERVED_RE = re.compile(r"observ|counter|read-only|probe only|no register|no memory|record", re.I)
FIXTURE_TESTS = re.compile(
    r"(?:test_(?:extract_function_evidence|(?:extract_)?function_xrefs|function_ledger|sample_function_ledger)\.py$"
    # asm-track tooling and x86-match tests: they prove the x86 match, not the native port, and
    # cite addresses as fixtures (for example BASE = 0x401000)
    r"|test_(?:audit_tool_assisted|compose_image|gen_hinted_asm|verify_matches)\.py$"
    r"|(?:test_)?matching_s08[A-Za-z0-9_]*\.py$)")
LEDGER_RECEIPT = re.compile(r"FL-\d")       # the function-ledger packets' own receipts carry no original-code evidence
FILE_KEYS = ("files", "owned_files", "owned_distributable_files", "changed_tracked_files",
             "committed_files", "tracked_files")


class EvidenceError(Exception):
    """A run-stopping problem; ``problems`` lists every one found."""

    def __init__(self, problems):
        if isinstance(problems, str):
            problems = [problems]
        self.problems = list(problems)
        head = f"{len(self.problems)} problem(s)"
        super().__init__(head + "\n" + "\n".join(self.problems))


class WindowError(Exception):
    pass


class WindowMismatch(WindowError):
    pass


class WindowAmbiguous(WindowError):
    pass


class ValidationError(ValueError):
    pass


# ---------------------------------------------------------------- basic helpers

def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def hx(value: int) -> str:
    return hex(value)


def parse_address(value) -> Optional[int]:
    """Int or ``0x`` hex string -> nonnegative int, else None."""
    if isinstance(value, bool):
        return None
    if isinstance(value, int):
        return value if value >= 0 else None
    if isinstance(value, str) and re.fullmatch(r"0[xX][0-9a-fA-F]{1,8}", value.strip()):
        return int(value.strip(), 16)
    return None


def is_va(value) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and PLAUSIBLE_LO <= value < PLAUSIBLE_HI


def normalize_path(raw: str) -> Optional[str]:
    """Repo- or work-relative posix path; None when it cannot be made relative."""
    s = raw.strip()
    if not s:
        return None
    if s.startswith("/") or s.startswith("~"):
        m = re.match(r"^/.*?/" + re.escape(REPO_NAME) + r"/(?:\.claude/worktrees/[^/]+/)?(.*)$", s)
        if not m:
            return None
        s = m.group(1)
    p = posixpath.normpath(s)
    if p.startswith("../") or p == ".." or p.startswith("/") or p == ".":
        return None
    return p


def slice_id(filename: str) -> str:
    base = filename[:-5] if filename.endswith(".json") else filename
    m = re.search(r"\.(?:[a-z]+-)*(?:handoff|validation)\b", base)
    if not m:
        m = re.search(r"-(?:handoff|validation)\b", base)
    return base[:m.start()] if m else base


def extract_addresses(text: str) -> list[int]:
    found = []
    for rx in (HEX_RE, FUN_RE):
        for m in rx.finditer(text):
            v = int(m.group(1), 16)
            if is_va(v):
                found.append(v)
    return found


def canon_text(item) -> str:
    return item if isinstance(item, str) else json.dumps(item, sort_keys=True, separators=(",", ":"))


# -------------------------------------------------------------------------- PE

class PE:
    def __init__(self, data: bytes, image_base: int, sections):
        self.data = data
        self.image_base = image_base
        self.sections = sections  # (name, rva, vsize, raw_off, raw_size)

    @classmethod
    def from_bytes(cls, data: bytes) -> "PE":
        try:
            return cls._parse(data)
        except struct.error as exc:
            raise EvidenceError(f"original executable header is truncated: {exc}") from exc

    @classmethod
    def _parse(cls, data: bytes) -> "PE":
        if len(data) < 0x40 or data[:2] != b"MZ":
            raise EvidenceError("original is not an MZ executable")
        pe_off = struct.unpack_from("<I", data, 0x3C)[0]
        if pe_off + 24 > len(data) or data[pe_off:pe_off + 4] != b"PE\0\0":
            raise EvidenceError("original has no PE signature")
        nsec, opt_size = struct.unpack_from("<H", data, pe_off + 6)[0], struct.unpack_from("<H", data, pe_off + 20)[0]
        opt = pe_off + 24
        if struct.unpack_from("<H", data, opt)[0] != 0x10B:
            raise EvidenceError("original is not PE32")
        image_base = struct.unpack_from("<I", data, opt + 28)[0]
        table = opt + opt_size
        sections = []
        for i in range(nsec):
            name, vsize, rva, rsize, roff = struct.unpack_from("<8sIIII", data, table + 40 * i)
            sections.append((name.rstrip(b"\0").decode("latin-1"), rva, vsize, roff, rsize))
        return cls(data, image_base, tuple(sections))

    def read_va(self, va: int, n: int) -> Optional[bytes]:
        if n <= 0:
            return None
        for _name, rva, _vsize, roff, rsize in self.sections:
            base = self.image_base + rva
            if base <= va and va + n <= base + rsize:
                off = roff + (va - base)
                if off + n <= len(self.data):
                    return self.data[off:off + n]
                return None
        return None

    def file_offset_to_va(self, off: int) -> Optional[int]:
        for _name, rva, _vsize, roff, rsize in self.sections:
            if roff <= off < roff + rsize:
                return self.image_base + rva + (off - roff)
        return None


def window_range(reading: str, a: int, b: int):
    if reading == "end_exclusive":
        return (a, b) if b > a else None
    if reading == "end_inclusive":
        return (a, b + 1) if b >= a else None
    if reading == "size":
        return (a, a + b) if b > 0 else None
    raise ValueError(reading)


def pick_reading(digests: dict, recorded: str) -> str:
    matches = sorted(k for k, d in digests.items() if d == recorded)
    if len(matches) > 1:
        raise WindowAmbiguous("more than one reading reproduces the recorded hash: " + ", ".join(matches))
    if not matches:
        raise WindowMismatch("no reading reproduces the recorded hash")
    return matches[0]


def settle_window(pe: PE, a: int, b: int, recorded: str, readings=None):
    """Return ``(reading, start, end_exclusive)`` or raise WindowError."""
    digests, ranges = {}, {}
    for name in readings or READINGS:
        rng = window_range(name, a, b)
        if rng is None:
            continue
        data = pe.read_va(rng[0], rng[1] - rng[0])
        if data is None:
            continue
        digests[name] = sha256_bytes(data)
        ranges[name] = rng
    if not digests:
        raise WindowMismatch("window is not backed by file bytes under any reading")
    reading = pick_reading(digests, recorded)
    return reading, ranges[reading][0], ranges[reading][1]


class FunctionMap:
    def __init__(self, starts: Iterable[int], text_start: int = TEXT_START, text_end: int = TEXT_END):
        self.starts = sorted(starts)
        self.text_start = text_start
        self.text_end = text_end

    def classify(self, va: int):
        if va < self.text_start:
            return ("unresolved", "below_text_start")
        if va >= self.text_end:
            return ("unresolved", "at_or_above_text_end")
        i = bisect.bisect_right(self.starts, va) - 1
        if i < 0:
            return ("unresolved", "below_first_function")
        s = self.starts[i]
        return ("exact", s) if s == va else ("interior", s)

    def span_end(self, start: int) -> int:
        i = bisect.bisect_right(self.starts, start)
        return self.starts[i] if i < len(self.starts) else self.text_end

    def span(self, start: int) -> int:
        return self.span_end(start) - start

    def starts_in(self, a: int, b: int):
        return self.starts[bisect.bisect_left(self.starts, a):bisect.bisect_left(self.starts, b)]


# ------------------------------------------------------------- C source scanning

@dataclasses.dataclass(frozen=True)
class Citation:
    va: int
    symbol: Optional[str]


def _blank(chars: list, a: int, b: int, fill: str = " "):
    for i in range(a, b):
        if chars[i] != "\n":
            chars[i] = fill


def _func_name(header: str, objc: bool) -> Optional[str]:
    h = " ".join(header.split())
    if not h:
        return None
    if objc:
        ms = list(re.finditer(r"(?:^|[\s;}])[-+]\s*\([^()]*\)\s*([A-Za-z_]\w*)", h))
        if ms:
            return ms[-1].group(1)
    if h.startswith("typedef") or "=" in h:
        return None
    while True:
        k = h.rstrip()
        if not k.endswith(")"):
            return None
        depth = 0
        idx = -1
        for j in range(len(k) - 1, -1, -1):
            if k[j] == ")":
                depth += 1
            elif k[j] == "(":
                depth -= 1
                if depth == 0:
                    idx = j
                    break
        if idx < 0:
            return None
        m = re.search(r"([A-Za-z_]\w*)\s*$", k[:idx])
        if not m:
            return None
        name = m.group(1)
        if name in ("__attribute__", "__declspec", "__asm__", "asm", "alignas"):
            h = k[:m.start()]
            continue
        return None if name in ("if", "for", "while", "switch", "return", "sizeof") else name


def _c_structure(text: str, filename: str):
    """Mask a C/ObjC source and find its top-level items.

    Returns ``(vis, code, comments, pp, gap, st, items)``: ``vis`` has strings blanked and comments kept,
    ``code`` has both blanked, ``items`` is ``(first_nonspace, open, close, name)`` per function body or
    prototype (a prototype has open == close)."""
    objc = filename.endswith(".mm")
    n = len(text)
    vis = list(text)        # strings blanked, comments kept
    code = list(text)       # strings and comments blanked
    comments = []
    i = 0
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if c == "/" and nxt == "*":
            j = text.find("*/", i + 2)
            j = n if j < 0 else j + 2
            comments.append((i, j))
            _blank(code, i, j)
            i = j
        elif c == "/" and nxt == "/":
            j = text.find("\n", i)
            j = n if j < 0 else j
            comments.append((i, j))
            _blank(code, i, j)
            i = j
        elif c in "\"'":
            j = i + 1
            while j < n and text[j] != c and text[j] != "\n":
                j += 2 if text[j] == "\\" else 1
            j = min(j + 1, n)
            _blank(vis, i, j)
            _blank(code, i, j)
            i = j
        else:
            i += 1
    # preprocessor lines (with continuations) are scanned for citations but not for braces
    pp = []
    pos = 0
    code_s = "".join(code)
    lines = code_s.split("\n")
    raw_lines = text.split("\n")
    k = 0
    while k < len(lines):
        start_line = k
        if lines[k].lstrip().startswith("#"):
            while k < len(raw_lines) - 1 and raw_lines[k].rstrip().endswith("\\"):
                k += 1
            a = sum(len(x) + 1 for x in lines[:start_line])
            b = sum(len(x) + 1 for x in lines[:k + 1]) - 1
            pp.append((a, b))
        k += 1
    struct_chars = list(code_s)
    gap_chars = list(code_s)
    for a, b in pp:
        _blank(struct_chars, a, b)
        _blank(gap_chars, a, b, "#")
    st = "".join(struct_chars)
    gap = "".join(gap_chars)

    def first_nonspace(a, b):
        j = a
        while j < b and st[j].isspace():
            j += 1
        return j

    items = []  # (first_nonspace, open_or_end, close_or_end, name)
    depth = 0
    hs = 0
    open_at = 0
    for idx, ch in enumerate(st):
        if ch == "{":
            if depth == 0:
                if re.fullmatch(r"\s*extern\s*", st[hs:idx]):
                    hs = idx + 1            # extern "C" { ... } is transparent
                    continue
                open_at = idx
            depth += 1
        elif ch == "}":
            if depth > 0:
                depth -= 1
                if depth == 0:
                    items.append((first_nonspace(hs, open_at), open_at, idx, _func_name(st[hs:open_at], objc)))
                    hs = idx + 1
        elif ch == ";" and depth == 0:
            name = _func_name(st[hs:idx], objc)
            if name:
                items.append((first_nonspace(hs, idx), idx, idx, name))
            hs = idx + 1
    items.sort()
    return vis, code, comments, pp, gap, st, items


def scan_c_functions(text: str, filename: str = "x.c") -> dict:
    """Function definitions of a C/ObjC source: name -> body with comments and strings blanked.

    Used to find which test function mentions a native symbol; a name defined twice keeps its first body."""
    _vis, code, _comments, _pp, _gap, st, items = _c_structure(text, filename)
    out = {}
    for _first, op, cl, name in items:
        if name and cl > op and name not in out:
            out[name] = "".join(code[op:cl + 1])
    return out


def scan_c_source(text: str, filename: str = "x.c") -> list:
    """Address citations in a C/ObjC source with their enclosing symbol."""
    vis, code, comments, pp, gap, st, items = _c_structure(text, filename)

    def symbol_at(p: int, comment_end: Optional[int]):
        for first, op, cl, name in items:
            if first <= p <= cl:
                return name
        if comment_end is not None:
            for first, op, cl, name in items:
                if first >= comment_end:
                    return name if gap[comment_end:first].strip() == "" else None
        return None

    comment_starts = [c[0] for c in comments]
    out = []
    vis_s = "".join(vis)
    for rx in (HEX_RE, FUN_RE):
        for m in rx.finditer(vis_s):
            va = int(m.group(1), 16)
            if not is_va(va):
                continue
            p = m.start()
            if any(a <= p < b for a, b in pp):
                out.append(Citation(va, None))
                continue
            ci = bisect.bisect_right(comment_starts, p) - 1
            cend = None
            if ci >= 0 and comments[ci][0] <= p < comments[ci][1]:
                cend = comments[ci][1]
            out.append(Citation(va, symbol_at(p, cend)))
    return sorted(set(out), key=lambda c: (c.va, c.symbol or ""))


# --------------------------------------------------------- Python source scanning

def _py_scopes(tree):
    scopes = []

    def visit(node, quals):
        for ch in ast.iter_child_nodes(node):
            if isinstance(ch, ast.ClassDef):
                q = quals + [ch.name]
                scopes.append((ch.lineno, ch.end_lineno or ch.lineno, ".".join(q)))
                visit(ch, q)
            elif isinstance(ch, (ast.FunctionDef, ast.AsyncFunctionDef)):
                q = quals + [ch.name]
                scopes.append((ch.lineno, ch.end_lineno or ch.lineno, ".".join(q)))
                # nested functions keep the outer name
            else:
                visit(ch, quals)

    visit(tree, [])
    return scopes


def _scope_at(scopes, line):
    best = None
    for a, b, q in scopes:
        if a <= line <= b and (best is None or (b - a) < (best[1] - best[0])):
            best = (a, b, q)
    return best[2] if best else None


def _py_parse(text: str, name: str):
    try:
        return ast.parse(text)
    except (SyntaxError, ValueError) as exc:
        raise EvidenceError(f"{name}: cannot parse Python: {exc}") from exc


def _py_tokens(text: str, name: str):
    try:
        return list(tokenize.generate_tokens(io.StringIO(text).readline))
    except (tokenize.TokenError, IndentationError, SyntaxError) as exc:
        raise EvidenceError(f"{name}: cannot tokenize: {exc}") from exc


_STRINGISH = {tokenize.STRING, tokenize.COMMENT}
if hasattr(tokenize, "FSTRING_MIDDLE"):
    _STRINGISH.add(tokenize.FSTRING_MIDDLE)


def scan_python_source(text: str, name: str = "x.py") -> list:
    tree = _py_parse(text, name)
    scopes = _py_scopes(tree)
    out = set()
    for tok in _py_tokens(text, name):
        line = tok.start[0]
        if tok.type == tokenize.NUMBER and tok.string.lower().startswith("0x"):
            try:
                v = int(tok.string.replace("_", ""), 16)
            except ValueError:
                continue
            if is_va(v):
                out.add(Citation(v, _scope_at(scopes, line)))
        elif tok.type in _STRINGISH:
            for rx in (HEX_RE, FUN_RE):
                for m in rx.finditer(tok.string):
                    v = int(m.group(1), 16)
                    if is_va(v):
                        out.add(Citation(v, _scope_at(scopes, line + tok.string.count("\n", 0, m.start()))))
    return sorted(out, key=lambda c: (c.va, c.symbol or ""))


_IDENT_RE = re.compile(r"[A-Za-z_]\w*")


def scan_python_tests(text: str, name: str = "x.py") -> dict:
    """Test functions of a Python source: ``Class.method`` / ``function`` -> identifiers they mention.

    A test is a function or method whose name starts with ``test``.  The identifiers are the NAME tokens
    in its line range, string literals that are one bare identifier (``lib["sym"]``, ``getattr(lib,
    "sym")``) and the words of its docstring (a test may say which function it covers when it reaches the
    function through a helper).  Comments are not references."""
    tree = _py_parse(text, name)
    tests = []                                         # (first line, last line, test_id)
    docs = {}                                          # test_id -> identifiers in its docstring

    def visit(node, quals):
        for ch in ast.iter_child_nodes(node):
            if isinstance(ch, ast.ClassDef):
                visit(ch, quals + [ch.name])
            elif isinstance(ch, (ast.FunctionDef, ast.AsyncFunctionDef)):
                if ch.name.startswith("test"):
                    test_id = ".".join(quals + [ch.name])
                    tests.append((ch.lineno, ch.end_lineno or ch.lineno, test_id))
                    docs[test_id] = set(_IDENT_RE.findall(ast.get_docstring(ch) or ""))
            else:
                visit(ch, quals)

    visit(tree, [])
    out = {test_id: set(docs[test_id]) for _a, _b, test_id in tests}
    if not tests:
        return out
    for tok in _py_tokens(text, name):
        line = tok.start[0]
        if tok.type == tokenize.NAME:
            word = tok.string
        elif tok.type == tokenize.STRING:
            try:
                value = ast.literal_eval(tok.string)
            except (ValueError, SyntaxError):
                continue
            if not isinstance(value, str) or not _IDENT_RE.fullmatch(value):
                continue
            word = value
        else:
            continue
        for first, last, test_id in tests:
            if first <= line <= last:
                out[test_id].add(word)
    return out


# ------------------------------------------------------------------ window candidates

@dataclasses.dataclass(frozen=True)
class Candidate:
    a: int                      # start (or file offset for shape file_offset)
    b: int                      # end / size as written
    sha: Optional[str]
    shape: str
    context: str                # oracle | static | doc
    hint: Optional[str]         # reading implied by the key name, if any
    source: str                 # file the declaration was found in
    field: str
    is_source: bool


class _NoEval(Exception):
    pass


def _const_eval(node, env):
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, str)) and not isinstance(node.value, bool):
        return node.value
    if isinstance(node, ast.Name) and node.id in env:
        return env[node.id]
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
        v = _const_eval(node.operand, env)
        if isinstance(v, int):
            return -v
    if isinstance(node, ast.BinOp):
        l, r = _const_eval(node.left, env), _const_eval(node.right, env)
        if isinstance(l, int) and isinstance(r, int):
            ops = {ast.Add: lambda: l + r, ast.Sub: lambda: l - r, ast.Mult: lambda: l * r,
                   ast.LShift: lambda: l << r, ast.BitOr: lambda: l | r, ast.BitAnd: lambda: l & r,
                   ast.FloorDiv: lambda: l // r if r else None}
            f = ops.get(type(node.op))
            if f:
                v = f()
                if v is not None:
                    return v
    if isinstance(node, (ast.Tuple, ast.List)):
        return tuple(_const_eval(e, env) for e in node.elts)
    if isinstance(node, ast.Dict):
        if any(k is None for k in node.keys):
            raise _NoEval
        return {_const_eval(k, env): _const_eval(v, env) for k, v in zip(node.keys, node.values)}
    raise _NoEval


def _pairs(val):
    if isinstance(val, tuple):
        if (len(val) in (2, 3) and is_va(val[0]) and isinstance(val[1], int) and not isinstance(val[1], bool)
                and (len(val) == 2 or isinstance(val[2], str))):
            if not (len(val) == 3 and SHA_RE.fullmatch(val[2])):
                yield val[0], val[1]
            return
        for v in val:
            yield from _pairs(v)
    elif isinstance(val, dict):
        for v in val.values():
            yield from _pairs(v)


def _pair_hint(a: int, b: int) -> Optional[str]:
    return "end_exclusive" if b >= PLAUSIBLE_LO else ("size" if b > 0 else None)


def oracle_windows(text: str, name: str) -> list:
    """Code windows declared in a committed Python oracle/test source."""
    tree = _py_parse(text, name)
    env = {}
    for node in tree.body:
        if isinstance(node, ast.Assign) and len(node.targets) == 1 and isinstance(node.targets[0], ast.Name):
            try:
                v = _const_eval(node.value, env)
            except _NoEval:
                continue
            if isinstance(v, int):
                env[node.targets[0].id] = v
    out = set()

    def add(a, b, sha, shape, ctx, field):
        hint = None if sha else _pair_hint(a, b)
        out.add(Candidate(a, b, sha, shape, ctx, hint if not sha else None, name, field, True))

    for node in ast.walk(tree):                       # hashed (va, end|size, sha) tuples
        if isinstance(node, (ast.Tuple, ast.List)) and len(node.elts) == 3:
            try:
                v = _const_eval(node, env)
            except _NoEval:
                continue
            if is_va(v[0]) and isinstance(v[1], int) and isinstance(v[2], str) and SHA_RE.fullmatch(v[2]):
                add(v[0], v[1], v[2], "tuple", "oracle", "tuple")
    for node in ast.walk(tree):                       # unhashed pairs under window-like names
        targets, value = [], None
        if isinstance(node, ast.Assign):
            targets, value = node.targets, node.value
        elif isinstance(node, ast.AnnAssign) and node.value is not None:
            targets, value = [node.target], node.value
        for t in targets:
            if isinstance(t, ast.Name) and WINDOW_NAME_RE.search(t.id):
                try:
                    v = _const_eval(value, env)
                except _NoEval:
                    continue
                ctx = "static" if STATIC_RE.search(t.id) else "oracle"
                for a, b in _pairs(v):
                    add(a, b, None, "pair", ctx, t.id)
    for tok in _py_tokens(text, name):                # "0xA..0xB" in docstrings and comments
        if tok.type in _STRINGISH:
            for m in RANGE_RE.finditer(tok.string):
                a, b = int(m.group(1), 16), int(m.group(2), 16)
                if is_va(a) and is_va(b) and b > a:
                    out.add(Candidate(a, b, None, "doc_range", "doc", "end_exclusive", name, "doc", True))
    return sorted(out, key=lambda c: (c.a, c.b, c.sha or "", c.shape, c.field))


START_KEYS = ("start", "start_va", "va", "begin")
END_RE = re.compile(r"(?:^|_)(?:end|stop)(?:_|$)|^exclusive_end")
SIZE_KEYS = ("size", "bytes", "length", "byte_count", "length_bytes")
SHA_KEYS = ("window_sha256", "original_window_sha256", "code_sha256", "sha256", "original_sha256", "sha")
DASH_KEY = re.compile(r"^\s*0[xX]([0-9a-fA-F]{6,8})\s*-\s*0[xX]([0-9a-fA-F]{6,8})\b")
ANY_VA_RE = re.compile(r"0[xX][0-9a-fA-F]{6,8}")
NAMED_PAIR_KEY = re.compile(r"_0x([0-9a-fA-F]{6,8})_0x([0-9a-fA-F]{6,8})(?:_sha256)?$")
DOTDOT_KEY = re.compile(r"^\s*0[xX]([0-9a-fA-F]{6,8})\s*\.\.\s*0[xX]([0-9a-fA-F]{6,8})\b")


def _recorded_sha(node: dict, keys=SHA_KEYS):
    for k in keys:
        v = node.get(k)
        if isinstance(v, str) and SHA_RE.fullmatch(v):
            return v
    return None


def _context(path: list, node=None) -> str:
    for seg in path:
        if isinstance(seg, str) and STATIC_RE.search(seg):
            return "static"
    if isinstance(node, dict):
        for k in ("scope", "evidence_class", "purpose", "label", "name"):
            v = node.get(k)
            if isinstance(v, str) and STATIC_RE.search(v):
                return "static"
    return "oracle"


def receipt_windows(doc, source: str) -> list:
    """Code windows (hashed or declared-only) found anywhere in a receipt."""
    out = []

    def emit(a, b, sha, shape, hint, path, node=None):
        out.append(Candidate(a, b, sha, shape, _context(path, node), hint, source,
                             "/".join(str(p) for p in path), False))

    def dict_window(node, path):
        sha = _recorded_sha(node)
        start_key = next((k for k in START_KEYS if k in node), None)
        a = parse_address(node[start_key]) if start_key else None
        end_key = next((k for k in node if isinstance(k, str) and END_RE.search(k)
                        and k not in ("code_end",) and parse_address(node[k]) is not None), None)
        size_key = next((k for k in SIZE_KEYS if k in node and isinstance(node[k], int)
                         and not isinstance(node[k], bool)), None)
        if "file_offset" in node and isinstance(node["file_offset"], int) and size_key and sha:
            emit(node["file_offset"], node[size_key], sha, "file_offset", "size", path, node)
            return
        if a is not None and is_va(a) and (end_key or size_key):
            if end_key:
                b, hint = parse_address(node[end_key]), "end_exclusive"
            else:
                b, hint = node[size_key], "size"
            emit(a, b, sha, "dict", hint, path, node)
            return
        rng = node.get("range")
        if isinstance(rng, list) and len(rng) == 2:
            ra, rb = parse_address(rng[0]), parse_address(rng[1])
            if is_va(ra) and rb is not None:
                emit(ra, rb, sha, "range", "end_exclusive", path, node)
                return
        if "code_start" in node and "code_end" in node:
            ra, rb = parse_address(node["code_start"]), parse_address(node["code_end"])
            if is_va(ra) and rb is not None:
                emit(ra, rb, _recorded_sha(node, ("code_window", "code_sha256", "code_window_sha256", "sha256")),
                     "code_start_end", "end_exclusive", path, node)

    def walk(node, path):
        if isinstance(node, dict):
            dict_window(node, path)
            for k, v in node.items():
                if not (isinstance(k, str) and isinstance(v, str) and SHA_RE.fullmatch(v)):
                    continue
                # a key naming both ends of the window (dash form or name_0xA_0xB[_sha256]);
                # the hash decides the reading, so these are safe outside code_window containers
                pair = DASH_KEY.match(k) or NAMED_PAIR_KEY.search(k)
                if pair:
                    a, b = int(pair.group(1), 16), int(pair.group(2), 16)
                    if is_va(a):
                        emit(a, b, v, "named_pair", None, path + [k])
                    continue
                if path and isinstance(path[-1], str) and "code_window" in path[-1]:
                    m = re.search(r"_0x([0-9a-fA-F]{6,8})$", k)
                    if m and is_va(int(m.group(1), 16)):
                        emit(int(m.group(1), 16), 0, v, "start_sha", None, path + [k])
            for k, v in node.items():
                if isinstance(k, str) and isinstance(v, str) and SHA_RE.fullmatch(v):
                    m = DOTDOT_KEY.match(k)
                    if m:
                        a, b = int(m.group(1), 16), int(m.group(2), 16)
                        if is_va(a):
                            emit(a, b, v, "dotdot_key", "end_exclusive", path + [k])
                walk(v, path + [k])
        elif isinstance(node, list):
            if len(node) == 3 and isinstance(node[2], str) and SHA_RE.fullmatch(node[2]):
                a, b = parse_address(node[0]), parse_address(node[1])
                if is_va(a) and b is not None:
                    emit(a, b, node[2], "triple", None, path)
            elif (len(node) == 2 and path and isinstance(path[-1], str)
                  and re.fullmatch(r"code_ranges?", path[-1])):
                a, b = parse_address(node[0]), parse_address(node[1])
                if is_va(a) and b is not None:
                    emit(a, b, None, "range", "end_exclusive", path)
            for i, v in enumerate(node):
                walk(v, path + [i])

    walk(doc, [])
    seen, uniq = set(), []
    for c in out:
        key = (c.a, c.b, c.sha, c.shape, c.context)
        if key not in seen:
            seen.add(key)
            uniq.append(c)
    return uniq


def unconsumed_window_keys(doc, wins: list) -> list:
    """Residual audit: receipt keys that pair two VAs with a sha but produced no window candidate.

    Fails the run instead of silently dropping a hashed window whose key shape nothing recognises."""
    fields = [c.field for c in wins]
    found = []

    def walk(node, path):
        if isinstance(node, dict):
            for k, v in node.items():
                if (isinstance(k, str) and isinstance(v, str) and SHA_RE.fullmatch(v)
                        and len(ANY_VA_RE.findall(k)) >= 2
                        and not any(f == k or f.endswith("/" + k) for f in fields)):
                    found.append("/".join(str(p) for p in path + [k]))
                walk(v, path + [k])
        elif isinstance(node, list):
            for i, v in enumerate(node):
                walk(v, path + [i])

    walk(doc, [])
    return found


# -------------------------------------------------------------- receipt metadata

@dataclasses.dataclass(frozen=True)
class Item:
    field: str
    index: int
    text_sha256: str
    addresses: tuple


@dataclasses.dataclass(frozen=True)
class Hook:
    address: int
    kind: str


def receipt_review(doc) -> dict:
    node = doc.get("independent_review") if isinstance(doc, dict) else None
    if node is None and isinstance(doc, dict):
        node = doc.get("review")
    if node is None:
        return {"state": "absent", "reviewer_recorded": False}
    if isinstance(node, str):
        return {"state": "none", "reviewer_recorded": False}
    if not isinstance(node, dict):
        return {"state": "none", "reviewer_recorded": False}
    reviewer = node.get("reviewer")
    recorded = bool(reviewer) and not isinstance(reviewer, bool)
    status = node.get("status") if isinstance(node.get("status"), str) else ""
    if recorded:
        state = "reviewer_recorded"
    elif re.search(r"addressed|fixed", status, re.I):
        state = "findings_addressed"
    elif "pending" in status.lower():
        state = "pending"
    else:
        state = "none"
    return {"state": state, "reviewer_recorded": recorded}


def receipt_items(doc, key_re) -> list:
    out = []

    def add(field, index, item):
        text = canon_text(item)
        out.append(Item(field, index, sha256_bytes(text.encode("utf-8")), tuple(sorted(set(extract_addresses(text))))))

    def walk(node, path):
        if isinstance(node, dict):
            for k, v in node.items():
                if isinstance(k, str) and key_re.match(k):
                    field = "/".join(str(p) for p in path + [k])
                    if isinstance(v, list):
                        for i, el in enumerate(v):
                            add(field, i, el)
                    elif isinstance(v, dict):
                        for i, (kk, vv) in enumerate(v.items()):
                            add(field, i, {kk: vv})
                    elif isinstance(v, str):
                        add(field, 0, v)
                else:
                    walk(v, path + [k])
        elif isinstance(node, list):
            for i, v in enumerate(node):
                walk(v, path + [i])

    walk(doc, [])
    return out


def _flatten(node) -> str:
    if isinstance(node, dict):
        return " ".join(f"{k} {_flatten(v)}" for k, v in node.items())
    if isinstance(node, list):
        return " ".join(_flatten(v) for v in node)
    return "" if node is None else str(node)


def _classify_hook(text: str) -> str:
    """Fail closed: ``observed`` needs an explicit 'observ' and no sign of a write, stop or forced result."""
    if REPLACED_RE.search(text) or MUTATING_RE.search(text):
        return "replaced" if REPLACED_RE.search(text) else "unclassified"
    if OBSERVED_RE.search(text) and re.search(r"observ", text, re.I):
        return "observed"
    return "unclassified"


_HOOK_PRIORITY = {"replaced": 0, "unclassified": 1, "observed": 2}


def receipt_hooks(doc) -> list:
    found = {}

    def take(text):
        kind = _classify_hook(text)
        for a in extract_addresses(text):
            cur = found.get(a)
            if cur is None or _HOOK_PRIORITY[kind] < _HOOK_PRIORITY[cur]:
                found[a] = kind

    def walk(node):
        if isinstance(node, dict):
            for k, v in node.items():
                if isinstance(k, str) and "hook" in k.lower():
                    if isinstance(v, dict):
                        for kk, vv in v.items():
                            take(f"{kk} {_flatten(vv)}")
                    elif isinstance(v, list):
                        for el in v:
                            take(_flatten(el))
                    elif isinstance(v, str):
                        take(v)
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(doc)
    return [Hook(a, found[a]) for a in sorted(found)]


def receipt_files(doc) -> list:
    out = set()
    if isinstance(doc, dict):
        for k in FILE_KEYS:
            v = doc.get(k)
            names = v.keys() if isinstance(v, dict) else v if isinstance(v, list) else []
            for s in names:
                if isinstance(s, str) and ("/" in s or re.search(r"\.\w+$", s)):
                    p = normalize_path(s)
                    if p:
                        out.add(p)
    return sorted(out)


# ------------------------------------------------------------------------ config

@dataclasses.dataclass
class Config:
    repo: Path
    outputs: Path
    index: Path
    src_dir: Path
    tests_dir: Path
    slices_dir: Path
    game_source: Path
    output: Path
    exe: Optional[Path] = None
    exe_sha256: Optional[str] = PINNED_EXE_SHA256
    text_start: int = TEXT_START
    text_end: int = TEXT_END
    work_dir: Optional[Path] = None             # private tree; default <repo>/work (a worktree has none)

    @classmethod
    def for_repo(cls, repo, **kw) -> "Config":
        repo = Path(repo)
        out = repo / "outputs" / "blackmoor-decomp"
        work = Path(kw.pop("work_dir", None) or repo / "work")
        base = dict(repo=repo, outputs=out, index=out / "function-index.json", src_dir=out / "src",
                    tests_dir=out / "tests", slices_dir=work / "analysis" / "slices",
                    game_source=work / "analysis" / "game-source.json",
                    output=out / "function-evidence.json", work_dir=work)
        base.update(kw)
        return cls(**base)

    def rel(self, path: Path) -> str:
        return path.relative_to(self.repo).as_posix()

    def work_rel(self, path: Path) -> str:
        return path.relative_to(self.work_dir or self.repo / "work").as_posix()


def _original_path(cfg: Config) -> Path:
    if cfg.exe:
        return Path(cfg.exe)
    try:
        info = json.loads(cfg.game_source.read_text(encoding="utf-8"))
        recorded = Path(info["game_dir"]) / "GAME.EXE"
    except (OSError, ValueError, KeyError, TypeError) as exc:
        raise EvidenceError(f"cannot locate the original through {cfg.game_source.name}: {exc}") from exc
    # A cloud checkout has the owner's GAME.EXE only as a private copy under work/original (same pinned hash).
    private_copy = (cfg.work_dir or cfg.repo / "work") / "original" / "GAME.EXE"
    return recorded if recorded.is_file() or not private_copy.is_file() else private_copy


def _receipt_files(cfg: Config) -> list:
    d = cfg.slices_dir
    if not d.is_dir():
        return []
    names = {p for pat in ("*handoff*.json", "*validation*.json") for p in d.glob(pat)
             if p.is_file() and not LEDGER_RECEIPT.match(p.name)}
    return sorted(names, key=lambda p: p.name)


# ------------------------------------------------------------------------ derive

def _decode(data: bytes) -> str:
    return data.decode("utf-8", errors="replace")


def derive(cfg: Config, *, receipts: bool = True) -> dict:
    problems: list = []
    exe_path = _original_path(cfg)
    try:
        exe_bytes = exe_path.read_bytes()
    except OSError as exc:
        raise EvidenceError(f"cannot read the original executable: {exc.strerror or exc}") from exc
    exe_sha = sha256_bytes(exe_bytes)
    if cfg.exe_sha256 and exe_sha != cfg.exe_sha256:
        raise EvidenceError(f"original executable hash {exe_sha} != pinned {cfg.exe_sha256}")
    pe = PE.from_bytes(exe_bytes)

    # function index
    try:
        raw_index = cfg.index.read_bytes()
        index = json.loads(raw_index)
        starts = [int(f["address"], 16) for f in index["functions"]]
    except (OSError, ValueError, KeyError, TypeError) as exc:
        raise EvidenceError(f"cannot read function index: {exc}") from exc
    if len(set(starts)) != len(starts):
        raise EvidenceError("function index lists the same start twice")
    if any(not (cfg.text_start <= s < cfg.text_end) for s in starts):
        raise EvidenceError("function index has a start outside .text")
    fm = FunctionMap(starts, cfg.text_start, cfg.text_end)

    pointers = {s: {} for s in starts}      # start -> {canonical json: pointer}
    mentions = {}                           # (start, path, symbol, via, sha) -> set(addresses)
    blockers = {s: [] for s in starts}
    divergences = {s: [] for s in starts}
    rec_touch = {}                          # (start, receipt path) -> {"via": set, "hook": kind|None}
    unresolved = {}                         # address -> {reason, refs, sources:set, kinds:set}
    stats = {"citations": {"native_source_exact": 0, "native_source_interior": 0, "test_exact": 0,
                           "test_interior": 0, "test_case_by_symbol": 0}}

    def add_unresolved(va, reason, kind, source):
        u = unresolved.setdefault(va, {"reason": reason, "refs": 0, "sources": set(), "kinds": set()})
        u["refs"] += 1
        u["sources"].add(source)
        u["kinds"].add(kind)

    def put(start, ptr):
        pointers[start][json.dumps(ptr, sort_keys=True)] = ptr

    def put_mention(start, path, sha, symbol, via, address):
        mentions.setdefault((start, path, symbol, via, sha), set()).add(address)

    # ---- committed sources
    sources = []
    cands: list = []
    file_sha = {}
    test_units = {}         # test source path -> (sha256, {test_id: identifiers it mentions})

    def scan_files(directory: Path, suffixes, is_src: bool):
        if not directory.is_dir():
            return
        for p in sorted(q for q in directory.iterdir() if q.is_file() and q.suffix in suffixes):
            if not is_src and FIXTURE_TESTS.match(p.name):
                continue            # ledger tooling tests use real-looking fixture addresses
            data = p.read_bytes()
            rel = cfg.rel(p)
            digest = sha256_bytes(data)
            file_sha[rel] = digest
            text = _decode(data)
            if is_src:
                role, kind = "native_source", "native_source"
                cites = scan_c_source(text, p.name)
            elif p.suffix == ".py":
                try:
                    cands.extend(oracle_windows(text, rel))
                except EvidenceError as exc:
                    problems.extend(exc.problems)
                    continue
                if p.name.startswith("test_"):
                    role, kind = "test", "test"
                    try:
                        cites = scan_python_source(text, rel)
                        test_units[rel] = (digest, scan_python_tests(text, rel))
                    except EvidenceError as exc:
                        problems.extend(exc.problems)
                        continue
                else:
                    role, kind, cites = "oracle_source", None, []
            else:
                role, kind = "test", "test"
                cites = scan_c_source(text, p.name)
                test_units[rel] = (digest, {name: set(_IDENT_RE.findall(body))
                                            for name, body in scan_c_functions(text, p.name).items()})
            sources.append({"path": rel, "sha256": digest, "role": role})
            for c in cites:
                k, x = fm.classify(c.va)
                if k == "exact":
                    if kind == "native_source":
                        put(x, {"kind": "native_source", "path": rel, "symbol": c.symbol, "sha256": digest})
                        stats["citations"]["native_source_exact"] += 1
                    else:
                        put(x, {"kind": "test", "path": rel, "test_id": c.symbol, "sha256": digest})
                        stats["citations"]["test_exact"] += 1
                elif k == "interior":
                    put_mention(x, rel, digest, c.symbol, "citation", c.va)
                    stats["citations"]["native_source_interior" if kind == "native_source"
                                       else "test_interior"] += 1
                else:
                    add_unresolved(c.va, x, "citation", rel)

    scan_files(cfg.src_dir, {".c", ".h", ".mm"}, True)
    scan_files(cfg.tests_dir, {".py", ".c", ".mm"}, False)

    # ---- the test cases that mention a cited native symbol (lexical, like every pointer here)
    for start in list(pointers):
        symbols = {p["symbol"] for p in list(pointers[start].values()) if p["kind"] == "native_source" and p["symbol"]}
        if not symbols:
            continue
        for rel, (digest, units) in sorted(test_units.items()):
            for test_id, words in sorted(units.items()):
                if symbols & words:
                    ptr = {"kind": "test", "path": rel, "test_id": test_id, "sha256": digest}
                    if json.dumps(ptr, sort_keys=True) not in pointers[start]:
                        stats["citations"]["test_case_by_symbol"] += 1
                    put(start, ptr)

    # ---- receipts
    receipt_rows = []
    rec = {}                                 # work-relative path -> info
    if receipts:
        for p in _receipt_files(cfg):
            data = p.read_bytes()
            wrel = cfg.work_rel(p)
            try:
                doc = json.loads(data)
            except ValueError as exc:
                problems.append(f"{wrel}: invalid JSON: {exc}")
                continue
            if not isinstance(doc, dict):
                problems.append(f"{wrel}: receipt is not a JSON object")
                continue
            wins = receipt_windows(doc, wrel)
            for key_path in unconsumed_window_keys(doc, wins):
                problems.append(f"unrecognised window key shape: {wrel} [{key_path}]")
            cands.extend(wins)
            hooks = receipt_hooks(doc)
            unver = receipt_items(doc, UNVERIFIED_KEY)
            div = receipt_items(doc, DIVERGENCE_KEY)
            rec[wrel] = {
                "slice": slice_id(p.name), "kind": "validation" if "validation" in p.name else "handoff",
                "sha256": sha256_bytes(data), "review": receipt_review(doc), "files": receipt_files(doc),
                "hooks": {h.address: h.kind for h in hooks}, "unver": unver, "div": div,
                "wins": wins,
            }

    # ---- windows
    counters = {"declared": 0, "hashed": 0, "verified": 0, "mismatch": 0, "outside_text": 0,
                "declared_only": 0, "label_disagrees": 0, "invalid": 0}
    by_shape, by_reading = {}, {}
    per_receipt = {w: {"declared": 0, "hashed": 0, "verified": 0} for w in rec}
    windows = {}            # (s, e) -> {"sha", "reading", "hashed": bool, "declarers": {source: info}}
    known = {}              # (start, sha) -> (reading, start, end) of verified windows
    ordered = [c for c in cands if c.shape != "start_sha"] + [c for c in cands if c.shape == "start_sha"]
    for c in ordered:
        counters["declared"] += 1
        if c.sha:
            counters["hashed"] += 1
        pr = per_receipt.get(c.source)
        if pr is not None:
            pr["declared"] += 1
            pr["hashed"] += 1 if c.sha else 0
        a, readings = c.a, None
        where = f"{c.source} [{c.field}]"
        if c.shape == "file_offset":
            va = pe.file_offset_to_va(c.a)
            if va is None:
                problems.append(f"window hash mismatch: {where}: file offset {c.a} is not in a section")
                counters["mismatch"] += 1
                continue
            a, readings = va, ("size",)
        elif c.shape == "named_pair":
            readings = ("end_exclusive", "end_inclusive")
        if not (cfg.text_start <= a < cfg.text_end):
            counters["outside_text"] += 1
            add_unresolved(a, "at_or_above_text_end" if a >= cfg.text_end else "below_text_start",
                           "window_start", c.source)
            continue
        if c.sha:
            if c.shape == "start_sha":
                hit = known.get((a, c.sha))
                if hit is None:
                    counters["mismatch"] += 1
                    problems.append(f"window hash mismatch: {where}: start-only window at {hx(a)} has no end "
                                    "and no hashed twin with the same start and hash")
                    continue
                reading, s, e = hit
            else:
                try:
                    reading, s, e = settle_window(pe, a, c.b, c.sha, readings)
                except WindowError as exc:
                    counters["mismatch"] += 1
                    problems.append(f"window hash mismatch: {where}: start {hx(a)} value {c.b}: {exc}")
                    continue
            known.setdefault((s, c.sha), (reading, s, e))
            counters["verified"] += 1
            if pr is not None:
                pr["verified"] += 1
            by_shape[c.shape] = by_shape.get(c.shape, 0) + 1
            by_reading[reading] = by_reading.get(reading, 0) + 1
            if c.hint and c.hint != reading:
                counters["label_disagrees"] += 1
            digest = c.sha
        else:
            counters["declared_only"] += 1
            reading = c.hint or "end_exclusive"
            rng = window_range(reading, a, c.b)
            if rng is None:
                counters["invalid"] += 1
                continue
            s, e = rng
            data = pe.read_va(s, e - s)
            digest = sha256_bytes(data) if data is not None else None
        w = windows.setdefault((s, e), {"sha": None, "reading": None, "hashed": False, "declarers": {}})
        d = w["declarers"].setdefault(c.source, {"is_source": c.is_source, "contexts": set(), "hashed": False})
        d["contexts"].add(c.context)
        if c.sha:
            d["hashed"] = True
            w["hashed"] = True
            w["sha"], w["reading"] = digest, reading
        elif not w["hashed"] and w["sha"] is None:
            w["sha"], w["reading"] = digest, reading
    if problems:
        raise EvidenceError(sorted(set(problems)))

    # ---- link oracle sources to the receipts that list them
    linked = {}
    for wrel, info in rec.items():
        for f in info["files"]:
            if f in file_sha:
                linked.setdefault(f, []).append(wrel)

    def hooks_for(source):
        info = rec.get(source)
        if info is not None:
            return info["hooks"]
        merged = {}
        for wrel in linked.get(source, []):
            for a, k in rec[wrel]["hooks"].items():
                if a not in merged or _HOOK_PRIORITY[k] < _HOOK_PRIORITY[merged[a]]:
                    merged[a] = k
        return merged

    def sha_of_source(source):
        return file_sha.get(source) or (rec[source]["sha256"] if source in rec else None)

    def src_label(source):
        return source if source in file_sha else source  # receipts are already work-relative

    def touch(start, wrel, via, hook=None):
        t = rec_touch.setdefault((start, wrel), {"via": set(), "hook": None})
        t["via"].add(via)
        if hook and (t["hook"] is None or _HOOK_PRIORITY[hook] < _HOOK_PRIORITY[t["hook"]]):
            t["hook"] = hook

    for (s, e), w in sorted(windows.items()):
        k, container = fm.classify(s)
        hashed_decl = {src: d for src, d in w["declarers"].items() if d["hashed"]}
        joiners = sorted(src for src, d in w["declarers"].items() if not d["hashed"])
        for src, d in w["declarers"].items():
            if k == "interior":
                put_mention(container, src_label(src), sha_of_source(src), None, "window_start", s)
            if src in rec:
                if k in ("exact", "interior"):
                    touch(container, src, "window")
        for f in fm.starts_in(s, e):
            for src, d in w["declarers"].items():
                if src in rec:
                    touch(f, src, "window")
            groups = {}
            if not hashed_decl:
                groups[("mapped", "unhashed")] = set()
            gbases = {}
            for src, d in hashed_decl.items():
                oracle_ctx = "oracle" in d["contexts"]
                hk = hooks_for(src).get(f)
                if not oracle_ctx:
                    use, basis = "mapped", "static_scope"
                elif hk == "replaced":
                    use, basis = "mapped", "replaced_by_hook"
                elif hk == "unclassified":
                    use, basis = "mapped", "hook_unclassified"
                elif hk == "observed":
                    use, basis = ("entry" if f == s else "callee"), "observed_hook"
                elif f == s:
                    use, basis = "entry", "window_start"
                else:
                    use, basis = "mapped", "containment_only"
                groups.setdefault((use, "-"), set()).add(src)
                gbases.setdefault(use, set()).add(basis)
            for (use, basis), srcs in sorted(groups.items()):
                if basis == "-":
                    basis = min(gbases[use], key=BASIS_PRIORITY.index)
                declared = sorted(set(srcs) | set(joiners))
                oracle_paths = [x for x in declared if x in file_sha]
                ptr = {
                    "kind": "oracle",
                    "path": oracle_paths[0] if oracle_paths else None,
                    "sha256": file_sha[oracle_paths[0]] if oracle_paths else None,
                    "window": [hx(s), hx(e)], "window_sha256": w["sha"], "reading": w["reading"],
                    "verified": "recorded_hash" if hashed_decl else "declared_only",
                    "use": use, "use_basis": basis,
                    "tail_gap": max(0, fm.span_end(f) - e), "declared_in": declared,
                }
                put(f, ptr)

    # ---- executed ranges (FL-8): which oracle script really ran how much of each function
    execution_stats = {"runs": 0, "functions": 0, "full": 0, "partial": 0}
    execution_file = cfg.outputs / EXECUTION_FILE
    if execution_file.is_file():
        try:
            execution = json.loads(execution_file.read_text(encoding="utf-8"))
            if execution["schema"] != "blackmoor-function-execution/1" or execution["original_sha256"] != exe_sha:
                raise ValueError("schema or original hash differs")
            xrefs_file = cfg.outputs / "function-xrefs.json"
            if xrefs_file.is_file() and execution["inputs"]["function_xrefs_sha256"] != sha256_bytes(xrefs_file.read_bytes()):
                raise ValueError("it was recorded against another function-xrefs.json; rerun record_function_execution.py collect --write")
            run_paths = []
            for run in execution["runs"]:
                rel = "outputs/blackmoor-decomp/" + run["script"].split("outputs/blackmoor-decomp/", 1)[-1]
                if rel not in file_sha or file_sha[rel] != run["script_sha256"]:
                    problems.append(f"{EXECUTION_FILE}: the recorded run of {run['script']} does not match the committed "
                                    "script; rerun scripts/record_function_execution.py")
                run_paths.append(rel)
            execution_stats["runs"] = len(run_paths)
            for va_text, record in execution["functions"].items():
                start = int(va_text, 16)
                if fm.classify(start)[0] != "exact":
                    problems.append(f"{EXECUTION_FILE}: {va_text} is not a function start")
                    continue
                code = record[0]
                end = start + fm.span(start)
                data = pe.read_va(start, end - start)
                if data is None:
                    problems.append(f"{EXECUTION_FILE}: {va_text} is not file-backed")
                    continue
                window_sha = sha256_bytes(data)
                execution_stats["functions"] += 1
                for run_index, entry_hits, executed_bytes, _hits in record[1:]:
                    path = run_paths[run_index]
                    full = bool(entry_hits) and code is not None and executed_bytes >= code
                    execution_stats["full" if full else "partial"] += 1
                    put(start, {
                        "kind": "oracle", "path": path, "sha256": file_sha[path],
                        "window": [hx(start), hx(end)], "window_sha256": window_sha, "reading": "end_exclusive",
                        "verified": "recorded_hash",
                        "use": "entry" if full else "mapped",
                        "use_basis": "executed" if full else "executed_partial",
                        "tail_gap": 0, "declared_in": []})
        except (OSError, ValueError, KeyError, TypeError, IndexError) as exc:
            problems.append(f"{EXECUTION_FILE}: unreadable or inconsistent: {exc}")
        if problems:
            raise EvidenceError(sorted(set(problems)))

    # ---- receipt blockers, divergences, hooks
    for wrel, info in sorted(rec.items()):
        for kind_name, items, dest in (("blocker", info["unver"], blockers), ("divergence", info["div"], divergences)):
            for it in items:
                for a in it.addresses:
                    k, x = fm.classify(a)
                    if k == "unresolved":
                        add_unresolved(a, x, kind_name, wrel)
                        continue
                    dest[x].append({"slice": info["slice"], "path": wrel, "field": it.field, "index": it.index,
                                    "text_sha256": it.text_sha256, "address": hx(a), "interior": k == "interior"})
                    touch(x, wrel, kind_name)
        for a, hk in info["hooks"].items():
            k, x = fm.classify(a)
            if k == "exact":
                touch(x, wrel, "hook", hk)
            elif k == "unresolved":
                add_unresolved(a, x, "hook", wrel)

    # ---- assemble
    for (start, path, symbol, via, sha), addrs in mentions.items():
        put(start, {"kind": "mention", "path": path, "sha256": sha, "symbol": symbol,
                    "addresses": [hx(a) for a in sorted(addrs)], "via": via})
    for (start, wrel), t in rec_touch.items():
        info = rec[wrel]
        put(start, {"kind": "receipt", "slice": info["slice"], "path": wrel, "sha256": info["sha256"],
                    "review": info["review"], "via": sorted(t["via"]), "hook": t["hook"],
                    "unlocated_unverified": sum(1 for i in info["unver"] if not i.addresses)})

    functions = []
    for s in sorted(starts):
        ev = sorted(pointers[s].values(), key=lambda p: (KIND_ORDER[p["kind"]], json.dumps(p, sort_keys=True)))
        bl = sorted(blockers[s], key=lambda x: (x["slice"], x["path"], x["field"], x["index"], x["address"]))
        dv = sorted(divergences[s], key=lambda x: (x["slice"], x["path"], x["field"], x["index"], x["address"]))
        if ev or bl or dv:
            functions.append({"va": hx(s), "evidence": ev, "blockers": bl, "divergences": dv})

    for wrel, info in rec.items():
        receipt_rows.append({
            "slice": info["slice"], "kind": info["kind"], "path": wrel, "sha256": info["sha256"],
            "review": info["review"], "windows": per_receipt[wrel],
            "unverified": {"items": len(info["unver"]), "located": sum(1 for i in info["unver"] if i.addresses)},
            "divergence_items": len(info["div"]), "hook_addresses": len(info["hooks"]), "files": info["files"],
        })
    receipt_rows.sort(key=lambda r: r["path"])
    unresolved_rows = [{"address": hx(a), "reason": u["reason"], "references": u["refs"],
                        "sources": sorted(u["sources"])[:5], "kinds": sorted(u["kinds"])}
                       for a, u in sorted(unresolved.items())]
    kinds = {k: 0 for k in KIND_ORDER}
    mention_addresses = 0
    with_citation = with_window = with_entry = 0
    for f in functions:
        ks = {p["kind"] for p in f["evidence"]}
        for p in f["evidence"]:
            kinds[p["kind"]] += 1
            if p["kind"] == "mention":
                mention_addresses += len(p["addresses"])
        with_citation += "native_source" in ks
        win = [p for p in f["evidence"] if p["kind"] == "oracle" and p["verified"] == "recorded_hash"]
        with_window += bool(win)
        with_entry += any(p["use"] == "entry" for p in win)
    review_counts = {}
    for r in receipt_rows:
        review_counts[r["review"]["state"]] = review_counts.get(r["review"]["state"], 0) + 1
    counts = {
        "functions_total": len(starts),
        "functions_with_evidence": len(functions),
        "functions_with_native_source": with_citation,
        "functions_with_verified_window": with_window,
        "functions_with_verified_entry_window": with_entry,
        "pointers": kinds,
        "mention_addresses": mention_addresses,
        "citations": stats["citations"],
        "windows": {
            "declared": counters["declared"], "hashed": counters["hashed"], "verified": counters["verified"],
            "mismatch": counters["mismatch"], "declared_only": counters["declared_only"],
            "outside_text": counters["outside_text"], "label_disagrees": counters["label_disagrees"],
            "invalid": counters["invalid"], "distinct": len(windows),
            "distinct_verified": sum(1 for w in windows.values() if w["hashed"]),
            "by_shape": dict(sorted(by_shape.items())), "by_reading": dict(sorted(by_reading.items())),
        },
        "receipts": {"total": len(receipt_rows), "by_review_state": dict(sorted(review_counts.items()))},
        "blockers": sum(len(v) for v in blockers.values()),
        "divergences": sum(len(v) for v in divergences.values()),
        "unresolved": {"addresses": len(unresolved_rows), "references": sum(u["refs"] for u in unresolved.values())},
    }
    return {
        "schema": SCHEMA,
        "original_sha256": exe_sha,
        "text_range": [hx(cfg.text_start), hx(cfg.text_end)],
        "function_index": {"path": cfg.rel(cfg.index), "sha256": sha256_bytes(raw_index), "functions": len(starts)},
        "sources": sorted(sources, key=lambda r: r["path"]),
        "receipts": receipt_rows,
        "functions": functions,
        "unresolved": unresolved_rows,
        "counts": counts,
    }


# ----------------------------------------------------------------------- render

def _dumps(value) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def render(doc: dict) -> str:
    parts = []
    for key in TOP_ORDER:
        if key not in doc:
            continue
        value = doc[key]
        if isinstance(value, list):
            if value:
                body = ",\n".join("  " + _dumps(v) for v in value)
                parts.append(f'"{key}": [\n{body}\n]')
            else:
                parts.append(f'"{key}": []')
        else:
            parts.append(f'"{key}": {_dumps(value)}')
    return "{\n" + ",\n".join(parts) + "\n}\n"


# --------------------------------------------------------------------- validator

HEX_ADDR = re.compile(r"0x[0-9a-f]{1,8}")


def validate_document(doc: dict) -> None:
    def fail(msg):
        raise ValidationError(msg)

    def keys(obj, expected, name):
        if not isinstance(obj, dict) or set(obj) != set(expected.split()):
            fail(f"{name}: unexpected or missing keys")

    def is_sha(v):
        return isinstance(v, str) and SHA_RE.fullmatch(v) is not None

    def is_hex(v):
        return isinstance(v, str) and HEX_ADDR.fullmatch(v) is not None

    def is_rel(v):
        return (isinstance(v, str) and v and not v.startswith("/") and "\\" not in v
                and ".." not in v.split("/") and "/Users/" not in v)

    def no_absolute(obj):
        if isinstance(obj, str):
            if obj.startswith("/") or "/Users/" in obj:
                fail(f"absolute path in output: {obj[:40]}")
        elif isinstance(obj, dict):
            for k, v in obj.items():
                no_absolute(k)
                no_absolute(v)
        elif isinstance(obj, list):
            for v in obj:
                no_absolute(v)

    keys(doc, " ".join(TOP_ORDER), "document")
    if doc["schema"] != SCHEMA:
        fail("wrong schema")
    if not is_sha(doc["original_sha256"]):
        fail("original_sha256")
    tr = doc["text_range"]
    if not (isinstance(tr, list) and len(tr) == 2 and all(is_hex(x) for x in tr)):
        fail("text_range")
    lo, hi = int(tr[0], 16), int(tr[1], 16)
    keys(doc["function_index"], "path sha256 functions", "function_index")
    if not is_rel(doc["function_index"]["path"]) or not is_sha(doc["function_index"]["sha256"]):
        fail("function_index")
    for s in doc["sources"]:
        keys(s, "path sha256 role", "source")
        if not is_rel(s["path"]) or not is_sha(s["sha256"]) or s["role"] not in SOURCE_ROLES:
            fail("source row")
    review_keys = "state reviewer_recorded"
    for r in doc["receipts"]:
        keys(r, "slice kind path sha256 review windows unverified divergence_items hook_addresses files", "receipt")
        keys(r["review"], review_keys, "review")
        keys(r["windows"], "declared hashed verified", "receipt windows")
        keys(r["unverified"], "items located", "receipt unverified")
        if (not is_rel(r["path"]) or not is_sha(r["sha256"]) or r["review"]["state"] not in REVIEW_STATES
                or r["kind"] not in {"handoff", "validation"} or not all(is_rel(f) for f in r["files"])):
            fail("receipt row")
    prev = -1
    for f in doc["functions"]:
        keys(f, "va evidence blockers divergences", "function")
        if not is_hex(f["va"]):
            fail("function va")
        v = int(f["va"], 16)
        if not (lo <= v < hi):
            fail("function outside text range")
        if v <= prev:
            fail("functions not strictly sorted")
        prev = v
        ev_prev = None
        for p in f["evidence"]:
            kind = p.get("kind")
            if kind == "native_source":
                keys(p, "kind path symbol sha256", "native_source")
                if not is_rel(p["path"]) or not is_sha(p["sha256"]) or not (p["symbol"] is None or isinstance(p["symbol"], str)):
                    fail("native_source")
            elif kind == "test":
                keys(p, "kind path test_id sha256", "test")
                if not is_rel(p["path"]) or not is_sha(p["sha256"]) or not (p["test_id"] is None or isinstance(p["test_id"], str)):
                    fail("test")
            elif kind == "oracle":
                keys(p, "kind path sha256 window window_sha256 reading verified use use_basis tail_gap declared_in", "oracle")
                if (p["path"] is None) != (p["sha256"] is None) or (p["path"] is not None and not (is_rel(p["path"]) and is_sha(p["sha256"]))):
                    fail("oracle path/sha256")
                w = p["window"]
                if not (isinstance(w, list) and len(w) == 2 and all(is_hex(x) for x in w) and int(w[0], 16) < int(w[1], 16)):
                    fail("oracle window")
                if not (p["window_sha256"] is None or is_sha(p["window_sha256"])):
                    fail("oracle window_sha256")
                if p["verified"] == "recorded_hash" and not is_sha(p["window_sha256"]):
                    fail("verified window without hash")
                if (p["reading"] not in READINGS or p["verified"] not in VERIFIED or p["use"] not in USES
                        or p["use_basis"] not in USE_BASES or not isinstance(p["tail_gap"], int) or p["tail_gap"] < 0
                        or not (isinstance(p["declared_in"], list) and p["declared_in"] == sorted(p["declared_in"])
                                and all(is_rel(x) for x in p["declared_in"]))):
                    fail("oracle fields")
                if p["use"] != "mapped" and p["verified"] != "recorded_hash":
                    fail("unhashed window with entry/callee use")
            elif kind == "receipt":
                keys(p, "kind slice path sha256 review via hook unlocated_unverified", "receipt pointer")
                keys(p["review"], review_keys, "pointer review")
                if (not is_rel(p["path"]) or not is_sha(p["sha256"]) or p["hook"] not in HOOK_KINDS | {None}
                        or not (isinstance(p["via"], list) and p["via"] and set(p["via"]) <= RECEIPT_VIAS)
                        or p["review"]["state"] not in REVIEW_STATES):
                    fail("receipt pointer")
            elif kind == "mention":
                keys(p, "kind path sha256 symbol addresses via", "mention")
                if (not is_rel(p["path"]) or not is_sha(p["sha256"]) or p["via"] not in MENTION_VIAS
                        or not (isinstance(p["addresses"], list) and p["addresses"] and all(is_hex(a) for a in p["addresses"]))):
                    fail("mention")
            else:
                fail("unknown pointer kind")
            key = (KIND_ORDER[kind], json.dumps(p, sort_keys=True))
            if ev_prev is not None and key < ev_prev:
                fail("evidence not sorted")
            ev_prev = key
        for lst in (f["blockers"], f["divergences"]):
            for b in lst:
                keys(b, "slice path field index text_sha256 address interior", "blocker")
                if not (is_rel(b["path"]) and is_sha(b["text_sha256"]) and is_hex(b["address"])
                        and isinstance(b["interior"], bool) and isinstance(b["index"], int)):
                    fail("blocker item")
    prev = -1
    for u in doc["unresolved"]:
        keys(u, "address reason references sources kinds", "unresolved")
        if not is_hex(u["address"]) or int(u["address"], 16) <= prev:
            fail("unresolved address")
        prev = int(u["address"], 16)
        if not (set(u["kinds"]) <= UNRESOLVED_KINDS and all(is_rel(s) for s in u["sources"])):
            fail("unresolved row")
    if not isinstance(doc["counts"], dict):
        fail("counts")
    no_absolute(doc)


# ------------------------------------------------------------------------- check

def _diff_summary(a: str, b: str, limit: int = 5) -> list:
    al, bl = a.splitlines(), b.splitlines()
    sa, sb = set(al), set(bl)
    out = []
    for line in al:
        if line not in sb and len(out) < limit:
            out.append("committed only: " + line[:140])
    for line in bl:
        if line not in sa and len(out) < 2 * limit:
            out.append("derived only:   " + line[:140])
    return out


def check(cfg: Config, notes: Optional[list] = None) -> list:
    """Re-derive and compare; returns a list of problems (empty when current)."""
    notes = notes if notes is not None else []
    rel = cfg.rel(cfg.output) if str(cfg.output).startswith(str(cfg.repo)) else cfg.output.name
    if not cfg.output.is_file():
        return [f"{rel} is missing; run extract_function_evidence.py --write"]
    text = cfg.output.read_text(encoding="utf-8")
    try:
        committed = json.loads(text)
        validate_document(committed)
    except (ValueError, ValidationError) as exc:
        return [f"{rel} is not a valid evidence file: {exc}"]
    problems = []
    pins = {r["path"]: r["sha256"] for r in committed["receipts"]}
    present = {}
    for p in _receipt_files(cfg):
        present[cfg.work_rel(p)] = sha256_bytes(p.read_bytes())
    missing = sorted(set(pins) - set(present))
    for path in sorted(set(pins) & set(present)):
        if pins[path] != present[path]:
            problems.append(f"receipt changed since the evidence was written: {path}")
    for path in sorted(set(present) - set(pins)):
        problems.append(f"receipt not pinned in the evidence file: {path}")
    if missing:
        notes.append(f"{len(missing)} pinned receipts not present (of {len(pins)}); their hashes are recorded "
                     "and were not re-checked, and receipt-derived pointers were not re-derived")
    try:
        derived = derive(cfg, receipts=not missing)
    except EvidenceError as exc:
        return problems + [f"re-derivation failed: {line}" for line in str(exc).splitlines()]
    if not missing:
        fresh = render(derived)
        if fresh != text:
            problems.append(f"{rel} is stale; rerun extract_function_evidence.py --write")
            problems.extend(_diff_summary(text, fresh))
        return problems

    def public_view(doc):
        view = {k: doc[k] for k in ("original_sha256", "text_range", "function_index", "sources")}
        per = {}
        for f in doc["functions"]:
            for p in f["evidence"]:
                private = p["kind"] == "receipt" or str(p.get("path") or "").startswith("analysis/")
                if p["kind"] in ("native_source", "test", "mention") and not private:
                    per.setdefault(f["va"], []).append(json.dumps(p, sort_keys=True))
        view["pointers"] = {k: sorted(v) for k, v in sorted(per.items())}
        return view

    if public_view(committed) != public_view(derived):
        problems.append(f"{rel} is stale for sources, native/test/mention pointers or the function index; "
                        "rerun extract_function_evidence.py --write")
    pe = PE.from_bytes(_original_path(cfg).read_bytes())
    for f in committed["functions"]:
        for p in f["evidence"]:
            if p["kind"] == "oracle" and p["window_sha256"] is not None:
                s, e = int(p["window"][0], 16), int(p["window"][1], 16)
                data = pe.read_va(s, e - s)
                if data is None or sha256_bytes(data) != p["window_sha256"]:
                    problems.append(f"committed window {p['window']} no longer hashes to its recorded value")
    return problems


# --------------------------------------------------------------------------- CLI

def summary_line(doc: dict) -> str:
    c = doc["counts"]
    return (f"functions_with_evidence={c['functions_with_evidence']} windows_verified={c['windows']['verified']} "
            f"mismatch={c['windows']['mismatch']} mentions={c['pointers']['mention']} "
            f"unresolved={c['unresolved']['addresses']}")


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--repo", default=str(Path(__file__).resolve().parents[3]),
                    help="repository root (contains outputs/ and work/)")
    ap.add_argument("--write", action="store_true", help="write function-evidence.json")
    ap.add_argument("--check", action="store_true", help="re-derive and diff against the committed file")
    ap.add_argument("--work", help="private work tree holding analysis/slices and game-source.json "
                                   "(default <repo>/work; a git worktree has none, point this at the main checkout's)")
    ap.add_argument("--output", help="evidence file (default outputs/blackmoor-decomp/function-evidence.json)")
    ap.add_argument("--exe", help="override the original executable path (read-only)")
    ap.add_argument("--text-end", help="end of .text (default 0x52925a); for fixtures")
    ap.add_argument("--no-exe-pin", action="store_true", help="do not require the pinned GAME.EXE hash; for fixtures")
    args = ap.parse_args(argv)
    kw = {}
    if args.output:
        kw["output"] = Path(args.output)
    if args.work:
        kw["work_dir"] = Path(args.work)
    if args.exe:
        kw["exe"] = Path(args.exe)
    if args.text_end:
        kw["text_end"] = int(args.text_end, 16)
    if args.no_exe_pin:
        kw["exe_sha256"] = None
    cfg = Config.for_repo(args.repo, **kw)
    try:
        if args.check:
            notes: list = []
            problems = check(cfg, notes)
            for n in notes:
                print("note: " + n)
            if problems:
                print("check failed:", file=sys.stderr)
                for p in problems:
                    print("  " + p, file=sys.stderr)
                return 1
            committed = json.loads(cfg.output.read_text(encoding="utf-8"))
            print("check ok: " + summary_line(committed))
            return 0
        doc = derive(cfg)
        validate_document(doc)
        if args.write:
            cfg.output.write_text(render(doc), encoding="utf-8")
        print(summary_line(doc))
        return 0
    except EvidenceError as exc:
        print("error: " + str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
