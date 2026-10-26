"""NATIVE-22 pure Jane planner: injected predicate component cases only.

The literal expectations come from the recovered 0x43ff18 instruction blocks
and 0x445253 switch. No original execution, resource text, story-route claim,
deliberate process fault, sanitizer, or mutation runner is used.
"""
import ctypes
import hashlib
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[1]
EVENT_COUNT = 2070
PRESENCE_COUNT = 22
OK, ARGUMENT, BOUNDS, UNSUPPORTED = range(4)
ADD, REPLACE = range(2)


class World(ctypes.Structure):
    _fields_ = [("events", ctypes.POINTER(ctypes.c_int32)),
                ("event_count", ctypes.c_size_t),
                ("presence", ctypes.POINTER(ctypes.c_int32)),
                ("presence_count", ctypes.c_size_t)]


class Entry(ctypes.Structure):
    _fields_ = [("key", ctypes.c_char_p), ("scene", ctypes.c_int16),
                ("kind", ctypes.c_uint8)]


class Plan(ctypes.Structure):
    _fields_ = [("entries", Entry * 23), ("count", ctypes.c_size_t)]


# Each tuple is one original independent conditional block, in instruction
# order. Zero-based E/P indices are original event/presence dword indices.
CANDIDATES = [
    ("NJP45", 1245, (("P", 21, 1), ("E", 1366, 0))),
    ("NJP50", 1250, (("E", 1494, 1), ("E", 1404, 0))),
    ("NJP57", 1257, (("E", 1435, 1), ("E", 1405, 0))),
    ("NJP62", 1262, (("E", 1968, 1), ("E", 1838, 1),
                     ("E", 1535, 0), ("E", 1333, 0))),
    ("NJP63", 1263, (("E", 1405, 1), ("P", 7, 0), ("E", 2058, 1))),
    ("NJP65", 1265, (("E", 1332, 0),)),
    ("NJP67", 1268, (("E", 1567, 1),)),
    ("NJP69", 1269, (("E", 1405, 1), ("E", 1971, 1),
                     ("E", 1997, 0), ("E", 1329, 0))),
    ("NJP70", 1270, (("E", 1704, 1), ("E", 1430, 0))),
    ("NJP71", 1271, (("E", 1905, 1), ("E", 1424, 0))),
    ("NJP74", 1274, (("E", 1424, 1), ("E", 1980, 0))),
    ("NJP75", 1275, (("E", 2069, 1), ("E", 1985, 0), ("E", 1385, 0))),
    ("NJP97", 1297, (("E", 1419, 0), ("E", 2069, 1),
                     ("E", 1385, 1), ("E", 1985, 0))),
    ("NJP77", 1277, (("E", 1823, 1), ("E", 1958, 0), ("E", 1316, 0))),
    ("NJP78", 1278, (("E", 1467, 1), ("E", 1774, 0), ("E", 1387, 0))),
    ("NJP79", 1279, (("E", 1383, 0),)),
    ("NJP80", 1280, (("E", 1865, 1), ("E", 1349, 0))),
    ("NJP82", 1282, (("E", 1865, 1), ("E", 1349, 1),
                     ("P", 5, 1), ("P", 13, 0))),
    ("NJP83", 1283, (("E", 1944, 1), ("E", 1414, 0))),
    ("NJP88", 1288, (("E", 1863, 1), ("E", 1492, 1), ("E", 1400, 0))),
    ("NJJ55", 5055, (("E", 1242, 1), ("E", 1399, 0))),
    ("NJJ56", 5056, (("E", 1922, 1), ("E", 1694, 0), ("E", 1403, 0))),
]


class NativeJaneResponsesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = None
        source = PROJECT / "src/native_jane_responses.c"
        if not source.is_file():
            return
        compiler = shutil.which("clang") or shutil.which("cc")
        if compiler is None:
            raise RuntimeError("C compiler required for Jane planner tests")
        temp = tempfile.TemporaryDirectory(prefix="blackmoor-native-jane-")
        cls.addClassCleanup(temp.cleanup)
        library = Path(temp.name) / ("jane.dylib" if sys.platform == "darwin" else "jane.so")
        command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Wpedantic", "-Werror"]
        command += ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
        command += [str(source), "-o", str(library)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError("Jane planner compilation failed:\n" + result.stderr)
        cls.lib = ctypes.CDLL(str(library))
        cls.plan = cls.lib.native_jane_responses_plan
        cls.plan.argtypes = [ctypes.POINTER(World), ctypes.c_uint8, ctypes.c_uint8,
                             ctypes.c_int32, ctypes.POINTER(Plan)]
        cls.plan.restype = ctypes.c_int
        print("JANE_RESPONSES_BUILD source_sha256=" + hashlib.sha256(source.read_bytes()).hexdigest() +
              " library_sha256=" + hashlib.sha256(library.read_bytes()).hexdigest())

    def setUp(self):
        self.assertIsNotNone(self.lib, "Jane symbolic response planner is not implemented")

    @staticmethod
    def world(value=2):
        events = (ctypes.c_int32 * EVENT_COUNT)(*([value] * EVENT_COUNT))
        presence = (ctypes.c_int32 * PRESENCE_COUNT)(*([value] * PRESENCE_COUNT))
        return World(events, EVENT_COUNT, presence, PRESENCE_COUNT), events, presence

    @staticmethod
    def entries(plan):
        return [(plan.entries[i].key.decode("ascii"), plan.entries[i].scene,
                 plan.entries[i].kind) for i in range(plan.count)]

    def test_no_hooks_need_no_world_or_random_value(self):
        output = Plan()
        output.count = 7
        self.assertEqual(self.plan(None, 20, 20, -2147483648, ctypes.byref(output)), OK)
        self.assertEqual(output.count, 0)

    def test_zero_world_has_only_the_two_unasked_topics(self):
        world, events, presence = self.world(0)
        before = bytes(events), bytes(presence)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 1, 20, -1,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [("NJP65", 1265, ADD), ("NJP79", 1279, ADD)])
        self.assertEqual((bytes(events), bytes(presence)), before)

    def test_each_injected_predicate_selects_its_recovered_key_and_scene(self):
        for key, scene, predicates in CANDIDATES:
            with self.subTest(component=key):
                world, events, presence = self.world()
                for array, index, wanted in predicates:
                    (events if array == "E" else presence)[index] = wanted
                output = Plan()
                self.assertEqual(self.plan(ctypes.byref(world), 1, 20, 0,
                                           ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [(key, scene, ADD)])

    def test_each_injected_predicate_requires_exact_dword_equality(self):
        for key, scene, predicates in CANDIDATES:
            for array, index, wanted in predicates:
                for other in (wanted + 256, wanted - 256, -1, 2):
                    with self.subTest(component=key, array=array, index=index, value=other):
                        world, events, presence = self.world()
                        for which, slot, value in predicates:
                            (events if which == "E" else presence)[slot] = value
                        (events if array == "E" else presence)[index] = other
                        output = Plan()
                        self.assertEqual(self.plan(ctypes.byref(world), 1, 20, 0,
                                                   ctypes.byref(output)), OK)
                        self.assertNotIn((key, scene, ADD), self.entries(output))

    def test_independent_topics_keep_original_order_before_random_replacement(self):
        world, events, presence = self.world()
        for index, value in ((1366, 0), (1494, 1), (1404, 0), (1968, 1), (1838, 1),
                             (1535, 0), (1333, 0), (1332, 0), (1567, 1), (1405, 1),
                             (1971, 1), (1997, 0), (1329, 0), (1424, 1), (1980, 0),
                             (1419, 0), (2069, 1), (1385, 1), (1985, 0), (1383, 0),
                             (1865, 1), (1349, 1), (1922, 1), (1694, 0), (1403, 0)):
            events[index] = value
        presence[21], presence[5], presence[13] = 1, 1, 0
        before = bytes(events), bytes(presence)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 1, 1, 32767,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [
            ("NJP45", 1245, ADD), ("NJP50", 1250, ADD), ("NJP62", 1262, ADD),
            ("NJP65", 1265, ADD), ("NJP67", 1268, ADD), ("NJP69", 1269, ADD),
            ("NJP74", 1274, ADD), ("NJP97", 1297, ADD), ("NJP79", 1279, ADD),
            ("NJP82", 1282, ADD), ("NJJ56", 5056, ADD), ("NJP90", 1293, REPLACE)])
        self.assertEqual((bytes(events), bytes(presence)), before)

    def test_genuine_crt_values_map_to_all_four_scenes_without_world(self):
        for value, scene in ((0, 1290), (1, 1291), (2, 1292), (3, 1293), (4, 1290),
                             (32764, 1290), (32765, 1291), (32766, 1292), (32767, 1293)):
            with self.subTest(crt_return=value):
                output = Plan()
                self.assertEqual(self.plan(None, 20, 1, value, ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [("NJP90", scene, REPLACE)])

    def test_errors_leave_output_unchanged_and_reject_unsupported_hooks(self):
        world, events, presence = self.world()
        output = Plan()
        ctypes.memset(ctypes.byref(output), 0xA5, ctypes.sizeof(output))
        before = bytes(output)
        self.assertEqual(self.plan(None, 20, 20, 0, None), ARGUMENT)
        cases = [(None, 1, 20, 0, ARGUMENT),
                 (ctypes.byref(World(None, EVENT_COUNT, presence, PRESENCE_COUNT)),
                  1, 20, 0, ARGUMENT),
                 (ctypes.byref(World(events, EVENT_COUNT, None, PRESENCE_COUNT)),
                  1, 20, 0, ARGUMENT),
                 (ctypes.byref(World(events, EVENT_COUNT - 1, presence, PRESENCE_COUNT)),
                  1, 20, 0, BOUNDS),
                 (ctypes.byref(World(events, EVENT_COUNT, presence, PRESENCE_COUNT - 1)),
                  1, 20, 0, BOUNDS)]
        cases += [(None, 20, 1, value, BOUNDS)
                  for value in (-2147483648, -1, 32768, 2147483647)]
        cases += [(ctypes.byref(world), hook, 20, 0, UNSUPPORTED)
                  for hook in (0, 2, 9, 19, 21, 255)]
        cases += [(ctypes.byref(world), 20, hook, 0, UNSUPPORTED)
                  for hook in (0, 2, 9, 19, 21, 255)]
        for world_ptr, a, b, value, wanted in cases:
            with self.subTest(hook_a=a, hook_b=b, crt_return=value, status=wanted):
                self.assertEqual(self.plan(world_ptr, a, b, value, ctypes.byref(output)), wanted)
                self.assertEqual(bytes(output), before)


if __name__ == "__main__":
    unittest.main()
