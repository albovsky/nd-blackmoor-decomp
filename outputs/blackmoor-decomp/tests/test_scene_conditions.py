import ctypes as c
from pathlib import Path
import unittest


class SceneDependencyInfo(c.Structure):
    _fields_ = [
        ("opcode", c.c_uint16),
        ("or_after", c.c_int16),
        ("raw_bytes", c.POINTER(c.c_uint8)),
        ("fields", c.c_int16 * 8),
    ]


class SceneConditionState(c.Structure):
    _fields_ = [
        ("inventory_presence", c.POINTER(c.c_int32)),
        ("inventory_count", c.c_size_t),
        ("selected_inventory_item", c.c_int32),
        ("event_flags", c.POINTER(c.c_int32)),
        ("event_flag_count", c.c_size_t),
        ("value_table", c.POINTER(c.c_int32)),
        ("value_count", c.c_size_t),
        ("scene_visit_counts", c.POINTER(c.c_int16)),
        ("scene_visit_count", c.c_size_t),
        ("timer_4_value", c.c_int32),
        ("timer_5_value", c.c_int32),
        ("time_of_day_minutes", c.c_int32),
    ]


def record(opcode, index=0, condition=0, or_after=0, time_fields=(0, 0, 0, 0),
           extra_fields=None):
    value = SceneDependencyInfo()
    value.opcode = opcode
    value.or_after = or_after
    fields = [opcode, index, condition, or_after, *time_fields]
    if extra_fields is not None:
        fields[4:] = extra_fields
    value.fields[:] = fields
    return value


class SceneConditionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        path = Path(__file__).resolve().parents[1] / "build/libsceneconditions.dylib"
        if not path.is_file():
            raise unittest.SkipTest("Build scene conditions with scripts/build_scene_conditions.sh first")
        cls.lib = c.CDLL(str(path))
        cls.lib.scene_conditions_build.argtypes = [
            c.POINTER(SceneDependencyInfo), c.c_size_t, c.POINTER(c.c_void_p)
        ]
        cls.lib.scene_conditions_build.restype = c.c_int
        cls.lib.scene_conditions_destroy.argtypes = [c.c_void_p]
        cls.lib.scene_conditions_reset.argtypes = [c.c_void_p]
        cls.lib.scene_conditions_evaluate.argtypes = [
            c.c_void_p, c.POINTER(SceneConditionState), c.POINTER(c.c_int),
            c.POINTER(c.c_uint16)
        ]
        cls.lib.scene_conditions_evaluate.restype = c.c_int

    def make_tree(self, records):
        tree = c.c_void_p()
        if records:
            record_array = (SceneDependencyInfo * len(records))(*records)
            status = self.lib.scene_conditions_build(record_array, len(records), c.byref(tree))
        else:
            record_array = None
            status = self.lib.scene_conditions_build(None, 0, c.byref(tree))
        self.assertEqual(status, 0)
        self.addCleanup(self.lib.scene_conditions_destroy, tree)
        return tree

    @staticmethod
    def state(inventory=None, selected=-1, flags=None, values=None, visits=None,
              timer4=0, timer5=0, clock=0):
        inventory = inventory or []
        flags = flags or []
        values = values or []
        visits = visits or []
        inventory_array = (c.c_int32 * len(inventory))(*inventory) if inventory else None
        flags_array = (c.c_int32 * len(flags))(*flags) if flags else None
        values_array = (c.c_int32 * len(values))(*values) if values else None
        visits_array = (c.c_int16 * len(visits))(*visits) if visits else None
        result = SceneConditionState(
            inventory_array, len(inventory), selected,
            flags_array, len(flags), values_array, len(values), visits_array,
            len(visits), timer4, timer5, clock
        )
        return result

    def evaluate(self, records, state):
        tree = self.make_tree(records)
        answer = c.c_int(-1)
        unsupported = c.c_uint16(0xffff)
        status = self.lib.scene_conditions_evaluate(
            tree, c.byref(state) if state is not None else None,
            c.byref(answer), c.byref(unsupported)
        )
        return status, answer.value, unsupported.value

    def test_empty_tree_is_true_without_runtime_state(self):
        self.assertEqual(self.evaluate([], None), (0, 1, 0))

    def test_inventory_presence_and_selected_item_semantics(self):
        self.assertEqual(self.evaluate([record(1, 2, 1)], self.state(inventory=[0, 0, 0])),
                         (0, 0, 0))
        self.assertEqual(self.evaluate([record(1, 2, 1)], self.state(inventory=[0, 0, 0], selected=2)),
                         (0, 1, 0))
        self.assertEqual(self.evaluate([record(1, 2, 0)], self.state(inventory=[0, 0, 0], selected=2)),
                         (0, 0, 0))
        self.assertEqual(self.evaluate([record(1, 1, 0)], self.state(inventory=[0, 1])),
                         (0, 0, 0))

    def test_event_flags_and_value_table_compare_exact_int32(self):
        self.assertEqual(self.evaluate([record(2, 1, -7)], self.state(flags=[0, -7])),
                         (0, 1, 0))
        self.assertEqual(self.evaluate([record(3, 0, 655)], self.state(values=[655])),
                         (0, 1, 0))
        self.assertEqual(self.evaluate([record(2, 2, 1)], self.state(flags=[0])),
                         (5, 0, 0))

    def test_timer_opcodes_use_signed_wrapping_millisecond_thresholds(self):
        fields = (1, 2, 3, 4)
        threshold = 3_723_004
        self.assertEqual(self.evaluate([record(4, time_fields=fields)],
                                       self.state(timer4=threshold)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(4, time_fields=fields)],
                                       self.state(timer4=threshold - 1)), (0, 0, 0))
        self.assertEqual(self.evaluate([record(5, time_fields=(-1, 0, 0, 0))],
                                       self.state(timer5=-3_600_000)), (0, 1, 0))

    def test_time_of_day_comparators_and_inclusive_ranges(self):
        fields = (8, 30, 17, 0)
        at_830 = 8 * 60 + 30
        self.assertEqual(self.evaluate([record(6, condition=0, time_fields=fields)],
                                       self.state(clock=at_830)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(6, condition=1, time_fields=fields)],
                                       self.state(clock=at_830 + 1)), (0, 0, 0))
        self.assertEqual(self.evaluate([record(6, condition=2, time_fields=fields)],
                                       self.state(clock=at_830)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(6, condition=3,
                                                time_fields=(8, 30, 17, 0))],
                                       self.state(clock=12 * 60)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(6, condition=3,
                                                time_fields=(22, 0, 2, 0))],
                                       self.state(clock=23 * 60)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(6, condition=3,
                                                time_fields=(22, 0, 2, 0))],
                                       self.state(clock=12 * 60)), (0, 0, 0))

    def test_scene_visit_count_comparators_include_s0_sound9f(self):
        s0_sound9f = record(9, extra_fields=(6400, 1, 0, 1))
        visits = [0] * 6401
        self.assertEqual(self.evaluate([s0_sound9f], self.state(visits=visits)),
                         (0, 1, 0))
        visits[6400] = 1
        self.assertEqual(self.evaluate([s0_sound9f], self.state(visits=visits)),
                         (0, 0, 0))
        self.assertEqual(self.evaluate([record(9, extra_fields=(6400, 1, 0, 2))],
                                       self.state(visits=visits)), (0, 0, 0))
        self.assertEqual(self.evaluate([record(9, extra_fields=(6400, 1, 0, 3))],
                                       self.state(visits=visits)), (0, 1, 0))
        self.assertEqual(self.evaluate([record(9, extra_fields=(6400, 1, 0, 4))],
                                       self.state(visits=visits)), (3, 0, 0))
        self.assertEqual(self.evaluate([s0_sound9f], self.state(visits=[0])),
                         (5, 0, 0))

    def test_nested_parentheses_reduce_within_their_own_branch(self):
        records = [
            record(0x12, or_after=0),
            record(2, 0, 1, or_after=1),
            record(2, 1, 1, or_after=0),
            record(0x13, or_after=0),
            record(2, 2, 1, or_after=0),
        ]
        self.assertEqual(self.evaluate(records, self.state(flags=[1, 0, 0])),
                         (0, 0, 0))
        self.assertEqual(self.evaluate(records, self.state(flags=[0, 1, 1])),
                         (0, 1, 0))
        self.assertEqual(self.evaluate(records, self.state(flags=[0, 0, 1])),
                         (0, 0, 0))

    def test_only_operator_one_joins_or_group_and_other_markers_are_and(self):
        records = [record(2, 0, 1, or_after=2), record(2, 1, 1)]
        self.assertEqual(self.evaluate(records, self.state(flags=[1, 0])), (0, 0, 0))

    def test_parenthesis_markers_match_after_original_boolean_normalization(self):
        for opener, closer in ((2, 0), (-1, 0), (0, 2), (2, -1), (1, 1)):
            with self.subTest(opener=opener, closer=closer):
                records = [record(0x12, or_after=opener), record(2, 0, 1),
                           record(2, 1, 1), record(0x13, or_after=closer)]
                self.assertEqual(self.evaluate(records, self.state(flags=[1, 1])),
                                 (0, 1, 0))
                self.assertEqual(self.evaluate(records, self.state(flags=[1, 0])),
                                 (0, 0, 0))

    def test_nested_group_can_contain_one_branch_child_with_multiple_records(self):
        records = [record(0x12), record(0x12), record(2, 0, 1),
                   record(2, 1, 1), record(0x13), record(0x13)]
        self.assertEqual(self.evaluate(records, self.state(flags=[1, 1])), (0, 1, 0))
        self.assertEqual(self.evaluate(records, self.state(flags=[1, 0])), (0, 0, 0))

    def test_malformed_parentheses_and_short_groups_are_rejected(self):
        for records in (
            [record(0x13)],
            [record(0x12, or_after=1), record(2, 0, 0), record(0x13, or_after=0)],
            [record(0x12, or_after=0), record(0x13, or_after=0)],
            [record(0x12), record(2, 0, 0), record(0x13)],
            [record(0x12, or_after=0)],
        ):
            tree = c.c_void_p()
            record_array = (SceneDependencyInfo * len(records))(*records)
            self.assertEqual(self.lib.scene_conditions_build(record_array, len(records),
                                                             c.byref(tree)), 3)
            self.assertFalse(tree.value)

    def test_unsupported_opcodes_are_explicit(self):
        self.assertEqual(self.evaluate([record(10)], self.state()), (6, 0, 10))

    def test_record_limit_is_enforced(self):
        records = (SceneDependencyInfo * 513)()
        tree = c.c_void_p()
        self.assertEqual(self.lib.scene_conditions_build(records, 513, c.byref(tree)), 4)
        self.assertFalse(tree.value)


if __name__ == "__main__":
    unittest.main()
