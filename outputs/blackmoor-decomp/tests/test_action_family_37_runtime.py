"""RT-18: raw 0x37 "Static overlay" rows bound to the COverlay runtime (type 0x36).

Facts under test (original GAME.EXE, read from the disassembly; see
work/analysis/slices/RT-18.recovery.md):
 * The raw 0x37 loader arm 0x40c446 runs the constructor 0x4895cc and stores the
   runtime type 0x36 (0x40c47b), so the row reaches the same dispatcher arm
   (0x4280b4, gate 0x423f57 mode 1) and COverlay::Process 0x4899ca as raw 0x36.
 * The constructor (0x4895cc over 0x48945b) allocates a 0xABA-byte image, zeroes it
   and writes the defaults: flag +0x21 = 2, option +0x25 = 2, marker +0x29 = 1,
   primary count +0x2b = 1, event index +0x39 = 0xffff, +0x3d = 9999, +0x43 = 1,
   dword +0x4d = 1, ten event pairs -1, sound "NO SOUND", secondary count +0xaa = 1,
   and the single secondary record (frame 0, primary 0, HOT WORD 2, source offsets
   0,0,right-left,bottom-top, destination = the body rectangle); the body supplies the
   name, +0x23 (plain-blit option), +0x27 (layer) and the primary record (+0xac).
 * Hot word 2 means 0x4897cd never hits it; event index -1 means phase 1 never
   completes: a registered 0x37 row stays pending in phase 1 until the scene ends.
"""
import ctypes as c
import struct
import unittest

import session_binding_support as session
import test_action_family_36_runtime as t36
import test_action_family_38 as t38
import test_scene_executor_extension as ext_tests

IMAGE_BYTES = t36.IMAGE_BYTES
OK = t36.OK
SESSION_ERR_EXECUTOR = 5      # test_scene_session_extension.py


def pad_name(name):
    assert len(name) < 33
    return name + b'\0' * (33 - len(name))


def body37(name=b'OVL37', *, plain=1, layer=10, rect=(10, 20, 29, 39), geometry=(5, 6, 24, 25),
           deps=()):
    """The 69-byte raw 0x37 body (A-37.2): name[33], word 0x21, word 0x23, rect 0x25,
    geometry 0x35, then 16-byte dependency records."""
    data = pad_name(name) + struct.pack('<hh', plain, layer) + struct.pack('<4i', *rect) + \
        struct.pack('<4i', *geometry)
    assert len(data) == 0x45
    return data + b''.join(deps)


def model_image(name=b'OVL37', *, plain=1, layer=10, rect=(10, 20, 29, 39), geometry=(5, 6, 24, 25)):
    """Independent model of 0x4895cc: the 0xABA allocation is zeroed (rep stosd/stosw), then
    0x48945b writes the defaults and 0x4895cc copies the name (through its NUL) and words."""
    image = bytearray(IMAGE_BYTES)
    t36.w16(image, 0x21, 2)
    t36.w16(image, 0x25, 2)
    t36.w16(image, 0x29, 1)
    t36.w16(image, 0x2b, 1)
    t36.w16(image, 0x39, -1)
    t36.w16(image, 0x3d, 0x270f)
    t36.w16(image, 0x43, 1)
    t36.w32(image, 0x4d, 1)
    for i in range(10):
        t36.w16(image, 0x51 + 4 * i, -1)
    image[0x79:0x79 + 9] = b'NO SOUND\0'
    t36.w16(image, 0xaa, 1)
    t36.w16(image, 0x6ec, 0)
    t36.w16(image, 0x6ee, 0)
    t36.w16(image, 0x6f0, 2)
    t36.w32(image, 0x6f2, 0)
    t36.w32(image, 0x6f6, 0)
    t36.w32(image, 0x6fa, rect[2] - rect[0])
    t36.w32(image, 0x6fe, rect[3] - rect[1])
    for i, value in enumerate(rect):
        t36.w32(image, 0x702 + 4 * i, value)
    image[0:len(name) + 1] = name + b'\0'
    t36.w16(image, 0x23, plain)
    t36.w16(image, 0x27, layer)
    for i, value in enumerate(geometry):
        t36.w32(image, 0xac + 4 * i, value)
    return bytes(image)


def overlay37(name=b'OVL37', subtype=1, deps=(), **kwargs):
    return session.action(0x37, subtype, body37(name, deps=deps, **kwargs), ())


def overlay36(name=b'OVL36', subtype=1, deps=(), **kwargs):
    return t36.overlay_action(name=name, subtype=subtype, deps=deps, **kwargs)


BOTH = (0x36, 0x37)


def setup_library(cls):
    t36.BindingTests.setUpClass.__func__(cls)
    lib = cls.lib
    lib.session_a36_build_image.argtypes = [c.c_uint8, c.POINTER(c.c_uint8), c.c_size_t,
                                            c.POINTER(c.c_uint8)]
    lib.session_a36_build_image.restype = c.c_int
    lib.session_a36_row_raw_type.argtypes = [c.c_void_p, c.c_size_t]
    lib.session_a36_row_raw_type.restype = c.c_uint8


class ConstructionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        setup_library(cls)

    def build(self, raw_type, data):
        owner = (c.c_uint8 * max(1, len(data))).from_buffer_copy(data or b'\0')
        out = (c.c_uint8 * IMAGE_BYTES)()
        c.memset(out, 0xA5, IMAGE_BYTES)
        status = self.lib.session_a36_build_image(raw_type, owner, len(data), out)
        return status, bytes(out)

    def test_the_0x37_image_equals_the_independent_model_of_the_original_constructor(self):
        for kwargs in ({}, dict(name=b'TUT_Next_OVL', plain=2, layer=11, rect=(0, 0, 0, 0)),
                       dict(name=b'', geometry=(-7, 0, 2 ** 31 - 1, -2 ** 31)),
                       dict(name=b'X' * 32, rect=(300, 5, 100, 4))):
            status, image = self.build(0x37, body37(**kwargs))
            self.assertEqual(status, 0, kwargs)
            self.assertEqual(image, model_image(**kwargs), kwargs)

    def test_bytes_after_the_name_terminator_are_not_copied(self):
        data = bytearray(body37(b'AB'))
        data[3:10] = b'garbage'
        status, image = self.build(0x37, bytes(data))
        self.assertEqual(status, 0)
        self.assertEqual(image, model_image(b'AB'))

    def test_dependency_tail_is_not_part_of_the_image(self):
        status, image = self.build(0x37, body37(deps=(session.flag_gate(1),)))
        self.assertEqual((status, image), (0, model_image()))

    def test_malformed_0x37_bodies_are_rejected_and_leave_the_output_alone(self):
        for data in (body37()[:0x44], b'', b'N' * 33 + body37()[33:],
                     body37() + b'\0' * 7):
            status, image = self.build(0x37, data)
            self.assertNotEqual(status, 0, len(data))
            self.assertEqual(image, b'\xa5' * IMAGE_BYTES)

    def test_0x38_and_other_raw_types_have_no_image(self):
        for raw_type in (0x38, 0x35, 0x39, 0):
            status, image = self.build(raw_type, body37())
            self.assertNotEqual(status, 0, raw_type)
            self.assertEqual(image, b'\xa5' * IMAGE_BYTES)

    def test_the_0x36_image_is_still_the_a36_constructor_image(self):
        pre = t36.prefix(b'IMG_OVL', primaries=2, secondaries=2)
        prims = [t36.primary_record(1, 2, 3, 4), t36.primary_record(5, 6, 7, 8)]
        secs = [t36.secondary(0, 0, 1, (1, 2, 3, 4), (5, 6, 7, 8)), t36.secondary(3, 1, 2)]
        status, image = self.build(0x36, t36.raw_body(pre, prims, secs))
        self.assertEqual(status, 0)
        self.assertEqual(image, bytes(t36.make_image(pre, prims, secs)))


class BindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        setup_library(cls)

    def fixture(self, actions, **kwargs):
        return t36.Fixture(self, self.lib, actions, binding_types=BOTH, **kwargs)

    def test_scene_images_are_built_per_raw_type(self):
        f = self.fixture([overlay37(b'A37'), overlay36(b'A36'),
                          session.action(0x61, 1, session.i16(4) + session.i16(1) +
                                         session.i16(-1) + session.i16(0))])
        self.assertEqual(bytes(f.image(0)), model_image(b'A37'))
        self.assertEqual([self.lib.session_a36_row_raw_type(f.binding, row) for row in range(4)],
                         [0x37, 0x36, 0, 0])
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 0), b'A37')
        self.assertIsNone(f.image(2))

    def test_raw_0x38_rows_get_no_image_and_the_scene_still_loads(self):
        data = t38.body_fixture()
        f = self.fixture([overlay37(b'A37'), session.action(0x38, 1, data, ())])
        self.assertIsNone(f.image(1))
        self.assertEqual(self.lib.session_a36_row_raw_type(f.binding, 1), 0)

    def test_first_tick_registers_and_the_row_stays_pending_in_phase_one(self):
        f = self.fixture([overlay37(b'TUT_Next_OVL')])
        self.assertEqual(f.tick()[0], session.SESSION_OK)
        self.assertEqual(f.state(), (0, 1))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'TUT_Next_OVL'])
        self.assertEqual(f.start_flag, 1)
        image = f.image(0)
        self.assertEqual((t36.image_s16(image, 0xab0), t36.image_s16(image, 0xaa2),
                          t36.image_s16(image, 0xaa4), t36.image_u32(image, 0xab2)),
                         (0, 24, 0, 1))

    def test_a_registered_0x37_row_never_completes_whatever_the_event_array_holds(self):
        # Event index -1 (word 0xffff): phase 1 compares nothing. Even with every flag set the
        # row keeps waiting, and a (-1, 0) pair is never written.
        f = self.fixture([overlay37(b'A37')], event_count=2048)
        f.tick()
        for value in (0, 1, 7, -1, 0x270f):
            for index in range(len(f.flags)):
                f.flags[index] = value
            for _ in range(5):
                f.tick()
            self.assertEqual(f.state(), (0, 1), value)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 1)
        self.assertEqual(f.loaded, [b'A37'])

    def test_a_0x37_row_exports_no_hot_rectangle_and_no_hit(self):
        f = self.fixture([overlay37(b'A37'), overlay36(b'A36')])
        f.tick()
        # only the 0x36 row (hot record) is exported; the 0x37 record has hot word 2
        self.assertEqual(f.priority_rows(), (OK, [(1, 10, 20, 29, 39, 1)]))
        hit, row = c.c_int(), c.c_int32()
        for x, y in ((10, 20), (15, 25), (29, 39)):
            self.assertEqual(self.lib.session_a36_hit_test(f.binding, x, y, c.byref(hit),
                                                           c.byref(row)), 0)
            self.assertEqual((hit.value, row.value), (1, 1))     # the 0x36 row wins, never row 0
        only = self.fixture([overlay37(b'A37')])
        only.tick()
        self.assertEqual(only.priority_rows(), (OK, []))
        self.assertEqual(self.lib.session_a36_hit_test(only.binding, 15, 25, c.byref(hit),
                                                       c.byref(row)), 0)
        self.assertEqual((hit.value, row.value), (0, -1))

    def test_plain_option_draws_an_opaque_blit_from_the_geometry_to_the_rectangle(self):
        f = self.fixture([overlay37(b'A37', plain=1, layer=10)])
        f.tick()
        drawn = c.c_size_t()
        self.assertEqual(self.lib.session_a36_render(f.binding, 0, 20, c.byref(drawn)), 0)
        self.assertEqual(drawn.value, 1)
        # source = primary record 0 (geometry) + (0, 0, right-left, bottom-top); destination =
        # the body rectangle + the view origin (10, 10)
        self.assertEqual(f.log, [('blit', 1, 0, (5, 6, 24, 25), (20, 30, 39, 49))])

    def test_other_option_values_use_the_keyed_blit(self):
        f = self.fixture([overlay37(b'A37', plain=2, layer=11)])
        f.tick()
        self.assertEqual(self.lib.session_a36_render(f.binding, 11, 11, c.byref(c.c_size_t())), 0)
        self.assertEqual(f.log, [('blit', 2, 0, (5, 6, 24, 25), (20, 30, 39, 49))])

    def test_the_layer_word_selects_the_render_layer(self):
        f = self.fixture([overlay37(b'A', layer=10), overlay37(b'B', layer=11)])
        f.tick()
        drawn = c.c_size_t()
        for lo, hi, expected in ((0, 9, 0), (10, 10, 1), (11, 11, 1), (10, 11, 2), (12, 20, 0)):
            f.log.clear()
            self.assertEqual(self.lib.session_a36_render(f.binding, lo, hi, c.byref(drawn)), 0)
            self.assertEqual((lo, hi, drawn.value), (lo, hi, expected))

    def test_the_record_is_drawn_only_while_the_selector_is_zero(self):
        f = self.fixture([overlay37(b'A37')], selector=3)
        f.tick()
        drawn = c.c_size_t()
        self.assertEqual(self.lib.session_a36_render(f.binding, 0, 20, c.byref(drawn)), 0)
        self.assertEqual((drawn.value, f.log), (1, []))     # visited, nothing blitted (frame 0 != 3)
        f.selector = 0
        self.assertEqual(self.lib.session_a36_render(f.binding, 0, 20, c.byref(drawn)), 0)
        self.assertEqual(len(f.log), 1)

    def test_dependency_gate_false_does_not_register_and_true_registers_once(self):
        f = self.fixture([overlay37(b'A37', deps=(session.flag_gate(3),))])
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 0), 0))
        f.flags[3] = 1
        f.tick()
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 1), 1))
        # a registered overlay stays registered when its gate turns false again (the row is
        # simply not visited); the render entry stays active
        f.flags[3] = 0
        f.tick()
        self.assertEqual((f.state(), self.lib.session_a36_registered(f.binding)), ((0, 1), 1))

    def test_same_name_across_raw_types_reuses_one_cached_surface(self):
        f = self.fixture([overlay36(b'TUT_Next_OVL'), overlay37(b'tut_next_ovl')])
        f.tick()
        self.assertEqual(f.loaded, [b'TUT_Next_OVL'])
        self.assertEqual(self.lib.session_a36_registered(f.binding), 2)

    def test_list_order_is_registration_order_across_both_raw_types(self):
        f = self.fixture([overlay37(b'A'), overlay36(b'B'), overlay37(b'C')])
        f.tick()
        manager = self.lib.session_a36_manager(f.binding)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 3)
        self.assertEqual(f.loaded, [b'A', b'B', b'C'])
        del manager

    def test_the_autotext_surface_is_not_available_so_such_a_row_is_an_explicit_stop(self):
        # USE_AUTOTEXT1..3 take the surface globals 0x5d0397/9b/9f; the native app does not
        # provide them (they are 0 here too). The row must stop the session before any effect.
        for name in (b'USE_AUTOTEXT1', b'USE_AUTOTEXT3'):
            f = self.fixture([overlay37(name)])
            status, result = f.tick()
            self.assertEqual((status, result.failure.action_type, result.failure.detail_status),
                             (session.SESSION_BLOCKED, 0x37, 1), name)
            self.assertIn(b'AUTOTEXT', self.lib.session_a36_failure(f.binding))
            self.assertEqual(self.lib.session_a36_registered(f.binding), 0)
            self.assertEqual(f.state(), (0, 0))

    def test_handler_checks_the_raw_type_against_the_row_image(self):
        f = self.fixture([overlay37(b'A37'), overlay36(b'A36')])
        info = session.SceneActionInfo()
        before, out = session.RuntimeState(0, 0), session.HandlerResult(123, 456)
        for row, wrong in ((0, 0x36), (1, 0x37)):
            self.assertEqual(self.lib.scene_resource_action_at(f.scene, row, c.byref(info)), 0)
            info.type = wrong
            self.assertEqual(self.lib.session_a36_handler(f.binding, row, c.byref(info),
                                                          c.byref(before), c.byref(out)), 2, row)
        info.type = 0x38
        self.assertEqual(self.lib.session_a36_handler(f.binding, 0, c.byref(info),
                                                      c.byref(before), c.byref(out)), 2)
        self.assertEqual((out.disposition, out.phase), (123, 456))

    def test_the_original_0x36_behaviour_is_unchanged_next_to_a_0x37_row(self):
        f = self.fixture([overlay37(b'A37'), overlay36(b'A36', event=(7, 3), pairs=[(9, 2)])])
        f.tick()
        self.assertEqual((f.state(0), f.state(1)), ((0, 1), (0, 1)))
        f.flags[7] = 3
        f.tick()
        f.tick()
        self.assertEqual((f.state(0), f.state(1), f.flags[9]), ((0, 1), (1, 0), 2))

    def test_a_new_scene_rebuilds_the_0x37_images_and_resets_the_manager(self):
        f = self.fixture([overlay37(b'A37')])
        f.tick()
        other, owner = session.open_scene(self.lib, [overlay37(b'B37', layer=11), overlay36(b'C')])
        self.assertEqual(self.lib.session_a36_begin_scene(f.binding, other), 0)
        self.assertEqual(self.lib.session_a36_registered(f.binding), 0)
        self.assertEqual(self.lib.session_a36_row_name(f.binding, 0), b'B37')
        self.assertEqual(self.lib.session_a36_row_raw_type(f.binding, 1), 0x36)
        self.lib.scene_resource_close(other)
        del owner

    def test_exhausting_the_render_table_with_0x37_rows_is_an_explicit_rejection(self):
        # 41 rows sharing one image name (one cached surface): the original reports an error
        # at the 41st registration (manager list and render table hold 40); the native binding
        # stops with a bounds status before touching anything.
        actions = [overlay37(b'SAME') for _ in range(41)]
        f = self.fixture(actions)
        status, result = f.tick()
        # a handler ERROR (not UNSUPPORTED) ends the session tick with the executor error
        self.assertEqual((status, result.failure.action_index, result.failure.action_type),
                         (SESSION_ERR_EXECUTOR, 40, 0x37))
        self.assertIn(b'overlay list is full', self.lib.session_a36_failure(f.binding))
        self.assertEqual(self.lib.session_a36_registered(f.binding), 40)


class GateModeTests(ext_tests.ExecutorExtensionTests):
    """The dispatcher gates every overlay row with 0x423f57 mode 1 because the loaders store
    the runtime type 0x36 (0x40c43a raw 0x38 arm, 0x40c47b raw 0x37 arm, 0x40c3dd arm raw 0x36),
    not the raw type. The executor sees the raw type and must map it."""

    def modes_for(self, action):
        self.events.clear()
        executor, world, _ = self.setup_executor([action])
        self.register(executor, self.make_extension(lambda r: (0, 1, 0)))
        self.step(executor, self.condition_state(world))
        return [e[2] for e in self.events if e[0] == 'leaf']

    def test_overlay_rows_are_gated_with_mode_one_for_every_raw_type(self):
        condition = ext_tests.condition
        body36 = t36.raw_body(t36.prefix(b'A'), [t36.primary_record()], [t36.secondary(0)])
        self.assertEqual(self.modes_for(session.action(0x36, 1, body36, (condition(11, 1),))), [1])
        self.assertEqual(self.modes_for(session.action(0x37, 1, body37(), (condition(11, 1),))), [1])
        self.assertEqual(self.modes_for(session.action(0x38, 1, t38.body_fixture(tail=0),
                                                       (condition(11, 1),))), [1])


# The inherited RT-4 tests are not RT-18's; keep only the new one.
for _name in list(vars(ext_tests.ExecutorExtensionTests)):
    if _name.startswith('test_') and _name not in vars(GateModeTests):
        setattr(GateModeTests, _name, None)


if __name__ == '__main__':
    unittest.main()
