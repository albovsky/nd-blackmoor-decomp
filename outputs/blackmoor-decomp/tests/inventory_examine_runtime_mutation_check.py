#!/usr/bin/env python3
"""RT-43 mutation check: each deliberately broken rule of inventory_examine_runtime.c (and of the examine hook in
inventory_view_runtime.c) must be detected by tests/test_inventory_examine_runtime.py and, with --oracle, by the quick matrix
of the original-x86 oracle (tests/inventory_examine_runtime_original_oracle.py). The mutants are compiled separately, never
into the shipped library."""
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

PROJECT = Path(__file__).resolve().parents[1]
SRC = PROJECT / 'src'
EXAMINE = (SRC / 'inventory_examine_runtime.c').read_text()
VIEW = (SRC / 'inventory_view_runtime.c').read_text()

MUTANTS = [
    # (name, file, old, new)
    ('selector rule inverted', 'e', 'put_back = selector != -1;', 'put_back = selector == -1;'),
    ('selector 0 treated as none', 'e', 'put_back = selector != -1;', 'put_back = selector > 0;'),
    ('put-back add without the flag', 'e', 'action78_add_item(selector, 1, model', 'action78_add_item(selector, 0, model'),
    ('save type 1', 'e', '&current, INVEXAM_SAVE_TYPE)', '&current, 1)'),
    ('save also after a put back', 'e', '(!put_back && examine->host.load_current', '(examine->host.load_current'),
    ('take rule: nonzero', 'e', 'take == 1 ? item', 'take != 0 ? item'),
    ('take rule: swapped', 'e', 'take == 1 ? item : (int16_t)-1', 'take == 1 ? (int16_t)-1 : item'),
    ('selector never stored', 'e', '*examine->selector = take == 1 ? item : (int16_t)-1;', '(void)take;'),
    ('remove another item', 'e', 'action79_remove_item((uint16_t)item, &model->inventory', 'action79_remove_item((uint16_t)item + 1, &model->inventory'),
    ('sound slot 0x14', 'e', 'host->request_sound(host->context, (uint16_t)INVEXAM_SOUND_SLOT)', 'host->request_sound(host->context, 0x14u)'),
    ('sound only for 1', 'e', 'if (sound != 0) {\n        observe', 'if (sound == 1) {\n        observe'),
    ('sound always', 'e', 'if (sound != 0) {\n        observe', 'if (1) {\n        observe'),
    ('scene word from the flag table', 'e', 'out->request.scene_5bb57b = data->text[item]', 'out->request.scene_5bb57b = examine->flag_word[item]'),
    ('start word from the text table', 'e', 'out->request.word_5c39ff = examine->flag_word[item]', 'out->request.word_5c39ff = data->text[item]'),
    ('dword 0x5bb5a3 zero', 'e', 'out->request.dword_5bb5a3 = 1;', 'out->request.dword_5bb5a3 = 0;'),
    ('engine mode 3', 'e', 'out->request.mode_583999 = 4;', 'out->request.mode_583999 = 3;'),
    ('word 0x5bb599 one', 'e', 'out->request.word_5bb599 = 0;', 'out->request.word_5bb599 = 1;'),
    ('scene sign extension lost', 'e', 'out->request.scene_5bb57b = data->text[item];', 'out->request.scene_5bb57b = (uint16_t)data->text[item];'),
    ('view not closed', 'e', '    inventory_view_close(view);\n    out->closed = 1u;\n    return INVVIEW_OK;', '    out->closed = 1u;\n    return INVVIEW_OK;'),
    ('no dry run', 'e', 'status = dry_run(model, host, put_back, selector, item, failure);', 'status = INVVIEW_OK;'),
    ('item above the records accepted', 'e', '(size_t)item >= INVEXAM_ITEMS', '(size_t)item > INVEXAM_ITEMS + 1000u'),
    ('removed flag lost', 'e', 'out->removed = removed.found;', 'out->removed = 0;'),
    ('teardown failure ignored', 'e', 'host->close_view(host->context) != 0) {\n        *failure = "view teardown failed";', 'host->close_view(host->context) == 99) {\n        *failure = "view teardown failed";'),
    ('scene refusal ignored', 'e', 'examine->host.scene_change(examine->host.context, &out->request) != 0', 'examine->host.scene_change(examine->host.context, &out->request) == 99'),
    ('scene provider optional', 'e', 'if (examine->host.scene_change == NULL) {', 'if (0) {'),
    ('load provider optional', 'e', 'if (examine->host.load_current == NULL) {', 'if (0) {'),
    ('load refusal ignored', 'e', 'examine->host.load_current(examine->host.context, &current) != 0', 'examine->host.load_current(examine->host.context, &current) == 99'),
    ('sound provider optional', 'e', 'if (sound != 0 && host->request_sound == NULL) {', 'if (0) {'),
    ('click: take 0', 'v', 'host->examine, (int16_t)hot, 1, 1,', 'host->examine, (int16_t)hot, 0, 1,'),
    ('click: sound 0', 'v', 'host->examine, (int16_t)hot, 1, 1,', 'host->examine, (int16_t)hot, 1, 0,'),
    ('click: hook ignored', 'v', 'if (host->examine != NULL) {', 'if (0) {'),
    ('click: live view mode not passed', 'v', 'local.view.mode = view->mode;             /* the add step reads the live view */\n                local.view.slot_flag = layout->slot_flag;\n                status = inventory_examine', 'local.view.mode = 0;\n                local.view.slot_flag = 0;\n                status = inventory_examine'),
    ('click: not handled', 'v', '                result->handled = 1u;\n                return INVVIEW_OK;\n            }\n            if (failure != NULL) {\n                *failure = "read/examine', '                return INVVIEW_OK;\n            }\n            if (failure != NULL) {\n                *failure = "read/examine'),
    ('click: failure swallowed', 'v', '                if (status != INVVIEW_OK) {\n                    return status;\n                }\n                result->handled = 1u;', '                result->handled = 1u;'),
]


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def run_oracle(library, scratch):
    done = subprocess.run([sys.executable, str(PROJECT / 'tests/inventory_examine_runtime_original_oracle.py'), '--quick',
                           '--library', str(library), '--report', str(scratch / 'oracle.json')],
                          cwd=PROJECT / 'tests', capture_output=True, text=True,
                          env=dict(os.environ, INVVIEW_RUNTIME_LIBRARY=str(library), A78_RUNTIME_LIBRARY=str(library)))
    return 'oracle-killed' if done.returncode != 0 else 'ORACLE-SURVIVED'


def run(name, which, old, new, scratch, oracle):
    source = EXAMINE if which == 'e' else VIEW
    if old not in source or source.count(old) != 1:
        return 'NOT-APPLIED'
    work = scratch / 'src'
    shutil.copytree(SRC, work, dirs_exist_ok=True)
    target = work / ('inventory_examine_runtime.c' if which == 'e' else 'inventory_view_runtime.c')
    target.write_text(source.replace(old, new, 1))
    library = scratch / 'lib.so'
    done = subprocess.run([compiler(), '-std=c11', '-O1', '-fPIC', '-shared', '-I', str(work),
                           str(work / 'inventory_examine_runtime.c'), str(work / 'inventory_view_runtime.c'),
                           str(work / 'action_family_78_runtime.c'), str(work / 'action_family_79_runtime.c'),
                           str(work / 'action_family_7d_runtime.c'), '-o', str(library)], capture_output=True, text=True)
    if done.returncode != 0:
        return 'COMPILE-ERROR ' + done.stderr[:200]
    env = dict(os.environ, INVVIEW_RUNTIME_LIBRARY=str(library), A78_RUNTIME_LIBRARY=str(library))
    tests = subprocess.run([sys.executable, '-m', 'unittest', 'test_inventory_examine_runtime'], cwd=PROJECT / 'tests',
                           env=env, capture_output=True, text=True)
    unit = 'killed' if tests.returncode != 0 else 'SURVIVED'
    return unit + ' ' + run_oracle(library, scratch) if oracle else unit


def main():
    oracle = '--oracle' in sys.argv[1:]
    results = {}
    for name, which, old, new in MUTANTS:
        with tempfile.TemporaryDirectory() as directory:
            results[name] = run(name, which, old, new, Path(directory), oracle)
        print(f'{results[name]:36s} {name}', flush=True)
    killed = sum(1 for v in results.values() if v.startswith('killed'))
    print(f'unit tests killed {killed}/{len(MUTANTS)}')
    status = 0 if killed == len(MUTANTS) else 1
    if oracle:
        oracle_killed = sum(1 for v in results.values() if v.endswith('oracle-killed'))
        print(f'oracle killed {oracle_killed}/{len(MUTANTS)} (quick matrix)')
        print('(the survivors are provider-absence and host-refusal paths: the oracle always supplies working providers)')
    return status


if __name__ == '__main__':
    raise SystemExit(main())
