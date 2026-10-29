#!/usr/bin/env python3
"""Lift every ledger function with the FL41 lifter in bulk mode for the native host: writes rc_lifted_NN.c (split for parallel compilation),
rc_generated.c/.h (the registration table, the import table and the import thunks) and lift_census.json.

  python3 -I lift_recomp.py OUT_DIR [CHUNKS]
"""
import json, sys, time, collections, traceback, re, os
from pathlib import Path
sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent                 # outputs/blackmoor-decomp
sys.path.insert(0, str(PROJECT / 'tests')); sys.path.insert(0, str(PROJECT / 'scripts'))
import lift_fl41 as L
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('.')
CHUNKS = int(sys.argv[2]) if len(sys.argv) > 2 else 24
OUT.mkdir(parents=True, exist_ok=True)
L.BULK = True
# fiadd/fisub/fimul/fidiv with an integer memory operand: the lifter refuses them; they are the float forms with that operand converted
FIARITH = {"fiadd": "fadd", "fisub": "fsub", "fisubr": "fsubr", "fimul": "fmul", "fidiv": "fdiv", "fidivr": "fdivr"}
_lift_x87 = L.lift_x87
def lift_x87(c, i, mn):
    if mn in FIARITH and i.operands and i.operands[0].type == L.X.X86_OP_MEM:
        op, reverse = L.FARITH[FIARITH[mn]]
        c.emit("{ long double d_ = FL41_FST(fp, 0), s_ = %s; FL41_FST(fp, 0) = fl41_fx_%s(fp, %s, %s); }" % (L.f_load(i, i.operands[0], "i"), op, "s_" if reverse else "d_", "d_" if reverse else "s_"))
        return
    return _lift_x87(c, i, mn)
L.lift_x87 = lift_x87
L.INLINE_CALLEES.add(0x50f978)
spans = L.ledger_spans()
entries = json.load(open(PROJECT / 'function-ledger.json'))['entries']
rows = sorted(int(e['va'], 16) for e in entries)
ok, refused = {}, {}
meta = {}
t0 = time.time()
for n, va in enumerate(rows):
    body = spans[va]
    try:
        text, callees, imports, fs, inline = L.lift(va, body)
        ok[va] = text
        meta[va] = {'callees': {hex(k): v for k, v in callees.items()}, 'imports': {hex(k): v for k, v in imports.items()}, 'fs': fs,
                    'indirect': {hex(k): v for k, v in L.INDIRECT_SITES.get(va, {}).items()}, 'inline': sorted(hex(x) for x in inline)}
    except L.Unsupported as ex:
        refused[va] = str(ex)
    except Exception as ex:
        refused[va] = 'ERROR ' + repr(ex)[:200]
    if n % 500 == 0:
        print(n, len(ok), len(refused), '%.0fs' % (time.time() - t0), flush=True)
parts_ok = parts_bad = 0
part_size = {}
for e in entries:
    c = int(e['va'], 16)
    parts = sorted(int(p, 16) for p in (e.get('derived_parts') or []))
    end = c + e['span']
    for k, pva in enumerate(parts):
        if pva in ok:
            continue
        nxt = parts[k + 1] if k + 1 < len(parts) else end
        try:
            text, callees, imports, fs, inline = L.lift(pva, nxt - pva)
            ok[pva] = text
            part_size[pva] = nxt - pva
            meta[pva] = {'callees': {hex(a): v for a, v in callees.items()}, 'imports': {hex(a): v for a, v in imports.items()}, 'fs': fs,
                         'indirect': {hex(a): v for a, v in L.INDIRECT_SITES.get(pva, {}).items()}, 'inline': sorted(hex(x) for x in inline), 'part_of': e['va']}
            parts_ok += 1
        except Exception as ex:
            # a part that runs into the jump table of its function: the table is data, so cut the part where the run of code pointers starts
            m = re.search(r'disassembly stops at (0x[0-9a-f]+)', str(ex))
            if m:
                img = L.od.load_image()
                stop = int(m.group(1), 16)
                t = stop & ~3
                while t > pva and 0x401000 <= int.from_bytes(img.image[t - 4 - img.image_base:t - img.image_base], 'little') < 0x540000:
                    t -= 4
                if pva < t < stop:
                    try:
                        text, callees, imports, fs, inline = L.lift(pva, t - pva)
                        ok[pva] = text
                        part_size[pva] = t - pva
                        meta[pva] = {'callees': {hex(a): v for a, v in callees.items()}, 'imports': {hex(a): v for a, v in imports.items()}, 'fs': fs,
                                     'indirect': {hex(a): v for a, v in L.INDIRECT_SITES.get(pva, {}).items()}, 'inline': sorted(hex(x) for x in inline), 'part_of': e['va']}
                        parts_ok += 1
                        continue
                    except Exception as ex2:
                        ex = ex2
            refused[pva] = 'part of %s: %s' % (e['va'], str(ex)[:120])
            parts_bad += 1
print('derived parts lifted', parts_ok, 'refused', parts_bad)
print('lifted', len(ok), 'refused', len(refused), '%.0fs' % (time.time() - t0))
import re, bisect
TAIL1 = re.compile(r'FL41_CALL\((0x[0-9a-f]+u)\); esp \+= \d+u; goto done;(  /\* 0x[0-9a-f]+: jmp )')
TAIL2 = re.compile(r'FL41_CALL\(t_\); esp \+= \d+u; goto done; \}(  /\* 0x[0-9a-f]+: jmp )')
tails = 0
for va in ok:
    t, n1 = TAIL1.subn(r'FL41_TAILJMP(\1);\2', ok[va])
    t, n2 = TAIL2.subn(r'FL41_TAILJMP(t_); }\1', t)
    ok[va] = t
    tails += n1 + n2
print('tail jumps rewritten', tails)
# a call through a register or pointer: the lifter assumed the callee pops what the caller pushed (stdcall), which is wrong for a
# cdecl callback (qsort's comparator); take the callee's own `ret N` from its final esp instead
ICALL = re.compile(r'FL41_CALL\(t_\); (?:esp \+= (\d+)u; )?esp \+= 4u; \}')
icalls = 0
for va in ok:
    ok[va], n = ICALL.subn(lambda m: 'FL41_ICALL(t_, %su); }' % (m.group(1) or '0'), ok[va])
    icalls += n
print('indirect calls rewritten', icalls)
# the x87 stack is global, as on the machine: a callee takes its operands from the caller's stack and leaves its result on it, so the
# per-call model (callee on an empty stack, `fpush(fret)` / `fpop` in the caller) is dropped; the host no longer zeroes or restores the stack
FPCALL = re.compile(r'(FL41_CALL\(0x[0-9a-f]+u\);\n(?:    esp \+= \d+u;\n)+)    fl41_fp(?:ush\(fp, fl41_ld_f64\(fp, h->fret\(h->ctx\)\)\)|op\(fp\));\n')
fpcalls = 0
for va in ok:
    ok[va], n = FPCALL.subn(r'\1', ok[va])
    fpcalls += n
print('x87 per-call adjustments removed', fpcalls)
# entry aliases for direct calls and tail jumps that land inside a function
starts = sorted(ok)
aliases = {}
for e in entries:
    c = int(e['va'], 16)
    if c in ok:
        for part in e.get('derived_parts') or []:
            aliases[int(part, 16)] = c
for va, m in meta.items():
    for t in m['callees']:
        t = int(t, 16)
        if t in spans or t in ok or t in aliases:
            continue
        i = bisect.bisect_right(starts, t) - 1
        if i >= 0 and starts[i] <= t < starts[i] + (spans.get(starts[i]) or part_size[starts[i]]):
            aliases[t] = starts[i]
print('alias candidates', len(aliases))
alias_text = {}
for t, c in sorted(aliases.items()):
    text = ok[c]
    marker = '/* 0x%x: ' % t
    if marker not in text:
        print('alias %x: no instruction at that address in %x' % (t, c)); continue
    lines = text.split('\n')
    out = []
    inserted_goto = False
    for ln in lines:
        if ln.startswith('void m%x_lifted(' % c):
            ln = ln.replace('m%x_lifted' % c, 'm%x_lifted' % t)
        if marker in ln and ('L_%x:' % t) not in text:
            out.append('L_%x:' % t)
        out.append(ln)
        if not inserted_goto and ln.strip() in ('FL41_PROLOGUE', 'FL41_FPU_PROLOGUE', 'uint32_t esp0_ = esp;'):
            pass
    # the goto goes after the last prologue line
    k = max(i for i, ln in enumerate(out) if ln.strip() in ('FL41_PROLOGUE', 'FL41_FPU_PROLOGUE', 'uint32_t esp0_ = esp;'))
    out.insert(k + 1, '    goto L_%x;' % t)
    alias_text[t] = '\n'.join(out)
print('aliases', len(alias_text), 'of', len(aliases))

# ---- output: the lifted functions, split over CHUNKS files of similar size
allfns = {va: ok[va] for va in ok if ok[va] is not None}
allfns.update(alias_text)
order = sorted(allfns, key=lambda v: -len(allfns[v]))
bins = [[] for _ in range(CHUNKS)]
sizes = [0] * CHUNKS
for va in order:
    k = sizes.index(min(sizes))
    bins[k].append(va); sizes[k] += len(allfns[va])
for k, vas in enumerate(bins):
    with open(OUT / ('rc_lifted_%02d.c' % k), 'w') as f:
        f.write('#include "rc_lift_prelude.h"\n')
        for va in sorted(vas):
            f.write('\n' + allfns[va])
lifted = sorted(allfns)

# ---- imports: every entry of the PE's import table with the bytes its stdcall callee pops
ARGS = {'GetStringTypeW': 4, 'GetStringTypeA': 5, 'LCMapStringW': 6, 'LCMapStringA': 6, 'MultiByteToWideChar': 6, 'WideCharToMultiByte': 8,
        'GetModuleHandleA': 1, 'GetProcAddress': 2, 'LoadLibraryA': 1, 'FreeLibrary': 1, 'RtlUnwind': 4, 'RaiseException': 4,
        'GetLocaleInfoA': 4, 'GetLocaleInfoW': 4, 'CompareStringA': 6, 'CompareStringW': 6, 'IsValidCodePage': 1, 'IsValidLocale': 2,
        'EnumSystemLocalesA': 2, 'GetUserDefaultLCID': 0, 'SetConsoleCtrlHandler': 2, 'FlushFileBuffers': 1, 'SetStdHandle': 2,
        'CloseHandle': 1, 'ReadFile': 5, 'SetFilePointer': 4, 'SetEndOfFile': 1, 'GetTimeZoneInformation': 1, 'GetSystemTime': 1,
        'GetLocalTime': 1, 'SystemTimeToFileTime': 2, 'FileTimeToSystemTime': 2, 'FileTimeToLocalFileTime': 2, 'LocalFileTimeToFileTime': 2,
        'GetFileTime': 4, 'SetFileTime': 4, 'DeleteFileA': 1, 'MoveFileA': 2, 'CreateDirectoryA': 2, 'RemoveDirectoryA': 1,
        'FindNextFileA': 2, 'GetFullPathNameA': 4, 'GetShortPathNameA': 3, 'SetErrorMode': 1, 'GetExitCodeProcess': 2,
        'CreateProcessA': 10, 'WaitForSingleObject': 2, 'CreateEventA': 4, 'SetEvent': 1, 'ResetEvent': 1, 'CreateThread': 6,
        'ResumeThread': 1, 'SuspendThread': 1, 'SetThreadPriority': 2, 'GetThreadPriority': 1, 'ExitThread': 1, 'TerminateThread': 2,
        'CreateMutexA': 3, 'ReleaseMutex': 1, 'OutputDebugStringA': 1, 'IsDBCSLeadByte': 1, 'GetTempPathA': 2, 'GetTempFileNameA': 4,
        'FormatMessageA': 7, 'GetDiskFreeSpaceA': 5, 'GetVolumeInformationA': 8, 'GlobalReAlloc': 3, 'GlobalSize': 1, 'GlobalFlags': 1,
        'LocalReAlloc': 3, 'LocalLock': 1, 'LocalUnlock': 1, 'VirtualProtect': 4, 'VirtualQuery': 3, 'DuplicateHandle': 7, 'Beep': 2,
        'DirectDrawEnumerateExA': 3, 'DirectDrawCreateEx': 4, '#1': 3, '#2': 2, 'VerQueryValueA': 4, 'GetFileVersionInfoA': 4,
        'GetFileVersionInfoSizeA': 2, '_BinkOpenDirectSound@4': 1, 'GetStringTypeExA': 5, 'GetEnvironmentStringsW': 0, 'VirtualFree': 3,
        'SetUnhandledExceptionFilter': 1, 'TranslateAcceleratorA': 3, 'ReleaseCapture': 0, 'ReuseDDElParam': 5, 'UnpackDDElParam': 4,
        'DrawTextA': 5, 'GetSysColorBrush': 1, 'GetMenuItemID': 2, 'RegisterWindowMessageA': 1, 'GetClipBox': 2, 'SaveDC': 1, 'RestoreDC': 2,
        'SelectObject': 2, 'SetMapMode': 2, 'SetViewportOrgEx': 4, 'OffsetViewportOrgEx': 4, 'SetViewportExtEx': 4, 'ScaleViewportExtEx': 6,
        'SetWindowExtEx': 4, 'ScaleWindowExtEx': 6, 'PtVisible': 3, 'RectVisible': 2, 'TextOutA': 5, 'Escape': 5, 'GetFileTitleA': 3,
        'PrintDlgA': 1, 'CommDlgExtendedError': 0, 'DocumentPropertiesA': 6, 'OpenPrinterA': 3, 'ClosePrinter': 1, 'DragQueryFileA': 4, 'GetACP': 0}
import pefile
EXE = Path(os.environ['GAME_EXE']) if os.environ.get('GAME_EXE') else PROJECT.parent.parent / 'work' / 'original' / 'GAME.EXE'
pe = pefile.PE(str(EXE))
cleanup = {}
for va, m in meta.items():
    for slot, n in m['imports'].items():
        cleanup[int(slot, 16)] = n
imports = []
for d in pe.DIRECTORY_ENTRY_IMPORT:
    dll = d.dll.decode()
    for imp in d.imports:
        name = imp.name.decode() if imp.name else '#%d' % imp.ordinal
        n = cleanup.get(imp.address)
        if n is None:
            n = ARGS.get(name, 0) * 4
        imports.append((dll, name, imp.address, n))
byname = {dll + '!' + name: slot for dll, name, slot, n in imports}
xrefs = json.load(open(PROJECT / 'function-xrefs.json'))
thunks = sorted((int(t['va'], 16), byname[t['import']]) for t in xrefs['thunks'] if t.get('kind') == 'import' and t['import'] in byname)

with open(OUT / 'rc_generated.h', 'w') as f:
    f.write("""/* generated by recomp/lift_recomp.py: do not edit or commit */
#ifndef RC_GENERATED_H
#define RC_GENERATED_H
#include <stdint.h>
typedef struct RcGenImport { const char *dll; const char *name; uint32_t slot; uint32_t cleanup; } RcGenImport;
typedef struct RcGenThunk { uint32_t va, slot; } RcGenThunk;
extern const RcGenImport rc_gen_imports[];
extern const uint32_t rc_gen_import_count;
extern const RcGenThunk rc_gen_thunks[];
extern const uint32_t rc_gen_thunk_count;
extern const uint32_t rc_gen_lifted_count;
#endif
""")
with open(OUT / 'rc_generated.c', 'w') as f:
    f.write('/* generated by recomp/lift_recomp.py: do not edit or commit */\n#include "rc.h"\n#include "rc_generated.h"\n')
    for va in lifted:
        f.write('void m%x_lifted(Fl41Regs *, const Fl41Host *);\n' % va)
    f.write('void rc_register_all(void)\n{\n')
    for va in lifted:
        f.write('    rc_register(0x%xu, m%x_lifted);\n' % (va, va))
    f.write('}\n')
    f.write('const uint32_t rc_gen_lifted_count = %d;\n' % len(lifted))
    f.write('const RcGenImport rc_gen_imports[] = {\n')
    for dll, name, slot, n in imports:
        f.write('    {"%s", "%s", 0x%xu, %d},\n' % (dll, name, slot, n))
    f.write('};\nconst uint32_t rc_gen_import_count = %d;\n' % len(imports))
    f.write('const RcGenThunk rc_gen_thunks[] = {\n')
    for va, slot in thunks:
        f.write('    {0x%xu, 0x%xu},\n' % (va, slot))
    f.write('    {0, 0}\n};\nconst uint32_t rc_gen_thunk_count = %d;\n' % len(thunks))
json.dump({'lifted': [hex(v) for v in lifted], 'refused': {hex(k): v for k, v in refused.items()}}, open(OUT / 'lift_census.json', 'w'), indent=0)
reasons = collections.Counter(' '.join(r.split()[:3]) for r in refused.values())
for r, c in reasons.most_common(40):
    print('%5d  %s' % (c, r))
print('wrote', len(lifted), 'functions in', CHUNKS, 'files;', len(imports), 'imports;', len(thunks), 'thunks')
