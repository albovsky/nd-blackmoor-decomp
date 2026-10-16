#!/usr/bin/env python3
"""List which pending ``candidate_port`` functions pass the mechanical checks of a port acceptance.

Read-only: it reads the committed ``function-ledger.json`` and the sources it cites, runs the cheap
checks that ``decomp-progress/function_ledger.py`` re-runs for a ``port_acceptances`` entry (the VA in
the native symbol, a named test that mentions the symbol or module, a hash-verified entry/callee oracle
window over the whole body, blockers, derived parts) and prints one verdict per function.  It decides
nothing: ``ready`` means a reviewer may read the code against the original and record an acceptance;
the generator still re-checks every acceptance and fails closed.

    audit_port_candidates.py                 # summary plus one line per function
    audit_port_candidates.py --json PATH     # also write every detail (scratch, not committed)
    audit_port_candidates.py --va 0x4f52a9   # only these functions (repeatable)
    audit_port_candidates.py --va 0x4f6059 --symbol sound_control_play   # judge one symbol only

Verdicts: ``ready`` (all mechanical checks pass), ``ready_after_blocker_review`` (the only open item is
located unverified receipt items: they need ``blockers_reviewed`` in the acceptance), ``no_symbol`` (no
native symbol whose body or leading comment holds the VA), ``no_test`` (no named test mentions the symbol
or module), ``parts`` (derived parts need a reviewer).
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import re
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parents[1]  # outputs/blackmoor-decomp
SPEC = importlib.util.spec_from_file_location("blackmoor_function_ledger", OUT / "decomp-progress" / "function_ledger.py")
FL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FL)


def text_of(root, rel):
    return FL.read_text_input(root, rel, "audit")


SYMBOLS = set()     # --symbol: only these native symbols are considered


def symbol_hits(root, entry):
    """(path, symbol) pairs of native_source pointers whose body or leading comment holds the VA."""
    va, hits, notes = int(entry["va"], 16), [], []
    for path, symbol in sorted({(p["path"], p["symbol"]) for p in entry["evidence"]
                                if p["kind"] == "native_source" and p["symbol"]}):
        if SYMBOLS and symbol not in SYMBOLS:
            continue
        try:
            area = FL.symbol_area(text_of(root, path), symbol, path)
        except FL.LedgerError as exc:
            notes.append(str(exc))
            continue
        if va in FL.addresses_in(area):
            hits.append((path, symbol))
        else:
            notes.append(f"{symbol} in {path} does not hold {entry['va']}")
    return hits, notes


def named_tests(root, entry, path, symbol):
    """Test pointers with a test_id whose test body mentions the symbol or the module."""
    module, found = Path(path).stem, []
    for p in entry["evidence"]:
        if p["kind"] != "test" or not p["test_id"]:
            continue
        try:
            body = FL.test_area(text_of(root, p["path"]), p["test_id"], p["path"])
        except FL.LedgerError:
            continue
        if re.search(r"\b" + re.escape(symbol) + r"\b", body) or re.search(r"\b" + re.escape(module) + r"\b", body):
            found.append({"path": p["path"], "test_id": p["test_id"]})
    return found


def assess(root, entry):
    va, body = int(entry["va"], 16), entry["body_size"]
    hits, notes = symbol_hits(root, entry)
    out = {"va": entry["va"], "name": entry["name"], "body_size": body, "verdict": None, "notes": notes,
           "blockers": [b["id"] for b in entry["blockers"] if not FL.cleared(b, entry["divergences"])],
           "derived_parts": entry["derived_parts"], "native_source": None, "tests": [], "oracle": None, "class": None}
    if not hits:
        out["verdict"] = "no_symbol"
        return out
    for path, symbol in hits:
        tests = named_tests(root, entry, path, symbol)
        if tests:
            out["native_source"], out["tests"] = {"path": path, "symbol": symbol}, tests
            break
    else:
        out["native_source"] = {"path": hits[0][0], "symbol": hits[0][1]}
        out["verdict"] = "no_test"
        return out
    oracle = [p for p in entry["evidence"] if FL.qualifies(p) and FL.covers(p, va, body) and p["path"]]
    if oracle:
        p = sorted(oracle, key=lambda q: (q["use"], q["path"], q["window"]))[0]
        out["oracle"] = {"path": p["path"], "window": p["window"], "use": p["use"]}
    out["class"] = "native_oracle_verified" if oracle else "native_tests_only"
    if entry["derived_parts"]:
        out["verdict"] = "parts"
    else:
        out["verdict"] = "ready_after_blocker_review" if out["blockers"] else "ready"
    return out


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--root", type=Path, default=OUT, help="input tree (default: outputs/blackmoor-decomp)")
    ap.add_argument("--json", type=Path, default=None, help="write the full detail here")
    ap.add_argument("--va", action="append", default=[], help="only this function (0x...); repeatable")
    ap.add_argument("--symbol", action="append", default=[],
                    help="only consider this native symbol (repeatable); the default takes the first that fits")
    args = ap.parse_args(argv)
    SYMBOLS.update(args.symbol)
    root = args.root.resolve()
    ledger = json.loads((root / "function-ledger.json").read_text(encoding="utf-8"))
    wanted = {FL.fmt(int(v, 16)) for v in args.va}
    rows = []
    for entry in ledger["entries"]:
        if entry["status"] != "pending" or entry["class"] != "candidate_port":
            continue
        if wanted and entry["va"] not in wanted:
            continue
        rows.append(assess(root, entry))
    counts = {}
    for r in rows:
        counts[r["verdict"]] = counts.get(r["verdict"], 0) + 1
    print("candidate_port functions: %d  %s" % (len(rows), ", ".join(f"{k} {v}" for k, v in sorted(counts.items()))))
    for r in rows:
        src = r["native_source"]["symbol"] if r["native_source"] else "-"
        print(f"{r['va']:>9} {r['verdict']:<27} {src:<32} tests {len(r['tests']):>2} blockers {len(r['blockers']):>2} "
              f"{r['class'] or '-'}")
    if args.json:
        args.json.write_text(json.dumps(rows, indent=1) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
