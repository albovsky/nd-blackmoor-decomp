import ctypes as c
from pathlib import Path
import unittest


class DependencyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        path = Path(__file__).resolve().parents[1] / 'build/libscenedependencies.dylib'
        if not path.is_file():
            raise unittest.SkipTest('Build the scene dependency library first')
        cls.reduce = c.CDLL(str(path)).scene_dependencies_reduce
        cls.reduce.argtypes = [c.POINTER(c.c_int32), c.POINTER(c.c_uint16), c.c_size_t, c.POINTER(c.c_int)]

    def run_branch(self, states, links):
        values = (c.c_int32 * len(states))(*states)
        operators = (c.c_uint16 * len(links))(*links)
        result = c.c_int(-1)
        status = self.reduce(values, operators, len(states), c.byref(result))
        return status, list(values), result.value

    def test_s0_dependency_group_accepts_either_difficulty_flag(self):
        for a, b, expected in ((0, 0, 0), (1, 0, 1), (0, 1, 1), (1, 1, 1)):
            status, values, result = self.run_branch([a, b], [1, 1])
            self.assertEqual((status, result), (0, expected))
            self.assertEqual(values, [expected, expected])

    def test_and_requires_all_conditions(self):
        for a, b in ((0, 0), (1, 0), (0, 1), (1, 1)):
            status, values, result = self.run_branch([a, b], [0, 0])
            self.assertEqual((status, result), (0, int(bool(a and b))))
            self.assertEqual(values, [a, b])

    def test_mixed_groups_do_not_cross_and_boundary(self):
        self.assertEqual(self.run_branch([1, 0, 0, 0], [1, 0, 1, 0]), (0, [1, 1, 0, 0], 0))
        self.assertEqual(self.run_branch([1, 0, 0, 2], [1, 0, 1, 0]), (0, [1, 1, 1, 2], 1))

    def test_backward_propagation_reaches_fixed_point(self):
        self.assertEqual(self.run_branch([0, 0, 0, -7], [1, 1, 1, 0]), (0, [1, 1, 1, -7], 1))

    def test_only_link_value_one_propagates(self):
        self.assertEqual(self.run_branch([0, 1], [2, 1]), (0, [0, 1], 0))

    def test_no_dependencies_follow_loader_true_path(self):
        result = c.c_int(0)
        self.assertEqual(self.reduce(None, None, 0, c.byref(result)), 0)
        self.assertEqual(result.value, 1)

    def test_limit_and_null_outputs_are_rejected(self):
        result = c.c_int(1)
        self.assertEqual(self.reduce(None, None, 513, c.byref(result)), 2)
        self.assertEqual(result.value, 0)
        self.assertEqual(self.reduce(None, None, 1, c.byref(result)), 1)
        self.assertEqual(self.reduce(None, None, 0, None), 1)


if __name__ == '__main__':
    unittest.main()
