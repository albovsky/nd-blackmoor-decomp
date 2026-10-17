#!/usr/bin/env python3
"""RT-57 mutation check for the raw-0x1c oracle (tests/action_family_1c_runtime_original_oracle.py).

Every mutant is a ONE-SITE textual edit of a COPY of src/action_family_1c_runtime.c, src/session_bindings_a1c.c or the constants of
src/action_family_1c_runtime.h (the project files are never touched). The mutants are GENERATED from the source text, not hand-picked:
  relational operators (== != < <= > >=), logical operators (&& ||), every integer literal (+1, and 1 -> 0), binary + - | & and <<,
  the C1C_ERR_* and SCENE_ACTION_HANDLER_* result codes (each occurrence replaced by a neighbouring code), and the deletion of every
  single-line assignment or call statement. Comments, strings, character literals and preprocessor lines are not mutated (header
  constants are).
Each mutant is built into a driver library and run through the original-x86 oracle against the unmodified GAME.EXE image:
  stage 1  the quick scenario set plus the native-only refusal / limit / host-failure / argument checks   -> KILLED on the first mismatch
  stage 2  survivors: the full scenario set (--workers 2) plus the same checks                           -> KILLED
  stage 3  survivors: the full set once more with the driver built under AddressSanitizer + UBSan       -> KILLED (memory error, signal)
A mutant is INVALID when it does not compile (never counted as killed) and EQUIVALENT when it survives all three stages and a reason
read from the kernel and the original is recorded in EQUIVALENT below (not counted in the kill rate).

The BASE tree (default src/) must itself pass the oracle with 0 mismatches; otherwise every mutant would trivially "die" and the sweep
refuses to run (use --base to mutate a corrected copy while the project sources still carry the differences the oracle reports).

Usage:  python3 action_family_1c_runtime_mutation_check.py [--base DIR] [--jobs N] [--only TEXT] [--names a,b] [--limit N] [--result FILE]
        [--list] [--no-asan]
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
ROOT = PROJECT.parents[1]
ORACLE = HERE / 'action_family_1c_runtime_original_oracle.py'
FILES = {'k': 'action_family_1c_runtime.c', 'b': 'session_bindings_a1c.c', 'h': 'action_family_1c_runtime.h'}
TYPES = ('int', 'int8_t', 'int16_t', 'int32_t', 'uint8_t', 'uint16_t', 'uint32_t', 'size_t', 'char', 'void', 'const', 'static', 'unsigned',
         'C1cIv', 'C1cEntry', 'C1cRect', 'C1cOutcome', 'C1cObject', 'C1cHost', 'SceneActionInfo', 'SceneActionHandlerResult', 'SessionA1cBinding',
         'ActionFamily1cDecoded', 'struct', 'typedef', 'extern')
SWAP = {'C1C_ERR_ARGUMENT': 'C1C_ERR_HOST', 'C1C_ERR_HOST': 'C1C_ERR_FILE', 'C1C_ERR_FILE': 'C1C_ERR_BODY', 'C1C_ERR_BODY': 'C1C_ERR_ARGUMENT',
        'SCENE_ACTION_HANDLER_PENDING': 'SCENE_ACTION_HANDLER_COMPLETED', 'SCENE_ACTION_HANDLER_COMPLETED': 'SCENE_ACTION_HANDLER_PENDING',
        'SCENE_ACTION_HANDLER_DIRECT_COMPLETED': 'SCENE_ACTION_HANDLER_COMPLETED',
        'SCENE_ACTION_HANDLER_OK': 'SCENE_ACTION_HANDLER_ERROR', 'SCENE_ACTION_HANDLER_ERROR': 'SCENE_ACTION_HANDLER_UNSUPPORTED',
        'SCENE_ACTION_HANDLER_UNSUPPORTED': 'SCENE_ACTION_HANDLER_ERROR'}


def mask_text(text):
    """The text with comments, string and character literals replaced by spaces (same length, newlines kept)."""
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if text.startswith('/*', i):
            j = text.find('*/', i + 2)
            j = n if j < 0 else j + 2
            out.append(''.join('\n' if ch == '\n' else ' ' for ch in text[i:j]))
            i = j
        elif text.startswith('//', i):
            j = text.find('\n', i)
            j = n if j < 0 else j
            out.append(' ' * (j - i))
            i = j
        elif c in '"\'':
            j = i + 1
            while j < n and text[j] != c and text[j] != '\n':
                j += 2 if text[j] == '\\' else 1
            j = min(j + 1, n)
            out.append(' ' * (j - i))
            i = j
        else:
            out.append(c)
            i += 1
    return ''.join(out)


def literal_value(tok):
    t = tok.rstrip('uU')
    return int(t, 16) if t.lower().startswith('0x') else int(t)


def render_literal(tok, value):
    suffix = tok[len(tok.rstrip('uU')):]
    return ('0x%X' % value if tok.lower().startswith('0x') else str(value)) + suffix


def line_mutants(key, line, code):
    """Yield (op, index, new_line) one-site mutants of a source line."""
    stripped = line.strip()
    if not stripped:
        return
    if line.lstrip().startswith('#'):
        if key == 'h' and line.lstrip().startswith('#define'):
            for k, m in enumerate(re.finditer(r'\b(0x[0-9a-fA-F]+|\d+)u?\b', code)):
                if m.start() > code.find(stripped.split()[1]) + len(stripped.split()[1]):
                    v = literal_value(m.group(0))
                    yield 'lit+1', k, line[:m.start()] + render_literal(m.group(0), v + 1) + line[m.end():]
        return
    if key == 'h':
        return
    if not code.strip():
        return
    ops = [('==', '!=', r'(?<![=!<>])==(?!=)'), ('!=', '==', r'!='), ('<=', '<', r'(?<!<)<=(?!=)'), ('>=', '>', r'(?<!>)>=(?!=)'),
           ('<', '<=', r'(?<![<\-])<(?![<=])'), ('>', '>=', r'(?<![>\-])>(?![>=])'), ('&&', '||', r'&&'), ('||', '&&', r'\|\|'),
           ('<<', '>>', r'<<(?!=)'), ('|', '&', r'(?<![|])\|(?![|=])'), ('+', '-', r'(?<=[\w\)\]]) \+ (?=[\w\(\-])'),
           ('-', '+', r'(?<=[\w\)\]]) - (?=[\w\(])'), ('&', '|', r'(?<=[\w\)\]]) & (?=[\w\(])')]
    for old, new, pat in ops:
        for k, m in enumerate(re.finditer(pat, code)):
            text = m.group(0)
            repl = text.replace(old, new, 1)
            yield 'op %s->%s' % (old, new), k, line[:m.start()] + repl + line[m.end():]
    for k, m in enumerate(re.finditer(r'(?<![\w.])(0x[0-9a-fA-F]+|\d+)u?\b', code)):
        tok = m.group(0)
        v = literal_value(tok)
        yield 'lit+1', k, line[:m.start()] + render_literal(tok, v + 1) + line[m.end():]
        if v == 1:
            yield 'lit1->0', k, line[:m.start()] + render_literal(tok, 0) + line[m.end():]
    for name, repl in SWAP.items():
        for k, m in enumerate(re.finditer(r'\b%s\b' % name, code)):
            yield 'code %s->%s' % (name, repl), k, line[:m.start()] + repl + line[m.end():]
    first = stripped.split('(')[0].split()[0] if stripped.split('(')[0].split() else ''
    if (stripped.endswith(';') and first not in TYPES and not re.match(r'^(if|for|while|else|return|goto|break|continue|switch|case|default)\b', stripped)
            and not stripped.startswith('}') and not stripped.endswith(':;') and (re.search(r'(?<![=!<>])=(?!=)', code) or re.match(r'^\+\+|^\w[\w\->.\[\]]*\(', stripped)
                                                                                 or stripped.startswith('++'))
            and code.count('(') == code.count(')')):
        indent = line[:len(line) - len(line.lstrip())]
        yield 'delete', 0, indent + ';'
    # statements that follow an if/else on the same line: delete the statement part
    m = re.match(r'^(\s*(?:if|else if|while|for)\s*\(.*\)\s*)(\w[\w\->.\[\]]*\s*=[^=].*;|\w[\w\->.]*\(.*\);)\s*$', code)
    if m and not re.match(r'^\s*(return|goto|break)', m.group(2)):
        yield 'delete-guarded', 0, line[:len(m.group(1))] + ';'


def generate(texts):
    out = []
    for key, text in texts.items():
        masked = mask_text(text).split('\n')
        for lineno, line in enumerate(text.split('\n'), 1):
            seen = set()
            for op, k, new in line_mutants(key, line, masked[lineno - 1]):
                if new == line or (op, k, new) in seen:
                    continue
                seen.add((op, k, new))
                sig = '%s|%s|%s#%d' % (key, line.strip(), op, k)
                out.append(dict(name='%s:%d:%s#%d' % (key, lineno, op, k), sig=sig, key=key, line=lineno, op=op, new=new))
    return out


# Mutants that survive all three stages and are equivalent in every state the original or the oracle can reach, with the reason read from
# the kernel, the binding and the original. Keyed by "file|line text|op#occurrence" (line numbers move; the text does not).
EQUIVALENT = {
    'k|if (a[i] == 0) return 1;|lit+1#1':
        'names_equal is only used as a boolean (the caller tests !names_equal), so 2 is the same as 1',
    'k|return 1;|lit+1#0':
        'names_equal is only used as a boolean, so 2 is the same as 1',
    'k|object->record = NULL;|delete#0':
        'three sites: free_iv (killed by a direct test), the phase-2 reset (record is only non-NULL while iv is non-NULL, and c1c_free_iv a few lines above clears it) and the phase-0 init (the phase-1 tail executed in the same call sets record = NULL again before anything can read it)',
    'k|object->dword_14e = 0;|delete#0':
        'dword_14e is never written non-zero by this kernel (only by CInteractiveVideo methods outside the handler), so it is always 0',
    'k|object->dword_154 = 0;|delete#0':
        'dword_154 is never written non-zero by this kernel, so it is always 0',
    'k|object->dword_158 = 0;|delete#0':
        'dword_158 is never written non-zero by this kernel, so it is always 0',
    'k|object->changed = 0;|lit+1#0':
        'the phase-0 init value is overwritten by the phase-1 tail (changed = 0 at 0x4cb7ff) in the same call, before any read or comparison',
    'k|object->changed = 0;|delete#0':
        'the phase-0 init is redundant with the phase-1 tail (changed = 0 at 0x4cb7ff) in the same call; the phase-2 and phase-1 sites are killed',
    'k|for (i = 0; i < object->iv->count; ++i) {|op <-><=#0':
        'free loop reads entries[count], which is the zeroed sentinel block (calloc of count + 1): free(NULL) is a no-op',
    'k|c1c_free_iv(object);|delete#0':
        'load_iv is only called with object->iv == NULL (c1c_visit phase 0), so the free at its start is a no-op; the phase-2 call is a different line and is killed',
    'k|iv = (C1cIv *)calloc(1u, sizeof(*iv));|lit+1#0':
        'allocates one spare record; never read',
    'k|uint8_t count_bytes[4];|lit+1#0':
        'larger local buffer; only 4 bytes are read into or from it',
    'k|iv->entries = (C1cEntry *)calloc((size_t)iv->count + 1u, sizeof(C1cEntry));|lit+1#0':
        'allocates one more spare sentinel entry; never read',
    'k|iv->entries = (C1cEntry *)calloc((size_t)iv->count + 1u, sizeof(C1cEntry));|lit1->0#0':
        'the sentinel entry is never read once the free loop is bounded by count; calloc(0) is non-NULL on glibc (platform assumption)',
    'k|uint8_t b2[2];|lit+1#0':
        'larger local buffer; only 2 bytes are used',
    'k|uint8_t b1[1];|lit+1#0':
        'larger local buffer; only 1 byte is used',
    'k|for (i = 0; i < iv->count; ++i) {|op <-><=#0':
        'the fail_entries free loop (the load loop of the same text is killed) reads entries[count], the zeroed sentinel: free(NULL)',
    'k|int32_t dx = 0, dy = 0;|lit+1#0':
        'dx is only read when the host reported an origin, and then the host has overwritten it',
    'k|int32_t dx = 0, dy = 0;|lit+1#1':
        'dy is only read when the host reported an origin, and then the host has overwritten it',
    'k|phase = 1u;|lit+1#0':
        'dead store: the local phase is not read again, outcome->phase is set explicitly on the previous line',
    'k|phase = 1u;|lit1->0#0':
        'dead store: the local phase is not read again',
    'k|phase = 1u;|delete#0':
        'dead store: the local phase is not read again',
    'b|b = (SessionA1cBinding *)calloc(1u, sizeof(*b));|lit+1#0':
        'allocates one spare binding; never read',
    'b|c1c_object_reset(&b->object);|delete#0':
        'c1c_object_reset is a memset of zero, and calloc has already zeroed the object',
    'h|#define C1C_ERR_FILE 3|lit+1#0':
        'the value is only used through the macro; the new value 4 equals C1C_ERR_BODY, but nothing in the binding distinguishes them by value',
}


def matches_header(sig, key):
    """Header #define lines carry a trailing comment: the key names the text up to the comment and the operator at the end."""
    head, _, op = key.rpartition('|')
    return key.startswith('h|') and sig.startswith(head) and sig.endswith('|' + op)


def run_oracle(src_dir, mode, timeout=900):
    """mode: 'quick' | 'full' | 'asan'. Returns (verdict, detail)."""
    cmd = [sys.executable, str(ORACLE), '--src', str(src_dir), '--lenient-build', '--fail-fast', '--show', '2']
    env = dict(os.environ)
    if mode == 'quick':
        cmd.append('--quick-only')
    elif mode == 'full':
        cmd += ['--workers', '2']
    else:
        cmd.append('--sanitize')
        asan = subprocess.run(['cc', '-print-file-name=libasan.so'], capture_output=True, text=True).stdout.strip()
        env.update(LD_PRELOAD=asan, ASAN_OPTIONS='detect_leaks=0:abort_on_error=0', CC='cc')
    try:
        done = subprocess.run(cmd, capture_output=True, text=True, cwd=str(HERE), env=env, timeout=timeout)
    except subprocess.TimeoutExpired:
        return 'KILLED', 'timeout (the mutant hangs)'
    text = done.stdout + done.stderr
    if 'driver build failed' in text:
        return 'INVALID', 'does not build: ' + text[-200:].replace('\n', ' ')
    first = next((l for l in done.stdout.splitlines() if l.startswith('MISMATCH')), None)
    if done.returncode == 0:
        return 'SURVIVED', None
    if first is not None:
        return 'KILLED', first[:240]
    if done.returncode < 0 or 'AddressSanitizer' in text or 'runtime error' in text or 'Segmentation' in text:
        hit = re.search(r'(ERROR: AddressSanitizer[^\n]*|runtime error[^\n]*|Segmentation[^\n]*)', text)
        return 'KILLED', 'crash / sanitizer: ' + (hit.group(0)[:160] if hit else 'signal %d' % -done.returncode)
    return 'ERROR', text[-300:].replace('\n', ' ')


def one(task):
    mut, base, texts, work, asan = task
    d = work / hashlib.md5(mut['name'].encode()).hexdigest()[:12]
    d.mkdir()
    for item in base.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, d / item.name)
    lines = texts[mut['key']].split('\n')
    lines[mut['line'] - 1] = mut['new']
    (d / FILES[mut['key']]).write_text('\n'.join(lines))
    row = dict(name=mut['name'], sig=mut['sig'], op=mut['op'], file=FILES[mut['key']], line=mut['line'], new=mut['new'].strip()[:120])
    for stage in ('quick', 'full') + (('asan',) if asan else ()):
        verdict, detail = run_oracle(d, stage)
        row.update(stage=stage, verdict=verdict, detail=detail)
        if verdict != 'SURVIVED':
            break
    shutil.rmtree(d, ignore_errors=True)
    return row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base', type=Path, default=PROJECT / 'src')
    ap.add_argument('--jobs', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--only')
    ap.add_argument('--names')
    ap.add_argument('--limit', type=int)
    ap.add_argument('--result', type=Path)
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--no-asan', action='store_true')
    ap.add_argument('--skip-baseline', action='store_true')
    a = ap.parse_args()
    texts = {key: (a.base / fname).read_text() for key, fname in FILES.items()}
    mutants = generate(texts)
    names = [m['name'] for m in mutants]
    if len(set(names)) != len(names):
        raise SystemExit('duplicate mutant names')
    if a.only:
        mutants = [m for m in mutants if a.only in m['name'] or a.only in m['sig']]
    if a.names:
        wanted = set(a.names.split(','))
        mutants = [m for m in mutants if m['name'] in wanted]
    if a.limit:
        mutants = mutants[:a.limit]
    if a.list:
        for m in mutants:
            print(m['name'], '|', m['sig'].split('|')[1][:70], '=>', m['new'].strip()[:70])
        print(len(mutants), 'mutants')
        return 0
    if not a.skip_baseline:
        verdict, detail = run_oracle(a.base, 'full')
        if verdict != 'SURVIVED':
            print('the base tree does not pass the oracle (%s: %s); refusing to run the sweep' % (verdict, detail))
            return 2
    scratch = ROOT / 'work' / 'rt57'
    scratch.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='rt57_1c_mut_', dir=str(scratch)))
    t0 = time.monotonic()
    rows = []
    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        for row in pool.map(one, [(m, a.base, texts, work, not a.no_asan) for m in mutants]):
            rows.append(row)
            print(row['name'], row['verdict'], row.get('stage', ''), (row.get('detail') or '')[:110], flush=True)
    for r in rows:
        why = next((v for k, v in EQUIVALENT.items() if r['sig'] == k or matches_header(r['sig'], k)), None) \
            if r['verdict'] == 'SURVIVED' else None
        if why is not None:
            r['verdict'] = 'EQUIVALENT'
            r['reason'] = why
    killed = sum(1 for r in rows if r['verdict'] == 'KILLED')
    survivors = [r for r in rows if r['verdict'] == 'SURVIVED']
    counted = killed + len(survivors)
    by_stage = {}
    for r in rows:
        if r['verdict'] == 'KILLED':
            by_stage[r['stage']] = by_stage.get(r['stage'], 0) + 1
    out = dict(mutants_total=len(rows), counted=counted, killed=killed, killed_by_stage=by_stage, kill_rate=round(killed / counted, 4) if counted else None,
               invalid=[r['name'] for r in rows if r['verdict'] in ('INVALID', 'ERROR')],
               equivalent=[dict(name=r['name'], line=r['new'], reason=r['reason']) for r in rows if r['verdict'] == 'EQUIVALENT'],
               survivors=[dict(name=r['name'], file=r['file'], line=r['line'], op=r['op'], new=r['new'], sig=r['sig']) for r in survivors],
               seconds=round(time.monotonic() - t0, 1), base=str(a.base))
    out['source_sha256'] = {fname: hashlib.sha256((a.base / fname).read_bytes()).hexdigest() for fname in FILES.values()}
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k not in ('survivors', 'equivalent')}, indent=1))
    for s in survivors:
        print('SURVIVOR', s['name'], '|', s['sig'].split('|')[1][:80], '=>', s['new'][:80])
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(dict(out, rows=rows), indent=1, sort_keys=True))
    return 0 if not survivors and not out['invalid'] else 1


if __name__ == '__main__':
    sys.exit(main())
