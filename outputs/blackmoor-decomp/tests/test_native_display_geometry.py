"""Pure native presentation geometry; no AppKit, assets, audio or game state."""
from __future__ import annotations

import ctypes as C
import math
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
FIT, STRETCH = 0, 1
INT32_MIN, INT32_MAX = -(2 ** 31), 2 ** 31 - 1


class Rect(C.Structure):
    _fields_ = [('x', C.c_double), ('y', C.c_double),
                ('width', C.c_double), ('height', C.c_double)]

    def values(self):
        return self.x, self.y, self.width, self.height


class NativeDisplayGeometryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory(prefix='native-display-')
        cls.addClassCleanup(cls.tmp.cleanup)
        library = Path(cls.tmp.name) / 'geometry.dylib'
        compiler = shutil.which('clang') or shutil.which('cc')
        if compiler is None:
            raise RuntimeError('C compiler required')
        built = subprocess.run([compiler, '-std=c11', '-Wall', '-Wextra', '-Wpedantic',
                                '-Werror', '-O2', '-fPIC', '-shared',
                                str(PROJECT / 'src/native_display_geometry.c'),
                                '-lm', '-o', str(library)], capture_output=True, text=True)
        if built.returncode != 0:
            raise RuntimeError(built.stdout + built.stderr)
        cls.lib = C.CDLL(str(library))
        cls.lib.native_display_layout.argtypes = [C.c_uint32, C.c_uint32, C.c_double,
                                                  C.c_double, C.c_int, C.POINTER(Rect)]
        cls.lib.native_display_map_point.argtypes = [C.c_uint32, C.c_uint32, C.POINTER(Rect),
                                                     C.c_double, C.c_double,
                                                     C.POINTER(C.c_int32), C.POINTER(C.c_int32)]

    def layout(self, width, height, mode=FIT, logical=(640, 480)):
        out = Rect(11, 22, 33, 44)
        result = self.lib.native_display_layout(*logical, width, height, mode, C.byref(out))
        self.assertEqual(result, 1)
        return out

    def mapped(self, rect, x, y, logical=(640, 480)):
        out_x, out_y = C.c_int32(123), C.c_int32(456)
        result = self.lib.native_display_map_point(*logical, C.byref(rect), x, y,
                                                   C.byref(out_x), C.byref(out_y))
        self.assertEqual(result, 1)
        return out_x.value, out_y.value

    def test_fit_centers_surface_in_widescreen_ultrawide_and_tall_views(self):
        cases = [(640, 480, (0, 0, 640, 480)),
                 (1280, 720, (160, 0, 960, 720)),
                 (1920, 1080, (240, 0, 1440, 1080)),
                 (3440, 1440, (760, 0, 1920, 1440)),
                 (900, 1600, (0, 462.5, 900, 675))]
        for width, height, expected in cases:
            with self.subTest(view=(width, height)):
                self.assertEqual(self.layout(width, height).values(), expected)

    def test_stretch_uses_entire_view_and_independent_inverse_scales(self):
        for width, height in ((1920, 1080), (3440, 1440), (900, 1600)):
            self.assertEqual(self.layout(width, height, STRETCH).values(), (0, 0, width, height))
        rect = self.layout(1920, 1080, STRETCH)
        for point, expected in [((0, 0), (0, 0)), ((960, 540), (320, 240)),
                                ((1920, 1080), (640, 480)), ((2.99, 2.24), (0, 0)),
                                ((3, 2.25), (1, 1)), ((-3, -2.25), (-1, -1))]:
            self.assertEqual(self.mapped(rect, *point), expected)

    def test_fit_maps_corners_center_and_bar_coordinates_without_clamping(self):
        rect = self.layout(1280, 720)
        for point, expected in [((160, 0), (0, 0)), ((640, 360), (320, 240)),
                                ((1120, 720), (640, 480)), ((80, 360), (-54, 240)),
                                ((1200, 360), (693, 240)), ((159.99, -0.01), (-1, -1)),
                                ((-1, 721), (-108, 480))]:
            self.assertEqual(self.mapped(rect, *point), expected)
        self.assertEqual(self.mapped(self.layout(900, 1600), 450, 0), (320, -329))

    def test_fractional_and_tiny_layouts_support_inverse_interior_points(self):
        rect = self.layout(1000.5, 700.25)
        for actual, expected in zip(rect.values(), (33.416666666666686, 0, 933.6666666666666, 700.25)):
            self.assertAlmostEqual(actual, expected, places=10)
        for mode in (FIT, STRETCH):
            rect = self.layout(1000.5, 700.25, mode)
            x = rect.x + 17.25 * rect.width / 640
            y = rect.y + 29.75 * rect.height / 480
            self.assertEqual(self.mapped(rect, x, y), (17, 29))
        tiny = self.layout(1e-300, 1e-300)
        for actual, expected in zip(tiny.values(), (0, 1.25e-301, 1e-300, 7.5e-301)):
            self.assertTrue(math.isclose(actual, expected, rel_tol=1e-12, abs_tol=0))
        self.assertEqual(self.mapped(tiny, 5.01e-301, 5.01e-301), (320, 240))

    def test_logical_dimensions_are_not_fixed_to_640_by_480(self):
        rect = self.layout(1920, 1080, logical=(320, 200))
        self.assertEqual(rect.values(), (96, 0, 1728, 1080))
        self.assertEqual(self.mapped(rect, 960, 540, logical=(320, 200)), (160, 100))
        rect = self.layout(1, 1, STRETCH, logical=(2 ** 32 - 1, 2 ** 32 - 1))
        self.assertEqual(self.mapped(rect, 1, -1, logical=(2 ** 32 - 1, 2 ** 32 - 1)),
                         (INT32_MAX, INT32_MIN))

    def test_finite_overflow_saturates_without_losing_finite_normalized_results(self):
        huge = sys.float_info.max
        rect = Rect(0, 0, 640, 480)
        self.assertEqual(self.mapped(rect, huge, -huge), (INT32_MAX, INT32_MIN))
        self.assertEqual(self.mapped(Rect(-huge, huge, huge, huge), huge, -huge), (1280, -960))
        origin = 1e300
        step = math.nextafter(origin, math.inf) - origin
        self.assertEqual(self.mapped(Rect(origin, origin, step * 640, step * 480),
                                     origin + step, origin + step), (1, 1))
        # A negative underflow is still outside the logical surface, not pixel0.
        self.assertEqual(self.mapped(Rect(0, 0, huge, huge), -5e-324, 0), (-1, 0))

    def test_invalid_layouts_preserve_output(self):
        invalid = [(0, 480, 800, 600, FIT), (640, 0, 800, 600, FIT),
                   (640, 480, 800, 600, -1), (640, 480, 800, 600, 2)]
        for value in (0, -1, math.nan, math.inf, -math.inf):
            invalid.extend([(640, 480, value, 600, FIT), (640, 480, 800, value, STRETCH)])
        for args in invalid:
            out = Rect(11, 22, 33, 44)
            self.assertEqual(self.lib.native_display_layout(*args, C.byref(out)), 0)
            self.assertEqual(out.values(), (11, 22, 33, 44))
        self.assertEqual(self.lib.native_display_layout(640, 480, 800, 600, FIT, None), 0)

    def test_invalid_mapping_inputs_preserve_both_outputs(self):
        rects = [Rect(math.nan, 0, 640, 480), Rect(0, math.inf, 640, 480)]
        for value in (0, -1, math.nan, math.inf, -math.inf):
            rects.extend([Rect(0, 0, value, 480), Rect(0, 0, 640, value)])
        for rect in rects:
            x, y = C.c_int32(123), C.c_int32(456)
            self.assertEqual(self.lib.native_display_map_point(640, 480, C.byref(rect), 1, 2,
                                                               C.byref(x), C.byref(y)), 0)
            self.assertEqual((x.value, y.value), (123, 456))
        rect = Rect(0, 0, 640, 480)
        cases = [(0, 480, 1, 2), (640, 0, 1, 2)]
        for value in (math.nan, math.inf, -math.inf):
            cases.extend([(640, 480, value, 2), (640, 480, 1, value)])
        for width, height, px, py in cases:
            x, y = C.c_int32(123), C.c_int32(456)
            self.assertEqual(self.lib.native_display_map_point(width, height, C.byref(rect), px, py,
                                                               C.byref(x), C.byref(y)), 0)
            self.assertEqual((x.value, y.value), (123, 456))
        x, y = C.c_int32(123), C.c_int32(456)
        for rp, xp, yp in [(None, C.byref(x), C.byref(y)),
                           (C.byref(rect), None, C.byref(y)),
                           (C.byref(rect), C.byref(x), None),
                           (C.byref(rect), C.byref(x), C.byref(x))]:
            self.assertEqual(self.lib.native_display_map_point(640, 480, rp, 1, 2, xp, yp), 0)
            self.assertEqual((x.value, y.value), (123, 456))


if __name__ == '__main__':
    unittest.main()
