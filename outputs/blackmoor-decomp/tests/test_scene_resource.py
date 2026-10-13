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
            0x0B: 24,
            0x4F: 10,
            0x78: 6,
            0xD9: 35,
            0x47: 39,
            0x95: 3,
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

    def test_recovered_boundaries_match_every_real_scene_action(self):
        root = Path(__file__).resolve().parents[3] / "work/analysis/hiff-resources"
        expected_fixed = {0x0B: 24, 0x4F: 10, 0x78: 6, 0xD9: 35, 0x47: 39, 0x95: 3, 0x64: 5}
        counts = {action_type: 0 for action_type in
                  (*expected_fixed, 0x9F, 0x51, 0x62)}
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
        self.assertEqual(typed_actions, 11017)
        self.assertEqual(opaque_actions, 8595)
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
        self.assertEqual(counts[0x51], 97)

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
