#!/usr/bin/env python3
"""Deterministic reviewer sampling for the function ledger (packet FL-3).

Selects N entries (default 59, the size that gives a zero-defect sample 95%
confidence of a defect rate below 5%) from a stated universe, so that a
reviewer and a later re-run draw exactly the same functions.

* Universe: all entries of ``function-xrefs.json`` narrowed by ``--origin``,
  ``--region``, ``--reach`` and/or ``--rule`` (the rule's predicate from
  ``extract_function_xrefs.RULE_PREDICATES`` plus the ``semantics_sensitive``
  spec and the rule parameters in the overrides file); with ``--ledger``
  also ``--status`` and ``--class`` from the generated ledger.
* Seed: SHA-256 over the SHA-256 of every input file read (xrefs, overrides,
  ledger when given), the canonical selection description and N.  Changing any
  input byte or the selection changes the seed.
* Selection: each VA gets the key SHA-256(seed + ":" + VA); the N smallest keys
  are taken, so the sample depends on the VA, never on list order; output is
  sorted by VA.  If N covers the universe the sample is exhaustive.
* Output (JSON, sorted keys): seed, universe_size, sample, ``sample_sha256``
  (SHA-256 of the VAs joined by newlines; this is the value a rule review
  records as ``review.sample_sha256``) and per-VA facts from the xrefs file.
  Only addresses, hashes and enums are printed.

Usage:  sample_function_ledger.py --rule R-EH --n 59
        sample_function_ledger.py --origin library --region crt_mfc --n 20
        sample_function_ledger.py --ledger function-ledger.json --status pending --class none
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from pathlib import Path
from typing import Any, Optional

SCRIPTS = Path(__file__).resolve().parent
PROJECT = SCRIPTS.parent
SCHEMA = "blackmoor-function-ledger-sample/1"
DEFAULT_N = 59


def _load_xrefs_module():
    existing = sys.modules.get("extract_function_xrefs")
    if existing is not None and hasattr(existing, "rule_candidates"):
        return existing
    spec = importlib.util.spec_from_file_location("extract_function_xrefs", SCRIPTS / "extract_function_xrefs.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules["extract_function_xrefs"] = module
    spec.loader.exec_module(module)
    return module


def select(vas: list[str], seed: str, n: int) -> list[str]:
    """The N VAs with the smallest SHA-256(seed:VA), sorted by VA.  Order of ``vas`` is irrelevant."""

    unique = sorted(set(vas))
    if n >= len(unique):
        return unique
    keyed = sorted(unique, key=lambda va: hashlib.sha256(f"{seed}:{va}".encode()).hexdigest())
    return sorted(keyed[:n])


def dump(result: dict[str, Any]) -> str:
    return json.dumps(result, indent=1, sort_keys=True) + "\n"


def run(argv: Optional[list[str]] = None) -> dict[str, Any]:
    xr = _load_xrefs_module()
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--xrefs", type=Path, default=PROJECT / "function-xrefs.json")
    ap.add_argument("--overrides", type=Path, default=PROJECT / "function-ledger-overrides.json")
    ap.add_argument("--ledger", type=Path, default=None)
    ap.add_argument("--n", type=int, default=DEFAULT_N)
    ap.add_argument("--rule", default=None, help="not_needed_rules id (candidates from its predicate)")
    ap.add_argument("--origin", choices=xr.ORIGINS)
    ap.add_argument("--region")
    ap.add_argument("--reach", choices=xr.REACH)
    ap.add_argument("--status", help="ledger status (needs --ledger)")
    ap.add_argument("--class", dest="klass", help="ledger class (needs --ledger)")
    args = ap.parse_args(argv)
    if args.n < 0:
        raise SystemExit("--n must be >= 0")
    if (args.status or args.klass) and not args.ledger:
        raise SystemExit("--status/--class need --ledger")

    doc = xr.load_xrefs(args.xrefs)
    overrides = json.loads(args.overrides.read_text(encoding="utf-8"))
    sensitive_specs = overrides.get("semantics_sensitive", [])
    entries = doc["entries"]
    universe = {e["va"] for e in entries}

    selection: dict[str, Any] = {}
    if args.origin:
        selection["origin"] = args.origin
        universe &= {e["va"] for e in entries if e["origin"] == args.origin}
    if args.region:
        selection["region"] = args.region
        universe &= {e["va"] for e in entries if e["region"] == args.region}
    if args.reach:
        selection["reach"] = args.reach
        universe &= {e["va"] for e in entries if e["reach"] == args.reach}
    if args.rule:
        rules = {r["id"]: r for r in overrides.get("not_needed_rules", [])}
        if args.rule not in rules:
            raise SystemExit(f"unknown rule {args.rule!r}; the overrides file defines {sorted(rules)}")
        rule = rules[args.rule]
        if rule.get("predicate") not in xr.RULE_PREDICATES:
            raise SystemExit(f"rule {args.rule} names unknown predicate {rule.get('predicate')!r}")
        params = rule.get("parameters", {})
        candidates = xr.rule_candidates(doc, sensitive_specs, params.get("eh_parent_regions"))
        selection["rule"] = args.rule
        universe &= set(candidates[rule["predicate"]])
    inputs = [
        {"role": "xrefs", "sha256": hashlib.sha256(args.xrefs.read_bytes()).hexdigest()},
        {"role": "overrides", "sha256": hashlib.sha256(args.overrides.read_bytes()).hexdigest()},
    ]
    if args.ledger:
        ledger_bytes = args.ledger.read_bytes()
        inputs.append({"role": "ledger", "sha256": hashlib.sha256(ledger_bytes).hexdigest()})
        ledger = json.loads(ledger_bytes)
        rows = {f"0x{int(r['va'], 16):08x}": r for r in ledger["entries"]}
        if args.status:
            selection["status"] = args.status
            universe &= {va for va, r in rows.items() if r.get("status") == args.status}
        if args.klass:
            selection["class"] = args.klass
            universe &= {va for va, r in rows.items() if r.get("class") == args.klass}
    seed = hashlib.sha256(
        json.dumps({"inputs": inputs, "selection": selection, "n": args.n}, sort_keys=True).encode()
    ).hexdigest()
    sample = select(sorted(universe), seed, args.n)
    by_va = {e["va"]: e for e in entries}
    return {
        "schema": SCHEMA,
        "seed": seed,
        "inputs": inputs,
        "selection": selection,
        "n_requested": args.n,
        "universe_size": len(universe),
        "exhaustive": args.n >= len(universe),
        "sample": sample,
        "sample_sha256": hashlib.sha256("\n".join(sample).encode()).hexdigest(),
        "facts": {
            va: {k: by_va[va][k] for k in ("region", "span", "origin", "reach", "seam", "eh_kind", "eh_parent_region")}
            for va in sample
        },
    }


def main(argv: Optional[list[str]] = None) -> int:
    sys.stdout.write(dump(run(argv)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
