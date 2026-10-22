#!/usr/bin/env python3
"""FL-41: take the FL-39 batch d rows that the operator-level recheck sent back to pending out of the port acceptances.

  fl41_prune_recheck.py            (from outputs/blackmoor-decomp)

Reads `totals.credited_rows_sent_back_to_pending` of tasks/fl41-fl39d-recheck.json and removes those rows from `port_acceptances` of function-ledger-overrides.json and from
tasks/fl39d-acceptances.json. Their ports and tests stay in src/original_methods_fl39d.c and tests/ (green against the oracle); only the credit goes. Safe to rerun
(after merging main, for example): rows that are already out are left alone. Regenerate the evidence and the ledger afterwards.
"""
import json
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]


def main():
    recheck = json.loads((PROJECT / 'tasks/fl41-fl39d-recheck.json').read_text())
    drop = {'0x' + va for va in recheck['totals']['credited_rows_sent_back_to_pending']}
    overrides_path = PROJECT / 'function-ledger-overrides.json'
    overrides = json.loads(overrides_path.read_text())
    before = len(overrides['port_acceptances'])
    overrides['port_acceptances'] = [e for e in overrides['port_acceptances'] if e['va'] not in drop]
    overrides_path.write_text(json.dumps(overrides, indent=1, ensure_ascii=False) + '\n')
    accept_path = PROJECT / 'tasks/fl39d-acceptances.json'
    accepted = json.loads(accept_path.read_text())
    accepted = [e for e in accepted if e['va'] not in drop]
    accept_path.write_text(json.dumps(accepted, indent=1, ensure_ascii=False) + '\n')
    print('port acceptances %d -> %d; fl39d acceptances %d' % (before, len(overrides['port_acceptances']), len(accepted)))


if __name__ == '__main__':
    main()
