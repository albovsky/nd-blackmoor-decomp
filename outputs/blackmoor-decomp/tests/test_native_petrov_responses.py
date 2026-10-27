"""Hook-6 Petrov planner: injected predicate component checks only.

Literal expectations follow the recovered 0x443ad8 blocks and 0x4458d4
switch. No original execution, resource text, phone route, playback or
function-ledger credit is represented by this isolated planner test.
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
EVENT_COUNT = 2015
OK, ARGUMENT, BOUNDS, UNSUPPORTED = range(4)
ADD, REPLACE = range(2)


class World(ctypes.Structure):
    _fields_ = [("events", ctypes.POINTER(ctypes.c_int32)),
                ("event_count", ctypes.c_size_t)]


class Entry(ctypes.Structure):
    _fields_ = [("key", ctypes.c_char_p), ("scene", ctypes.c_int16),
                ("kind", ctypes.c_uint8)]


class Plan(ctypes.Structure):
    _fields_ = [("entries", Entry * 7), ("count", ctypes.c_size_t)]


CANDIDATES = [
    ("NMP50", 1650, ((1416, 0), (1610, 0))),
    ("NMP53", 1653, ((1498, 1), (1878, 0), (1609, 0))),
    ("NMP55", 1655, ((1601, 0),)),
    ("NMP56", 1656, ((1242, 1), (1606, 0))),
    ("NMP58", 1658, ((1493, 1), (1611, 0))),
    ("NMP62", 1662, ((2014, 1), (1605, 0))),
]


class NativePetrovResponsesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lib = None
        source = PROJECT / "src/native_petrov_responses.c"
        if not source.is_file():
            return
        compiler = shutil.which("clang") or shutil.which("cc")
        if compiler is None:
            raise RuntimeError("C compiler required for Petrov planner tests")
        temp = tempfile.TemporaryDirectory(prefix="blackmoor-native-petrov-")
        cls.addClassCleanup(temp.cleanup)
        library = Path(temp.name) / ("petrov.dylib" if sys.platform == "darwin" else "petrov.so")
        command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Wpedantic", "-Werror"]
        command += ["-dynamiclib"] if sys.platform == "darwin" else ["-shared", "-fPIC"]
        command += [str(source), "-o", str(library)]
        result = subprocess.run(command, capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError("Petrov planner compilation failed:\n" + result.stderr)
        cls.lib = ctypes.CDLL(str(library))
        cls.plan = cls.lib.native_petrov_responses_plan
        cls.plan.argtypes = [ctypes.POINTER(World), ctypes.c_uint8, ctypes.c_uint8,
                             ctypes.c_int32, ctypes.POINTER(Plan)]
        cls.plan.restype = ctypes.c_int
        print("PETROV_RESPONSES_BUILD source_sha256=" + hashlib.sha256(source.read_bytes()).hexdigest() +
              " library_sha256=" + hashlib.sha256(library.read_bytes()).hexdigest())

    def setUp(self):
        self.assertIsNotNone(self.lib, "Petrov symbolic response planner is not implemented")

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
        output.count = 4
        self.assertEqual(self.plan(None, 20, 20, -2147483648, ctypes.byref(output)), OK)
        self.assertEqual(output.count, 0)

    def test_zero_world_has_two_topics_without_state_writes(self):
        world, events = self.world(0)
        before = bytes(world), bytes(events)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 6, 20, -1,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [("NMP50", 1650, ADD), ("NMP55", 1655, ADD)])
        self.assertEqual((bytes(world), bytes(events)), before)

    def test_each_injected_predicate_selects_its_recovered_key_and_scene(self):
        for key, scene, predicates in CANDIDATES:
            with self.subTest(component=key):
                world, events = self.world()
                for index, wanted in predicates:
                    events[index] = wanted
                output = Plan()
                self.assertEqual(self.plan(ctypes.byref(world), 6, 20, 0,
                                           ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [(key, scene, ADD)])

    def test_each_predicate_requires_full_dword_equality(self):
        for key, scene, predicates in CANDIDATES:
            for index, wanted in predicates:
                for other in (1 - wanted, wanted + 65536, wanted - 65536, -1, 2):
                    with self.subTest(component=key, index=index, value=other):
                        world, events = self.world()
                        for slot, value in predicates:
                            events[slot] = value
                        events[index] = other
                        output = Plan()
                        self.assertEqual(self.plan(ctypes.byref(world), 6, 20, 0,
                                                   ctypes.byref(output)), OK)
                        self.assertNotIn((key, scene, ADD), self.entries(output))

    def test_all_six_additions_fill_plan_in_order_before_random_replacement(self):
        world, events = self.world()
        for index, value in ((1416, 0), (1610, 0), (1498, 1), (1878, 0), (1609, 0),
                             (1601, 0), (1242, 1), (1606, 0), (1493, 1), (1611, 0),
                             (2014, 1), (1605, 0)):
            events[index] = value
        before = bytes(world), bytes(events)
        output = Plan()
        self.assertEqual(self.plan(ctypes.byref(world), 6, 6, 32767,
                                   ctypes.byref(output)), OK)
        self.assertEqual(self.entries(output), [
            ("NMP50", 1650, ADD), ("NMP53", 1653, ADD), ("NMP55", 1655, ADD),
            ("NMP56", 1656, ADD), ("NMP58", 1658, ADD), ("NMP62", 1662, ADD),
            ("NMP90", 1691, REPLACE)])
        self.assertEqual((bytes(world), bytes(events)), before)

    def test_genuine_crt_values_map_to_three_scenes_without_world(self):
        for value, scene in ((0, 1690), (1, 1691), (2, 1692), (3, 1690), (4, 1691),
                             (32765, 1692), (32766, 1690), (32767, 1691)):
            with self.subTest(crt_return=value):
                output = Plan()
                self.assertEqual(self.plan(None, 20, 6, value, ctypes.byref(output)), OK)
                self.assertEqual(self.entries(output), [("NMP90", scene, REPLACE)])

    def test_errors_leave_output_unchanged_and_refuse_other_hooks(self):
        world, events = self.world()
        output = Plan()
        ctypes.memset(ctypes.byref(output), 0xA5, ctypes.sizeof(output))
        before = bytes(output)
        self.assertEqual(self.plan(None, 20, 20, 0, None), ARGUMENT)
        cases = [(None, 6, 20, 0, ARGUMENT),
                 (ctypes.byref(World(None, EVENT_COUNT)), 6, 20, 0, ARGUMENT),
                 (ctypes.byref(World(events, EVENT_COUNT - 1)), 6, 20, 0, BOUNDS)]
        cases += [(None, 20, 6, value, BOUNDS)
                  for value in (-2147483648, -1, 32768, 2147483647)]
        cases += [(ctypes.byref(world), 6, 6, value, BOUNDS)
                  for value in (-2147483648, -1, 32768, 2147483647)]
        cases += [(ctypes.byref(world), hook, 20, 0, UNSUPPORTED)
                  for hook in (0, 1, 2, 5, 7, 19, 21, 255)]
        cases += [(ctypes.byref(world), 20, hook, 0, UNSUPPORTED)
                  for hook in (0, 1, 2, 5, 7, 19, 21, 255)]
        for world_ptr, a, b, value, wanted in cases:
            with self.subTest(hook_a=a, hook_b=b, crt_return=value, status=wanted):
                self.assertEqual(self.plan(world_ptr, a, b, value, ctypes.byref(output)), wanted)
                self.assertEqual(bytes(output), before)


if __name__ == "__main__":
    unittest.main()
