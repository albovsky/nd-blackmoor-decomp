"""NATIVE-25 pure Drake planner: injected predicate component cases only.

Literal expectations come from the recovered 0x43f31a conditional blocks and
0x44512a switch. These checks do not execute the original or establish a
story route, live playback, or function-ledger credit.
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
EVENT_COUNT = 2081
OK, ARGUMENT, BOUNDS, UNSUPPORTED = range(4)
ADD, REPLACE = range(2)


class World(ctypes.Structure):
    _fields_ = [("events", ctypes.POINTER(ctypes.c_int32)),
                ("event_count", ctypes.c_size_t)]


class Entry(ctypes.Structure):
    _fields_ = [("key", ctypes.c_char_p), ("scene", ctypes.c_int16),
                ("kind", ctypes.c_uint8)]


class Plan(ctypes.Structure):
    _fields_ = [("entries", Entry * 19), ("count", ctypes.c_size_t)]


# Independent blocks in original instruction order. Each predicate compares
# the full signed event dword to the literal value shown here.
CANDIDATES = [
    ("NMD50", 1050, ((1944, 1), (1538, 0))),
    ("NMD55", 1055, ((1968, 1), (1838, 1), (1535, 0))),
    ("NMD58", 1058, ((1576, 1), (1544, 0))),
    ("NMD60", 1060, ((1395, 1), (1528, 0))),
    ("NDC08d", 1061, ((1519, 0),)),
    ("NMD62", 1062, ((1529, 0),)),
    ("NMD63", 1063, ((1528, 1), (1515, 0))),
    ("NMD65", 1065, ((1954, 1), (1545, 0))),
    ("NMD67", 1067, ((1569, 1), (1525, 0))),
    ("NMD68", 1068, ((1467, 1), (1525, 1), (1526, 0))),
    ("NMD72", 1072, ((1262, 1), (1523, 0))),
    ("NMD75", 1075, ((1865, 1), (1349, 0), (1522, 0))),
    ("NMD76", 1076, ((1941, 1), (1536, 0))),
    ("NMD77", 1077, ((1857, 1), (1518, 0))),
    ("NMD78", 1078, ((2069, 1), (1985, 0), (1385, 0), (1524, 0))),
    ("NMD82", 1082, ((1349, 1), (1543, 0))),
    ("NMD86", 1086, ((1535, 1), (2080, 1), (2002, 0), (1530, 0))),
    ("NMD88", 1088, ((2002, 1), (1541, 0))),
]


class NativeDrakeResponsesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = None
        source = PROJECT / "src/native_drake_responses.c"
        if not source.is_file():
            return
        compiler = shutil.which("clang") or shutil.which("cc")
        if compiler is None:
            raise RuntimeError("C compiler required for Drake planner tests")
        temp = tempfile.TemporaryDirectory(prefix="blackmoor-native-drake-")
        cls.addClassCleanup(temp.cleanup)
        library = Path(temp.name) / ("drake.dylib" if sys.platform == "darwin" else "drake.so")
        command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Wpedantic", "-Werror"]
        command += ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
        command += [str(source), "-o", str(library)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError("Drake planner compilation failed:\n" + result.stderr)
        cls.lib = ctypes.CDLL(str(library))
        cls.plan = cls.lib.native_drake_responses_plan
        cls.plan.argtypes = [ctypes.POINTER(World), ctypes.c_uint8, ctypes.c_uint8,
                             ctypes.c_int32, ctypes.POINTER(Plan)]
        cls.plan.restype = ctypes.c_int
        print("DRAKE_RESPONSES_BUILD source_sha256=" + hashlib.sha256(source.read_bytes()).hexdigest() +
              " library_sha256=" + hashlib.sha256(library.read_bytes()).hexdigest())

    def setUp(self):
        self.assertIsNotNone(self.lib, "Drake symbolic response planner is not implemented")

    @staticmethod
    def world(value=2):
        events = (ctypes.c_int32 * EVENT_COUNT)(*([value] * EVENT_COUNT))
        return World(events, EVENT_COUNT), events

    @staticmethod
    def entries(plan):
        return [(plan.entries[i].key.decode("ascii"), plan.entries[i].scene,
                 plan.entries[i].kind) for i in range(plan.count)]

    def test_no_hooks_need_no_world_or_random_value(self):
        output = Plan()
        output.count = 7
        self.assertEqual(self.plan(None, 20, 20, -2147483648, ctypes.byref(output)), OK)
        self.assertEqual(output.count, 0)

    def test_zero_world_has_the_two_unasked_topics_with_original_key_case(self):
        world, events = self.world(0)
        before = bytes(world), bytes(events)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 0, 20, -1,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [("NDC08d", 1061, ADD), ("NMD62", 1062, ADD)])
        self.assertEqual((bytes(world), bytes(events)), before)

    def test_each_injected_predicate_selects_its_recovered_key_and_scene(self):
        for key, scene, predicates in CANDIDATES:
            with self.subTest(component=key):
                world, events = self.world()
                for index, wanted in predicates:
                    events[index] = wanted
                output = Plan()
                self.assertEqual(self.plan(ctypes.byref(world), 0, 20, 0,
                                           ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [(key, scene, ADD)])

    def test_each_injected_predicate_requires_exact_dword_equality(self):
        for key, scene, predicates in CANDIDATES:
            for index, wanted in predicates:
                for other in (wanted + 256, wanted - 256, -1, 2):
                    with self.subTest(component=key, index=index, value=other):
                        world, events = self.world()
                        for slot, value in predicates:
                            events[slot] = value
                        events[index] = other
                        output = Plan()
                        self.assertEqual(self.plan(ctypes.byref(world), 0, 20, 0,
                                                   ctypes.byref(output)), OK)
                        self.assertNotIn((key, scene, ADD), self.entries(output))

    def test_independent_topics_keep_original_order_before_random_replacement(self):
        world, events = self.world()
        for index, value in ((1944, 1), (1538, 0), (1968, 1), (1838, 1), (1535, 0),
                             (1576, 1), (1544, 0), (1395, 1), (1528, 0), (1519, 0),
                             (1529, 0), (1954, 1), (1545, 0), (1569, 1), (1525, 0),
                             (1262, 1), (1523, 0), (1865, 1), (1349, 0), (1522, 0),
                             (1941, 1), (1536, 0), (1857, 1), (1518, 0), (2069, 1),
                             (1985, 0), (1385, 0), (1524, 0), (2002, 1), (1541, 0)):
            events[index] = value
        before = bytes(world), bytes(events)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 0, 0, 32767,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [
            ("NMD50", 1050, ADD), ("NMD55", 1055, ADD), ("NMD58", 1058, ADD),
            ("NMD60", 1060, ADD), ("NDC08d", 1061, ADD), ("NMD62", 1062, ADD),
            ("NMD65", 1065, ADD), ("NMD67", 1067, ADD), ("NMD72", 1072, ADD),
            ("NMD75", 1075, ADD), ("NMD76", 1076, ADD), ("NMD77", 1077, ADD),
            ("NMD78", 1078, ADD), ("NMD88", 1088, ADD), ("NDE90", 1091, REPLACE)])
        self.assertEqual((bytes(world), bytes(events)), before)

    def test_alternate_gates_still_produce_independent_ordered_topics(self):
        world, events = self.world()
        for index, value in ((1528, 1), (1515, 0), (1467, 1), (1525, 1), (1526, 0),
                             (1349, 1), (1543, 0), (1535, 1), (2080, 1), (2002, 0),
                             (1530, 0)):
            events[index] = value
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 0, 20, 2147483647,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [("NMD63", 1063, ADD), ("NMD68", 1068, ADD),
                                                ("NMD82", 1082, ADD), ("NMD86", 1086, ADD)])

    def test_genuine_crt_values_map_to_three_scenes_without_world(self):
        for value, scene in ((0, 1090), (1, 1091), (2, 1092), (3, 1090), (4, 1091),
                             (32765, 1092), (32766, 1090), (32767, 1091)):
            with self.subTest(crt_return=value):
                output = Plan()
                self.assertEqual(self.plan(None, 20, 0, value, ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [("NDE90", scene, REPLACE)])

    def test_errors_leave_output_unchanged_and_reject_unsupported_hooks(self):
        world, events = self.world()
        output = Plan()
        ctypes.memset(ctypes.byref(output), 0xA5, ctypes.sizeof(output))
        before = bytes(output)
        self.assertEqual(self.plan(None, 20, 20, 0, None), ARGUMENT)
        cases = [(None, 0, 20, 0, ARGUMENT),
                 (ctypes.byref(World(None, EVENT_COUNT)), 0, 20, 0, ARGUMENT),
                 (ctypes.byref(World(events, EVENT_COUNT - 1)), 0, 20, 0, BOUNDS)]
        cases += [(None, 20, 0, value, BOUNDS)
                  for value in (-2147483648, -1, 32768, 2147483647)]
        cases += [(ctypes.byref(world), hook, 20, 0, UNSUPPORTED)
                  for hook in (1, 2, 9, 19, 21, 255)]
        cases += [(ctypes.byref(world), 20, hook, 0, UNSUPPORTED)
                  for hook in (1, 2, 9, 19, 21, 255)]
        for world_ptr, a, b, value, wanted in cases:
            with self.subTest(hook_a=a, hook_b=b, crt_return=value, status=wanted):
                self.assertEqual(self.plan(world_ptr, a, b, value, ctypes.byref(output)), wanted)
                self.assertEqual(bytes(output), before)


if __name__ == "__main__":
    unittest.main()
