import ctypes as c
from pathlib import Path
import unittest


class SceneSummary(c.Structure):
    _fields_ = [
        ("title", c.c_char * 51),
        ("background", c.c_char * 34),
        ("audio", c.c_char * 34),
        ("raw_tail", c.c_uint8 * 10),
        ("action_count", c.c_size_t),
    ]


class SceneActionInfo(c.Structure):
    _fields_ = [
        ("description", c.c_char * 49),
        ("type", c.c_uint8),
        ("subtype", c.c_uint8),
        ("payload_kind", c.c_int),
        ("raw_body", c.POINTER(c.c_uint8)),
        ("raw_body_length", c.c_size_t),
        ("typed_body", c.POINTER(c.c_uint8)),
        ("typed_body_length", c.c_size_t),
        ("dependency_records", c.POINTER(c.c_uint8)),
        ("dependency_count", c.c_size_t),
    ]


class SceneDependencyInfo(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("or_after", c.c_int16),
        ("raw_bytes", c.POINTER(c.c_uint8)),
        ("fields", c.c_int16 * 8),
    ]


class SceneResourceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        project = Path(__file__).resolve().parents[1]
        library = project / "build/libsceneresource.dylib"
        if not library.is_file():
            raise unittest.SkipTest("Build scene_resource with scripts/build_scene_resource.sh first")
        cls.lib = c.CDLL(str(library))
        cls.lib.scene_resource_open_memory.argtypes = [
            c.POINTER(c.c_uint8), c.c_size_t, c.c_char_p, c.c_size_t
        ]
        cls.lib.scene_resource_open_memory.restype = c.c_void_p
        cls.lib.scene_resource_close.argtypes = [c.c_void_p]
        cls.lib.scene_resource_get_summary.argtypes = [c.c_void_p, c.POINTER(SceneSummary)]
        cls.lib.scene_resource_get_summary.restype = c.c_int
        cls.lib.scene_resource_action_count.argtypes = [c.c_void_p]
        cls.lib.scene_resource_action_count.restype = c.c_size_t
        cls.lib.scene_resource_action_at.argtypes = [
            c.c_void_p, c.c_size_t, c.POINTER(SceneActionInfo)
        ]
        cls.lib.scene_resource_action_at.restype = c.c_int
        cls.lib.scene_resource_dependency_at.argtypes = [
            c.c_void_p, c.c_size_t, c.c_size_t, c.POINTER(SceneDependencyInfo)
        ]
        cls.lib.scene_resource_dependency_at.restype = c.c_int

    def open_bytes(self, data):
        buffer = (c.c_uint8 * len(data)).from_buffer_copy(data)
        error = c.create_string_buffer(256)
        scene = self.lib.scene_resource_open_memory(buffer, len(data), error, len(error))
        return scene, error.value.decode("utf-8", "replace")

    @staticmethod
    def chunk(identifier, payload):
        return identifier + len(payload).to_bytes(4, "big") + payload + (b"\0" if len(payload) & 1 else b"")

    @classmethod
    def resource(cls, act_payload=None, tsum_length=126):
        tsum = bytearray(126)
        tsum[:len(b"Test scene\0")] = b"Test scene\0"
        tsum[50:len(b"background\0") + 50] = b"background\0"
        tsum[83:len(b"sound\0") + 83] = b"sound\0"
        chunks = [cls.chunk(b"TSUM", bytes(tsum[:tsum_length]))]
        if act_payload is not None:
            chunks.append(cls.chunk(b"ACT\0", act_payload))
        body = b"SCEN" + b"".join(chunks)
        return b"DATA" + len(body).to_bytes(4, "big") + body

    def test_decodes_s0_summary_and_original_action_count(self):
        path = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/0800.bin"
        scene, error = self.open_bytes(path.read_bytes())
        self.assertIsNotNone(scene, error)
        try:
            summary = SceneSummary()
            self.assertEqual(self.lib.scene_resource_get_summary(scene, c.byref(summary)), 0)
            self.assertEqual(summary.title, b"Player Challenge Screen")
            self.assertEqual(summary.background, b"diff")
            self.assertEqual(summary.audio, b"ndsig")
            self.assertEqual(summary.action_count, 38)
            self.assertEqual(self.lib.scene_resource_action_count(scene), 38)
        finally:
            self.lib.scene_resource_close(scene)

    def test_s0_start_map_preserves_two_or_dependencies(self):
        path = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/0800.bin"
        scene, error = self.open_bytes(path.read_bytes())
        self.assertIsNotNone(scene, error)
        try:
            matches = []
            for index in range(self.lib.scene_resource_action_count(scene)):
                action = SceneActionInfo()
                self.assertEqual(self.lib.scene_resource_action_at(scene, index, c.byref(action)), 0)
                if action.description == b"->start map":
                    matches.append((index, action))
            self.assertEqual(len(matches), 1)
            action_index, action = matches[0]
            self.assertEqual((action.type, action.subtype), (0x0A, 1))
            self.assertEqual(action.typed_body_length, 20)
            self.assertEqual(action.dependency_count, 2)
            for dependency_index in range(2):
                dependency = SceneDependencyInfo()
                self.assertEqual(
                    self.lib.scene_resource_dependency_at(
                        scene, action_index, dependency_index, c.byref(dependency)
                    ),
                    0,
                )
                self.assertEqual(dependency.opcode, 2)
                self.assertEqual(dependency.or_after, 1)
                self.assertEqual(dependency.fields[0], 2)
                self.assertEqual(dependency.fields[3], 1)
                self.assertEqual(c.string_at(dependency.raw_bytes, 16)[6:8], b"\x01\0")
        finally:
            self.lib.scene_resource_close(scene)

    def test_s5900_action_8_has_a28_body_and_flag_1000_dependency(self):
        path = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/2743.bin"
        scene, error = self.open_bytes(path.read_bytes())
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 8, c.byref(action)), 0)
            self.assertEqual((action.type, action.subtype), (0x28, 1))
            self.assertEqual((action.payload_kind, action.typed_body_length,
                              action.dependency_count), (1, 21, 1))
            self.assertEqual(
                c.string_at(action.typed_body, action.typed_body_length).hex(),
                "02f401d00700000000000000000000000000000000",
            )
            dependency = SceneDependencyInfo()
            self.assertEqual(self.lib.scene_resource_dependency_at(
                scene, 8, 0, c.byref(dependency)), 0)
            self.assertEqual(tuple(dependency.fields[:4]), (2, 1000, 1, 0))
        finally:
            self.lib.scene_resource_close(scene)

    def test_unknown_action_type_keeps_entire_body_opaque(self):
        description = b"unknown action".ljust(48, b"\0")
        scene, error = self.open_bytes(
            self.resource(description + bytes((0xFE, 1)) + b"opaque body and possible tail")
        )
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.type, 0xFE)
            self.assertEqual(action.payload_kind, 0)
            self.assertEqual(action.typed_body_length, 0)
            self.assertFalse(bool(action.typed_body))
            self.assertEqual(action.dependency_count, 0)
            self.assertEqual(action.raw_body_length, len(b"opaque body and possible tail"))
        finally:
            self.lib.scene_resource_close(scene)

    def test_s0_sound_action_has_original_9f_boundary_and_dependency(self):
        path = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources/0800.bin"
        scene, error = self.open_bytes(path.read_bytes())
        self.assertIsNotNone(scene, error)
        try:
            found = []
            for index in range(self.lib.scene_resource_action_count(scene)):
                action = SceneActionInfo()
                self.assertEqual(self.lib.scene_resource_action_at(scene, index, c.byref(action)), 0)
                if action.description == b"Sound":
                    found.append((index, action))
            self.assertEqual(len(found), 1)
            action_index, action = found[0]
            self.assertEqual((action.type, action.subtype), (0x9F, 1))
            self.assertEqual(action.payload_kind, 3)
            self.assertEqual(action.raw_body_length, 97)
            self.assertEqual(action.typed_body_length, 81)
            self.assertEqual(action.dependency_count, 1)
            body = c.string_at(action.typed_body, action.typed_body_length)
            self.assertEqual(int.from_bytes(body[46:48], "little"), 0xFFFF)
            dependency = SceneDependencyInfo()
            self.assertEqual(
                self.lib.scene_resource_dependency_at(scene, action_index, 0, c.byref(dependency)),
                0,
            )
            self.assertEqual(c.string_at(dependency.raw_bytes, 16), c.string_at(action.dependency_records, 16))
        finally:
            self.lib.scene_resource_close(scene)

    def test_new_fixed_action_boundaries_and_truncation(self):
        fixed_lengths = {
            0x28: 21,
            0x0B: 24,
            0x4F: 10,
            0x78: 6,
            0xD9: 35,
            0x47: 39,
            0x95: 3,
            0x37: 69,
        }
        for action_type, body_length in fixed_lengths.items():
            with self.subTest(action_type=hex(action_type)):
                description = b"boundary".ljust(48, b"\0")
                body = bytes((action_type, 1)) + bytes(body_length) + bytes(range(16))
                scene, error = self.open_bytes(self.resource(description + body))
                self.assertIsNotNone(scene, error)
                try:
                    action = SceneActionInfo()
                    self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
                    self.assertEqual(action.type, action_type)
                    self.assertEqual(action.payload_kind, 1)
                    self.assertEqual(action.typed_body_length, body_length)
                    self.assertEqual(action.dependency_count, 1)
                    self.assertEqual(c.string_at(action.dependency_records, 16), bytes(range(16)))
                finally:
                    self.lib.scene_resource_close(scene)

                truncated = bytes((action_type, 1)) + bytes(body_length - 1)
                scene, error = self.open_bytes(self.resource(description + truncated))
                self.assertIsNone(scene, error)
                self.assertTrue(error)

    def test_64_clock_action_is_exactly_five_bytes_with_separate_dependency_tail(self):
        description = b"clock action".ljust(48, b"\0")
        typed = bytes((3,)) + (-2).to_bytes(2, "little", signed=True) + (300).to_bytes(2, "little", signed=True)
        dependency = bytes(range(16))
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x64, 2)) + typed + dependency)
        )
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.type, 0x64)
            self.assertEqual(action.payload_kind, 1)
            self.assertEqual(action.typed_body_length, 5)
            self.assertEqual(c.string_at(action.typed_body, 5), typed)
            self.assertEqual(action.dependency_count, 1)
            self.assertEqual(c.string_at(action.dependency_records, 16), dependency)
        finally:
            self.lib.scene_resource_close(scene)

        scene, error = self.open_bytes(
            self.resource(description + bytes((0x64, 2)) + typed[:-1])
        )
        self.assertIsNone(scene)
        self.assertTrue(error)

    def test_62_count_body_and_dependency_tail_are_independent(self):
        description = b"counted action".ljust(48, b"\0")
        body = bytearray(12 + 18)
        body[10:12] = (1).to_bytes(2, "little", signed=True)
        body[12:30] = bytes(range(18))
        dependency = bytes(range(0x80, 0x90))
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x62, 7)) + body + dependency)
        )
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.type, 0x62)
            self.assertEqual(action.payload_kind, 3)
            self.assertEqual(action.typed_body_length, 30)
            self.assertEqual(c.string_at(action.typed_body, 30), bytes(body))
            self.assertEqual(action.dependency_count, 1)
            self.assertEqual(c.string_at(action.dependency_records, 16), dependency)
        finally:
            self.lib.scene_resource_close(scene)

        empty = bytearray(12)
        scene, error = self.open_bytes(self.resource(description + bytes((0x62, 0)) + empty))
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.typed_body_length, 12)
            self.assertEqual(action.dependency_count, 0)
        finally:
            self.lib.scene_resource_close(scene)

    def test_62_rejects_truncated_prefix_entries_negative_or_unrepresentable_counts(self):
        description = b"bad counted action".ljust(48, b"\0")
        for prefix_length in range(12):
            with self.subTest(prefix_length=prefix_length):
                body = bytearray(prefix_length)
                if prefix_length >= 12:
                    body[10:12] = (0).to_bytes(2, "little", signed=True)
                scene, error = self.open_bytes(
                    self.resource(description + bytes((0x62, 0)) + body)
                )
                self.assertIsNone(scene)
                self.assertTrue(error)

        for count in (-1, 1820):
            with self.subTest(count=count):
                body = bytearray(12)
                body[10:12] = count.to_bytes(2, "little", signed=True)
                scene, error = self.open_bytes(
                    self.resource(description + bytes((0x62, 0)) + body)
                )
                self.assertIsNone(scene)
                self.assertTrue(error)

        # Count one requires all 18 bytes of its entry after the 12-byte prefix.
        for short_entry_bytes in range(18):
            with self.subTest(short_entry_bytes=short_entry_bytes):
                body = bytearray(12 + short_entry_bytes)
                body[10:12] = (1).to_bytes(2, "little", signed=True)
                scene, error = self.open_bytes(
                    self.resource(description + bytes((0x62, 0)) + body)
                )
                self.assertIsNone(scene)
                self.assertTrue(error)

    def test_62_signed_short_boundary_and_dependency_remainder(self):
        description = b"count limit".ljust(48, b"\0")
        maximum = bytearray(12 + 1819 * 18)
        maximum[10:12] = (1819).to_bytes(2, "little", signed=True)
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x62, 0)) + maximum)
        )
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.typed_body_length, 32754)
            self.assertEqual(action.dependency_count, 0)
        finally:
            self.lib.scene_resource_close(scene)

        body = bytearray(12)
        body[10:12] = (0).to_bytes(2, "little", signed=True)
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x62, 0)) + body + b"\x99")
        )
        self.assertIsNone(scene)
        self.assertTrue(error)

    def test_51_selector_boundaries_and_dependency_tail(self):
        description = b"multi textbox".ljust(48, b"\0")
        dependency = bytes(range(0xA0, 0xB0))
        auto_text = bytearray(45)
        auto_text[10:12] = (-1).to_bytes(2, "little", signed=True)
        scene, error = self.open_bytes(self.resource(
            description + bytes((0x51, 1)) + auto_text + dependency
        ))
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.type, action.payload_kind,
                              action.typed_body_length, action.dependency_count),
                             (0x51, 3, 45, 1))
            self.assertEqual(c.string_at(action.dependency_records, 16), dependency)
        finally:
            self.lib.scene_resource_close(scene)

        inline = bytearray(15)
        inline[10:12] = (3).to_bytes(2, "little", signed=True)
        inline[12:15] = b"abc"
        scene, error = self.open_bytes(self.resource(
            description + bytes((0x51, 1)) + inline + dependency
        ))
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.typed_body_length, 15)
            self.assertEqual(action.dependency_count, 1)
            self.assertEqual(c.string_at(action.typed_body, 15), bytes(inline))
        finally:
            self.lib.scene_resource_close(scene)

    def test_51_rejects_short_prefix_unsupported_negative_and_oversized_selectors(self):
        description = b"invalid multi textbox".ljust(48, b"\0")
        for prefix_length in range(12):
            with self.subTest(prefix_length=prefix_length):
                scene, error = self.open_bytes(self.resource(
                    description + bytes((0x51, 1)) + bytes(prefix_length)
                ))
                self.assertIsNone(scene)
                self.assertTrue(error)
        for selector in (-2, 10000):
            with self.subTest(selector=selector):
                body = bytearray(12)
                body[10:12] = selector.to_bytes(2, "little", signed=True)
                scene, error = self.open_bytes(self.resource(
                    description + bytes((0x51, 1)) + body
                ))
                self.assertIsNone(scene)
                self.assertTrue(error)

    def test_63_remains_opaque(self):
        description = b"sibling action".ljust(48, b"\0")
        body = bytearray(30)
        body[10:12] = (1).to_bytes(2, "little", signed=True)
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x63, 0)) + body)
        )
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.type, 0x63)
            self.assertEqual(action.payload_kind, 0)
            self.assertEqual(action.typed_body_length, 0)
            self.assertFalse(bool(action.typed_body))
            self.assertEqual(action.raw_body_length, len(body))
            self.assertEqual(action.dependency_count, 0)
        finally:
            self.lib.scene_resource_close(scene)

    def test_9f_numeric_and_malformed_boundaries(self):
        description = b"numbered sound".ljust(48, b"\0")
        body = bytearray(0x35)
        body[46:48] = (5).to_bytes(2, "little")
        scene, error = self.open_bytes(self.resource(description + bytes((0x9F, 1)) + body))
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual(action.type, 0x9F)
            self.assertEqual(action.payload_kind, 3)
            self.assertEqual(action.typed_body_length, 0x35)
            self.assertEqual(action.dependency_count, 0)
        finally:
            self.lib.scene_resource_close(scene)

        short_sentinel_body = bytearray(0x50)
        short_sentinel_body[46:48] = b"\xff\xff"
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x9F, 1)) + bytes(short_sentinel_body))
        )
        self.assertIsNone(scene)
        self.assertTrue(error)

        invalid_selector_body = bytearray(48)
        invalid_selector_body[46:48] = (10000).to_bytes(2, "little")
        scene, error = self.open_bytes(
            self.resource(description + bytes((0x9F, 1)) + bytes(invalid_selector_body))
        )
        self.assertIsNone(scene)
        self.assertTrue(error)

    def test_dependency_prescan_rejects_what_the_original_aborts_on(self):
        description = b"prescan action".ljust(48, b"\0")

        def row(opcode, word6=1):
            record = bytearray(16)
            record[0:2] = opcode.to_bytes(2, "little", signed=True)
            record[6:8] = word6.to_bytes(2, "little", signed=True)
            return bytes(record)

        def opens(rows):
            body = description + bytes((0x79, 1)) + bytes(2) + b"".join(rows)
            scene, _ = self.open_bytes(self.resource(body))
            if scene:
                self.lib.scene_resource_close(scene)
            return scene is not None

        leaf = row(2)
        self.assertTrue(opens([]))
        self.assertTrue(opens([leaf, leaf]))
        self.assertTrue(opens([row(0x12), leaf, leaf, row(0x13)]))
        self.assertTrue(opens([row(0x13), row(0x12)]), "ordering is not checked here")
        self.assertTrue(opens([row(0x0B, 1), row(0x0B, 1)]))
        self.assertTrue(opens([row(0x0B, 0), leaf]))
        self.assertFalse(opens([row(0x12), row(0x13)]), "empty group")
        self.assertFalse(opens([row(0x12), leaf, row(0x13)]), "one-leaf group")
        self.assertFalse(opens([row(0x12), leaf, leaf]), "unclosed group")
        self.assertFalse(opens([row(0x13)]), "unopened close")
        self.assertFalse(opens([row(0x0B, 0), row(0x0B, 1)]), "adjacent 0x0b pair, zero word")

    def test_1b_and_33_count_boundaries_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(action_type, body):
            return self.open_bytes(self.resource(description + bytes((action_type, 1)) + body))

        def i16(value):
            return value.to_bytes(2, "little", signed=True)

        def body_1b(n1, n2):
            return i16(n1) + bytes(22 * n1) + bytes(22) + i16(n2) + bytes(18 * n2)

        def body_33(a, b):
            body = bytearray(113)
            body[109:111] = i16(a)
            body[111:113] = i16(b)
            return bytes(body) + bytes(6 * max(a, 0) + 66 * max(b, 0))

        def check(action_type, body, typed, deps):
            scene, error = open_action(action_type, body)
            self.assertIsNotNone(scene, error)
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.payload_kind, action.typed_body_length, action.dependency_count),
                             (3, typed, deps))
            self.lib.scene_resource_close(scene)

        check(0x1B, body_1b(2, 3) + dependency, 26 + 44 + 54, 1)
        check(0x1B, body_1b(0, 0), 26, 0)
        check(0x33, body_33(2, 1) + dependency, 113 + 12 + 66, 1)
        check(0x33, body_33(0, 0), 113, 0)
        for label, action_type, body in (
                ("0x1b negative primary", 0x1B, i16(-1) + bytes(48)),
                ("0x1b negative secondary", 0x1B, i16(0) + bytes(22) + i16(-1)),
                ("0x1b truncated entries", 0x1B, body_1b(2, 3)[:-1]),
                ("0x1b fractional tail", 0x1B, body_1b(1, 1) + dependency[:5]),
                ("0x1b short body", 0x1B, bytes(1)),
                ("0x33 negative count", 0x33, body_33(-1, 0)),
                ("0x33 truncated entries", 0x33, body_33(2, 1)[:-1]),
                ("0x33 size above the native bound", 0x33, body_33(0, 500)),
                ("0x33 fractional tail", 0x33, body_33(0, 0) + dependency[:5]),
                ("0x33 short body", 0x33, bytes(112))):
            scene, _ = open_action(action_type, body)
            self.assertIsNone(scene, label)

    def test_4b_selector_forms_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(body):
            return self.open_bytes(self.resource(description + bytes((0x4B, 1)) + body))

        def keyed(key=b"KEY"):
            return (-1).to_bytes(2, "little", signed=True) + key.ljust(33, b"\0")

        def inline(selector, text=b""):
            return selector.to_bytes(2, "little", signed=True) + text

        for body, typed, deps in ((keyed() + dependency, 35, 1), (inline(4, b"hi\0\0"), 6, 0),
                                  (inline(0) + dependency, 2, 1)):
            scene, error = open_action(body)
            self.assertIsNotNone(scene, error)
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.type, action.payload_kind, action.typed_body_length,
                              action.dependency_count), (0x4B, 3, typed, deps))
            self.lib.scene_resource_close(scene)
        for label, body in (("unterminated key", keyed(b"x" * 33)),
                            ("selector -2", inline(-2)),
                            ("selector above the native bound", inline(10000)),
                            ("truncated inline text", inline(8, b"hi")),
                            ("fractional tail", keyed() + dependency[:5]),
                            ("short body", b"\0")):
            scene, _ = open_action(body)
            self.assertIsNone(scene, label)

    def test_0c_and_17_count_boundaries_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(action_type, body):
            return self.open_bytes(self.resource(description + bytes((action_type, 1)) + body))

        def body_of(base, offset, count):
            body = bytearray(base)
            body[offset:offset + 2] = count.to_bytes(2, "little", signed=True)
            return bytes(body) + bytes(18 * max(count, 0))

        for action_type, base, offset in ((0x0C, 10, 8), (0x17, 22, 20), (0x16, 22, 20)):
            scene, error = open_action(action_type, body_of(base, offset, 3) + dependency)
            self.assertIsNotNone(scene, error)
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.type, action.payload_kind, action.typed_body_length,
                              action.dependency_count), (action_type, 3, base + 54, 1))
            self.lib.scene_resource_close(scene)
            scene, error = open_action(action_type, body_of(base, offset, 1819))
            self.assertIsNotNone(scene, error)
            self.lib.scene_resource_close(scene)
            for label, body in (("negative count", body_of(base, offset, -1)),
                                ("count above the native bound", body_of(base, offset, 1820)),
                                ("truncated entries", body_of(base, offset, 3)[:-1]),
                                ("fractional tail", body_of(base, offset, 1) + dependency[:5]),
                                ("short body", bytes(base - 1))):
                scene, _ = open_action(action_type, body)
                self.assertIsNone(scene, (action_type, label))

    def test_45_44_36_boundaries_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(action_type, body):
            return self.open_bytes(self.resource(description + bytes((action_type, 1)) + body))

        def check(action_type, body, typed, dependencies):
            scene, error = open_action(action_type, body)
            self.assertIsNotNone(scene, error)
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.type, action.payload_kind, action.typed_body_length,
                              action.dependency_count), (action_type, 3, typed, dependencies))
            self.lib.scene_resource_close(scene)

        def reject(action_type, body, label):
            scene, _ = open_action(action_type, body)
            self.assertIsNone(scene, label)

        def body_45(count):
            body = bytearray(196)
            body[194:196] = count.to_bytes(2, "little", signed=True)
            return bytes(body) + bytes(4 * max(count, 0))

        check(0x45, body_45(0) + dependency, 196, 1)
        check(0x45, body_45(10), 236, 0)
        reject(0x45, body_45(11), "0x45 count above the original limit")
        reject(0x45, body_45(-1) + bytes(4), "0x45 negative count")
        reject(0x45, body_45(2) + dependency[:5], "0x45 fractional tail")
        reject(0x45, bytes(195), "0x45 short body")

        def body_44(keyed, count=0, text=b"", option=1):
            body = bytearray(528)
            body[2:4] = option.to_bytes(2, "little")
            body[492] = 1 if keyed else 0
            body[493:496] = b"KEY"
            body[526:528] = count.to_bytes(2, "little", signed=True)
            return bytes(body) + text

        check(0x44, body_44(True) + dependency, 528, 1)
        check(0x44, body_44(False, 4, b"hi\0\0"), 532, 0)
        key33 = bytearray(body_44(True))
        key33[493:526] = b"x" * 33
        reject(0x44, bytes(key33), "0x44 unterminated key")
        reject(0x44, body_44(False, -1), "0x44 negative inline count")
        reject(0x44, body_44(False, 3, b"abc"), "0x44 inline text without NUL")
        reject(0x44, body_44(False, 3, b"hi\0", option=3), "0x44 inline option 3")
        reject(0x44, body_44(True) + dependency[:7], "0x44 fractional tail")

        def body_36(primary, secondary, mode=1, lo=0, hi=0):
            body = bytearray(0xac)
            body[0x29:0x2b] = mode.to_bytes(2, "little")
            body[0x2b:0x2d] = primary.to_bytes(2, "little", signed=True)
            body[0x33:0x35] = lo.to_bytes(2, "little", signed=True)
            body[0x35:0x37] = hi.to_bytes(2, "little", signed=True)
            body[0xaa:0xac] = secondary.to_bytes(2, "little", signed=True)
            return bytes(body) + bytes(16 * max(primary, 0) + 38 * max(secondary, 0))

        check(0x36, body_36(3, 2) + dependency, 0xac + 48 + 76, 1)
        # Mode 2 derives the count from the endpoints, narrowed to a signed word.
        endpoint = bytearray(body_36(0, 0, mode=2, lo=5, hi=7))
        endpoint += bytes(16 * 3)
        check(0x36, bytes(endpoint), 0xac + 48, 0)
        reject(0x36, body_36(101, 0), "0x36 primary above the native bound")
        reject(0x36, body_36(0, 26), "0x36 secondary above the native bound")
        reject(0x36, body_36(-1, 0), "0x36 negative primary")
        reject(0x36, body_36(1, 0) + dependency[:3], "0x36 fractional tail")
        reject(0x36, bytes(0xab), "0x36 short body")

    def test_43_keyed_and_inline_boundaries_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")

        def open_action(body):
            return self.open_bytes(self.resource(description + bytes((0x43, 1)) + body))

        def body_43(keyed, count=0, text=b"", key=b"KEY", option=1):
            body = bytearray(301)
            body[2:4] = option.to_bytes(2, "little")
            body[0x109] = 1 if keyed else 0
            body[0x10a:0x10a + len(key)] = key
            body[0x12b:0x12d] = count.to_bytes(2, "little", signed=True)
            return bytes(body) + text

        dependency = bytes(range(16))
        scene, error = open_action(body_43(True) + dependency)
        self.assertIsNotNone(scene, error)
        action = SceneActionInfo()
        self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
        self.assertEqual((action.type, action.typed_body_length, action.dependency_count), (0x43, 301, 1))
        self.lib.scene_resource_close(scene)
        scene, error = open_action(body_43(False, 4, b"hi\0\0"))
        self.assertIsNotNone(scene, error)
        self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
        self.assertEqual((action.typed_body_length, action.dependency_count), (305, 0))
        self.lib.scene_resource_close(scene)
        for label, body in (
            ("fractional tail", body_43(True) + dependency[:7]),
            ("unterminated key", body_43(True, key=b"x" * 33)),
            ("negative inline count", body_43(False, -1)),
            ("inline text without NUL", body_43(False, 3, b"abc")),
            ("inline text truncated", body_43(False, 8, b"hi\0")),
            ("inline option 3", body_43(False, 3, b"hi\0", option=3)),
            ("short body", bytes(300)),
        ):
            scene, _ = open_action(body)
            self.assertIsNone(scene, label)

    def test_3e_boundary_requires_terminated_name_and_key_fields(self):
        description = b"variable action".ljust(48, b"\0")

        def open_action(body):
            return self.open_bytes(self.resource(description + bytes((0x3E, 1)) + body))

        prefix = bytearray(178)
        prefix[176:178] = (1).to_bytes(2, "little")
        record = bytes((2, 0)) + bytes(10) + bytes(68)
        trailer = bytes(2)
        scene, error = open_action(bytes(prefix) + record + trailer)
        self.assertIsNotNone(scene, error)
        self.lib.scene_resource_close(scene)
        for label, offset in (("name", 0), ("name 21", 33), ("name 42", 66),
                              ("name 65", 101), ("text key", 136)):
            body = bytearray(prefix + record + trailer)
            body[offset:offset + 33] = b"x" * 33
            scene, _ = open_action(bytes(body))
            self.assertIsNone(scene, label)
        for label, offset in (("primary key", 2 + 10), ("primary name", 35 + 10)):
            body = bytearray(prefix + record + trailer)
            start = 178 + offset
            body[start:start + 33] = b"x" * 33
            scene, _ = open_action(bytes(body))
            self.assertIsNone(scene, label)

    def test_3f_boundary_requires_terminated_name_and_key_fields(self):
        description = b"variable action".ljust(48, b"\0")

        def open_action(body):
            return self.open_bytes(self.resource(description + bytes((0x3F, 1)) + body))

        prefix = bytearray(77)
        prefix[75:77] = (1).to_bytes(2, "little")
        record = bytes((2, 0)) + bytes(10) + bytes(68)   # count 2: 2 + 10 + 68 bytes
        trailer = bytes(2)
        scene, error = open_action(bytes(prefix) + record + trailer)
        self.assertIsNotNone(scene, error)
        self.lib.scene_resource_close(scene)
        for label, offset in (("top-level name", 0), ("top-level key", 35)):
            body = bytearray(prefix + record + trailer)
            body[offset:offset + 33] = b"x" * 33
            scene, _ = open_action(bytes(body))
            self.assertIsNone(scene, label)
        for label, offset in (("primary key", 2 + 10), ("primary name", 35 + 10)):
            body = bytearray(prefix + record + trailer)
            start = 77 + offset
            body[start:start + 33] = b"x" * 33
            scene, _ = open_action(bytes(body))
            self.assertIsNone(scene, label)

    def test_97_and_a1_variable_body_boundaries_and_rejections(self):
        description = b"variable action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(action_type, body):
            return self.open_bytes(self.resource(description + bytes((action_type, 1)) + body))

        def body_97(entries):
            body = bytearray((len(entries)).to_bytes(2, "little") + bytes(13 + 33 * len(entries)))
            for selector, extra in entries:
                body += selector.to_bytes(2, "little", signed=True) + extra
            return bytes(body)

        # A -1 entry consumes 35 bytes, a non-negative one 2 + selector.
        typed = body_97([(-1, bytes(33)), (3, bytes(3))])
        scene, error = open_action(0x97, typed + dependency)
        self.assertIsNotNone(scene, error)
        try:
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.type, action.payload_kind), (0x97, 3))
            self.assertEqual(action.typed_body_length, 15 + 66 + 35 + 5)
            self.assertEqual(action.dependency_count, 1)
        finally:
            self.lib.scene_resource_close(scene)
        for label, body in (
            ("zero count", b"\0\0" + bytes(13)),
            ("ten entries", body_97([(0, b"")] * 10)),
            ("other negative selector", body_97([(-2, b"")])),
            ("truncated entry", body_97([(5, bytes(2))])),
            ("sum above int16", body_97([(30000, bytes(30000)), (3000, bytes(3000))])),
            ("non-multiple tail", typed + dependency[:7]),
        ):
            with self.subTest(label=label):
                scene, error = open_action(0x97, body)
                self.assertIsNone(scene)
                self.assertTrue(error)

        for selector, boundary in ((-1, 84), (0, 51), (9, 60)):
            with self.subTest(a1_selector=selector):
                body = bytearray(boundary)
                body[49:51] = selector.to_bytes(2, "little", signed=True)
                scene, error = open_action(0xA1, bytes(body) + dependency)
                self.assertIsNotNone(scene, error)
                try:
                    action = SceneActionInfo()
                    self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
                    self.assertEqual((action.type, action.payload_kind), (0xA1, 3))
                    self.assertEqual(action.typed_body_length, boundary)
                    self.assertEqual(action.dependency_count, 1)
                finally:
                    self.lib.scene_resource_close(scene)
        for label, selector in (("-2", -2), ("10000", 10000)):
            with self.subTest(a1_rejected=label):
                body = bytearray(51)
                body[49:51] = selector.to_bytes(2, "little", signed=True)
                scene, error = open_action(0xA1, bytes(body))
                self.assertIsNone(scene)
                self.assertTrue(error)

    def test_d3_e0_2d_ee_da_and_77_boundaries_and_rejections(self):
        description = b"batch action".ljust(48, b"\0")
        dependency = bytes(range(16))

        def open_action(action_type, body):
            return self.open_bytes(self.resource(description + bytes((action_type, 1)) + body))

        def i16(value):
            return value.to_bytes(2, "little", signed=True)

        def body_2d(entry_counts, groups):
            body = bytearray(39)
            body[0x23:0x25] = i16(len(entry_counts))
            body[0x25:0x27] = i16(groups)
            for records in entry_counts:
                entry = bytearray(49)
                entry[0x2F:0x31] = i16(records)
                body += entry + bytes(35 * max(records, 0))
            return bytes(body) + bytes(34 * max(groups, 0))

        def check(action_type, body, kind, typed, deps):
            scene, error = open_action(action_type, body)
            self.assertIsNotNone(scene, error)
            action = SceneActionInfo()
            self.assertEqual(self.lib.scene_resource_action_at(scene, 0, c.byref(action)), 0)
            self.assertEqual((action.payload_kind, action.typed_body_length, action.dependency_count),
                             (kind, typed, deps))
            self.lib.scene_resource_close(scene)

        # 0xd3: fixed 855 bytes (0x461903), nothing in the body is examined.
        check(0xD3, bytes(855), 1, 855, 0)
        check(0xD3, bytes(855) + dependency, 1, 855, 1)
        scene, _ = open_action(0xD3, bytes(854))
        self.assertIsNone(scene, "0xd3 short body")
        scene, _ = open_action(0xD3, bytes(855) + dependency[:5])
        self.assertIsNone(scene, "0xd3 fractional tail")

        for action_type, size in ((0xEE, 5826), (0xDA, 2958), (0x77, 731), (0x1C, 105), (0xEB, 2612), (0xD0, 1979), (0xE4, 2034), (0x80, 2), (0x70, 1), (0x20, 8), (0xAA, 763), (0xD6, 1733)):
            check(action_type, bytes(size), 1, size, 0)
            check(action_type, bytes(size) + dependency, 1, size, 1)
            scene, _ = open_action(action_type, bytes(size - 1))
            self.assertIsNone(scene, hex(action_type) + " short body")
            scene, _ = open_action(action_type, bytes(size) + dependency[:5])
            self.assertIsNone(scene, hex(action_type) + " fractional tail")

        # 0xe0: fixed 294 bytes (0x470e8e flag 1); a shorter body stays opaque
        # (scene S2705: the original aborts in the dependency stage there).
        check(0xE0, bytes(294), 1, 294, 0)
        check(0xE0, bytes(294) + dependency, 1, 294, 1)
        check(0xE0, bytes(293), 0, 0, 0)
        scene, _ = open_action(0xE0, bytes(294) + dependency[:5])
        self.assertIsNone(scene, "0xe0 fractional tail")

        # 0x2d: 39 + sum(49 + 35 * n) + 34 * groups (0x4cd243), signed words.
        check(0x2D, body_2d([], 0), 3, 39, 0)
        check(0x2D, body_2d([2, 0, 3], 1) + dependency, 3, 39 + 3 * 49 + 5 * 35 + 34, 1)
        check(0x2D, body_2d([0], 0), 3, 88, 0)
        for label, body in (
                ("0x2d short header", bytes(38)),
                ("0x2d negative entries", bytes(0x23) + i16(-1) + i16(0) + bytes(100)),
                ("0x2d negative groups", bytes(0x25) + i16(-1) + bytes(100)),
                ("0x2d negative records", body_2d([-1], 0) + bytes(64)),
                ("0x2d truncated entry header", body_2d([1], 0)[:39 + 48]),
                ("0x2d truncated records", body_2d([2], 0)[:-1]),
                ("0x2d truncated groups", body_2d([1], 2)[:-1]),
                ("0x2d fractional tail", body_2d([1], 1) + dependency[:5])):
            scene, _ = open_action(0x2D, body)
            self.assertIsNone(scene, label)

    def test_recovered_boundaries_match_every_real_scene_action(self):
        root = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources"
        expected_fixed = {0x0B: 24, 0x4F: 10, 0x78: 6, 0xD9: 35, 0x47: 39, 0x95: 3, 0x64: 5, 0x28: 21, 0x37: 69, 0x6E: 1, 0x79: 2, 0x67: 1, 0x6F: 1, 0x2E: 15, 0x94: 50, 0xD1: 927, 0x4E: 31, 0x68: 1, 0x83: 74, 0x69: 1, 0x65: 1, 0x7D: 1, 0xF6: 4934, 0xEA: 3847, 0xF5: 1390, 0xD3: 855, 0xEE: 5826, 0xDA: 2958, 0x77: 731, 0x1C: 105, 0xEB: 2612, 0xD0: 1979, 0xE4: 2034, 0x80: 2, 0x70: 1, 0x20: 8, 0xAA: 763, 0xD6: 1733}
        counts = {action_type: 0 for action_type in
                  (*expected_fixed, 0x9F, 0x51, 0x62, 0x97, 0xA1, 0x35, 0x38, 0x3F, 0x3E, 0x43, 0x45, 0x44, 0x36, 0x0C, 0x17, 0x4B, 0x16, 0x1B, 0x33)}
        scenes = 0
        actions = 0
        typed_actions = 0
        opaque_actions = 0
        raw_type_counts = {}
        raw_type_pairs = set()
        raw_type_values = set()
        for path in sorted(root.glob("*.bin")):
            raw = path.read_bytes()
            buffer = (c.c_uint8 * len(raw)).from_buffer_copy(raw)
            error = c.create_string_buffer(256)
            scene = self.lib.scene_resource_open_memory(buffer, len(raw), error, len(error))
            if not scene:
                continue
            scenes += 1
            try:
                action_count = self.lib.scene_resource_action_count(scene)
                actions += action_count
                for index in range(action_count):
                    action = SceneActionInfo()
                    self.assertEqual(self.lib.scene_resource_action_at(scene, index, c.byref(action)), 0)
                    raw_type_values.add(action.type)
                    raw_type_counts[action.type] = raw_type_counts.get(action.type, 0) + 1
                    raw_type_pairs.add((action.type, action.subtype))
                    if action.payload_kind == 0:
                        opaque_actions += 1
                    else:
                        typed_actions += 1
                    if action.type in expected_fixed:
                        counts[action.type] += 1
                        self.assertEqual(action.payload_kind, 1, (path.name, index, hex(action.type)))
                        self.assertEqual(
                            action.typed_body_length,
                            expected_fixed[action.type],
                            (path.name, index, hex(action.type)),
                        )
                    elif action.type == 0x9F:
                        counts[0x9F] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        selector = int.from_bytes(body[46:48], "little")
                        boundary = 0x51 if selector == 0xFFFF else selector + 0x30
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(
                            action.typed_body_length,
                            boundary,
                            (path.name, index, selector),
                        )
                        self.assertEqual(
                            action.dependency_count,
                            (len(body) - boundary) // 16,
                            (path.name, index, selector),
                        )
                    elif action.type == 0x62:
                        counts[0x62] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        self.assertGreaterEqual(len(body), 12, (path.name, index))
                        count = int.from_bytes(body[10:12], "little", signed=True)
                        self.assertGreaterEqual(count, 0, (path.name, index, count))
                        boundary = 12 + count * 18
                        self.assertLessEqual(boundary, 32767, (path.name, index, count))
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index, count))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index, count))
                    elif action.type == 0xA1:
                        counts[0xA1] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        selector = int.from_bytes(body[49:51], "little", signed=True)
                        boundary = 84 if selector == -1 else 51 + selector
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x97:
                        counts[0x97] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        n = int.from_bytes(body[0:2], "little", signed=True)
                        boundary = 15 + 33 * n
                        for _ in range(n):
                            sel = int.from_bytes(body[boundary:boundary + 2], "little", signed=True)
                            boundary += 35 if sel == -1 else 2 + sel
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x35:
                        counts[0x35] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        n = int.from_bytes(body[59:61], "little", signed=True)
                        m = int.from_bytes(body[61 + 6 * n:63 + 6 * n], "little", signed=True)
                        self.assertGreaterEqual(n, 0, (path.name, index))
                        self.assertGreaterEqual(m, 0, (path.name, index))
                        boundary = 63 + 6 * n + 34 * m
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x38:
                        counts[0x38] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        frames = (int.from_bytes(body[0x35:0x37], "little", signed=True) -
                                  int.from_bytes(body[0x33:0x35], "little", signed=True) + 1)
                        boundary = 71 + 16 * frames
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x1B:
                        counts[0x1B] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        n1 = int.from_bytes(body[0:2], "little", signed=True)
                        n2 = int.from_bytes(body[2 + 22 * n1 + 22:4 + 22 * n1 + 22], "little", signed=True)
                        boundary = 26 + 22 * n1 + 18 * n2
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x33:
                        counts[0x33] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        a = int.from_bytes(body[109:111], "little", signed=True)
                        b = int.from_bytes(body[111:113], "little", signed=True)
                        boundary = 113 + 6 * a + 66 * b
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x4B:
                        counts[0x4B] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        selector = int.from_bytes(body[0:2], "little", signed=True)
                        boundary = 35 if selector == -1 else 2 + selector
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type in (0x0C, 0x17, 0x16):
                        counts[action.type] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        base, offset = (10, 8) if action.type == 0x0C else (22, 20)
                        boundary = base + 18 * int.from_bytes(body[offset:offset + 2], "little", signed=True)
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x45:
                        counts[0x45] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        boundary = 196 + 4 * int.from_bytes(body[194:196], "little", signed=True)
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x44:
                        counts[0x44] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        boundary = 528 if body[492] != 0 else 528 + int.from_bytes(
                            body[526:528], "little", signed=True)
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x36:
                        counts[0x36] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        if int.from_bytes(body[0x29:0x2b], "little", signed=True) == 2:
                            end = int.from_bytes(body[0x35:0x37], "little", signed=True)
                            start = int.from_bytes(body[0x33:0x35], "little", signed=True)
                            primary = (end - start + 1 + 0x8000) % 0x10000 - 0x8000
                        else:
                            primary = int.from_bytes(body[0x2b:0x2d], "little", signed=True)
                        secondary = int.from_bytes(body[0xaa:0xac], "little", signed=True)
                        boundary = 0xac + 16 * primary + 38 * secondary
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x43:
                        counts[0x43] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        boundary = 301 if body[0x109] != 0 else 301 + int.from_bytes(
                            body[0x12b:0x12d], "little", signed=True)
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - boundary) // 16,
                                         (path.name, index))
                    elif action.type == 0x3E:
                        counts[0x3E] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        cursor = 178
                        for _ in range(int.from_bytes(body[176:178], "little", signed=True)):
                            cursor += 70 + 5 * body[cursor]
                        secondary = body[cursor]
                        cursor += 2
                        for _ in range(secondary):
                            cursor += 6 + 5 * body[cursor]
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, cursor, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - cursor) // 16,
                                         (path.name, index))
                    elif action.type == 0x3F:
                        counts[0x3F] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        cursor = 77
                        for _ in range(int.from_bytes(body[75:77], "little", signed=True)):
                            cursor += 70 + 5 * body[cursor]
                        secondary = body[cursor]
                        cursor += 2
                        for _ in range(secondary):
                            cursor += 6 + 5 * body[cursor]
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, cursor, (path.name, index))
                        self.assertEqual(action.dependency_count, (len(body) - cursor) // 16,
                                         (path.name, index))
                    elif action.type == 0x51:
                        counts[0x51] += 1
                        body = c.string_at(action.raw_body, action.raw_body_length)
                        self.assertGreaterEqual(len(body), 12, (path.name, index))
                        selector = int.from_bytes(body[10:12], "little", signed=True)
                        self.assertTrue(selector == -1 or 0 <= selector <= 9999,
                                        (path.name, index, selector))
                        boundary = 45 if selector == -1 else 12 + selector
                        self.assertEqual(action.payload_kind, 3, (path.name, index))
                        self.assertEqual(action.typed_body_length, boundary,
                                         (path.name, index, selector))
                        self.assertEqual(action.dependency_count,
                                         (len(body) - boundary) // 16,
                                         (path.name, index, selector))
            finally:
                self.lib.scene_resource_close(scene)
        self.assertEqual(scenes, 2078)
        self.assertEqual(actions, 19612)
        # A-28 contributes 72 recovered 21-byte bodies; dependency tails stay
        # separate from the typed body, preserving the total action count.
        # A-37 registers 4,308 raw 0x37 bodies (69-byte prefix, see A-37.2).
        # A-97.1 adds 1,958 raw 0x97 and A-A1.1 565 raw 0xa1 body boundaries.
        # A-35.1 adds 113 raw 0x35, A-38.1 425 raw 0x38 and A-3F.1 493 raw 0x3f
        # body boundaries; A-3E.1 202 raw 0x3e, A-6E.1 68 raw 0x6e and A-79.1
        # 38 raw 0x79.
        # A-67.1 and A-6F.1 add 27 raw 0x67 and 25 raw 0x6f fixed one-byte
        # bodies; A-43.1 13 raw 0x43 bodies.
        # A-45.1 adds 32 raw 0x45, A-44.1 27 raw 0x44 and A-36.1 20 raw 0x36 bodies.
        # A-94.1 adds 12 raw 0x94, A-D1.1 11 raw 0xd1 and A-2E.1 10 raw 0x2e fixed bodies.
        # A-0C.1 adds 43 raw 0x0c, A-4E.1 18 raw 0x4e and A-17.1 10 raw 0x17 bodies.
        # A-68.1, A-83.1 and A-4B.1 add 10 raw 0x68, 9 raw 0x83 and 9 raw 0x4b bodies.
        # A-69.1 and A-65.1 add 7 raw 0x69 and 7 raw 0x65 one-byte bodies; A-16.1
        # shares the 0x17 layout for its 2 raw 0x16 records.
        # A-1B.1 adds 4 raw 0x1b, A-7D.1 4 raw 0x7d and A-33.1 3 raw 0x33 bodies.
        # A-F6.1 adds 6 raw 0xf6, A-EA.1 6 raw 0xea and A-F5.1 4 raw 0xf5 fixed bodies.
        # A-D3.1 adds 3 raw 0xd3 fixed bodies, A-2D.1 3 count-driven raw 0x2d bodies and
        # A-E0.1 2 of 3 raw 0xe0 bodies (S2705's 292-byte record stays opaque).
        # A-EE.1 adds 2 raw 0xee, A-DA.1 2 raw 0xda and A-77.1 2 raw 0x77 fixed bodies.
        self.assertEqual(typed_actions, 19608)
        self.assertEqual(opaque_actions, 4)
        self.assertEqual(len(raw_type_values), 71)
        self.assertEqual(len(raw_type_pairs), 73)
        self.assertEqual(raw_type_counts[0x97], 1958)
        self.assertEqual(raw_type_counts[0x9F], 3570)
        self.assertEqual(raw_type_counts[0xA1], 565)
        self.assertEqual(counts[0x0B], 1275)
        self.assertEqual(counts[0x4F], 815)
        self.assertEqual(counts[0x78], 466)
        self.assertEqual(counts[0xD9], 274)
        self.assertEqual(counts[0x47], 139)
        self.assertEqual(counts[0x95], 123)
        self.assertEqual(counts[0x9F], 3570)
        self.assertEqual(counts[0x62], 1802)
        self.assertEqual(counts[0x64], 7)
        self.assertEqual(counts[0x28], 72)
        self.assertEqual(counts[0x51], 97)
        self.assertEqual(counts[0x37], 4308)
        self.assertEqual(counts[0x97], 1958)
        self.assertEqual(counts[0xA1], 565)
        self.assertEqual(counts[0x35], 113)
        self.assertEqual(counts[0x38], 425)
        self.assertEqual(counts[0x3F], 493)
        self.assertEqual(counts[0x3E], 202)
        self.assertEqual(counts[0x6E], 68)
        self.assertEqual(counts[0x79], 38)
        self.assertEqual(counts[0x67], 27)
        self.assertEqual(counts[0x6F], 25)
        self.assertEqual(counts[0x43], 13)
        self.assertEqual(counts[0x45], 32)
        self.assertEqual(counts[0x44], 27)
        self.assertEqual(counts[0x36], 20)
        self.assertEqual(counts[0x94], 12)
        self.assertEqual(counts[0xD1], 11)
        self.assertEqual(counts[0x2E], 10)
        self.assertEqual(counts[0x0C], 43)
        self.assertEqual(counts[0x4E], 18)
        self.assertEqual(counts[0x17], 10)
        self.assertEqual(counts[0x68], 10)
        self.assertEqual(counts[0x83], 9)
        self.assertEqual(counts[0x4B], 9)
        self.assertEqual(counts[0x69], 7)
        self.assertEqual(counts[0x65], 7)
        self.assertEqual(counts[0x16], 2)
        self.assertEqual(counts[0x1B], 4)
        self.assertEqual(counts[0x7D], 4)
        self.assertEqual(counts[0x33], 3)
        self.assertEqual(counts[0xF6], 6)
        self.assertEqual(counts[0xEA], 6)
        self.assertEqual(counts[0xF5], 4)

    def test_rejects_short_tsum_and_truncated_known_action_body(self):
        scene, error = self.open_bytes(self.resource(tsum_length=125))
        self.assertIsNone(scene)
        self.assertTrue(error)

        description = b"short difficulty".ljust(48, b"\0")
        truncated_difficulty = description + bytes((0x71, 1)) + b"\0" * 5
        scene, error = self.open_bytes(self.resource(truncated_difficulty))
        self.assertIsNone(scene)
        self.assertTrue(error)

    def test_rejects_non_integral_dependency_tail(self):
        description = b"bad dependency boundary".ljust(48, b"\0")
        action = description + bytes((0x71, 1)) + b"\0" * 7
        scene, error = self.open_bytes(self.resource(action))
        self.assertIsNone(scene)
        self.assertTrue(error)

    def test_other_recovered_scenes_have_expected_action_counts(self):
        root = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources"
        corpus = (("2743.bin", 15), ("2750.bin", 7), ("2648.bin", 15), ("2763.bin", 18))
        for filename, expected_count in corpus:
            with self.subTest(resource=filename):
                scene, error = self.open_bytes((root / filename).read_bytes())
                self.assertIsNotNone(scene, error)
                try:
                    self.assertEqual(self.lib.scene_resource_action_count(scene), expected_count)
                finally:
                    self.lib.scene_resource_close(scene)


if __name__ == "__main__":
    unittest.main()
