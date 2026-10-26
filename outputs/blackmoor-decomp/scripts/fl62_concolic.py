#!/usr/bin/env python3
"""FL-62: the FL-61 concolic coverage generator (scripts/fl61_concolic.py) on the translated upper rows (tests/fl41_world.py, src/original_methods_fl41.c).

The search itself is FL-61's. This wrapper swaps the world (tests/fl41_world.py: callee stubs, import slots, __EH_prolog and the other FL-41/FL-58 conventions), the lifter (scripts/lift_fl41.py) and the
coverage rule (fl41_generate.covers), and takes its start seeds from tests/fl41_translated.json and tests/fl41_pending.json. The output file has the corpus format ([[seed, [[address, size, value], ...]], ...]
per row) that `scripts/fl62_add_rows.py ROW --scen FILE` takes.

  fl62_concolic.py ROW [ROW ...] | --all [--shard i/n] [--budget-s N] [--skip-reports FILE,FILE] --out FILE --report FILE        (run from outputs/blackmoor-decomp)

Rows whose lift needs an inline helper (__EH_prolog, __chkstk) or has calls through registers are searched too when the shadow can follow them; the report says which ones were skipped and why.
"""
import json
import os
from pathlib import Path
import sys
import tempfile

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl61_concolic as C
import fl41_world as W41
import lift_fl41 as L41
import fl41_generate as G41

C.W, C.L, C.G = W41, L41, G41
SITES = os.environ.get('FL67_SITES', '1') != '0'      # FL-67: rows whose indirect calls the world plays as stub calls (`sites`) are searched too


def helper_chunk(spans):
    import re
    eh = L41.lift(0x50f978, spans[0x50f978])[0]
    eh = re.sub(r'^/\* GAME\.EXE 0x50f978 \(', '/* __EH_prolog 0x50f978 (second shared helper; not a row) (', eh)
    return L41.lift(0x50c920, spans[0x50c920])[0] + '\n' + eh


class Row41(C.Row):
    def __init__(self, key):
        self.key = key
        self.va = int(key, 16)
        spans = L41.ledger_spans()
        self.committed = None
        try:
            text, callees, imports, fs, inline = L41.lift(self.va, spans[self.va])
            table = json.loads((PROJECT / 'tests/fl41_translated.json').read_text()).get(key, {})
        except L41.Unsupported:                  # FL-67: a row the bulk lifter refuses (indirect calls) but that a committed translation and its table cover
            import fl66_tested as T66
            pool = T66.pool_of(key)
            table = T66.pool_table(pool)[key]
            callees = {int(a, 16): n for a, n in table['callees'].items()}
            imports = {int(a, 16): n for a, n in table.get('imports', {}).items()}
            fs, inline = table.get('fs', False), False
            text = T66.row_text(T66.POOLS[pool]['source'], key)
            self.committed = pool
        self.inline = inline
        self.text = text
        self.sites = {int(a, 16): n for a, n in table['sites'].items()} if table.get('sites') else None
        self.frame = table.get('frame')
        self.info = W41.row_info(self.va, spans[self.va], callees, imports, fs, self.sites, self.frame)
        self.md = C.capstone.Cs(C.capstone.CS_ARCH_X86, C.capstone.CS_MODE_32)
        self.md.detail = True
        pe = W41.od.load_image()
        off = self.va - pe.image_base
        self.insns = {i.address: i for i in self.md.disasm(pe.image[off:off + self.info['body']], self.va)}
        self.lib = None
        self.indirect = [hex(i.address) for i in self.insns.values() if i.mnemonic == 'call' and i.operands[0].type != C.CX.X86_OP_IMM
                         and not (i.operands[0].type == C.CX.X86_OP_MEM and not i.operands[0].mem.base and not i.operands[0].mem.index and (i.operands[0].mem.disp & 0xffffffff) in self.info['imports'])
                         and not (SITES and str(i.address) in {str(k) for k in (self.info.get('sites') or {})})]
        if (self.sites or self.frame) and not SITES:
            self.indirect = self.indirect or ['sites/frame']

    def native_lib(self):
        if self.lib is None and self.committed:
            import fl66_tested as T66
            self.lib = T66.library(self.committed)
        if self.lib is None:
            spans = L41.ledger_spans()
            tmp = tempfile.mkdtemp()
            src = Path(tmp) / 'row.c'
            helper = helper_chunk(spans) if self.inline else ''
            src.write_text('#include "original_methods_fl41.h"\n' + helper + '\n' + self.text)
            self.lib = W41.build_library(tmp, [src])
        return self.lib


def starting_seeds(key):
    table = json.loads((PROJECT / 'tests/fl41_translated.json').read_text()).get(key, {}).get('seeds', [])
    pending = json.loads((PROJECT / 'tests/fl41_pending.json').read_text()).get(key, {}).get('seeds', [])
    corpus = json.loads((PROJECT / 'tests/fl41_corpus.json').read_text()).get(key, {}).get('seeds', [])
    out = []
    for s in list(table) + list(pending) + list(corpus):
        t = (s, []) if isinstance(s, int) else (s[0], [list(o) for o in s[1]])
        if t not in out:
            out.append(t)
    return out


def upper_rows():
    """The rows that FL-60 refused for incomplete coverage (tasks/fl60-added.json) and that are still translated, unverified, smallest first (--all)."""
    refused = json.loads((PROJECT / 'tasks/fl60-added.json').read_text())['refused']
    table = json.loads((PROJECT / 'tests/fl41_translated.json').read_text())
    return sorted((k for k in refused if k in table), key=lambda k: (table[k]['body'], k))


C.Row = Row41
C.starting_seeds = starting_seeds
C.lower_rows = upper_rows

if __name__ == '__main__':
    C.main()
