#!/usr/bin/env python3
"""FL-41: look for a scenario that tells a surviving mutant of a FL-39 batch d row from the port.

usage (from outputs/blackmoor-decomp):  python3 tests/fl41_mutant_fuzz.py <survivors.json> [--scenarios 400] [--out FILE]

<survivors.json> is the survivor list of tests/fl41_operator_mutation_check.py ({va: {'survivors': [{'site', 'mutation', 'line'}]}}). For each survivor it builds the
mutant library, then runs the SAME scenarios (random and boundary-value recipes of the row, tests/fl41_boundary_recipes.py candidates) on the port and on the mutant
(both native, in a child process so that a crash is a rejected scenario) and compares everything the differential test compares: the return value, the memory
of every fixture region, the globals and the ordered calls out. A scenario that tells them apart is then run through the ORIGINAL bytes (Unicorn): if the original
agrees with the port there, the recipe is a new test (written to --out as {va: [recipe]}), which kills the mutant. A mutant for which no scenario tells it from the port is
listed as `indistinguishable`: its effect is not visible in any observable of the row.
"""
import argparse
import ctypes
import json
import os
from pathlib import Path
import random
import signal
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import fl39d_fixtures as fx
import fl41_boundary_recipes as B
import fl41_operator_mutation_check as M
import test_fl39d_differential as T
from test_fl_differential import buf, ptr, compiler

PROJECT = HERE.parent
SRC = PROJECT / 'src'


def build_lib(directory, kernel):
    out = Path(directory) / ('lib_%d.so' % os.getpid())
    cmd = [*compiler(), '-std=c11', '-O1', '-ffp-contract=off', '-g', '-shared', '-fPIC', f'-I{SRC}', str(T.Fl39dDifferential.SHIM), str(kernel), '-o', str(out)]
    done = subprocess.run(cmd, capture_output=True, text=True)
    if done.returncode != 0:
        raise RuntimeError(done.stderr[-400:])
    lib = ctypes.CDLL(str(out))
    lib.shim_calls.restype = ctypes.POINTER(T.ShimCall32)
    lib.shim_world_size.restype = ctypes.c_size_t
    lib.shim_script_probe.argtypes = [ctypes.c_uint32, ctypes.c_void_p, ctypes.c_int]
    lib.shim_fl39d.argtypes = [ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
    lib.shim_script_write_bytes.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]
    lib.shim_script_write.argtypes = [ctypes.c_uint32, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_uint32]
    return lib


class Recorder(T.Fl39dDifferential):
    """The native half of Fl39dDifferential.pair: runs the port of `lib` on a scenario and returns everything that can be observed."""

    def runTest(self):
        pass

    def record(self, lib, sc):
        self.lib = lib
        lib.shim_reset()
        arrays, by_name = [], {}
        for a in sc.areas:
            arr = buf(a.data)
            by_name[a.name] = arr
            arrays.append((a, arr))
            lib.shim_add_region(a.va, ptr(arr), len(arr))
        sw = fx.World()
        for field, value in sc.g.items():
            setattr(sw, field, value & ((1 << (8 * fx.GLOBALS[field][1])) - 1))
        for field, (name, offset) in sc.pointers.items():
            setattr(sw, field, ctypes.cast(ctypes.byref(by_name[name], offset), ctypes.c_void_p).value)
        probe_spec, deref_len = {}, {}
        for s in [*sc.stubs.values(), *sc.iat.values()]:
            for call, arg, offset, size_, value in s.writes:
                if isinstance(value, bytes):
                    lib.shim_script_write_bytes(s.name, call, arg, offset, value, len(value))
                else:
                    lib.shim_script_write(s.name, call, arg, offset, size_, value)
            for r in (s.results or ([s.result] if s.result else [])):
                lib.shim_script_return(s.name, r)
            for name, off, ln in (s.probe or ()):
                if name.startswith('g:'):
                    probe_spec.setdefault(s.name, []).append(('w', getattr(fx.World, name[2:]).offset, fx.GLOBALS[name[2:]][1]))
                else:
                    probe_spec.setdefault(s.name, []).append(('p', ln))
                    lib.shim_script_probe(s.name, ctypes.cast(ctypes.byref(by_name[name], off), ctypes.c_void_p).value, ln)
            for index, (arg, nbytes) in enumerate(getattr(s, 'derefs', None) or ()):
                (lib.shim_script_deref if index == 0 else lib.shim_script_deref2)(s.name, arg, nbytes)
                deref_len.setdefault(s.name, []).append((arg, nbytes))
        result = ctypes.c_int32(0)
        self_ptr = ptr(by_name['self']) if 'self' in by_name else None
        native_args = list(sc.args)
        if fx.SPECS[sc.key].get('ptr_args'):
            for i, v in enumerate(native_args):
                for a, arr in arrays:
                    if a.va <= v < a.va + len(arr):
                        native_args[i] = ctypes.addressof(arr) + (v - a.va)
        stack_args = (ctypes.c_uint64 * 8)(*[v & 0xffffffffffffffff for v in native_args])
        lib.shim_fl39d(sc.fn, self_ptr, ctypes.byref(stack_args), ctypes.byref(sw), ctypes.byref(result))
        calls = self.native_calls(arrays, probe_spec, deref_len)
        mem = [bytes(arr) for a, arr in arrays if a.compare]
        globs = [getattr(sw, f) & ((1 << (8 * fx.GLOBALS[f][1])) - 1) for f in sorted(sc.g)]
        ret = result.value & 0xffffffff
        return (ret, mem, globs, calls), bool(fx.SPECS[sc.key].get('ret'))


def differs(rec, lib_a, lib_b, key, row, recipe):
    """0 same, 1 different (return value only: 5), 2 crashed or rejected. Runs in a child process."""
    r, w = os.pipe()
    pid = os.fork()
    if pid == 0:
        os.close(r)
        code = 2
        try:
            signal.alarm(20)
            sc = fx.lift_scenario(key, row, recipe)
            a, ret_counts = rec.record(lib_a, sc)
            sc = fx.lift_scenario(key, row, recipe)
            b, _ = rec.record(lib_b, sc)
            if a[1:] != b[1:]:
                code = 1
            elif a[0] != b[0]:
                code = 1 if ret_counts else 5
            else:
                code = 0
        except Exception:
            code = 2
        os.write(w, bytes([code]))
        os._exit(0)
    os.close(w)
    _, st = os.waitpid(pid, 0)
    data = os.read(r, 1)
    os.close(r)
    return data[0] if data else 2


def recipes_for(key, row, rng, count):
    base = [dict(r) for r in row['recipes']]
    yield from base
    yield from B.candidates(key, count, rng)
    for _ in range(count // 2):         # plain random seeds
        yield {'seed': rng.randrange(1, 1 << 31), 'set': {}, 'args': {}, 'res': {}}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('survivors')
    ap.add_argument('--scenarios', type=int, default=400)
    ap.add_argument('--out', default='fuzz-result.json')
    ap.add_argument('--only')
    a = ap.parse_args()
    surv = json.load(open(a.survivors))
    only = {x.replace('0x', '') for x in a.only.split(',')} if a.only else None
    batch = M.Batch('fl39d')
    rec = Recorder()
    T.Fl39dDifferential.setUpClass()
    case = T.Fl39dDifferential('test_48217a_lifted')
    result = {}
    new_recipes = {}
    with tempfile.TemporaryDirectory() as d:
        base_lib = build_lib(d, SRC / 'original_methods_fl39d.c')
        for va, v in sorted(surv.items()):
            if only and va not in only:
                continue
            row = fx.ROWS[va][1]
            result[va] = []
            for sv in v['survivors']:
                s0, e0, new, label = batch.sites[va][sv['site']]
                text = batch.original[:s0] + new + batch.original[e0:]
                kernel = Path(d) / 'mutant.c'
                kernel.write_text(text)
                try:
                    mutant = build_lib(d, kernel)
                except RuntimeError as e:
                    result[va].append({**sv, 'verdict': 'mutant does not build'})
                    continue
                rng = random.Random(int(va, 16) * 7 + sv['site'])
                verdict, ret_only = 'indistinguishable', 0
                for n, recipe in enumerate(recipes_for(va, row, rng, a.scenarios)):
                    code = differs(rec, base_lib, mutant, va, row, recipe)
                    if code == 5:
                        ret_only += 1
                    if code != 1:
                        continue
                    status = B.judge(case, va, row, recipe)
                    if status == 0:
                        new_recipes.setdefault(va, []).append({'seed': recipe['seed'], 'set': {str(k): x for k, x in recipe['set'].items()},
                                                               'args': {str(k): x for k, x in recipe.get('args', {}).items()}, 'res': {}})
                        verdict = 'killed by a new scenario'
                        break
                    verdict = 'distinguished only where the port and the original disagree or fault (status %d)' % status
                if verdict == 'indistinguishable' and ret_only:
                    verdict = 'differs only in the return value, which the row does not compare (%d scenarios)' % ret_only
                result[va].append({**sv, 'verdict': verdict})
            print('0x%s %s' % (va, [r['verdict'][:30] for r in result[va]]), flush=True)
            Path(a.out).write_text(json.dumps({'result': result, 'new_recipes': new_recipes}, indent=1))
    Path(a.out).write_text(json.dumps({'result': result, 'new_recipes': new_recipes}, indent=1))


if __name__ == '__main__':
    main()
