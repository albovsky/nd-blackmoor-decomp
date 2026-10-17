"""RT-57: raw 0x6d and 0x9a (src/session_bindings_a6d_a9a.c over src/action_family_{6d,9a}_runtime.c).

Facts under test (original GAME.EXE, dispatcher 0x427a50, both arms gate mode 0 and ending in a direct completion-byte store):
 * 0x6d (arm 0x4290c0): a teardown chosen from the cells [0x5bb22a] (overlay, 0x4e303b), [0x583204] == 4 (0x4eb96e) or == 3
   (0x4e7d04), then 0x4fb018 unloads the scene sound and the outer-state cells are stored (0x583981 := 6, 0x5839a1 := 0,
   0x583999 := 0, 0x5bb1e2 := 0). The phase word is not written.
 * 0x9a (arm 0x429d34 -> 0x4336ad(row, 0)): phase 0 -> 2 (pending); phase 2 stops the sound channels (0x14: 0..13, 0x15: 1..13,
   else one), optionally takes the scene-change cells and stores an event flag, then completes directly; other phases nothing.
The unit cases live in tests/action_family_6d_9a_runtime_test.c; the corpus driver runs the 2 real rows of scene S6301; the
executor driver runs synthetic rows through the production scene executor. The original-x86 oracle is another worker's file.
"""
import concurrent.futures
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
ROOT = PROJECT.parents[1]
SRC = PROJECT / 'src'
TEST_C = PROJECT / 'tests/action_family_6d_9a_runtime_test.c'
CORPUS_C = PROJECT / 'tests/action_family_6d_9a_runtime_corpus.c'
EXECUTOR_C = PROJECT / 'tests/action_family_6d_9a_runtime_executor.c'
KERNEL_SOURCES = ['session_bindings_a6d_a9a.c', 'action_family_6d_runtime.c', 'action_family_9a_runtime.c', 'action_family_6d.c',
                  'action_family_9a.c']
CORPUS_SOURCES = KERNEL_SOURCES + ['scene_resource.c', 'hiff.c']
EXECUTOR_SOURCES = CORPUS_SOURCES + ['scene_executor.c', 'scene_conditions.c', 'scene_dependencies.c', 'action_family_64.c',
                                     'action_core.c']
RESOURCES = ROOT / 'work/analysis/hiff-resources'
EXPECTED_UNIT_TESTS = 18

sys.path.insert(0, str(PROJECT / 'tests'))
import test_scene_executor as base  # noqa: E402


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


def compile_c(output, main_c, sources, src_dir=SRC):
    cmd = [compiler(), '-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-O1', '-g',
           f'-I{src_dir}', str(main_c), *[str(Path(src_dir) / s) for s in sources], '-lm', '-o', str(output)]
    return subprocess.run(cmd, capture_output=True, text=True)


def run_unit(binary):
    done = subprocess.run([str(binary)], capture_output=True, text=True)
    results = {}
    for line in done.stdout.splitlines():
        status, _, rest = line.partition(' ')
        if status in ('PASS', 'FAIL'):
            name, _, message = rest.partition(': ')
            results[name] = (status, message)
    return done.returncode, results


def mutated_copy(tmp, filename, old, new, tag='mut'):
    original = (SRC / filename).read_text()
    assert original.count(old) == 1, 'mutation anchor drifted: ' + old
    work = Path(tmp) / tag
    shutil.rmtree(work, ignore_errors=True)
    work.mkdir()
    for item in SRC.iterdir():
        if item.suffix in ('.c', '.h'):
            shutil.copy(item, work / item.name)
    (work / filename).write_text(original.replace(old, new, 1))
    return work


def i16(value):
    return struct.pack('<h', value)


def body9a(sound=5, scene=9999, w4=0, w6=0, w8=0, d10=0, d14=0, d18=0, flag_index=-1, flag_value=0, start_word=0):
    return (i16(sound) + i16(scene) + i16(w4) + i16(w6) + i16(w8) + struct.pack('<III', d10, d14, d18) + i16(flag_index) +
            bytes([flag_value]) + struct.pack('<H', start_word))


def flag_is(index, value):
    return base.condition(2, index, value)


def scene_with_transition():
    """0x9a (sound 3, scene 6301, word 7, event flag 2 := 9) ungated, then a 0x6d behind event flag 5."""
    return base.scene_bytes([base.action(0x9a, 1, body9a(sound=3, scene=6301, w4=7, flag_index=2, flag_value=9)),
                             base.action(0x6d, 1, b'\0', (flag_is(5, 1),))])


def scene_with_plain_rows():
    """0x6d behind event flag 1, then a 0x9a that stops channels 0..13 with no scene and no flag."""
    return base.scene_bytes([base.action(0x6d, 1, b'\0', (flag_is(1, 1),)),
                             base.action(0x9a, 1, body9a(sound=0x14))])


K6, K9, B = 'action_family_6d_runtime.c', 'action_family_9a_runtime.c', 'session_bindings_a6d_a9a.c'
ARG_OK = ' != 0) {'
# each mutant must be caught by the unit cases
MUTANTS = {
    K6: {
        'overlay test inverted': ('if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a == 0) {'),
        'overlay loses to mode 4': ('if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a != 0 && world->popup_mode_583204 != 4) {'),
        'overlay loses to mode 3': ('if (world->overlay_flag_5bb22a != 0) {', 'if (world->overlay_flag_5bb22a != 0 && world->popup_mode_583204 != 3) {'),
        'overlay ignored': ('if (world->overlay_flag_5bb22a != 0) {', 'if (0) {'),
        'mode 4 compare': ('if (world->popup_mode_583204 == 4) {', 'if (world->popup_mode_583204 == 5) {'),
        'mode 3 compare': ('if (world->popup_mode_583204 == 3) {', 'if (world->popup_mode_583204 == 2) {'),
        'mode 4 any nonzero': ('if (world->popup_mode_583204 == 4) {', 'if (world->popup_mode_583204 != 0 && world->popup_mode_583204 != 3) {'),
        'mode 3 any nonzero': ('if (world->popup_mode_583204 == 3) {', 'if (world->popup_mode_583204 != 0) {'),
        'mode 4 kind is the mode 3 one': ('return ACTION_FAMILY_6D_TEARDOWN_MODE4;', 'return ACTION_FAMILY_6D_TEARDOWN_MODE3;'),
        'mode 3 kind is the mode 4 one': ('return ACTION_FAMILY_6D_TEARDOWN_MODE3;', 'return ACTION_FAMILY_6D_TEARDOWN_MODE4;'),
        'teardown refusal dropped': ('if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE && host->teardown == NULL) {', 'if (0) {'),
        'teardown refused for every kind': ('if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE && host->teardown == NULL) {', 'if (host->teardown == NULL) {'),
        'teardown skipped': ('if (host->teardown(host->context, kind) != 0) {', 'if (0) {'),
        'teardown failure ignored': ('if (host->teardown(host->context, kind) != 0) {', 'if (host->teardown(host->context, kind) != 0 && 0) {'),
        'teardown failure not an error': ('if (host->teardown(host->context, kind) != 0) {                  /* 0x4290f5, 0x42910a, 0x42911f */\n            return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;',
                                          'if (host->teardown(host->context, kind) != 0) {                  /* 0x4290f5, 0x42910a, 0x42911f */\n            return ACTION_FAMILY_6D_RUNTIME_OK;'),
        'popup mode kept': ('next.popup_mode_583204 = 0;', 'next.popup_mode_583204 = 1;'),
        'popup mode never cleared': ('next.popup_mode_583204 = 0;', ''),
        'overlay flag kept': ('next.overlay_flag_5bb22a = 0;', 'next.overlay_flag_5bb22a = 1;'),
        'overlay flag never cleared': ('next.overlay_flag_5bb22a = 0;', ''),
        'return scene value': ('next.overlay_return_6b2 = ACTION_FAMILY_6D_STORED_RETURN_SCENE;', 'next.overlay_return_6b2 = 0;'),
        'return scene never stored': ('next.overlay_return_6b2 = ACTION_FAMILY_6D_STORED_RETURN_SCENE;', ''),
        'return scene for every teardown': ('        if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {', '        if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE) {'),
        'return scene for the mode teardowns only': ('        if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {', '        if (kind != ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {'),
        'unload skipped': ('if (host->unload_scene_sound(host->context) != 0) {', 'if (0) {'),
        'unload failure ignored': ('if (host->unload_scene_sound(host->context) != 0) {', 'if (host->unload_scene_sound(host->context) != 0 && 0) {'),
        'unload before the teardown': ('    next = *world;\n', '    next = *world;\n    host->unload_scene_sound(host->context);\n'),
        'unload failure not an error': ('if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429129 */\n        return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;',
                                        'if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429129 */\n        return ACTION_FAMILY_6D_RUNTIME_OK;'),
        'outer state 5': ('next.outer_state_583981 = 6;', 'next.outer_state_583981 = 5;'),
        'cell 5839a1 not cleared': ('next.cell_5839a1 = 0;', 'next.cell_5839a1 = 1;'),
        'engine mode 1': ('next.engine_mode_583999 = 0;', 'next.engine_mode_583999 = 1;'),
        'cell 5bb1e2 not cleared': ('next.cell_5bb1e2 = 0;', 'next.cell_5bb1e2 = 1;'),
        'world not committed': ('    *world = next;\n', ''),
        'null decoded accepted': ('if (decoded == NULL || world == NULL', 'if ((void)decoded, world == NULL'),
        'null world accepted': ('|| world == NULL || host == NULL', '|| host == NULL'),
        'null host accepted': ('|| host == NULL || host->unload_scene_sound == NULL', '|| host->unload_scene_sound == NULL'),
        'missing unload accepted': ('|| host->unload_scene_sound == NULL) {', ') {'),
    },
    K9: {
        'phase 0 compare': ('if (phase == 0u) {', 'if (phase == 1u) {'),
        'phase 0 stores 1': ('outcome->phase = 2u;', 'outcome->phase = 1u;'),
        'phase 0 keeps 0': ('outcome->phase = 2u;', 'outcome->phase = 0u;'),
        'phase 2 compare': ('if (phase != 2u) {', 'if (phase > 2u) {'),
        'phase 2 compare 3': ('if (phase != 2u) {', 'if (phase != 3u) {'),
        'initial phase dropped': ('outcome->phase = phase;', 'outcome->phase = 0u;'),
        'initial disposition completed': ('outcome->disposition = SCENE_ACTION_HANDLER_PENDING;', 'outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
        'final disposition pending': ('outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;        /* 0x4338b0: completion byte := 1 */', 'outcome->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        'final disposition generic': ('outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;        /* 0x4338b0: completion byte := 1 */', 'outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
        'worked flag dropped': ('outcome->worked = 1;', 'outcome->worked = 0;'),
        'transition flag dropped': ('outcome->transition = 1;', 'outcome->transition = 0;'),
        'stop all from 0x13': ('#define STOP_ALL_FROM_0 0x14', '#define STOP_ALL_FROM_0 0x13'),
        'stop all from 0x15': ('#define STOP_ALL_FROM_0 0x14', '#define STOP_ALL_FROM_0 0x15'),
        'stop from one is 0x16': ('#define STOP_ALL_FROM_1 0x15', '#define STOP_ALL_FROM_1 0x16'),
        'stop from one is 0x14': ('#define STOP_ALL_FROM_1 0x15', '#define STOP_ALL_FROM_1 0x14'),
        'channel end 13': ('#define STOP_CHANNEL_END 14', '#define STOP_CHANNEL_END 13'),
        'channel end 15': ('#define STOP_CHANNEL_END 14', '#define STOP_CHANNEL_END 15'),
        'loop start inverted': ('(int16_t)(sound != STOP_ALL_FROM_0)', '(int16_t)(sound == STOP_ALL_FROM_0)'),
        'loop always from zero': ('(int16_t)(sound != STOP_ALL_FROM_0)', '(int16_t)0'),
        'loop always from one': ('(int16_t)(sound != STOP_ALL_FROM_0)', '(int16_t)1'),
        'channel cast narrows': ('host->stop_channel(host->context, (uint16_t)sound)', 'host->stop_channel(host->context, (uint16_t)(sound & 0xff))'),
        'single stop channel off by one': ('host->stop_channel(host->context, (uint16_t)sound)', 'host->stop_channel(host->context, (uint16_t)(sound + 1))'),
        'loop stop failure ignored': ('if (host->stop_channel(host->context, (uint16_t)channel) != 0) {', 'if (host->stop_channel(host->context, (uint16_t)channel) != 0 && 0) {'),
        'single stop failure ignored': ('} else if (host->stop_channel(host->context, (uint16_t)sound) != 0) {', '} else if (host->stop_channel(host->context, (uint16_t)sound) != 0 && 0) {'),
        'single stop skipped': ('} else if (host->stop_channel(host->context, (uint16_t)sound) != 0) {', '} else if (0) {'),
        'flag sentinel is 0': ('if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {', 'if (flag_index != 0 && host->event_flag_invalid(host->context, flag_index) != 0) {'),
        'flag query always': ('if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {', 'if (host->event_flag_invalid(host->context, flag_index) != 0) {'),
        'flag query inverted': ('host->event_flag_invalid(host->context, flag_index) != 0) {', 'host->event_flag_invalid(host->context, flag_index) == 0) {'),
        'flag query dropped': ('if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {', 'if (0) {'),
        'flag refusal is a host error': ('        return ACTION_FAMILY_9A_RUNTIME_ERR_FLAG;', '        return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;'),
        'flag index from the wrong word': ('flag_index = (int16_t)decoded->word[11];', 'flag_index = (int16_t)decoded->word[10];'),
        'sound from the wrong word': ('sound = (int16_t)decoded->word[0];', 'sound = (int16_t)decoded->word[1];'),
        'scene from the wrong word': ('scene = (int16_t)decoded->word[1];', 'scene = (int16_t)decoded->word[0];'),
        'scene compare inverted': ('if (scene != ACTION_FAMILY_9A_SCENE_NONE) {', 'if (scene == ACTION_FAMILY_9A_SCENE_NONE) {'),
        'negative scene dropped': ('if (scene != ACTION_FAMILY_9A_SCENE_NONE) {', 'if (scene != ACTION_FAMILY_9A_SCENE_NONE && scene >= 0) {'),
        'scene limit 10000': ('if (scene != ACTION_FAMILY_9A_SCENE_NONE) {', 'if (scene < ACTION_FAMILY_9A_SCENE_NONE) {'),
        'scene cell wrong': ('next.scene_5bb57b = scene;', 'next.scene_5bb57b = 0;'),
        'word 5bb599 wrong': ('next.word_5bb599 = (int16_t)decoded->word[2];', 'next.word_5bb599 = (int16_t)decoded->word[3];'),
        'word 5bb595 wrong': ('next.word_5bb595 = (int16_t)decoded->word[3];', 'next.word_5bb595 = (int16_t)decoded->word[2];'),
        'word 5c39ff wrong': ('next.word_5c39ff = (int16_t)decoded->word[4];', 'next.word_5c39ff = (int16_t)decoded->word[3];'),
        'dword 5bb59b wrong': ('next.dword_5bb59b = (int32_t)body_dword(decoded, 5u);', 'next.dword_5bb59b = (int32_t)body_dword(decoded, 7u);'),
        'dword 5bb59f wrong': ('next.dword_5bb59f = (int32_t)body_dword(decoded, 7u);', 'next.dword_5bb59f = (int32_t)body_dword(decoded, 9u);'),
        'dword 5bb5a3 wrong': ('next.dword_5bb5a3 = (int32_t)body_dword(decoded, 9u);', 'next.dword_5bb5a3 = (int32_t)body_dword(decoded, 5u);'),
        'dword high half shift': ('((uint32_t)d->word[word_index + 1u] << 16)', '((uint32_t)d->word[word_index + 1u] << 8)'),
        'dword high half dropped': ('((uint32_t)d->word[word_index + 1u] << 16)', '0u'),
        'dword halves swapped': ('(uint32_t)d->word[word_index] | ((uint32_t)d->word[word_index + 1u] << 16)', '(uint32_t)d->word[word_index + 1u] | ((uint32_t)d->word[word_index] << 16)'),
        'start flag inverted': ('!= 1);', '== 1);'),
        'start flag compare 0': ('!= 1);', '!= 0);'),
        'start word high byte lost': ('((uint16_t)decoded->byte_26 << 8)', '0u'),
        'start word high byte unshifted': ('((uint16_t)decoded->byte_26 << 8)', '((uint16_t)decoded->byte_26)'),
        'start word low byte dropped': ('(decoded->word[12] >> 8) |', '0u |'),
        'start word low byte from byte 24': ('(decoded->word[12] >> 8) |', '(decoded->word[12] & 0xffu) |'),
        'engine mode 3': ('next.engine_mode_583999 = 4;', 'next.engine_mode_583999 = 3;'),
        'engine mode not stored': ('next.engine_mode_583999 = 4;', ''),
        'flag store skipped': ('    if (flag_index != -1 &&\n        host->store_event_flag(', '    if (0 &&\n        host->store_event_flag('),
        'flag store sentinel is 0': ('    if (flag_index != -1 &&\n        host->store_event_flag(', '    if (flag_index != 0 &&\n        host->store_event_flag('),
        'flag value high byte': ('(uint32_t)(decoded->word[12] & 0xffu)', '(uint32_t)(decoded->word[12] >> 8)'),
        'flag value whole word': ('(uint32_t)(decoded->word[12] & 0xffu)', '(uint32_t)decoded->word[12]'),
        'flag value sign extended': ('(uint32_t)(decoded->word[12] & 0xffu)', '(uint32_t)(int8_t)(decoded->word[12] & 0xffu)'),
        'flag store failure ignored': ('0) { /* 0x43889f */', '0 && 0) { /* 0x43889f */'),
        'flag store failure not an error': ('(uint32_t)(decoded->word[12] & 0xffu)) != 0) { /* 0x43889f */\n        return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;',
                                            '(uint32_t)(decoded->word[12] & 0xffu)) != 0) { /* 0x43889f */\n        return ACTION_FAMILY_9A_RUNTIME_OK;'),
        'world not committed': ('    *world = next;\n', ''),
        'null decoded accepted': ('if (decoded == NULL || world == NULL', 'if (world == NULL'),
        'null outcome accepted': ('|| outcome == NULL || host->stop_channel == NULL', '|| host->stop_channel == NULL'),
        'null stop host accepted': ('|| host->stop_channel == NULL ||', '||'),
        'null query host accepted': ('host->event_flag_invalid == NULL ||', ''),
        'null store host accepted': ('|| host->store_event_flag == NULL) {', ') {'),
    },
    B: {
        # raw 0x6d binding
        'a6d type check dropped': ('|| action->type != SESSION_A6D_TYPE) {', ') {'),
        'a6d decode failure ignored': ('if (action_family_6d_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_6D_OK) {', 'if (action_family_6d_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_6D_OK && 0) {'),
        'a6d load refusal ignored': ('if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {', 'if (b->host.load_world == NULL) {'),
        'a6d load refusal is an error': ('b->failure = "world provider (cells 0x583204, 0x5bb22a)";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'b->failure = "world provider (cells 0x583204, 0x5bb22a)";\n        return SCENE_ACTION_HANDLER_ERROR;'),
        'a6d unload check dropped': ('if (b->host.unload_scene_sound == NULL) {', 'if (0) {'),
        'a6d teardown host dropped': ('kernel_host.teardown = b->host.teardown;', 'kernel_host.teardown = NULL;'),
        'a6d teardown refusal is an error': ('b->failure = "popup teardown (0x4eb96e / 0x4e7d04 / 0x4e303b) has no host";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'b->failure = "popup teardown (0x4eb96e / 0x4e7d04 / 0x4e303b) has no host";\n        return SCENE_ACTION_HANDLER_ERROR;'),
        'a6d teardown refusal mapping dropped': ('if (status == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN) {', 'if (0) {'),
        'a6d kernel failure ignored': ('if (status != ACTION_FAMILY_6D_RUNTIME_OK) {', 'if (status != ACTION_FAMILY_6D_RUNTIME_OK && 0) {'),
        'a6d last world dropped': ('    b->last_world = world;\n    ++b->visits;', '    ++b->visits;'),
        'a6d visits dropped': ('    b->last_world = world;\n    ++b->visits;', '    b->last_world = world;'),
        'a6d failure not cleared': ('    b->failure = "none";\n    b->last_world = world;', '    b->last_world = world;'),
        'a6d store skipped': ('    if (b->host.store_world != NULL) {\n        b->host.store_world(b->host.context, &world);\n    }\n    out->phase = before->phase;', '    out->phase = before->phase;'),
        'a6d store before the failure checks': ('    kernel_host.context = b->host.context;\n    kernel_host.unload_scene_sound', '    b->host.store_world(b->host.context, &world);\n    kernel_host.context = b->host.context;\n    kernel_host.unload_scene_sound'),
        'a6d phase reset': ('out->phase = before->phase;                                  /* the phase word is not written */', 'out->phase = 0u;'),
        'a6d left pending': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163: completion byte := 1 */', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
        'a6d completes generically': ('out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163: completion byte := 1 */', 'out->disposition = SCENE_ACTION_HANDLER_COMPLETED;'),
        'a6d null binding accepted': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A6D_TYPE) {', 'if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A6D_TYPE) {'),
        'a6d null action accepted': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A6D_TYPE) {', 'if (b == NULL || before == NULL || out == NULL || action->type != SESSION_A6D_TYPE) {'),
        'a6d failure text': ('return b == NULL ? "invalid binding" : b->failure;\n}\n\nconst Action6DWorld', 'return b == NULL ? "none" : b->failure;\n}\n\nconst Action6DWorld'),
        'a6d create ignores a null host': ('    SessionA6dBinding *b;\n    if (host == NULL) {\n        return NULL;\n    }', '    SessionA6dBinding *b;'),
        # raw 0x9a binding
        'a9a type check dropped': ('|| action->type != SESSION_A9A_TYPE) {', ') {'),
        'a9a decode failure ignored': ('if (action_family_9a_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_9A_OK) {', 'if (action_family_9a_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_9A_OK && 0) {'),
        'a9a stop host check dropped': ('if (b->host.stop_channel == NULL || b->host.event_flag_invalid == NULL', 'if (b->host.event_flag_invalid == NULL'),
        'a9a query host check dropped': ('b->host.event_flag_invalid == NULL || b->host.store_event_flag == NULL) {', 'b->host.store_event_flag == NULL) {'),
        'a9a store host check dropped': ('b->host.event_flag_invalid == NULL || b->host.store_event_flag == NULL) {', 'b->host.event_flag_invalid == NULL) {'),
        'a9a host check is an error': ('b->failure = "sound channel stop (0x4fc878) or event flag provider";\n        return SCENE_ACTION_HANDLER_UNSUPPORTED;', 'b->failure = "sound channel stop (0x4fc878) or event flag provider";\n        return SCENE_ACTION_HANDLER_ERROR;'),
        'a9a transition host check inverted': ('if ((int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL) {', 'if ((int16_t)decoded.word[1] == ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL) {'),
        'a9a transition host check dropped': ('if ((int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL) {', 'if (0) {'),
        'a9a transition host check unsigned': ('if ((int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL) {', 'if ((int16_t)decoded.word[1] > 0 && b->host.transition == NULL) {'),
        'a9a load refusal ignored': ('if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0) {', 'if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0 && 0) {'),
        'a9a load refusal inverted': ('if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0) {', 'if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) == 0) {'),
        'a9a flag mapping dropped': ('if (status == ACTION_FAMILY_9A_RUNTIME_ERR_FLAG) {', 'if (0) {'),
        'a9a kernel failure ignored': ('if (status != ACTION_FAMILY_9A_RUNTIME_OK) {', 'if (status != ACTION_FAMILY_9A_RUNTIME_OK && 0) {'),
        'a9a worked check dropped': ('if (outcome.worked != 0u) {', 'if (1) {'),
        'a9a last world dropped': ('        b->last_world = world;\n        if (b->host.store_world', '        if (b->host.store_world'),
        'a9a store skipped': ('        if (b->host.store_world != NULL) {\n            b->host.store_world(b->host.context, &world);\n        }\n', ''),
        'a9a transition check dropped': ('if (outcome.transition != 0u) {', 'if (1) {'),
        'a9a transition never': ('if (outcome.transition != 0u) {', 'if (0) {'),
        'a9a target unsigned': ('request.target_scene = (int16_t)world.scene_5bb57b;', 'request.target_scene = (int16_t)(world.scene_5bb57b & 0x7fff);'),
        'a9a request word 0': ('request.opaque_words[0] = world.word_5bb599;', 'request.opaque_words[0] = world.word_5bb595;'),
        'a9a request word 1': ('request.opaque_words[1] = world.word_5bb595;', 'request.opaque_words[1] = world.word_5bb599;'),
        'a9a request word 2': ('request.opaque_words[2] = world.word_5c39ff;', 'request.opaque_words[2] = world.word_5bb595;'),
        'a9a request dword 0': ('request.opaque_dwords[0] = world.dword_5bb59b;', 'request.opaque_dwords[0] = world.dword_5bb59f;'),
        'a9a request dword 1': ('request.opaque_dwords[1] = world.dword_5bb59f;', 'request.opaque_dwords[1] = world.dword_5bb5a3;'),
        'a9a request dword 2': ('request.opaque_dwords[2] = world.dword_5bb5a3;', 'request.opaque_dwords[2] = world.dword_5bb59b;'),
        'a9a transition refusal ignored': ('if (b->host.transition(b->host.context, &request) != 0) {', 'if (b->host.transition(b->host.context, &request) != 0 && 0) {'),
        'a9a visits dropped': ('    ++b->visits;\n    out->phase = outcome.phase;', '    out->phase = outcome.phase;'),
        'a9a failure not cleared': ('    b->failure = "none";\n    ++b->visits;\n    out->phase = outcome.phase;', '    ++b->visits;\n    out->phase = outcome.phase;'),
        'a9a phase from the row': ('out->phase = outcome.phase;', 'out->phase = before->phase;'),
        'a9a phase zero': ('out->phase = outcome.phase;', 'out->phase = 0u;'),
        'a9a disposition': ('out->disposition = outcome.disposition;', 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;'),
        'a9a kernel gets phase 0': ('action_family_9a_runtime_visit(&decoded, before->phase, &world, &kernel_host, &outcome)', 'action_family_9a_runtime_visit(&decoded, 2u, &world, &kernel_host, &outcome)'),
        'a9a kernel host stop dropped': ('kernel_host.stop_channel = b->host.stop_channel;', 'kernel_host.stop_channel = NULL;'),
        'a9a null binding accepted': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A9A_TYPE) {', 'if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A9A_TYPE) {'),
        'a9a null before accepted': ('if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A9A_TYPE) {', 'if (b == NULL || action == NULL || out == NULL || action->type != SESSION_A9A_TYPE) {'),
        'a9a failure text': ('return b == NULL ? "invalid binding" : b->failure;\n}\n\nconst Action9AWorld', 'return b == NULL ? "none" : b->failure;\n}\n\nconst Action9AWorld'),
        'a9a create ignores a null host': ('    SessionA9aBinding *b;\n    if (host == NULL) {\n        return NULL;\n    }', '    SessionA9aBinding *b;'),
    },
}

# Mutants that cannot change observable behaviour. Each carries the reason; test_equivalent_mutants_survive checks that the
# unit cases still pass on them, so a reason that stops being true is noticed.
EQUIVALENT = {
    'phase 0 returns through the later phase test': (K9, 'if (phase == 0u) {                                                   /* 0x4336ea: state := 2 */\n        outcome->phase = 2u;\n        return ACTION_FAMILY_9A_RUNTIME_OK;\n    }',
                                                     'if (phase == 0u) {                                                   /* 0x4336ea: state := 2 */\n        outcome->phase = 2u;\n    }',
                                                     'without the early return phase 0 reaches the test "phase != 2", which returns the same outcome (phase 2, pending, no work)'),
    'start word read as unsigned': (K9, '((int16_t)(uint16_t)((decoded->word[12] >> 8) | ((uint16_t)decoded->byte_26 << 8)) != 1)',
                                    '(((uint16_t)((decoded->word[12] >> 8) | ((uint16_t)decoded->byte_26 << 8))) != 1)',
                                    'the compare is with 1, which has the same bits signed and unsigned'),
    'sound narrowed through a signed cast': (K9, '(uint16_t)sound', '(uint16_t)(int16_t)sound',
                                             'sound is already an int16_t; the cast is the identity'),
    'a6d binding clears the world before the load': (B, '    memset(&world, 0, sizeof(world));\n    if (b->host.load_world == NULL ||',
                                                      '    if (b->host.load_world == NULL ||',
                                                      'the required load_world overwrites the whole structure, so the zero fill is only defence in depth (the structure is then read uninitialised only when the host fills nothing)'),
}
EXECUTOR_MUTANTS = {
    'a9a left pending': (B, 'out->disposition = outcome.disposition;', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'a6d left pending': (B, 'out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163: completion byte := 1 */', 'out->disposition = SCENE_ACTION_HANDLER_PENDING;'),
    'a9a phase 0 completes': (K9, 'outcome->phase = 2u;\n        return ACTION_FAMILY_9A_RUNTIME_OK;', 'outcome->phase = 2u;\n        outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;\n        return ACTION_FAMILY_9A_RUNTIME_OK;'),
    'a9a stops dropped': (K9, 'for (channel = (int16_t)(sound != STOP_ALL_FROM_0); channel < STOP_CHANNEL_END; ++channel) {', 'for (channel = 20; channel < STOP_CHANNEL_END; ++channel) {'),
}


class UnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.binary = Path(cls.tmp.name) / 'a6d9a_test'
        built = compile_c(cls.binary, TEST_C, KERNEL_SOURCES)
        assert built.returncode == 0, built.stderr

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def test_unit_cases_pass(self):
        code, results = run_unit(self.binary)
        self.assertGreaterEqual(len(results), EXPECTED_UNIT_TESTS)
        for name, (status, message) in sorted(results.items()):
            with self.subTest(name):
                self.assertEqual(status, 'PASS', message)
        self.assertEqual(code, 0)

    def test_sanitizers_on_the_unit_cases(self):
        for cc in (compiler(), shutil.which('gcc')):
            if cc is None:
                continue
            out = Path(self.tmp.name) / 'a6d9a_test_san'
            cmd = [cc, '-std=c11', '-g', '-O1', '-fsanitize=address,undefined', '-fno-sanitize-recover=undefined',
                   f'-I{SRC}', str(TEST_C), *[str(SRC / s) for s in KERNEL_SOURCES], '-lm', '-o', str(out)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode != 0:
                continue
            env = dict(os.environ, ASAN_OPTIONS='detect_leaks=0')
            done = subprocess.run([str(out)], capture_output=True, text=True, env=env)
            self.assertEqual(done.returncode, 0, done.stdout[-400:] + done.stderr[-400:])
            self.assertGreaterEqual(done.stdout.count('PASS'), EXPECTED_UNIT_TESTS)
            return
        self.skipTest('no compiler with an ASan/UBSan runtime in this environment')

    def _run_mutant(self, tag, filename, old, new):
        work = mutated_copy(self.tmp.name, filename, old, new, tag)
        binary = work / 'mut_test'
        built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
        if built.returncode != 0:
            return 'does not build: ' + built.stderr[-200:], None
        code, _ = run_unit(binary)
        return None, code

    def test_mutations_are_detected(self):
        """The cases must fail when a recovered rule is deliberately broken (the oracle has its own mutants against the original;
        these also cover the host-status mapping the oracle cannot reach)."""
        jobs = []
        for filename, mutations in MUTANTS.items():
            for name, (old, new) in mutations.items():
                jobs.append((filename, name, old, new))
        survivors, broken = [], []

        def run(job):
            filename, name, old, new = job
            tag = 'mut_' + re.sub(r'\W', '_', filename + name)
            return job, self._run_mutant(tag, filename, old, new)

        with concurrent.futures.ThreadPoolExecutor(max_workers=min(8, os.cpu_count() or 2)) as pool:
            for job, (problem, code) in pool.map(run, jobs):
                if problem is not None:
                    broken.append((job[1], problem))
                elif code == 0:
                    survivors.append(job[1])
        self.assertEqual(broken, [], 'mutants that do not build')
        self.assertEqual(survivors, [], 'mutants that survived')
        self.assertGreaterEqual(len(jobs), 150)

    def test_equivalent_mutants_survive(self):
        """The recorded equivalent mutants build and leave every unit case green (so the recorded reason is still true)."""
        for name, (filename, old, new, reason) in EQUIVALENT.items():
            with self.subTest(name):
                self.assertTrue(reason)
                original = (SRC / filename).read_text()
                if original.count(old) != 1:
                    # anchors that occur more than once are applied to every occurrence
                    work = Path(self.tmp.name) / 'eq'
                    shutil.rmtree(work, ignore_errors=True)
                    work.mkdir()
                    for item in SRC.iterdir():
                        if item.suffix in ('.c', '.h'):
                            shutil.copy(item, work / item.name)
                    self.assertGreaterEqual(original.count(old), 1)
                    (work / filename).write_text(original.replace(old, new))
                else:
                    work = mutated_copy(self.tmp.name, filename, old, new, 'eq')
                binary = work / 'eq_test'
                built = compile_c(binary, TEST_C, KERNEL_SOURCES, src_dir=work)
                self.assertEqual(built.returncode, 0, built.stderr[-300:])
                code, _ = run_unit(binary)
                self.assertEqual(code, 0, 'the recorded equivalent mutant is detected: ' + name)


class ExecutorTests(unittest.TestCase):
    """The production executor drives synthetic rows (gate mode 0, pending phase, direct completion, transition) with the real
    bindings."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.scenes = []
        for name, data in (('transition', scene_with_transition()), ('plain', scene_with_plain_rows())):
            path = Path(cls.tmp.name) / (name + '.bin')
            path.write_bytes(data)
            cls.scenes.append(str(path))

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_executor(self, src_dir=SRC, name='exec6d9a'):
        binary = Path(self.tmp.name) / name
        built = compile_c(binary, EXECUTOR_C, EXECUTOR_SOURCES, src_dir=src_dir)
        self.assertEqual(built.returncode, 0, built.stderr[-600:])
        return subprocess.run([str(binary), *self.scenes], capture_output=True, text=True)

    def test_executor_runs_the_pending_phase_and_the_direct_completions(self):
        done = self.run_executor()
        self.assertEqual((done.returncode, done.stdout.strip()), (0, 'PASS'), done.stdout)

    def test_executor_mutants_are_detected(self):
        for name, (filename, old, new) in EXECUTOR_MUTANTS.items():
            with self.subTest(name):
                work = mutated_copy(self.tmp.name, filename, old, new, 'exec_mut')
                done = self.run_executor(work, 'exec6d9a_mut')
                self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


class BuildAndCorpus(unittest.TestCase):
    def test_build_script(self):
        if shutil.which('xcrun') is None:
            self.skipTest('xcrun (or its shim) is not available')
        done = subprocess.run(['sh', str(PROJECT / 'scripts/build_action_family_6d_9a_runtime.sh')], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr)
        self.assertTrue(Path(done.stdout.strip()).exists())

    def test_corpus_rows_run_through_the_bindings(self):
        if not (RESOURCES / '0001.bin').exists():
            self.skipTest('local corpus evidence (work/) is not present')
        files = sorted(RESOURCES.glob('*.bin'))
        with tempfile.TemporaryDirectory() as tmp:
            binary = Path(tmp) / 'a6d9a_corpus'
            built = compile_c(binary, CORPUS_C, CORPUS_SOURCES)
            self.assertEqual(built.returncode, 0, built.stderr)
            done = subprocess.run([str(binary), *map(str, files)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stdout[-400:])
        summary = {}
        for line in done.stdout.splitlines():
            if line.startswith('SUMMARY'):
                summary = {k: int(v) for k, v in (item.split('=') for item in line.split()[1:])}
        # one scene (S6301) with one row of each type: the 0x9a row stops channels 0..13 without a scene or an event flag
        self.assertEqual((summary['scenes'], summary['rows'], summary['ok'], summary['bad']), (1, 2, 2, 0))
        self.assertEqual((summary['n6d'], summary['n9a'], summary['pending_ok']), (1, 1, 1))
        self.assertEqual((summary['sound_all'], summary['sound_from1'], summary['sound_single']), (1, 0, 0))
        self.assertEqual((summary['scene_rows'], summary['no_scene_rows'], summary['flag_rows']), (0, 1, 0))
        self.assertEqual((summary['stops'], summary['stop_low'], summary['stop_high']), (14, 14, 0))
        self.assertEqual((summary['unloads'], summary['transitions'], summary['flag_stores'], summary['flag_queries']), (1, 0, 0, 0))
        self.assertEqual((summary['store6d'], summary['store9a']), (1, 1))
        self.assertEqual(done.stdout.count('ROW_FAIL'), 0)


GLUE_PRELUDE = r'''
#include <cstdarg>
#include <cstddef>
#include <cstdint>
#include "scene_session.h"
#include "session_bindings_a6d_a9a.h"
struct StandInGlobals { int32_t overlay_ui = 0; int32_t load_game_flag = 0; uint32_t game_state = 0; };
struct StandInLifecycle { StandInGlobals g; };
struct StandInCaptions { StandInLifecycle lifecycle; };
struct StandInExit { StandInGlobals g; };
struct NativeApp {
    StandInCaptions captions; StandInExit exit_state; SceneSession *session = nullptr; int32_t start_flag_5bb1ca = 0;
    SessionA6dBinding *a6d = nullptr; SessionA9aBinding *a9a = nullptr; Action6DWorld a6d_world{};
};
static void record(NativeApp *, const char *, ...) {}
static bool unload_scene_sound_object(NativeApp *) { return true; }
static int native_ad1_event_flag_invalid(void *, int16_t) { return 0; }
static int native_ad1_store_event_flag(void *, int16_t, uint32_t) { return 0; }
'''


def glue_regions(app):
    start = app.index('/* Raw 0x6d (RT-57)')
    handler = app.index('static int native_a9a_handler(')
    end = app.index('\n}\n', handler) + 3
    create_start = app.index('    SessionA6dHost a6d_host{};')
    create_end = app.index('    app->a9a = session_a9a_create(&a9a_host);') + len('    app->a9a = session_a9a_create(&a9a_host);')
    return app[start:end], app[create_start:create_end]


class AppGlue(unittest.TestCase):
    """src/blackmoor_app.mm is not compiled in the cloud. The glue is syntax-checked here against stand-in types, and the
    registration is pinned at text level."""

    @classmethod
    def setUpClass(cls):
        cls.app = (SRC / 'blackmoor_app.mm').read_text()

    def test_glue_compiles_against_stand_in_types(self):
        cxx = shutil.which('clang++') or shutil.which('c++')
        if cxx is None:
            self.skipTest('no C++ compiler')
        functions, creation = glue_regions(self.app)
        source = GLUE_PRELUDE + functions + '\nstatic void create_for_syntax_check(NativeApp *app)\n{\n' + creation + '\n}\n'
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'glue_check.cpp'
            path.write_text(source)
            done = subprocess.run([cxx, '-std=c++17', '-fsyntax-only', '-Wall', '-Wextra', '-Werror', '-Wno-unused-function',
                                   f'-I{SRC}', str(path)], capture_output=True, text=True)
        self.assertEqual(done.returncode, 0, done.stderr[-1500:])

    def test_registration_uses_numeric_literals_and_gap_free_slots(self):
        for line in ('bindings[54].type = SESSION_A6D_TYPE;', 'bindings[54].callback = native_a6d_handler;', 'bindings[54].context = app;',
                     'bindings[55].type = SESSION_A9A_TYPE;', 'bindings[55].callback = native_a9a_handler;', 'bindings[55].context = app;'):
            self.assertEqual(self.app.count(line), 1, line)
        indices = sorted({int(n) for n in re.findall(r'\n    bindings\[(\d+)\]\.type', self.app)})
        self.assertEqual(indices, list(range(1, len(indices) + 1)))
        count = len(indices) + 1
        self.assertIn(f'SceneSessionActionBinding bindings[{count}]{{}};', self.app)
        self.assertIn(f'config.action_binding_count = {count}u;', self.app)

    def test_bindings_are_created_checked_and_destroyed(self):
        self.assertEqual(self.app.count('session_a6d_destroy(app->a6d);'), 1)
        self.assertEqual(self.app.count('session_a9a_destroy(app->a9a);'), 1)
        self.assertEqual(self.app.count('app->a6d = session_a6d_create(&a6d_host);'), 1)
        self.assertEqual(self.app.count('app->a9a = session_a9a_create(&a9a_host);'), 1)
        self.assertIn('app->a6d == nullptr || app->a9a == nullptr', self.app)
        self.assertIn('#include "session_bindings_a6d_a9a.h"', self.app)

    def test_9a_uses_the_shared_event_flag_helpers(self):
        self.assertIn('a9a_host.event_flag_invalid = native_ad1_event_flag_invalid;', self.app)
        self.assertIn('a9a_host.store_event_flag = native_ad1_store_event_flag;', self.app)

    def test_modules_are_in_the_native_app_build(self):
        build = (PROJECT / 'scripts/build_native_app.sh').read_text()
        for module in ('action_family_6d', 'action_family_9a', 'action_family_6d_runtime', 'action_family_9a_runtime',
                       'session_bindings_a6d_a9a'):
            self.assertRegex(build, rf'[ ]{module}[ ;]', module)
        script = (PROJECT / 'scripts/build_action_family_6d_9a_runtime.sh').read_text()
        for source in KERNEL_SOURCES:
            self.assertIn(source, script)


if __name__ == '__main__':
    unittest.main()
