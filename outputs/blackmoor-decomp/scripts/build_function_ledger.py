#!/usr/bin/env python3
"""Write or check outputs/blackmoor-decomp/function-ledger.json.

    build_function_ledger.py --write   derive the ledger from the pinned inputs and write it
    build_function_ledger.py --check   validate the committed ledger and prove it equals a fresh derivation

--check verifies the pinned hashes of the committed extractor outputs and re-derives the ledger from
them; it does not re-run the extractors, and pins on private inputs (GAME.EXE, the Ghidra dump,
private receipts) are reported as notes, never as a pass.

Derivation and validation live in decomp-progress/function_ledger.py (standard
library only). A failed derivation writes nothing, so the previous ledger stays
intact. This is the function ledger, not the whole-file range ledger that
decomp-progress/generate.py --ledger reads.
"""

from __future__ import annotations

import argparse
import importlib.util
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parents[1]  # outputs/blackmoor-decomp
SPEC = importlib.util.spec_from_file_location("blackmoor_function_ledger", OUT / "decomp-progress" / "function_ledger.py")
FL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FL)


def parse(argv):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true", help="derive and write the ledger")
    mode.add_argument("--check", action="store_true", help="validate the committed ledger and prove it is current")
    ap.add_argument("--root", type=Path, default=OUT, help="input tree (default: outputs/blackmoor-decomp)")
    ap.add_argument("--out", type=Path, default=None, help="ledger path (default: <root>/function-ledger.json)")
    ap.add_argument("--expected-functions", type=int, default=FL.EXPECTED_FUNCTIONS,
                    help="pinned function count (default: %(default)s)")
    ap.add_argument("--verify-private", action="store_true",
                    help="also re-hash private receipts under the work directory")
    ap.add_argument("--work-dir", type=Path, default=OUT.parent.parent / "work",
                    help="private work directory for --verify-private")
    return ap.parse_args(argv)


def main(argv=None):
    args = parse(argv)
    root = args.root.resolve()
    path = (args.out or root / "function-ledger.json").resolve()
    notes = []
    kwargs = {"expected_functions": args.expected_functions, "work_dir": args.work_dir,
              "verify_private": args.verify_private, "notes": notes}
    try:
        if args.write:
            ledger = FL.derive(root, **kwargs)
            text = FL.render(ledger)
            path.write_text(text, encoding="utf-8")
            action = "wrote"
        else:
            ledger = FL.check(root, path, **kwargs)
            action = "checked"
    except FL.LedgerError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    c = ledger["counts"]
    print(f"{action} {path.name}: {c['total']} functions "
          f"(ported {c['status']['ported']}, not_needed {c['status']['not_needed']}, pending {c['status']['pending']})")
    for note in notes:                  # facts this run could not re-check; never a pass
        print(f"note: {note}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
