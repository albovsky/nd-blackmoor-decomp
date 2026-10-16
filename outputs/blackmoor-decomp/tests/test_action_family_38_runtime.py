"""RT-31: raw 0x38 "animated overlay" rows bound to the COverlay runtime (type 0x36).

Facts under test (original GAME.EXE, read from the disassembly and run under Unicorn by
tests/action_family_38_runtime_original_oracle.py):
 * The raw 0x38 loader arm 0x40c404 runs the constructor 0x48905b and stores the runtime type
   0x36 (0x40c43a), so the row reaches the same dispatcher arm (0x4280b4, gate 0x423f57 mode 1)
   and COverlay::Process 0x4899ca as raw 0x36 and raw 0x37.
 * The constructor allocates a 0xABA-byte image, clears only the first 0xac bytes and writes: name,
   options 0x21/0x23/0x25/0x27 (from the same body offsets), marker +0x29 = 2 (animated), direction
   +0x2d and loop +0x2f (from body 0x29/0x2b), frame range +0x33/+0x35, fps +0x37 = 15, event index
   +0x39 = -1, +0x3d (body 0x2d), +0x43 = 1, dword +0x4d = 1, event pair 0 (body 0x2f, 0x31), nine
   pairs -1, sound "NO SOUND", secondary count +0xaa = 1, the frame table at +0xac, and the single
   secondary record (frame 0, primary 0, HOT WORD 2, source offsets 0, 0, width, height, destination
   = the body rectangle). The rest of the allocation is left to the allocator.
 * Hot word 2 means 0x4897cd never hits it; event index -1 means phase 1 never completes: a
   registered 0x38 row animates until the scene ends.
The native binding starts the bytes the constructor leaves alone as zeros.
"""
import ctypes as c
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest

import session_binding_support as session
import test_action_family_36_runtime as t36
import test_action_family_37_runtime as t37

IMAGE_BYTES = t36.IMAGE_BYTES
OK = t36.OK
SESSION_ERR_EXECUTOR = 5      # test_scene_session_extension.py
PREFIX = 71
ALL = (0x36, 0x37, 0x38)
PROJECT = t36.PROJECT
SRC = PROJECT / 'src'
CORPUS_OPTIONS = (2, 1, 2, 10, 1, 2, 9999, 0xffff, 0)    # every corpus row but one has layer 10


def pad_name(name):
    assert len(name) < 33
    return name + b'\0' * (33 - len(name))


def frame_record(i):
    return struct.pack('<4i', 10 * i, 5 * i, 10 * i + 64, 5 * i + 68)


def body38(name=b'OVL38', *, options=CORPUS_OPTIONS, start=0, count=4, rect=(70, 80, 135, 149),
           frames=None, deps=()):
    """The raw 0x38 body (A-38.1): name[33], nine option words at 0x21..0x31, frame start and end,
    the fixed rectangle, 16-byte frame records, then 16-byte dependency records."""
    data = pad_name(name) + struct.pack('<9H', *[v & 0xffff for v in options]) + \
        struct.pack('<hh4i', start, start + count - 1, *rect)
    assert len(data) == PREFIX
    if frames is None:
        frames = [frame_record(i) for i in range(max(count, 0))]
    return data + b''.join(frames) + b''.join(deps)


def model_image(name=b'OVL38', *, options=CORPUS_OPTIONS, start=0, count=4, rect=(70, 80, 135, 149),
                frames=None):
    """Independent model of 0x48905b: the first 0xac bytes are cleared, the allocator bytes of the
    rest are modeled as zeros."""
    o = [v & 0xffff for v in options]
    if frames is None:
        frames = [frame_record(i) for i in range(max(count, 0))]
    image = bytearray(IMAGE_BYTES)
    image[0:len(name) + 1] = name + b'\0'
    for offset, value in ((0x21, o[0]), (0x23, o[1]), (0x25, o[2]), (0x27, o[3]), (0x29, 2),
                          (0x2d, o[4]), (0x2f, o[5]), (0x33, start), (0x35, start + count - 1),
                          (0x37, 15), (0x39, -1), (0x3d, o[6]), (0x43, 1), (0x51, o[7]),
                          (0x53, o[8]), (0xaa, 1), (0x6ec, 0), (0x6ee, 0), (0x6f0, 2)):
        struct.pack_into('<H', image, offset, value & 0xffff)
    def w32(offset, value):
        struct.pack_into('<I', image, offset, value & 0xffffffff)

    w32(0x4d, 1)
    for i in range(1, 10):
        t36.w16(image, 0x51 + 4 * i, -1)
    image[0x79:0x79 + 9] = b'NO SOUND\0'
    w32(0x6f2, 0)
    w32(0x6f6, 0)
    w32(0x6fa, rect[2] - rect[0])
    w32(0x6fe, rect[3] - rect[1])
    for i, value in enumerate(rect):
        w32(0x702 + 4 * i, value)
    for i, record in enumerate(frames):
        image[0xac + 16 * i:0xac + 16 * i + 16] = record
    return bytes(image)


def overlay38(name=b'OVL38', subtype=1, deps=(), **kwargs):
    return session.action(0x38, subtype, body38(name, deps=deps, **kwargs), ())


def overlay37(name=b'OVL37', subtype=1, deps=(), **kwargs):
    return t37.overlay37(name, subtype, deps, **kwargs)


def overlay36(name=b'OVL36', subtype=1, deps=(), **kwargs):
    return t36.overlay_action(name=name, subtype=subtype, deps=deps, **kwargs)


class ConstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        t37.setup_library(cls)

    def build(self, raw_type, data):
        owner = (c.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')
        out = (c.c_uint8 * IMAGE_BYTES)()
        c.memset(out, 0xA5, IMAGE_BYTES)
        status = self.lib.session_a36_build_image(raw_type, owner, len(data), out)
        return status, bytes(out)

    def test_the_0x38_image_equals_the_independent_model_of_the_original_constructor(self):
        for kwargs in ({}, dict(name=b'CON_GrennyANIM_OVL', rect=(139, 80, 204, 149)),
                       dict(options=(1, 2, 1, 11, 2, 1, 5, 7, 3), start=3, count=16, rect=(0, 0, 0, 0)),
                       dict(name=b'', rect=(-7, 0, 2 ** 31 - 1, -2 ** 31)),
                       dict(name=b'X' * 32, rect=(300, 5, 100, 4), count=1),
                       dict(count=0), dict(count=100, start=-50),
                       dict(options=(0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff))):
            status, image = self.build(0x38, body38(**kwargs))
            self.assertEqual(status, 0, kwargs)
            self.assertEqual(image, model_image(**kwargs), kwargs)

    def test_a_hundred_frames_fill_the_table_up_to_the_secondary_record_without_touching_it(self):
        status, image = self.build(0x38, body38(count=100))
        self.assertEqual(status, 0)
        self.assertEqual(image[0xac:0x6ec], b''.join(frame_record(i) for i in range(100)))
        self.assertEqual(image[0x6ec:0x712], model_image(count=100)[0x6ec:0x712])

    def test_bytes_after_the_name_terminator_are_not_copied(self):
        data = bytearray(body38(b'AB'))
        data[3:10] = b'garbage'
        status, image = self.build(0x38, bytes(data))
        self.assertEqual(status, 0)
        self.assertEqual(image, model_image(b'AB'))

    def test_dependency_tail_is_not_part_of_the_image(self):
        status, image = self.build(0x38, body38(deps=(session.flag_gate(1), session.flag_gate(2))))
        self.assertEqual((status, image), (0, model_image()))

    def test_malformed_0x38_bodies_are_rejected_and_leave_the_output_alone(self):
        good = body38()
        for label, data in (('empty', b''), ('short prefix', good[:PREFIX - 1]),
                            ('missing frame bytes', good[:-1]),
                            ('unterminated name', b'N' * 33 + good[33:]),
                            ('tail not a multiple of 16', good + b'\0' * 7),
                            ('more than 100 frames', body38(count=101)),
                            ('negative frame count', body38(count=-3, frames=[]))):
            status, image = self.build(0x38, data)
            self.assertNotEqual(status, 0, label)
            self.assertEqual(image, b'\xa5' * IMAGE_BYTES, label)

    def test_a_0x37_shaped_body_is_not_a_0x38_body(self):
        status, image = self.build(0x38, t37.body37())
        self.assertNotEqual(status, 0)
        self.assertEqual(image, b'\xa5' * IMAGE_BYTES)

    def test_other_raw_types_have_no_image(self):
        for raw_type in (0x35, 0x39, 0):
            status, image = self.build(raw_type, body38())
            self.assertNotEqual(status, 0, raw_type)
            self.assertEqual(image, b'\xa5' * IMAGE_BYTES)


    def test_option_0x31_is_the_first_event_pair_value_and_not_the_frame_init(self):
        status, image = self.build(0x38, body38(options=(2, 1, 2, 10, 1, 2, 9999, 12, 3)))
        self.assertEqual(status, 0)
        self.assertEqual((t36.image_s16(image, 0x31), t36.image_s16(image, 0x51), t36.image_s16(image, 0x53)),
                         (0, 12, 3))

    def test_the_0x36_and_0x37_images_are_unchanged(self):
        status, image = self.build(0x37, t37.body37())
        self.assertEqual((status, image), (0, t37.model_image()))
        pre = t36.prefix(b'IMG_OVL', primaries=2, secondaries=2)
        prims = [t36.primary_record(1, 2, 3, 4), t36.primary_record(5, 6, 7, 8)]
        secs = [t36.secondary(0, 0, 1, (1, 2, 3, 4), (5, 6, 7, 8)), t36.secondary(3, 1, 2)]
        status, image = self.build(0x36, t36.raw_body(pre, prims, secs))
        self.assertEqual((status, image), (0, bytes(t36.make_image(pre, prims, secs))))


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        t37.setup_library(cls)

    def fixture(self, actions, **kwargs):
        return t36.Fixture(self, self.lib, actions, binding_types=ALL, **kwargs)

    def test_scene_images_are_built_per_raw_type(self):
        f = self.fixture([overlay38(b'A38'), overlay37(b'A37'), overlay36(b'A36'),
                          session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                         session.i16(-1) + session.i16(0))])
        self.assertEqual(bytes(f.image(0)), model_image(b'A38'))
        self.assertEqual([self.lib.session_a36_row_raw_type(f.binding, row) for row in range(5)],
                         [0x38, 0x37, 0x36, 0, 0])
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 0), b'A38')
        self.assertIsNone(f.image(3))

    def test_first_tick_registers_and_starts_the_animation_at_the_initial_frame(self):
        f = self.fixture([overlay38(b'CON_GrennyANIM_OVL')], tick=5000)
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'CON_GrennyANIM_OVL'])
        self.assertEqual(f.start_flag, 1)
        image = f.image(0)
        # row, render slot, surface cache slot, enabled, then the animation: frame 0, interval
        # 1000 / 15 = 66 ms, next tick = now + interval
        self.assertEqual((t36.image_s16(image, 0xab0), t36.image_s16(image, 0xaa2),
                          t36.image_s16(image, 0xaa4), t36.image_u32(image, 0xab2),
                          t36.image_s16(image, 0xaae), t36.image_u32(image, 0xaa6),
                          t36.image_u32(image, 0xaaa)),
                         (0, 24, 0, 1, 0, 66, 5066))

    def test_a_registered_0x38_row_never_completes_whatever_the_event_array_holds(self):
        # Event index -1 (word 0xffff): phase 1 compares nothing. Even with every flag set the
        # row keeps animating.
        f = self.fixture([overlay38(b'A38')], event_count=2048)
        f.tick()
        for value in (0, 1, 7, -1, 0x270f):
            for index in range(len(f.flags)):
                f.flags[index] = value
            for _ in range(5):
                f.tick()
            self.assertEqual(f.state(), (0, 1), value)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'A38'])

    def test_a_0x38_row_exports_no_hot_rectangle_and_no_hit(self):
        f = self.fixture([overlay38(b'A38'), overlay36(b'A36')])
        f.tick()
        # only the 0x36 row (hot record) is exported; the 0x38 record has hot word 2
        self.assertEqual(f.priority_rows(), (OK, [(1, 10, 20, 29, 39, 1)]))
        only = self.fixture([overlay38(b'A38')])
        only.tick()
        self.assertEqual(only.priority_rows(), (OK, []))
        hit, row = c.c_int(), c.c_int32()
        for x, y in ((70, 80), (100, 110), (135, 149)):
            self.assertEqual(self.lib.session_a36_hit_test(only.binding, x, y, c.byref(hit),
                                                           c.byref(row)), 0)
            self.assertEqual((hit.value, row.value), (0, -1))

    def test_the_plain_option_blits_the_current_frame_record_to_the_rectangle(self):
        f = self.fixture([overlay38(b'A38', options=(2, 1, 2, 10, 1, 2, 9999, 0xffff, 0))])
        f.tick()
        drawn = c.c_size_t()
        self.assertEqual(self.lib.session_a36_render(f.binding, 0, 20, c.byref(drawn)), 0)
        self.assertEqual(drawn.value, 1)
        # marker 2: the primary record is the CURRENT FRAME (0), not the secondary's word. The
        # source is the frame record's left/top plus (0, 0, width, height); the destination is
        # the body rectangle plus the view origin (10, 10).
        self.assertEqual(f.log, [('blit', 1, 0, (0, 0, 65, 69), (80, 90, 145, 159))])

    def test_other_option_values_use_the_restoring_keyed_blit(self):
        f = self.fixture([overlay38(b'A38', options=(2, 2, 2, 11, 1, 2, 9999, 0xffff, 0))])
        f.tick()
        self.assertEqual(self.lib.session_a36_render(f.binding, 11, 11, c.byref(c.c_size_t())), 0)
        kinds = [entry[1] for entry in f.log]
        self.assertEqual(len(f.log), 2, f.log)           # marker 2: restore background, then keyed
        self.assertEqual(kinds, [1, 2])

    def test_the_layer_word_selects_the_render_layer(self):
        f = self.fixture([overlay38(b'A', options=(2, 1, 2, 10, 1, 2, 9999, 0xffff, 0)),
                          overlay38(b'B', options=(2, 1, 2, 11, 1, 2, 9999, 0xffff, 0))])
        f.tick()
        drawn = c.c_size_t()
        for lo, hi, expected in ((0, 9, 0), (10, 10, 1), (11, 11, 1), (10, 11, 2), (12, 20, 0)):
            f.log.clear()
            self.assertEqual(self.lib.session_a36_render(f.binding, lo, hi, c.byref(drawn)), 0)
            self.assertEqual((lo, hi, drawn.value), (lo, hi, expected))

    def test_dependency_gate_false_does_not_register_and_true_registers_once(self):
        f = self.fixture([overlay38(b'A38', deps=(session.flag_gate(3),))])
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 0), 0))
        f.flags[3] = 1
        f.tick()
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 1), 1))
        f.flags[3] = 0
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 1), 1))

    def test_same_name_across_raw_types_reuses_one_cached_surface(self):
        f = self.fixture([overlay36(b'TUT_Next_OVL'), overlay37(b'tut_next_ovl'), overlay38(b'TUT_NEXT_OVL')])
        f.tick()
        self.assertEqual(f.loaded, [b'TUT_Next_OVL'])
        self.assertEqual(self.lib.session_a36_registered(f.binding), 3)

    def test_list_order_is_registration_order_across_all_three_raw_types(self):
        f = self.fixture([overlay38(b'A'), overlay36(b'B'), overlay37(b'C'), overlay38(b'D')])
        f.tick()
        self.assertEqual(self.lib.session_a36_registered(f.binding), 4)
        self.assertEqual(f.loaded, [b'A', b'B', b'C', b'D'])
        manager = t36.Manager.from_address(self.lib.session_a36_manager(f.binding))
        self.assertEqual(list(manager.list[:4]), [0, 1, 2, 3])

    def test_handler_checks_the_raw_type_against_the_row_image(self):
        f = self.fixture([overlay38(b'A38'), overlay37(b'A37'), overlay36(b'A36')])
        info = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        for row, wrong in ((0, 0x37), (0, 0x36), (1, 0x38), (2, 0x38), (2, 0x37)):
            self.assertEqual(self.lib.scene_resource_action_at(f.scene, row, c.byref(info)), 0)
            info.type = wrong
            self.assertEqual(self.lib.session_a36_handler(f.binding, row, c.byref(info),
                                                          c.byref(before), c.byref(out)), 2, (row, wrong))
        info.type = 0x39
        self.assertEqual(self.lib.session_a36_handler(f.binding, 0, c.byref(info),
                                                      c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))

    def test_the_original_0x36_behaviour_is_unchanged_next_to_a_0x38_row(self):
        f = self.fixture([overlay38(b'A38'), overlay36(b'A36', event=(7, 3), pairs=[(9, 2)])])
        f.tick()
        self.assertEqual((f.state(0), f.state(1)), ((0, 1), (0, 1)))
        f.flags[7] = 3
        f.tick()
        f.tick()
        self.assertEqual((f.state(0), f.state(1), f.flags[9]), ((0, 1), (1, 0), 2))

    def test_a_new_scene_rebuilds_the_0x38_images_and_resets_the_manager(self):
        f = self.fixture([overlay38(b'A38')])
        f.tick()
        other, owner = session.open_scene(self.lib, [overlay38(b'B38', count=2), overlay36(b'C')])
        self.assertEqual(self.lib.session_a36_begin_scene(f.binding, other), 0)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 0)
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 0), b'B38')
        self.assertEqual(bytes(f.image(0)), model_image(b'B38', count=2))
        self.assertEqual(self.lib.session_a36_row_raw_type(f.binding, 1), 0x36)
        self.lib.scene_resource_close(other)
        del owner

    def test_malformed_0x38_rows_never_reach_the_binding_the_scene_parser_refuses_them(self):
        # scene_resource.c (known_body_length) already enforces the A-38.1 boundary: the scene does
        # not open, so session_a36_begin_scene cannot see such a row.
        for label, bad in (('unterminated name', b'N' * 33 + body38()[33:]),
                           ('too many frames', body38(count=101)),
                           ('negative frame count', body38(count=-3, frames=[]))):
            with self.assertRaises(AssertionError, msg=label):
                session.open_scene(self.lib, [overlay38(b'OK'), session.action(0x38, 1, bad, ())])

    def test_exhausting_the_render_table_with_0x38_rows_is_an_explicit_rejection(self):
        # 41 rows sharing one image name: the original reports an error at the 41st registration
        # (manager list and render table hold 40); the native binding stops with a bounds status
        # before touching anything.
        f = self.fixture([overlay38(b'SAME') for _ in range(41)])
        status, result = f.tick()
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (SESSION_ERR_EXECUTOR, 40, 0x38))
        self.assertIn(b'overlay list is full', self.lib.session_a36_failure(f.binding))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 40)

    def test_finishing_with_option_one_requests_the_scene_change_like_the_0x0a_arm(self):
        # The pointer cascade accepts the row's candidate (phase 2); the next visit runs the
        # finish: option +0x25 == 1 stores the scene-change words from +0x3d.. (body 0x2d = 41
        # here). The 0x38 constructor leaves +0x3f/+0x41 and the dwords +0x45/+0x49 zero and
        # writes +0x43 = 1 and +0x4d = 1.
        f = self.fixture([overlay38(b'A38', options=(2, 1, 1, 10, 1, 2, 41, 0xffff, 0))])
        f.tick()
        self.assertEqual(f.state(), (0, 1))
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, _ = f.tick()
        self.assertEqual(status, session.SESSION_TRANSITION)
        self.assertEqual(f.transitions, [(41, [0, 0, 1], [0, 0, 1])])
        self.assertEqual(f.state(), (1, 0))

    def test_finishing_with_another_option_requests_nothing_and_completes(self):
        f = self.fixture([overlay38(b'A38')])
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        status, _ = f.tick()
        self.assertEqual((status, f.transitions, f.state()), (session.SESSION_OK, [], (1, 0)))

    def test_event_pair_zero_is_written_at_the_finish(self):
        f = self.fixture([overlay38(b'A38', options=(2, 1, 2, 10, 1, 2, 9999, 12, 3))], event_count=64)
        f.tick()
        self.lib.scene_session_accept_action_candidate(f.session, 0)
        f.tick()
        self.assertEqual((f.flags[12], f.state()), (3, (1, 0)))


class GateModeTests(t37.GateModeTests):
    """Raw 0x38 is gated with mode 1 as well (0x428083); inherited from RT-18 for the three types."""


for _name in list(vars(t37.GateModeTests)):
    if _name.startswith('test_') and _name not in vars(GateModeTests):
        setattr(GateModeTests, _name, None)


# ---- planted mutants of the 0x38 glue and of the constructor fields the runtime depends on -----

MUTANTS = {
    'build_image ignores raw 0x38': ('session_bindings_a36.c', 'if (raw_type == SESSION_A38_TYPE) {', 'if (0) {'),
    'scene load skips 0x38 rows': ('session_bindings_a36.c',
                                   'return type == SESSION_A36_TYPE || type == SESSION_A37_TYPE || type == SESSION_A38_TYPE;',
                                   'return type == SESSION_A36_TYPE || type == SESSION_A37_TYPE;'),
    'allocator bytes modeled as 0xff': ('session_bindings_a36.c',
                                        'memset(zeros, 0, sizeof(zeros));\n        if (action_family_38_construct',
                                        'memset(zeros, 0xff, sizeof(zeros));\n        if (action_family_38_construct'),
    'row image type not checked': ('session_bindings_a36.c', 'b->raw_types[index] != action->type', '0'),
    'marker 1 instead of 2': ('action_family_38.c', 'write_u16(object + 0x29u, 2u);', 'write_u16(object + 0x29u, 1u);'),
    'fps 16': ('action_family_38.c', 'write_u16(object + 0x37u, 15u);', 'write_u16(object + 0x37u, 16u);'),
    'direction and loop swapped': ('action_family_38.c', 'write_u16(object + 0x2du, d.option_29);\n    write_u16(object + 0x2fu, d.option_2b);',
                                    'write_u16(object + 0x2du, d.option_2b);\n    write_u16(object + 0x2fu, d.option_29);'),
    'event index default 0': ('action_family_38.c', 'write_u16(object + 0x39u, UINT16_MAX);', 'write_u16(object + 0x39u, 0u);'),
    'hot word 1': ('action_family_38.c', 'write_u16(object + 0x6f0u, 2u);', 'write_u16(object + 0x6f0u, 1u);'),
    'width off by one': ('action_family_38.c', '(uint32_t)d.fixed_rect[2] - (uint32_t)d.fixed_rect[0]);',
                         '(uint32_t)d.fixed_rect[2] - (uint32_t)d.fixed_rect[0] + 1u);'),
    'last frame record dropped': ('action_family_38.c', 'memcpy(object + 0xacu, d.frame_records, frames * ACTION_FAMILY_38_FRAME_BYTES);',
                                   'memcpy(object + 0xacu, d.frame_records, (frames ? frames - 1u : 0u) * ACTION_FAMILY_38_FRAME_BYTES);'),
    'event pair 0 not written': ('action_family_38.c', 'write_u16(object + 0x51u, d.option_2f);', '(void)d.option_2f;'),
}


def source_files_of_the_build_script():
    text = (PROJECT / 'scripts/build_action_family_36_runtime.sh').read_text()
    return re.findall(r'"\$source_dir/(\w+\.c)"', text)


def compiler():
    return os.environ.get('CC') or shutil.which('clang') or shutil.which('cc')


class MutantTests(unittest.TestCase):
    def test_planted_mutants_of_the_binding_and_the_constructor_are_detected(self):
        if os.environ.get('RT31_NO_MUTANTS'):
            self.skipTest('running inside a mutant check')
        sources = source_files_of_the_build_script()
        self.assertIn('action_family_38.c', sources)
        with tempfile.TemporaryDirectory() as tmp:
            for name, (filename, old, new) in MUTANTS.items():
                with self.subTest(name):
                    work = Path(tmp) / 'src'
                    shutil.rmtree(work, ignore_errors=True)
                    work.mkdir()
                    for item in SRC.iterdir():
                        if item.suffix in ('.c', '.h'):
                            shutil.copy(item, work / item.name)
                    original = (SRC / filename).read_text()
                    self.assertEqual(original.count(old), 1, 'mutation anchor drifted')
                    (work / filename).write_text(original.replace(old, new, 1))
                    library = Path(tmp) / 'mutant.dylib'
                    built = subprocess.run(
                        [compiler(), '-std=c11', '-O1', '-fPIC', '-shared', '-I', str(work)] +
                        [str(work / s) for s in sources] + ['-o', str(library)],
                        capture_output=True, text=True)
                    self.assertEqual(built.returncode, 0, built.stderr[-500:])
                    env = dict(os.environ, A36_RUNTIME_LIBRARY=str(library), RT31_NO_MUTANTS='1')
                    done = subprocess.run(
                        [sys.executable, '-m', 'unittest', 'test_action_family_38_runtime.ConstructionTests',
                         'test_action_family_38_runtime.BindingTests'],
                        cwd=str(PROJECT / 'tests'), env=env, capture_output=True, text=True)
                    self.assertNotEqual(done.returncode, 0, 'mutant survived: ' + name)


if __name__ == '__main__':
    unittest.main()
