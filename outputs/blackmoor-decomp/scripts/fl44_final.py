#!/usr/bin/env python3
"""FL-44: the final verdict on every translated row from the logs of the guarded exhaustive check, under the survivor rules as committed.

  fl44_final.py [--write]      (run from outputs/blackmoor-decomp)

A row is clean when every survivor of its exhaustive run (tasks/fl44-recheck-credited-log*.txt, tasks/fl44-recheck-big5-log.txt, tasks/fl44-new-rows-mutation-log.txt) is
  - identical -O2 code (tasks/fl44-recheck-equivalence*.json, tasks/fl44-new-equivalence.json), or
  - explained by a rule of scripts/fl40_survivors.py (same value, frame, cleanup, rep count, masked read, range, flow repeat/dead), or
  - killed by a rescue seed (tasks/fl44-recheck-rescue-40000*.txt, tasks/fl44-new-rescue-40000.txt, tasks/fl44-rescue-base40000.txt: a mutant listed there and not 'survives').
Rows of the corpus without a log (none expected) stay held. With --write the held file is rewritten: the rows that are not clean, with their unexplained survivors.
"""
import json
from pathlib import Path
import re
import sys

PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'scripts'))
sys.path.insert(0, str(PROJECT / 'tests'))
import fl40_mutation_check as M
import fl40_survivors as S

TASKS = PROJECT / 'tasks'
LOGS = ['fl44-recheck-credited-log-part1.txt', 'fl44-recheck-credited-log-part2.txt', 'fl44-recheck-credited-log-part3.txt', 'fl44-recheck-credited-log-part4.txt', 'fl44-recheck-big5-log.txt', 'fl44-new-rows-mutation-log.txt', 'fl46-unchecked-log.txt', 'fl46-budget3-log.txt', 'fl49-recheck-log.txt', 'fl49-recheck2-log.txt']
EQUIV = ['fl44-recheck-equivalence.json', 'fl44-recheck-equivalence-big.json', 'fl44-recheck-equivalence-big5.json', 'fl44-recheck-equivalence-part4.json', 'fl44-new-equivalence.json', 'fl46-equivalence.json']
RESCUE = ['fl44-rescue-base40000.txt', 'fl44-new-rescue-40000.txt', 'fl44-recheck-rescue-40000-part1.txt', 'fl44-recheck-rescue-40000-part2.txt', 'fl44-recheck-rescue-40000-part4.txt', 'fl44-recheck-rescue-40000-part5.txt', 'fl46-rescue-40000.txt', 'fl46-rescue-454065.txt']
REQUESTS = ['fl44-requests-held-fl42.json', 'fl44-new-survivors.json', 'fl44-recheck-survivors.json', 'fl44-part4-survivors.json', 'fl44-part5-survivors.json', 'fl46-survivors.json', 'fl46-rescue-454065-request.json']      # what the rescue runs were asked to retry
STRICT = '--strict' in sys.argv       # FL-46: a mutant killed only by the step budget is a survivor (Glib's first reading); by default it is killed (Glib's ruling of 2026-10-23)
BUDGET_KILL = 'killed by step budget'
LINE = re.compile(r'(0x[0-9a-f]+) mutants \d+ killed \d+ survivors (.*)')


def parse(path):
    out = {}
    for line in (TASKS / path).read_text().splitlines():
        m = LINE.match(line)
        if m:
            out[m.group(1)] = eval(m.group(2)[:m.group(2).rindex(']') + 1])
    return out


def main():
    funcs = M.split_functions((PROJECT / 'src/original_methods_fl40.c').read_text())
    corpus = json.loads((PROJECT / 'tests/fl40_corpus.json').read_text())
    equiv = {}
    for name in EQUIV:
        for row, items in json.loads((TASKS / name).read_text())['rows'].items():
            equiv.setdefault(row, {}).update({(i['kind'], i['line']): i['equivalent'] for i in items})
    logs = {}
    for name in LOGS:
        logs.update(parse(name))
    rescued = {}
    for name in RESCUE:
        hung = {}
        for line in (TASKS / name).read_text().splitlines():
            m = re.match(r'(0x[0-9a-f]+) mutants .* hang-kills (\d+)', line)
            if m and int(m.group(2)) and not name.startswith('fl46-'):
                hung[m.group(1)] = True         # a rescue kill by a wall-clock hang (before the step budget): never counts, the row is retried under the budget (fl46-*)
        for row, items in parse(name).items():
            if row not in hung:
                rescued[row] = items            # the later file wins: it is the later retry of what survived
    asked = {}
    for name in REQUESTS:
        doc = json.loads((TASKS / name).read_text())
        if 'rows' in doc:       # a held file: row -> [{kind, line}]
            for row, items in doc['rows'].items():
                asked.setdefault(row, set()).update((i['kind'], i['line']) for i in items)
        else:
            for row, items in doc['rows_with_survivors'].items():
                asked.setdefault(row, set()).update((kind, n) for kind, cls, _, n in items if cls is None)
    reasons = {}        # FL-46: row-specific written reasons, tied to the exact statement they were written for
    for reasons_path in sorted(TASKS.glob('fl4*-written-reasons.json')):          # FL-46, FL-49
        for row, items in json.loads(reasons_path.read_text())['rows'].items():
            for i in items:
                if len(i['reason']) >= 80:
                    reasons[(row, i['kind'], i['line'])] = i['statement']
    clean, held = [], {}
    for row in sorted(corpus, key=lambda k: int(k, 16)):
        if row not in logs:
            held[row] = [{'kind': 'unchecked', 'line': 0, 'statement': 'no exhaustive log under the guarded harness'}]
            continue
        text = funcs[row].split('\n')
        left = []
        retried = {}
        for k, n, why in rescued.get(row, []):          # FL-46: a line with several mutants stays open while any one of them survives
            if retried.get((k, n)) != 'survives':
                retried[(k, n)] = 'survives' if STRICT and why == BUDGET_KILL else why
        for kind, n, why in logs[row]:
            if why != 'survives' and not (STRICT and why == BUDGET_KILL):
                continue
            if S.classify(kind, text, n, equiv.get(row, {}).get((kind, n), False), row):
                continue
            if (kind, n) in asked.get(row, ()) and (kind, n) not in retried and row in rescued:
                continue            # asked, retried by the rescue run and not listed again: killed (by the corpus seeds or a rescue seed)
            if retried.get((kind, n)) not in (None, 'survives'):
                continue            # listed as killed by a rescue seed
            if reasons.get((row, kind, n)) == text[n].strip()[:300]:
                continue            # a written reason for exactly this statement (tasks/fl46-written-reasons.json)
            left.append({'kind': kind, 'line': n, 'statement': text[n].strip()[:300]})
        if left:
            held[row] = left
        else:
            clean.append(row)
    print('rows %d: clean %d, held %d' % (len(corpus), len(clean), len(held)))
    if '--write' in sys.argv:
        path = TASKS / 'fl40-held-rows.json'
        doc = json.loads(path.read_text())
        doc['rows'] = held
        path.write_text(json.dumps(doc, indent=1) + '\n')
    return clean, held


if __name__ == '__main__':
    main()
