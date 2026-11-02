"""jumpout_rows.py: the rows of the tested-equivalent manifest (and the thirteen rows) whose body has a jmp / jcc to a callee or import stub (the rows the FL-78 jump-out edge can change); replays their stored scenarios and compares the coverage with the manifest"""
import sys, json
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import capstone
import fl66_tested as T
M = json.loads(T.MANIFEST.read_text()); S = json.loads(T.SCENARIOS.read_text())
import original_differential as od
pe = od.load_image()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32); md.detail = True
hits = []
for k, r in sorted(M['rows'].items(), key=lambda kv: int(kv[0], 16)):
    row = T.row_info(r['pool'], k)
    stubs = set(row['callees']) | set(row['imports'])
    va = row['va']
    code = bytes(pe.image[va - pe.image_base:va - pe.image_base + row['body']])
    for i in md.disasm(code, va):
        if (i.mnemonic == 'jmp' or (i.mnemonic[0] == 'j' and i.mnemonic != 'jecxz')) and i.operands and i.operands[0].type == capstone.x86_const.X86_OP_IMM and i.operands[0].imm in stubs:
            hits.append(k); break
print(len(hits), hits, flush=True)
bad = []
for k in hits:
    r = T.check_row(k, scenarios=[T.norm(s) for s in S[k]])
    ok = r['status'] == 'tested_equivalent' and r['instructions'] == M['rows'][k]['instructions'] and r['directions'] == M['rows'][k]['directions']
    print(k, r['status'], r['instructions'], r['directions'], 'OK' if ok else 'DIFF', flush=True)
    if not ok:
        bad.append(k)
print('bad', bad)
