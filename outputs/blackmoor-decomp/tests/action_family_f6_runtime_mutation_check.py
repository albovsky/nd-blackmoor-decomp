#!/usr/bin/env python3
"""RT-47 mutation check for the raw-0xf6 oracle.

Every mutant is a one-site textual edit of a COPY of src/action_family_f6_runtime.c (the project file is never
touched). Each mutant is built into a driver library and run through the original-x86 oracle
(action_family_f6_runtime_original_oracle.py). A mutant is KILLED when the oracle reports at least one mismatch
against the unmodified GAME.EXE image; it SURVIVES when the oracle still reports 0 mismatches; it is INVALID if it does
not compile or the edit site is not found the stated number of times (invalid mutants never count as killed).

Usage:  python3 action_family_f6_runtime_mutation_check.py [--stage quick|full] [--only NAME] [--workers N]
                                                          [--result FILE]
Stage `quick` runs the oracle's --quick subset; survivors are re-run on the full scenario set (--stage full also
runs every mutant on the full set).
"""
import argparse
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
ORACLE = HERE / 'action_family_f6_runtime_original_oracle.py'
KERNEL = 'action_family_f6_runtime.c'

# (name, class, old text, new text, expected occurrences of old text, index of the occurrence to edit)
M = []


def m(name, cls, old, new, count=1, which=0):
    M.append((name, cls, old, new, count, which))


# wrong state transition / wait target
m('turn-wait-target', 'state-transition', 'o->wait_state = 5;\n        }\n        break;\n    case ST_CHOOSE:',
  'o->wait_state = 4;\n        }\n        break;\n    case ST_CHOOSE:')
m('phase0-initial-state', 'state-transition', 'o->outcome_2a9 = 0;\n    o->state = 4;', 'o->outcome_2a9 = 0;\n    o->state = 5;')
m('click-card-state', 'state-transition', 'object->state = ST_CHOOSE;\n    } else if (candidate == F6_CANDIDATE_BUTTON)',
  'object->state = ST_TURN;\n    } else if (candidate == F6_CANDIDATE_BUTTON)')
m('after-line-state', 'state-transition', 'o->state = o->next_state;\n            }', 'o->state = ST_TURN;\n            }')
# swapped constants 300 / 500 / 1000 / 2000
m('const-300-nocard', 'constant', 'o->deadline_state = now + 300u;', 'o->deadline_state = now + 500u;', 2, 0)
m('const-300-ask', 'constant', 'o->deadline_state = now + 300u;', 'o->deadline_state = now + 1000u;', 2, 1)
m('const-500-slide', 'constant', 'o->deadline_state = now + 500u;', 'o->deadline_state = now + 300u;')
m('const-1000-turn', 'constant', 'o->deadline_state = now + 1000u;', 'o->deadline_state = now + 2000u;')
m('const-2000-end', 'constant', 'o->deadline_state = now + 2000u;', 'o->deadline_state = now + 1000u;')
m('const-end-interval', 'constant', 'o->interval = 100;', 'o->interval = 101;')
# wrong modulus operand
m('mod-deal-row', 'modulus', 'row = (int16_t)(r1 % (int32_t)rows_of(c));', 'row = (int16_t)(r1 % (int32_t)cols_of(c));')
m('mod-deal-col', 'modulus', 'col = (int16_t)(r2 % (int32_t)cols_of(c));', 'col = (int16_t)(r2 % (int32_t)rows_of(c));')
m('mod-computer-col', 'modulus', 'col = (int16_t)(r % (int32_t)cols_of(c));', 'col = (int16_t)(r % (int32_t)rows_of(c));')
m('mod-pick-count', 'modulus', 'idx = (int16_t)(r % (int32_t)count);', 'idx = (int16_t)(r % (int32_t)(count - 1));')
m('mod-blink', 'modulus', '+ 1) % 2);', '+ 1) % 3);')
m('mod-anim-frame', 'modulus', 'o->anim_frame = mod16(o->delivery_step, (int16_t)frames);',
  'o->anim_frame = mod16(o->delivery_step + 1, (int16_t)frames);', 2, 0)
# missing / wrong marks and counters
m('missing-mark', 'missing-effect', 'if (o->count[o->player][k] == 3) o->mark[o->player][k] = 1;',
  'if (o->count[o->player][k] == 3) o->mark[o->player][k] = o->mark[o->player][k];')
m('score-increment', 'counter', 'o->score[o->player] = (int16_t)(o->score[o->player] + 1);\n        o->next_state = ST_TURN;\n        CHECK(refill_a(c, o->player));\n        mark_sets(o, c);\n        break;\n    case ST_DRAW:',
  'o->score[o->player] = (int16_t)(o->score[o->player] + 2);\n        o->next_state = ST_TURN;\n        CHECK(refill_a(c, o->player));\n        mark_sets(o, c);\n        break;\n    case ST_DRAW:')
m('player-flip-missing', 'state-transition', 'o->player = (int16_t)(o->player == 0);\n                    o->order[0] = -1;',
  'o->player = o->player;\n                    o->order[0] = -1;')
m('refill-b-zero', 'predicate', 'if (sum == 0 || (int)sum == (int)c->o->score[player] * 3) return deal(c, player, &col);',
  'if ((int)sum == (int)c->o->score[player] * 3) return deal(c, player, &col);')
m('free-pick-bound', 'compare', 'o->deck_left <= cols_of(c);', 'o->deck_left < cols_of(c);')
m('deal-count-limit', 'compare', '(free_pick || o->count[player][col] + 1 < 3)', '(free_pick || o->count[player][col] + 1 <= 3)')
m('mixed-threshold', 'compare', 'if (1 < o->count[0][k]) mixed = 1;', 'if (0 < o->count[0][k]) mixed = 1;')
# wrong rect index / stride
m('render-card-stride', 'rect', 'const size_t slot = B_CARD + (size_t)r * 0xd0u + (size_t)k * 16u;',
  'const size_t slot = B_CARD + (size_t)r * 0xc0u + (size_t)k * 16u;')
m('render-turn-index', 'rect', 'blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_TURN_SRC + (size_t)pl * 16u, B_TURN_DST + (size_t)pl * 16u);',
  'blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_TURN_SRC + (size_t)other * 16u, B_TURN_DST + (size_t)pl * 16u);')
m('render-suit-stride', 'rect', 'B_SUIT_DST + (size_t)pl * 0xd0u + (size_t)k * 16u', 'B_SUIT_DST + (size_t)pl * 0xc0u + (size_t)k * 16u')
m('render-button-index', 'rect', 'B_BUTTON_DOWN + (size_t)o->selected * 16u,\n                  B_BUTTON + (size_t)o->selected * 16u);',
  'B_BUTTON_DOWN + (size_t)o->selected * 16u,\n                  B_BUTTON + (size_t)(o->selected ^ 1) * 16u);')
m('render-kind', 'rect', 'if (o->card[1][r][k] == 0) blit_body(&p, body, F6_BLIT_RESTORE, slot, slot);',
  'if (o->card[1][r][k] == 0) blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, slot, slot);')
m('render-clear-kept', 'missing-effect', 'o->clear_29e = 0;\n    }\n    if (o->slide_step != -1) {', '}\n    if (o->slide_step != -1) {')
m('render-view-y', 'rect', 'blit->dst[1] = (int32_t)((uint32_t)dst_view[1] + (uint32_t)p->vy);',
  'blit->dst[1] = (int32_t)((uint32_t)dst_view[1] + (uint32_t)p->vx);')
m('render-delivery-frame', 'rect', 'B_DELIVER_RECT + (size_t)o->anim_frame * 16u, B_DELIVER_AREA',
  'B_DELIVER_RECT + (size_t)(o->anim_frame + 1) * 16u, B_DELIVER_AREA')
# skipped sound / caption / host effects
m('skip-sound-play', 'missing-effect',
  'HOST(c->h->sound_play(c->h->context, record_channel(o)));\n        fx(c->h, F6_FX_SOUND_PLAY, record_channel(o), 0);',
  '')
m('skip-sound-prepare', 'missing-effect',
  'HOST(c->h->sound_prepare(c->h->context, o->record));\n        fx(c->h, F6_FX_SOUND_PREPARE, 0, 0);\n        HOST(c->h->sound_play(c->h->context, record_channel(o)));',
  'HOST(c->h->sound_play(c->h->context, record_channel(o)));')
m('skip-caption', 'missing-effect', 'HOST(c->h->caption(c->h->context, buffer, len + 3u));', '(void)buffer;')
m('caption-length', 'missing-effect', 'HOST(c->h->caption(c->h->context, buffer, len + 3u));',
  'HOST(c->h->caption(c->h->context, buffer, len + 2u));')
m('idle-sound-busy', 'predicate', 'fx(c->h, F6_FX_SOUND_BUSY, o->channel, busy);\n        if (busy == 0) {\n            copy_name(o->record, name);',
  'fx(c->h, F6_FX_SOUND_BUSY, o->channel, busy);\n        if (busy != 0) {\n            copy_name(o->record, name);')
m('button-line', 'rect', 'CHECK(pick_line(&ctx, B_LINE_PICK, 1));', 'CHECK(pick_line(&ctx, B_LINE_DRAW, 1));')
# win block applied on exit / exit handling
m('win-exit-swap', 'predicate', 'world->start_flag_5bb1ca = 1;\n    fx(h, F6_FX_START_FLAG, 1, 0);\n    if (o->exit_taken == 0) {',
  'world->start_flag_5bb1ca = 1;\n    fx(h, F6_FX_START_FLAG, 1, 0);\n    if (o->exit_taken != 0) {')
m('win-flag-on-exit', 'predicate', 'if (o->exit_taken != 0 || o->finished == 0) return F6_NO_FLAG;', 'if (o->finished == 0) return F6_NO_FLAG;')
m('win-scene-pick', 'predicate', 'const int16_t scene = o->outcome_2a9 == 0 ?', 'const int16_t scene = o->outcome_2a9 != 0 ?')
m('apply-start-word', 'predicate', 'world->start_flag_5bb1ca = start_word != 1 ? 1 : 0;', 'world->start_flag_5bb1ca = start_word != 0 ? 1 : 0;')
m('phase0-start-flag', 'missing-effect', 'world->start_flag_5bb1ca = 1;\n    fx(h, F6_FX_START_FLAG, 1, 0);\n    HOST(h->clear_pending_item',
  'world->start_flag_5bb1ca = 0;\n    fx(h, F6_FX_START_FLAG, 1, 0);\n    HOST(h->clear_pending_item')
# cleanup that keeps the slot / surface
m('cleanup-keeps-slot', 'cleanup', 'HOST(host->release_slot(host->context, slot));\n        fx(host, F6_FX_RELEASE_SLOT, slot, 0);', '(void)slot;')
m('cleanup-slot-not-reset', 'cleanup', 'o->row = -1;\n    o->slot = -1;', 'o->row = -1;')
m('cleanup-keeps-surface', 'cleanup', 'object->surface = 0u;\n        fx(host, F6_FX_RELEASE_SURFACE', 'fx(host, F6_FX_RELEASE_SURFACE')
m('invalidate-active', 'predicate', 'if (object->active != 0 && object->slot != F6_NO_SLOT) {', 'if (object->slot != F6_NO_SLOT) {')
# wrong signed compare (original compares the tick deadlines unsigned)
m('signed-deadline-anim', 'signedness', 'if (o->deadline_anim <= now) {', 'if ((int32_t)o->deadline_anim <= (int32_t)now) {', 4, 0)
m('signed-deadline-slide', 'signedness', 'if (o->deadline_anim <= now) {', 'if ((int32_t)o->deadline_anim <= (int32_t)now) {', 4, 2)
m('signed-deadline-state', 'signedness', 'if (o->deadline_state <= now) o->state = o->wait_state;', 'if ((int32_t)o->deadline_state <= (int32_t)now) o->state = o->wait_state;')
m('wait-strict', 'compare', 'if (o->deadline_state <= now) o->state = o->wait_state;', 'if (o->deadline_state < now) o->state = o->wait_state;')
m('pick-idx-unsigned', 'signedness', 'idx = (int16_t)(r % (int32_t)count);', 'idx = (int16_t)((uint32_t)r % (uint32_t)count);')
m('deal-idx-unsigned', 'signedness', 'row = (int16_t)(r1 % (int32_t)rows_of(c));', 'row = (int16_t)((uint32_t)r1 % (uint32_t)rows_of(c));')
# off-by-one loop bounds
m('loop-sound-a', 'loop-bound', 'for (size_t k = 0; k < 13u; ++k)\n        if (nonempty(b + B_LINES_HUMAN + k * NAME_STRIDE))',
  'for (size_t k = 0; k < 12u; ++k)\n        if (nonempty(b + B_LINES_HUMAN + k * NAME_STRIDE))')
m('loop-sound-b', 'loop-bound', 'for (size_t k = 0; k < 13u; ++k)\n        if (nonempty(b + B_LINES_COMPUTER + k * NAME_STRIDE))',
  'for (size_t k = 0; k < 12u; ++k)\n        if (nonempty(b + B_LINES_COMPUTER + k * NAME_STRIDE))')
m('loop-deal-rounds', 'loop-bound', 'for (int16_t k = 0; k < rd_s16(b, B_DEAL); ++k) {', 'for (int16_t k = 0; k <= rd_s16(b, B_DEAL); ++k) {')
m('loop-order-scan', 'loop-bound', 'for (int16_t k = 0; k <= o->order_count; ++k)', 'for (int16_t k = 0; k < o->order_count; ++k)')
m('loop-render-cols', 'loop-bound', 'for (int k = 0; k < cols; ++k)\n                for (int pl = 0; pl < 2; ++pl)',
  'for (int k = 0; k < cols - 1; ++k)\n                for (int pl = 0; pl < 2; ++pl)')
m('loop-display-flip', 'loop-bound', 'for (int i = 0; i <= o->display_count; ++i) {', 'for (int i = 0; i < o->display_count; ++i) {')
m('loop-find-rows', 'loop-bound', 'for (int16_t r = 0; r < rows_of(c); ++r) {\n        if (c->o->card[player][r][col] == 1) {',
  'for (int16_t r = 0; r < rows_of(c) - 1; ++r) {\n        if (c->o->card[player][r][col] == 1) {')
m('loop-pointer-rows', 'loop-bound', 'for (int r = 0; r < 3; ++r)\n                for (int k = 0; k < cols; ++k) {',
  'for (int r = 0; r < 2; ++r)\n                for (int k = 0; k < cols; ++k) {')
# slide animation
m('slide-direction', 'state-transition', 'o->slide_step + (o->slide_forward == 0 ? -1 : 1)', 'o->slide_step + (o->slide_forward == 0 ? 1 : -1)')
m('slide-forward-end', 'compare', 'rd_s16(b, B_SLIDE_STEPS) <= o->slide_step', 'rd_s16(b, B_SLIDE_STEPS) < o->slide_step')
m('slide-back-offset', 'constant', 'rd_s16(b, B_SLIDE_STEPS) - 1);\n        o->slide_step = 0;',
  'rd_s16(b, B_SLIDE_STEPS));\n        o->slide_step = 0;')
m('slide-sheet-x2', 'rect', 'o->slide_sheet[idx][2] = (int32_t)((uint32_t)o->slide_sheet[idx][2] + (uint32_t)step);',
  'o->slide_sheet[idx][2] = (int32_t)((uint32_t)o->slide_sheet[idx][2] - (uint32_t)step);')
# pointer receiver
m('pointer-card-count', 'compare', 'object->card[1][r][k] == 1 && object->count[1][k] < 3', 'object->card[1][r][k] == 1 && object->count[1][k] <= 3')
m('pointer-y-strict', 'compare', 'if (rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n                        x <= rd_s32(body, rect + 8) && object->card',
  'if (rd_s32(body, rect + 4) <= y && y < rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&\n                        x <= rd_s32(body, rect + 8) && object->card')
m('pointer-exit-x', 'compare', 'rd_s32(body, B_EXIT_RECT) <= x && x <= rd_s32(body, B_EXIT_RECT + 8)',
  'rd_s32(body, B_EXIT_RECT) <= x && x < rd_s32(body, B_EXIT_RECT + 8)')
m('pointer-button-count', 'compare', '0 < object->count[1][k] && object->count[1][k] < 3', '0 <= object->count[1][k] && object->count[1][k] < 3')
m('pointer-state-gate', 'predicate', 'if (object->state == 4) {\n        const int cols', 'if (object->state == 5) {\n        const int cols')


# Mutants proved equivalent by reading the code: they cannot change any observable behaviour, so a surviving run is the
# expected result. They are reported separately and never count as killed.
EQUIVALENT = {
    'invalidate-active': 'slot != F6_NO_SLOT already implies active != 0: phase 0 sets active before it stores a slot and '
                         'put_reset clears both together, so the dropped test is never the deciding one',
    'pick-idx-unsigned': 'the host _rand is 0..32767 (never negative), where signed and unsigned remainders agree; a negative '
                         'draw is outside the contract (the original would index its stack frame negatively)',
    'deal-idx-unsigned': 'the host _rand is 0..32767 (never negative), where signed and unsigned remainders agree',
    'win-flag-on-exit': 'finish_flag is only evaluated for a row that has finished; the original sets exit_taken only while '
                        'finished == 0 and phase 2 follows at once, so exit_taken with finished != 0 is unreachable',
    'mixed-threshold': 'in computer_pick the `mixed` flag only chooses between two branches that both store the same column '
                       'and finish (`1 < count` implies `0 < count`), so `mixed` has no observable effect',
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
    a = ap.parse_args()
    kernel_text = (PROJECT / 'src' / KERNEL).read_text()
    work = Path(tempfile.mkdtemp(prefix='f6_mut_'))
    rows = []
    t0 = time.monotonic()
    for name, cls, old, new, count, which in M:
        if a.only and a.only not in name:
            continue
        d = work / name
        d.mkdir()
        for h in (PROJECT / 'src').glob('action_family_f6_runtime*.h'):
            shutil.copy(h, d / h.name)
        row = dict(name=name, cls=cls)
        try:
            mutated = apply(kernel_text, old, new, count, which)
        except ValueError as e:
            row.update(verdict='INVALID', detail=str(e))
            rows.append(row)
            print(name, row['verdict'], row['detail'], flush=True)
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
    import hashlib
    out['source_sha256'] = hashlib.sha256((PROJECT / 'src' / KERNEL).read_bytes()).hexdigest()
    out['mutation_script_sha256'] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    print(json.dumps({k: v for k, v in out.items() if k != 'rows'}, indent=1))
    if a.result:
        a.result.parent.mkdir(parents=True, exist_ok=True)
        a.result.write_text(json.dumps(out, indent=1, sort_keys=True))
    return 0 if not out['survived'] and not out['invalid'] else 1  # equivalent mutants do not fail the check


if __name__ == '__main__':
    sys.exit(main())
