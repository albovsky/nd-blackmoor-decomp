#!/usr/bin/env python3
"""RT-51 mutation check for the raw-0xd6 / raw-0xe0 oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_e0_runtime.c (the project file is never
touched). Each mutant is built into a driver library and run through the original-x86 oracle
(action_family_e0_runtime_original_oracle.py). A mutant is KILLED when the oracle reports at least one mismatch
against the unmodified GAME.EXE image; it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does
not compile or the edit site is not found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_e0_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--workers N]
                                                          [--result FILE]
Stage `quick` runs the oracle's --quick subset; survivors are re-run on the full scenario set (--stage full also
runs every mutant on the full set).
"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
ORACLE = HERE / 'action_family_e0_runtime_original_oracle.py'
KERNEL = 'action_family_e0_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


# ---- state transitions
m('phase0-initial-state', 'state-transition', 'o->state = 0;\n    o->initialized = 1u;', 'o->state = 1;\n    o->initialized = 1u;')
m('phase0-first-phase', 'state-transition', 'set_phase(c, 1u);\n    return E0_OK;\n}', 'set_phase(c, 2u);\n    return E0_OK;\n}')
m('state0-next-state', 'state-transition',
  'clear_player(o);\n        }\n        o->state = 1;\n        return E0_OK;', 'clear_player(o);\n        }\n        o->state = 3;\n        return E0_OK;')
m('state1-next-state', 'state-transition', 'o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;',
  'o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 4;')
m('state3-sound-state', 'state-transition', 'o->state = 4;\n        return E0_OK;\n    }\n    if (o->solved != 0u) {',
  'o->state = 3;\n        return E0_OK;\n    }\n    if (o->solved != 0u) {')
m('next-round-state', 'state-transition', 'o->blink = 0u;\n    o->state = 0;\n    return E0_OK;', 'o->blink = 0u;\n    o->state = 1;\n    return E0_OK;')
m('next-round-increment', 'state-transition', 'o->round = (int16_t)(o->round + 1);\n    o->blink = 0u;',
  'o->round = (int16_t)(o->round + 2);\n    o->blink = 0u;')
m('state4-busy-sense', 'state-transition', 'if (busy == 0) {', 'if (busy != 0) {')
m('state4-solved-sense', 'state-transition', '        if (o->solved != 0u) {\n            set_phase(c, 2u);',
  '        if (o->solved == 0u) {\n            set_phase(c, 2u);')
m('state3-solved-sense', 'state-transition', '    if (o->solved != 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);',
  '    if (o->solved == 0u) {\n        set_phase(c, 2u);\n        return E0_OK;\n    }\n    return next_round(c);')
m('click-exit-asked', 'state-transition', 'o->exit_asked = 1u;\n        *new_phase = 2u;', 'o->exit_asked = 0u;\n        *new_phase = 2u;')
# ---- constants 0x12c / 0x64 / 1000 / 0x190
m('const-12c-click', 'constant', 'o->wait_deadline = do_tick(h) + 0x12cu;\n            o->waiting = 1u;',
  'o->wait_deadline = do_tick(h) + 0x12du;\n            o->waiting = 1u;')
m('const-12c-exit', 'constant', 'o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12cu;',
  'o->exit_pending = 1u;\n        o->wait_deadline = do_tick(h) + 0x12bu;')
m('const-64-blink', 'constant', 'o->blink_deadline = do_tick(c->h) + 0x64u;\n        }', 'o->blink_deadline = do_tick(c->h) + 0x65u;\n        }')
m('const-64-init', 'constant', 'o->blink_deadline = do_tick(c->h) + 0x64u;\n    o->state = 3;',
  'o->blink_deadline = do_tick(c->h) + 0x63u;\n    o->state = 3;')
m('const-1000-delay', 'constant', '* 1000 + 0x190)', '* 100 + 0x190)')
m('const-190-delay', 'constant', '* 1000 + 0x190)', '* 1000 + 0x18f)')
# ---- tick comparisons (all unsigned in the original)
m('show-signed', 'compare', 'if (now < o->show_deadline) {', 'if ((int32_t)now < (int32_t)o->show_deadline) {')
m('show-boundary', 'compare', 'if (now < o->show_deadline) {', 'if (now <= o->show_deadline) {')
m('wait-signed', 'compare', 'if (now <= o->wait_deadline) return E0_OK;', 'if ((int32_t)now <= (int32_t)o->wait_deadline) return E0_OK;')
m('wait-boundary', 'compare', 'if (now <= o->wait_deadline) return E0_OK;', 'if (now < o->wait_deadline) return E0_OK;')
m('blink-boundary', 'compare', 'if (now >= o->blink_deadline) {', 'if (now > o->blink_deadline) {')
m('blink-signed', 'compare', 'if (now >= o->blink_deadline) {', 'if ((int32_t)now >= (int32_t)o->blink_deadline) {')
# ---- the stale scene cell and the failed block
m('stale-scene-zero-test', 'predicate', 'o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0',
  'o->solved == 0u && o->scene != E0_NO_SCENE && o->typed == 0')
m('stale-scene-typed-test', 'predicate', 'o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0',
  'o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0')
m('fail-block-sense', 'predicate', '} else if (rd_s16(b, B_FAIL_BLOCK) != E0_NO_SCENE) {', '} else if (rd_s16(b, B_FAIL_BLOCK) == E0_NO_SCENE) {')
m('stale-cell-test', 'predicate', 'if (w->scene_cell_5bb57b != E0_NO_SCENE) {\n            E0Transition t;',
  'if (w->scene_cell_5bb57b != 0) {\n            E0Transition t;')
m('fail-start-flag', 'predicate', 'w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;',
  'w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 0 ? 0 : 1;')
m('block-start-flag', 'predicate', 'world->start_flag_5bb1ca = start_word == 1 ? 0 : 1;', 'world->start_flag_5bb1ca = start_word == 0 ? 0 : 1;')
m('sets-branch-sense', 'predicate', 'const int sets_branch = !exit_branch && o->solved_sets != 0u;',
  'const int sets_branch = !exit_branch && o->solved_sets == 0u;')
m('fail-flag-value', 'predicate', 'flag_value = b[B_FAIL_VALUE];', 'flag_value = b[B_ALL_VALUE];')
m('complete-row', 'missing-effect', 'fx(h, E0_FX_COMPLETE, o->row, 0);', 'fx(h, E0_FX_COMPLETE, o->slot, 0);')
m('entry17-value', 'missing-effect', 'w->entry17_active_5d1a8f = 0;', 'w->entry17_active_5d1a8f = 1;')
# ---- skipped sounds / host effects
m('skip-prepare-init', 'missing-effect', 'HOST(h->sound_prepare(h->context, b + B_SOUND_A));\n        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_A, 0);',
  'fx(h, E0_FX_SOUND_PREPARE, B_SOUND_A, 0);')
m('skip-stop-finish', 'missing-effect', 'HOST(h->sound_stop(h->context, b + B_SOUND_A));', '(void)h;')
m('click-play-no-start-key', 'missing-effect', 'start_flag != 0 && !no_sound(b + B_SOUND_A)', '!no_sound(b + B_SOUND_A)', 2, 0)
m('click-play-no-start-exit', 'missing-effect', 'start_flag != 0 && !no_sound(b + B_SOUND_A)', '!no_sound(b + B_SOUND_A)', 2, 1)
m('click-channel', 'constant', 'HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));\n            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);\n        }\n    }\n    if (b[B_HAS_EXIT]',
  'HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));\n            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);\n        }\n    }\n    if (b[B_HAS_EXIT]')
m('win-channel-busy', 'constant', 'const int16_t channel = rd_s16(b, B_WIN_CHANNEL);', 'const int16_t channel = rd_s16(b, B_CLICK_CHANNEL);')
m('win-channel-play', 'constant', 'HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));', 'HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));')
m('state3-sound-test', 'predicate', 'if (!no_sound(b + B_SOUND_B)) {\n        HOST(h->sound_prepare', 'if (no_sound(b + B_SOUND_B)) {\n        HOST(h->sound_prepare')
m('skip-mark-dirty', 'missing-effect', 'HOST(host->mark_dirty(host->context, object->slot));', '(void)host;')
m('skip-release-surface', 'missing-effect', 'HOST(host->release_surface(host->context, surface));', '(void)host;')
m('skip-release-slot', 'missing-effect', 'HOST(host->release_slot(host->context, slot));', '(void)host;')
m('cleanup-keeps-sets', 'missing-effect', 'object->solved_sets = 0u;\n    object->blink = 0u;', 'object->blink = 0u;')
m('invalidate-active', 'predicate', 'if (object->active != 0u && object->slot != E0_NO_SLOT) {', 'if (object->slot != E0_NO_SLOT) {')
# ---- phase 0
m('surface-reload', 'predicate', 'if (o->surface == 0u) {\n        uint32_t surface = 0u;', 'if (1) {\n        uint32_t surface = 0u;')
m('rounds-init', 'predicate', 'if (o->rounds > 0 && o->round == 0) o->round = 1;', 'if (o->rounds > 0) o->round = 1;')
m('set-count', 'counter', 'if (b[B_SETS + 5u * (size_t)s] != 0u) ++o->set_count;', '++o->set_count;')
m('scene-init', 'constant', 'o->scene = E0_NO_SCENE;', 'o->scene = 0;')
m('e0-rounds', 'constant', 'o->rounds = 1;\n        o->round = 0;', 'o->rounds = 0;\n        o->round = 0;')
m('e0-scene', 'constant', 'o->scene = rd_s16(b, B_ROUNDS);', 'o->scene = E0_NO_SCENE;')
m('e0-col-gap', 'rect', '(uint32_t)(int32_t)rd_s16(b, B_KEY_W) + (uint32_t)(int32_t)rd_s16(b, B_XGAP));',
  '(uint32_t)(int32_t)rd_s16(b, B_KEY_W) + (uint32_t)(int32_t)rd_s16(b, B_YGAP));')
m('e0-row-floor', 'rect', 'const int16_t qi = (int16_t)(int32_t)q;', 'const int16_t qi = (int16_t)(cols != 0 ? (int32_t)i / (int32_t)cols : (int32_t)q);')
# ---- pointer
m('pointer-exit-area-edge', 'compare', 'x <= rd_s32(b, B_EXIT_AREA + 8)) {', 'x < rd_s32(b, B_EXIT_AREA + 8)) {')
m('pointer-key-edge', 'compare', 'x <= o->rect_b[i][2]) {', 'x < o->rect_b[i][2]) {')
m('pointer-exit-rect-edge', 'compare', 'y <= rd_s32(b, B_EXIT_RECT + 12) &&', 'y < rd_s32(b, B_EXIT_RECT + 12) &&')
m('pointer-waiting-exit', 'predicate', 'if (o->waiting == 0u && b[B_HAS_EXIT] != 0u && y >= rd_s32(b, B_EXIT_RECT + 4)',
  'if (b[B_HAS_EXIT] != 0u && y >= rd_s32(b, B_EXIT_RECT + 4)')
m('pointer-hover-reset', 'state-transition', '    o->hover = -1;\n    return E0_OK;', '    o->hover = 0;\n    return E0_OK;')
m('pointer-exit-candidate', 'constant', 'pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);', 'pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_KEY);')
# ---- click
m('click-ordered-untype', 'predicate', 'if (o->lit[hv] != 0u && b[B_ORDERED] != 0u) {', 'if (o->lit[hv] != 0u) {')
m('click-typed-clamp', 'compare', 'if (o->typed > n) o->typed = n;', 'if (o->typed >= n) o->typed = n;')
m('click-record-bound', 'compare', 'o->recorded <= n - 1', 'o->recorded < n - 1')
m('click-code-clamp', 'compare', 'o->typed > o->code_len) o->typed = o->code_len;', 'o->typed >= o->code_len) o->typed = o->code_len;')
m('click-shift-bound', 'compare', 'i < o->code_len - 1; ++i) o->player[i] = o->player[i + 1];', 'i < o->code_len; ++i) o->player[i] = o->player[i + 1];')
m('click-exit-button', 'predicate', 'if (b[B_HAS_EXIT] != 0u && o->hover == E0_EXIT_KEY) {', 'if (o->hover == E0_EXIT_KEY) {')
m('click-record-set-count', 'predicate', 'if (o->set_count > 0 && o->recorded <= n - 1) {', 'if (o->recorded <= n - 1) {')
# ---- the code check and the code sets
m('typed-equal', 'compare', 'o->typed == o->code_len) {\n        o->solved = 1u;', 'o->typed >= o->code_len) {\n        o->solved = 1u;')
m('scratch-index', 'rect', 'o->scratch[o->code_len] = -1;', 'o->scratch[m] = -1;')
m('record-index-n', 'rect', 'o->record[n] = -1; /* index N, not m (original) */', 'o->record[m] = -1;')
m('scratch-copy', 'missing-effect', 'memcpy(o->scratch, o->player, sizeof(o->scratch));', 'memset(o->scratch, 0xff, sizeof(o->scratch));')
m('set-hit-sense', 'predicate', 'if (flagm) {\n                        o->solved_sets = 1u;', 'if (!flagm) {\n                        o->solved_sets = 1u;')
m('exit-keep-recorded', 'missing-effect', 'o->recorded = 0;\n            clear_typed = 1;', 'clear_typed = 1;')
# ---- render
m('render-key-src', 'rect', 'E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);', 'E0_ROLE_KEY_DOWN, o->rect_b[i], vx, vy, o->rect_b[i]);')
m('render-view-y', 'rect', 'bl->dst[1] = dst_raw[1] + vy;', 'bl->dst[1] = dst_raw[1] + vx;')
m('render-blink-sense', 'predicate', 'if (o->blink != 0u) {\n                    rc = add_blit(plan, E0_BLIT_BG_KEYED',
  'if (o->blink == 0u) {\n                    rc = add_blit(plan, E0_BLIT_BG_KEYED')
m('render-exit-waiting', 'missing-effect', 'E0_ROLE_EXIT_DOWN, src, vx, vy, dst);\n            o->waiting = 1u;',
  'E0_ROLE_EXIT_DOWN, src, vx, vy, dst);')
m('render-light-count', 'compare', 'for (int16_t i = 0; i < o->round; ++i) {', 'for (int16_t i = 0; i < o->round - 1; ++i) {')
m('render-active-index', 'rect', 'const size_t last = (size_t)(o->round - 1);', 'const size_t last = (size_t)(o->round);')
m('render-light-empty', 'predicate', 'rd_rect(b, d, dst);\n            if (dst[3] - dst[1] != 0) {\n                rd_rect(b, B_LIGHT_SRC',
  'rd_rect(b, d, dst);\n            if (dst[2] - dst[0] != 0) {\n                rd_rect(b, B_LIGHT_SRC')


# Mutants proved equivalent by reading the code: they cannot change any observable behaviour, so a surviving run is the
# expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    'click-shift-bound': 'the extra iteration i == code_len - 1 copies player[code_len] into player[code_len - 1], which the next '
                         'statement overwrites with the hover index; for code_len <= 0 neither loop runs',
    'click-typed-clamp': 'when typed == N the clamp assigns N to typed, which already is N: `>` and `>=` give the same value',
    'click-code-clamp': 'when typed == code_len the clamp assigns code_len to typed, which already is code_len',
    'invalidate-active': 'slot != -1 implies active != 0: phase 0 sets active before it takes a slot, phase 2 clears both in the '
                         'same visit (the cleanup sets slot -1) and no poke touches active or slot',
}


def apply(text, old, new, count, which):
    n = text.count(old)
    if n != count:
        raise ValueError('site found %d times, expected %d' % (n, count))
    pos = -1
    for _ in range(which + 1):
        pos = text.index(old, pos + 1)
    return text[:pos] + new + text[pos + len(old):]


def run_oracle(src_dir, workers, quick, result):
    cmd = [sys.executable, str(ORACLE), '--kernel-src', str(src_dir), '--workers', str(workers), '--result', str(result), '--fail-fast']
    if quick:
        cmd.append('--quick')
    env = dict(os.environ)
    env['TMPDIR'] = str(src_dir)
    done = subprocess.run(cmd, capture_output=True, text=True, env=env)
    if not result.exists():
        return None, done.stderr[-600:]
    data = json.loads(result.read_text())
    return data, done.stderr[-300:]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--stage', choices=('quick', 'full'), default='quick')
    ap.add_argument('--only')
    ap.add_argument('--workers', type=int, default=min(4, os.cpu_count() or 1))
    ap.add_argument('--result', type=Path)
    ap.add_argument('--list', action='store_true', help='check the edit sites only')
    a = ap.parse_args()
    kernel_text = (PROJECT / 'src' / KERNEL).read_text()
    work = Path(tempfile.mkdtemp(prefix='e0_mut_'))
    rows = []
    t0 = time.monotonic()
    for name, cls, old, new, count, which in M:
        if a.only and a.only not in name:
            continue
        d = work / name
        d.mkdir()
        for h in (PROJECT / 'src').glob('action_family_e0_runtime*.h'):
            shutil.copy(h, d / h.name)
        row = dict(name=name, cls=cls)
        try:
            mutated = apply(kernel_text, old, new, count, which)
        except ValueError as e:
            row.update(verdict='INVALID', detail=str(e))
            rows.append(row)
            print(name, row['verdict'], row['detail'], flush=True)
            continue
        if a.list:
            row.update(verdict='SITE-OK')
            rows.append(row)
            continue
        (d / KERNEL).write_text(mutated)
        data, err = run_oracle(d, a.workers, a.stage == 'quick', d / 'result.json')
        if data is None:
            row.update(verdict='INVALID', detail='build or oracle error: ' + err.replace('\n', ' ')[:300])
        else:
            row.update(verdict='KILLED' if data['failures'] > 0 else 'SURVIVED', stage=a.stage,
                       failures=data['failures'], scenarios=data['scenarios_total'],
                       first=(data.get('failure_sample') or [{}])[0].get('id'),
                       first_kind=(data.get('failure_sample') or [{}])[0].get('kind'))
            if data['failures'] == 0 and a.stage == 'quick':
                full, err = run_oracle(d, a.workers, False, d / 'result_full.json')
                if full is not None:
                    row.update(stage='full', failures=full['failures'], scenarios=full['scenarios_total'],
                               verdict='KILLED' if full['failures'] > 0 else 'SURVIVED',
                               first=(full.get('failure_sample') or [{}])[0].get('id'),
                               first_kind=(full.get('failure_sample') or [{}])[0].get('kind'))
        rows.append(row)
        print(name, row['verdict'], row.get('stage', ''), row.get('failures', ''), row.get('first', ''), flush=True)
    for r in rows:
        if r['verdict'] == 'SURVIVED' and r['name'] in EQUIVALENT:
            r['verdict'] = 'EQUIVALENT'
            r['reason'] = EQUIVALENT[r['name']]
    killed = sum(1 for r in rows if r['verdict'] == 'KILLED')
    out = dict(mutants_total=len(rows), killed=killed, survived=[r['name'] for r in rows if r['verdict'] == 'SURVIVED'],
               invalid=[r['name'] for r in rows if r['verdict'] == 'INVALID'],
               equivalent=[r['name'] for r in rows if r['verdict'] == 'EQUIVALENT'], rows=rows,
               seconds=round(time.monotonic() - t0, 1), source_sha256=None)
    out['source_sha256'] = hashlib.sha256((PROJECT / 'src' / KERNEL).read_bytes()).hexdigest()
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k != 'rows'}, indent=1))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 0 if not out['survived'] and not out['invalid'] else 1  # equivalent mutants do not fail the check


if __name__ == '__main__':
    sys.exit(main())
