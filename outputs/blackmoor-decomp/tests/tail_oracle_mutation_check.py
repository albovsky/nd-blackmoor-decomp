#!/usr/bin/env python3
"""Compile five tail mutants per family in unique private build directories.

Use work/tools/oracle-python/bin/python with Unicorn JIT permitted. Every
mutant is checked by the shared stage, then by its unchanged old oracle with
an explicitly unique report/log path. No production source/build is changed.
"""
import json
from pathlib import Path
import re
import subprocess
import sys
import time

sys.dont_write_bytecode = True
import tail_oracle_common as T

MUTATIONS = ('remove_modulus', 'modulus_8', 'drop_short_body', 'count_u8', 'count_u16')


def mutate(source, family, mutation):
    prefix = f'ACTION_FAMILY_{family.upper()}'
    if mutation in ('remove_modulus', 'modulus_8'):
        # Modulo one makes the entire existing rejection predicate false;
        # changing the validation operand leaves the count divisor untouched.
        operand = '1u' if mutation == 'remove_modulus' else '8u'
        changed, sites = re.subn(r'%\s*' + prefix + r'_DEPENDENCY_BYTES', '% ' + operand, source)
        T.require(sites == 1, f'{family}: expected one modulus validation site')
    elif mutation == 'drop_short_body':
        # Disable ALL ERR_BODY returns, including variable-array extent checks.
        # Caller provides fully backed original body bytes for these probes.
        changed, sites = re.subn(r'return ' + prefix + r'_ERR_BODY;',
                                '(void)0; /* mutant: missing short-body rejection */', source)
        T.require(sites > 0, f'{family}: no short-body rejection sites')
    elif mutation in ('count_u8', 'count_u16'):
        cast = 'uint8_t' if mutation == 'count_u8' else 'uint16_t'
        pattern = (r'(\b(?:decoded|d)(?:->|\.)dependency_count\s*=)\s*'
                   r'([^;]+/\s*' + prefix + r'_DEPENDENCY_BYTES)\s*;')
        changed, sites = re.subn(pattern, lambda match:
                                f'{match[1]} ({cast})({match[2].strip()});', source)
        T.require(sites == 1, f'{family}: expected one decoded count assignment')
    else:
        raise ValueError(mutation)
    return changed, sites


def compile_mutant(family, mutation, directory):
    original = T.SOURCE / f'action_family_{family}.c'
    changed, sites = mutate(original.read_text(), family, mutation)
    directory.mkdir()
    source, library = directory / 'mutant.c', directory / 'native.dylib'
    with source.open('x') as output:
        output.write(changed)
    command = ['xcrun', '--sdk', 'macosx', 'clang', '-arch', 'arm64', '-std=c11',
               '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O2', '-fPIC', '-dynamiclib',
               '-I', str(T.SOURCE), str(source), '-o', str(library)]
    cp = subprocess.run(command, capture_output=True, text=True)
    T.require(cp.returncode == 0, f'{family}/{mutation}: mutant build failed: {cp.stderr[:2000]}')
    return library, dict(sites=sites, source_sha256=T.sha(source.read_bytes()),
                         native_sha256=T.sha(library.read_bytes()), build_command=command)


def witness(native, machine, payload, typed, mutation):
    if mutation == 'drop_short_body':
        # Larger bodies expose accidental acceptance after unsigned underflow.
        # For the 1/2-byte bodies, the observable API regression is ERR_BODY
        # becoming ERR_TAIL; modulo 16 still prevents acceptance there.
        T.check_short_body(native, machine, payload, typed, max(0, typed - 16))
    else:
        tail = dict(remove_modulus=1, modulus_8=8, count_u8=4096, count_u16=1048576)[mutation]
        T.compare_tail(native, machine, payload[:50 + typed] + bytes(tail), typed)


def old_oracle(family, library, directory):
    script = T.PROJECT / f'tests/action_family_{family}_original_oracle.py'
    report, log = directory / 'old-oracle.json', directory / 'old-oracle.log'
    command = [sys.executable, str(script), '--native-library', str(library), '--result', str(report)]
    with log.open('x') as output:
        cp = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT, timeout=300)
    output = log.read_text()
    # Fail closed on infrastructure errors. A surviving mutant requires a real
    # successful report; a kill requires a native comparison error, not a trap.
    if cp.returncode == 0:
        T.require(report.exists(), f'{family}: old oracle returned success without a report')
        result = json.loads(report.read_text())
        T.require(result.get('mismatches', 0) == 0, f'{family}: old oracle reported mismatches on success')
        detected = False
    else:
        reason = output.strip().splitlines()[-1] if output.strip() else ''
        T.require(cp.returncode == 1 and ('native' in reason or 'decoded' in reason) and
                  ('mismatch' in reason or 'rejected' in reason),
                  f'{family}: old oracle infrastructure/unexpected error; see {log}: {reason}')
        detected = True
    return dict(detected=detected, exit_code=cp.returncode, command=command,
                oracle_sha256=T.sha(script.read_bytes()), log=str(log), log_sha256=T.sha(log.read_bytes()),
                report=str(report) if report.exists() else None,
                report_sha256=T.sha(report.read_bytes()) if report.exists() else None,
                failure=output.strip().splitlines()[-1] if detected else None)


def main():
    started = time.monotonic()
    directory = T.new_run('mutations')
    corpus, machine = T.Corpus(), T.OriginalTail()
    results = []
    for family in T.FAMILIES:
        family_dir = directory / family
        family_dir.mkdir()
        baseline = T.NativeFamily(family, T.build_native(family, family_dir / 'baseline'))
        payload, expected = corpus.records(family)[0]
        typed = baseline.validated_length(payload, expected)
        # Each witness must pass with unmodified native code before it can kill
        # a mutant. Baseline acceptance never comes from a native-only formula.
        for mutation in MUTATIONS:
            witness(baseline, machine, payload, typed, mutation)
        for mutation in MUTATIONS:
            mutant_dir = family_dir / mutation
            library, build = compile_mutant(family, mutation, mutant_dir)
            native = T.NativeFamily(family, library)
            before = machine.calls
            try:
                witness(native, machine, payload, typed, mutation)
            except T.TailMismatch as error:
                failure = str(error)
            else:
                raise T.OracleError(f'{family}/{mutation}: non-equivalent mutant survived new stage')
            T.require(machine.calls == before + 1, 'mutant failed without an original-backed observation')
            previous = old_oracle(family, library, mutant_dir)
            row = dict(family=family, mutation=mutation, detected=True, failure=failure,
                       witness_scope='native short-body safety API; original arithmetic observed separately'
                       if mutation == 'drop_short_body' else 'original-backed acceptance/count comparison',
                       old_oracle=previous, build=build)
            results.append(row)
            print(json.dumps(dict(family=family, mutation=mutation, new_detected=True,
                                  old_detected=previous['detected'])), flush=True)
    report = dict(slice='A-TAIL.1', status='pass', compiled_mutants=len(results),
                  detected=sum(row['detected'] for row in results), equivalent_mutants=[],
                  old_oracle_missed=sum(not row['old_oracle']['detected'] for row in results),
                  results=results, original_calls=machine.calls, hooks=T.HOOKS,
                  exit_points=T.EXIT_POINTS, original_decisions_replaced=False,
                  inputs=dict(exe_sha256=T.EXE_HASH, code_sha256=T.CODE_HASH, corpus_pins=T.FAMILIES),
                  unverified_branches=T.UNVERIFIED,
                  helper_sha256=T.sha(Path(T.__file__).read_bytes()),
                  mutation_script_sha256=T.sha(Path(__file__).read_bytes()),
                  elapsed_seconds=round(time.monotonic() - started, 3))
    T.write_json(directory / 'report.json', report)
    print(json.dumps(dict(status='pass', compiled_mutants=len(results), detected=report['detected'],
                          old_oracle_missed=report['old_oracle_missed'],
                          result=str(directory / 'report.json'),
                          sha256=T.sha((directory / 'report.json').read_bytes()))), flush=True)


if __name__ == '__main__':
    main()
