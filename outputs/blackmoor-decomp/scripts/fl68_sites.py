#!/usr/bin/env python3
"""FL-68: the indirect calls and tail jumps (through a register or a pointer) that the FL-58 bulk driver did not register as sites, for the CRT/MFC rows of the tested-equivalent tier.

A call or `jmp` whose target is read from a register or a cell is played as a stub call on both sides (tests/fl41_world.py `site_hook`): the original cannot follow it into an unknown target, and the translation hands it to the
host (`FL41_CALL(t_)`). The bytes the target pops are the ones the translation itself pops after the call (`esp += N; esp += 4` for a call, `esp += N + 4` for a tail jump), so the site table takes them from the committed
translation text. Jump tables (`jmp [reg*4 + table]`) stay inside the function and are not sites.

  fl68_sites.py ROW [ROW ...] [--write]        (run from outputs/blackmoor-decomp; --write merges into tests/fl68_sites.json)
"""
import argparse
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
PROJECT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT / 'tests'))
sys.path.insert(0, str(PROJECT / 'scripts'))
import fl66_tested as F

OVERLAY = PROJECT / 'tests/fl68_sites.json'


def find_sites(key):
    """{site address: bytes the target pops} for the indirect calls and tail jumps of the row that its table does not list."""
    import capstone
    from capstone import x86_const as CX
    pool = F.pool_of(key)
    W, G = F.world(F.POOLS[pool]['world'])
    t = F.pool_table(pool)[key]
    have = {int(a, 16) for a in t.get('sites', {})}
    imports = {int(a, 16) for a in t.get('imports', {})}
    pe = W.od.load_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    md.detail = True
    va = int(key, 16)
    text = F.row_text(F.POOLS[pool]['source'], key)
    out = {}
    for i in md.disasm(pe.image[va - pe.image_base:va - pe.image_base + t['body']], va):
        if i.mnemonic not in ('call', 'jmp') or i.operands[0].type == CX.X86_OP_IMM:
            continue
        op = i.operands[0]
        if op.type == CX.X86_OP_MEM and not op.mem.base and not op.mem.index and (op.mem.disp & 0xffffffff) in imports:
            continue                                       # an import slot: the world already plays it
        if i.address in have:
            continue
        if i.mnemonic == 'jmp' and op.type == CX.X86_OP_MEM and op.mem.index:
            continue                                       # a jump table
        line = next((ln for ln in text.splitlines() if '/* 0x%x: %s' % (i.address, i.mnemonic) in ln), None)
        if line is None:
            raise ValueError('%s: no translation line for %x' % (key, i.address))
        if i.mnemonic == 'call':
            m = re.search(r'FL4[01]_CALL\(t_\);((?: esp \+= \d+u;)+)', line)
            pops = [int(x) for x in re.findall(r'esp \+= (\d+)u;', m.group(1))] if m else None
            if pops is None or pops[-1] != 4:
                raise ValueError('%s: cannot read the pops of the call at %x: %s' % (key, i.address, line.strip()[:120]))
            out[i.address] = sum(pops[:-1])
        else:
            m = re.search(r'FL4[01]_CALL\(t_\); esp \+= (\d+)u; goto done;', line)
            if not m or int(m.group(1)) < 4:
                raise ValueError('%s: cannot read the pops of the tail jump at %x: %s' % (key, i.address, line.strip()[:120]))
            out[i.address] = int(m.group(1)) - 4
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('rows', nargs='+')
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    cur = json.loads(OVERLAY.read_text()) if OVERLAY.exists() else {}
    for key in a.rows:
        try:
            s = find_sites(key)
        except ValueError as ex:
            print('SKIP', ex)
            continue
        if s:
            cur[key] = {hex(k): v for k, v in sorted(s.items())}
            print(key, cur[key])
    if a.write:
        OVERLAY.write_text(json.dumps({k: cur[k] for k in sorted(cur, key=lambda x: int(x, 16))}, indent=1, sort_keys=True) + '\n')


if __name__ == '__main__':
    main()
